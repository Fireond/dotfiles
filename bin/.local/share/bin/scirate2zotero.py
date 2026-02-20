#!/usr/bin/env python3
import json
import os
import re
import time
from datetime import datetime, timezone
from pathlib import Path
from typing import Dict, List, Tuple, Optional

import requests
import xml.etree.ElementTree as ET

SCIRATE_EXPORT_URL = "https://scirate.com/{user}/download_scites?page={page}"
ARXIV_API_URL = "https://export.arxiv.org/api/query?id_list={id_list}"
ZOTERO_API_BASE = "https://api.zotero.org"

# arXiv legacy API rate limit guidance: ~1 request per 3 seconds
ARXIV_MIN_INTERVAL_SEC = 3.05


def iso_parse(s: str) -> datetime:
    # Handles "2026-02-19T12:34:56.000Z" etc.
    s = s.replace("Z", "+00:00")
    return datetime.fromisoformat(s)


def strip_arxiv_version(arxiv_id: str) -> str:
    # "2601.07953v2" -> "2601.07953"
    return re.sub(r"v\d+$", "", arxiv_id)


def load_json(path: Path, default):
    if path.exists():
        return json.loads(path.read_text(encoding="utf-8"))
    return default


def save_json(path: Path, obj):
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(obj, ensure_ascii=False, indent=2), encoding="utf-8")


def chunks(xs: List[str], n: int) -> List[List[str]]:
    return [xs[i : i + n] for i in range(0, len(xs), n)]


def split_name(full: str) -> Tuple[str, str]:
    """
    Convert "First Last" (or "Last, First") -> (firstName, lastName).
    This makes Zotero/BetterBibTeX behave consistently.
    """
    full = " ".join(full.split())
    if "," in full:
        last, first = [x.strip() for x in full.split(",", 1)]
        return first, last
    parts = full.split()
    if len(parts) == 1:
        return "", parts[0]
    return " ".join(parts[:-1]), parts[-1]


def zotero_headers(api_key: str):
    return {
        "Zotero-API-Version": "3",
        "Zotero-API-Key": api_key,
        "Content-Type": "application/json",
        "Accept": "application/json",
    }


def zotero_get_all_collections(user_id: str, api_key: str):
    out = []
    start = 0
    while True:
        url = f"{ZOTERO_API_BASE}/users/{user_id}/collections?limit=100&start={start}"
        r = requests.get(url, headers=zotero_headers(api_key), timeout=30)
        r.raise_for_status()
        batch = r.json()
        out.extend(batch)
        if len(batch) < 100:
            break
        start += 100
    return out


def find_collection_key(user_id: str, api_key: str, collection_name: str) -> str:
    cols = zotero_get_all_collections(user_id, api_key)
    for c in cols:
        if c.get("data", {}).get("name") == collection_name:
            return c["key"]
    raise SystemExit(f"[ERR] Zotero collection not found: {collection_name}")


def fetch_scirate_scites(username: str, max_pages: int = 3):
    # Each page up to 1000 (per SciRate controller)
    items = []
    for page in range(1, max_pages + 1):
        url = SCIRATE_EXPORT_URL.format(user=username, page=page)
        r = requests.get(url, timeout=30)
        r.raise_for_status()
        batch = r.json()
        if not batch:
            break
        items.extend(batch)
        if len(batch) < 1000:
            break
    return items


