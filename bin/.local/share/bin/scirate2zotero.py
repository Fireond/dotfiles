#!/usr/bin/env python3
import json, os, re, sys
from datetime import datetime, timezone
from pathlib import Path
import requests
import xml.etree.ElementTree as ET

SCIRATE_EXPORT_URL = "https://scirate.com/{user}/download_scites?page={page}"
ARXIV_API_URL = "https://export.arxiv.org/api/query?id_list={arxiv_id}"
ZOTERO_API_BASE = "https://api.zotero.org"


def iso_parse(s: str) -> datetime:
    # Handles "2026-02-19T12:34:56.000Z" etc.
    s = s.replace("Z", "+00:00")
    return datetime.fromisoformat(s)


def strip_arxiv_version(arxiv_id: str) -> str:
    return re.sub(r"v\d+$", "", arxiv_id)


def load_json(path: Path, default):
    if path.exists():
        return json.loads(path.read_text(encoding="utf-8"))
    return default


def save_json(path: Path, obj):
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(obj, ensure_ascii=False, indent=2), encoding="utf-8")


def zotero_headers(api_key: str):
    # Zotero supports Zotero-API-Key or Authorization: Bearer
    return {
        "Zotero-API-Version": "3",
        "Zotero-API-Key": api_key,
        "Content-Type": "application/json",
        "Accept": "application/json",
    }


def zotero_get_all_collections(user_id: str, api_key: str):
    # Pagination: limit up to 100 each request
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


def arxiv_metadata(arxiv_id: str):
    url = ARXIV_API_URL.format(arxiv_id=arxiv_id)
    r = requests.get(url, timeout=30)
    r.raise_for_status()

    ns = {
        "atom": "http://www.w3.org/2005/Atom",
        "arxiv": "http://arxiv.org/schemas/atom",
    }
    root = ET.fromstring(r.text)
    entry = root.find("atom:entry", ns)
    if entry is None:
        raise RuntimeError(f"arXiv entry not found for {arxiv_id}")

    def text(path):
        el = entry.find(path, ns)
        return (el.text or "").strip() if el is not None else ""

    title = re.sub(r"\s+", " ", text("atom:title"))
    summary = re.sub(r"\s+", " ", text("atom:summary"))
    published = text("atom:published")
    updated = text("atom:updated")

    authors = []
    for a in entry.findall("atom:author", ns):
        name = a.find("atom:name", ns)
        if name is not None and name.text:
            authors.append(name.text.strip())

    abs_url = ""
    for link in entry.findall("atom:link", ns):
        if link.attrib.get("rel") == "alternate" and link.attrib.get("href"):
            abs_url = link.attrib["href"]
            break
    if not abs_url:
        abs_url = f"https://arxiv.org/abs/{arxiv_id}"

    primary_cat = ""
    pc = entry.find("arxiv:primary_category", ns)
    if pc is not None:
        primary_cat = pc.attrib.get("term", "")

    return {
        "title": title,
        "summary": summary,
        "published": published,
        "updated": updated,
        "authors": authors,
        "abs_url": abs_url,
        "primary_cat": primary_cat,
    }


def zotero_create_item(user_id: str, api_key: str, item: dict):
    url = f"{ZOTERO_API_BASE}/users/{user_id}/items"
    # v3 write: POST an array of items
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

    state_path = Path(
        cfg.get("state_file", "~/.config/scirate2zotero/state.json")
    ).expanduser()
    state = load_json(state_path, {"last_scite_created_at": None})

    collection_key = find_collection_key(zot_user_id, zot_key, collection_name)

    scites = fetch_scirate_scites(scirate_user, max_pages=max_pages)
    # SciRate returns newest first
    new_items = []
    last_seen = (
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
            # because sorted desc, we can stop early
            break
        new_items.append((t, uid))

    if not new_items:
        print("[OK] No new scites.")
        return

    # Create in chronological order (old -> new)
    new_items.sort(key=lambda x: x[0])

    for t, uid in new_items:
        arxiv_id = strip_arxiv_version(uid)
        meta = arxiv_metadata(arxiv_id)

        item = {
            "itemType": "preprint",
            "title": meta["title"],
            "creators": [{"creatorType": "author", "name": a} for a in meta["authors"]],
            "abstractNote": meta["summary"],
            "date": (meta["published"][:10] if meta["published"] else ""),
            "url": meta["abs_url"],
            "tags": [{"tag": tag_main}, {"tag": tag_extra}],
            "collections": [collection_key],
            "extra": f"arXiv:{arxiv_id}\nprimary-category:{meta['primary_cat']}\nscirate-scited-at:{t.isoformat()}",
        }

        resp = zotero_create_item(zot_user_id, zot_key, item)
        ok = resp.get("success", {})
        if ok:
            print(f"[ADD] {arxiv_id} -> Zotero OK ({list(ok.values())[0]})")
        else:
            print(f"[WARN] {arxiv_id} -> Zotero response: {resp}")

    if newest_time:
        state["last_scite_created_at"] = (
            newest_time.astimezone(timezone.utc).isoformat().replace("+00:00", "Z")
        )
        save_json(state_path, state)

    print(f"[OK] Imported {len(new_items)} new scites into '{collection_name}'.")


if __name__ == "__main__":
    main()