class ArxivClient:
    def __init__(self, user_agent: str, cache_path: Path):
        self.session = requests.Session()
        # arXiv ToU strongly suggests a descriptive UA (ideally with contact)
        self.session.headers.update({"User-Agent": user_agent})
        self.cache_path = cache_path
        self.cache: Dict[str, dict] = load_json(cache_path, {})
        self._last_call = 0.0

    def _rate_limit(self):
        dt = time.time() - self._last_call
        if dt < ARXIV_MIN_INTERVAL_SEC:
            time.sleep(ARXIV_MIN_INTERVAL_SEC - dt)

    def _get_with_retry(self, url: str) -> requests.Response:
        """
        GET with:
          - rate limiting (>= 3s between calls)
          - retry on 429 with Retry-After (or >=3s backoff)
          - retry on transient 5xx
        """
        for attempt in range(8):
            self._rate_limit()
            r = self.session.get(url, timeout=30)
            self._last_call = time.time()

            if r.status_code == 429:
                ra = r.headers.get("Retry-After")
                # If present and numeric, respect it; otherwise wait >= 3s
                sleep_s = float(ra) if (ra and ra.isdigit()) else ARXIV_MIN_INTERVAL_SEC
                sleep_s = max(sleep_s, ARXIV_MIN_INTERVAL_SEC)
                print(f"[arXiv] 429 rate limited. Sleep {sleep_s:.1f}s then retry...")
                time.sleep(sleep_s)
                continue

            if 500 <= r.status_code < 600:
                backoff = max(ARXIV_MIN_INTERVAL_SEC, 2**attempt)
                print(
                    f"[arXiv] {r.status_code} server error. Sleep {backoff:.1f}s then retry..."
                )
                time.sleep(backoff)
                continue

            r.raise_for_status()
            return r

        raise RuntimeError(f"[arXiv] Failed after retries: {url}")

    def _parse_feed(self, xml_text: str) -> Dict[str, dict]:
        ns = {
            "atom": "http://www.w3.org/2005/Atom",
            "arxiv": "http://arxiv.org/schemas/atom",
        }
        root = ET.fromstring(xml_text)
        out: Dict[str, dict] = {}

        for entry in root.findall("atom:entry", ns):
            entry_id = entry.findtext("atom:id", default="", namespaces=ns).strip()
            # entry_id like "http://arxiv.org/abs/2601.07953v1"
            plain = ""
            if entry_id:
                plain = strip_arxiv_version(entry_id.split("/")[-1])

            title = re.sub(
                r"\s+", " ", entry.findtext("atom:title", default="", namespaces=ns)
            ).strip()
            summary = re.sub(
                r"\s+", " ", entry.findtext("atom:summary", default="", namespaces=ns)
            ).strip()
            published = entry.findtext(
                "atom:published", default="", namespaces=ns
            ).strip()
            updated = entry.findtext("atom:updated", default="", namespaces=ns).strip()

            authors = []
            for a in entry.findall("atom:author", ns):
                nm = a.findtext("atom:name", default="", namespaces=ns).strip()
                if nm:
                    authors.append(nm)

            abs_url = ""
            for link in entry.findall("atom:link", ns):
                if link.attrib.get("rel") == "alternate" and link.attrib.get("href"):
                    abs_url = link.attrib["href"]
                    break
            if not abs_url and plain:
                abs_url = f"https://arxiv.org/abs/{plain}"

            primary_cat = ""
            pc = entry.find("arxiv:primary_category", ns)
            if pc is not None:
                primary_cat = pc.attrib.get("term", "")

            if plain:
                out[plain] = {
                    "title": title,
                    "summary": summary,
                    "published": published,
                    "updated": updated,
                    "authors": authors,
                    "abs_url": abs_url,
                    "primary_cat": primary_cat,
                }

        return out

    def metadata_many(
        self, arxiv_ids: List[str], batch_size: int = 40
    ) -> Dict[str, dict]:
        """
        Fetch metadata for a list of arXiv IDs (plain IDs without version preferred).
        Uses cache; calls arXiv API in batches.
        Returns map: plain_id -> meta
        """
        # normalize to plain ids
        plain_ids = [strip_arxiv_version(x) for x in arxiv_ids]
        need = [pid for pid in plain_ids if pid not in self.cache]

        if need:
            for batch in chunks(need, batch_size):
                url = ARXIV_API_URL.format(id_list=",".join(batch))
                r = self._get_with_retry(url)
                parsed = self._parse_feed(r.text)
                # even if some missing, store what we have
                self.cache.update(parsed)
                self._flush_cache()

        # return only requested (if still missing, they won't exist here)
        return {pid: self.cache.get(pid) for pid in plain_ids}

    def _flush_cache(self):
        save_json(self.cache_path, self.cache)


def zotero_create_item(user_id: str, api_key: str, item: dict):
    url = f"{ZOTERO_API_BASE}/users/{user_id}/items"
    r = requests.post(
        url, headers=zotero_headers(api_key), data=json.dumps([item]), timeout=30
    )
    r.raise_for_status()
    return r.json()


def main():
    cfg_path = Path(
        os.environ.get("SCIRATE2ZOTERO_CONFIG", "~/.config/scirate2zotero/config.json")
    ).expanduser()
    cfg = load_json(cfg_path, None)
    if not cfg:
        raise SystemExit(f"[ERR] Missing config: {cfg_path}")

    scirate_user = cfg["scirate_username"]
    zot_user_id = cfg["zotero_user_id"]
    zot_key = cfg["zotero_api_key"]
    collection_name = cfg["zotero_collection_name"]
    tag_main = cfg.get("tag_main", "scirate")
    tag_extra = cfg.get("tag_extra", "to-read")
    max_pages = int(cfg.get("scirate_max_pages", 3))

    # Strongly recommended: set a descriptive UA with contact email
    # e.g. "scirate2zotero/1.0 (mailto:yourname@domain.com)"
    arxiv_user_agent = cfg.get("arxiv_user_agent", "scirate2zotero/1.0")

    cache_path = Path(
        cfg.get("arxiv_cache_file", "~/.cache/scirate2zotero/arxiv_meta_cache.json")
    ).expanduser()

    state_path = Path(
        cfg.get("state_file", "~/.config/scirate2zotero/state.json")
    ).expanduser()
    state = load_json(state_path, {"last_scite_created_at": None})

    collection_key = find_collection_key(zot_user_id, zot_key, collection_name)

    scites = fetch_scirate_scites(scirate_user, max_pages=max_pages)

    new_items: List[Tuple[datetime, str]] = []
    last_seen: Optional[datetime] = (
        iso_parse(state["last_scite_created_at"])
        if state["last_scite_created_at"]
        else None
    )

    newest_time = last_seen
    for p in scites:
        scite_t = p.get("scite_created_at")
        uid = p.get("uid") or p.get("paper_uid") or p.get("id")  # be defensive
        if not scite_t or not uid:
            continue
        t = iso_parse(scite_t)
        if newest_time is None or t > newest_time:
            newest_time = t
        if last_seen is not None and t <= last_seen:
            # SciRate returns newest first, so we can stop early
            break
        new_items.append((t, uid))

    if not new_items:
        print("[OK] No new scites.")
        return

    # Create in chronological order (old -> new)
    new_items.sort(key=lambda x: x[0])

    # Prepare arXiv ids (plain) for batch metadata fetch
    plain_ids = [strip_arxiv_version(uid) for (_, uid) in new_items]
    # Deduplicate while preserving order
    seen = set()
    plain_ids_unique = []
    for pid in plain_ids:
        if pid not in seen:
            seen.add(pid)
            plain_ids_unique.append(pid)

    arxiv = ArxivClient(user_agent=arxiv_user_agent, cache_path=cache_path)
    meta_map = arxiv.metadata_many(
        plain_ids_unique, batch_size=int(cfg.get("arxiv_batch_size", 40))
    )

    imported = 0
    for t, uid in new_items:
        arxiv_id = strip_arxiv_version(uid)
        meta = meta_map.get(arxiv_id)
        if not meta:
            print(f"[WARN] arXiv metadata missing for {arxiv_id}, skip.")
            continue

        creators = [
            {
                "creatorType": "author",
                "firstName": split_name(a)[0],
                "lastName": split_name(a)[1],
            }
            for a in meta["authors"]
        ]

        # Make items more like Zotero Connector’s arXiv import
        item = {
            "itemType": "preprint",
            "title": meta["title"],
            "creators": creators,
            "abstractNote": meta["summary"],
            "date": (meta["published"][:10] if meta["published"] else ""),
            "url": meta["abs_url"],
            # Connector-like fields for arXiv
            "libraryCatalog": "arXiv.org",
            "repository": "arXiv",
            "archiveID": f"arXiv:{arxiv_id}",
            "tags": [{"tag": tag_main}, {"tag": tag_extra}],
            "collections": [collection_key],
            "extra": (
                f"arXiv:{arxiv_id}\n"
                f"primary-category:{meta['primary_cat']}\n"
                f"scirate-scited-at:{t.isoformat()}"
            ),
        }

        resp = zotero_create_item(zot_user_id, zot_key, item)
        ok = resp.get("success", {})
        if ok:
            imported += 1
            print(f"[ADD] {arxiv_id} -> Zotero OK ({list(ok.values())[0]})")
        else:
            print(f"[WARN] {arxiv_id} -> Zotero response: {resp}")

    if newest_time:
        state["last_scite_created_at"] = (
            newest_time.astimezone(timezone.utc).isoformat().replace("+00:00", "Z")
        )
        save_json(state_path, state)

    print(f"[OK] Imported {imported} new scites into '{collection_name}'.")


if __name__ == "__main__":
    main()
