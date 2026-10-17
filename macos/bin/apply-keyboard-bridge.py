#!/opt/homebrew/bin/python3
"""Merge this workflow's Win/Ctrl rules and device mappings without replacing unrelated settings."""
import argparse
import datetime
import json
import os
from pathlib import Path
import shutil

RETIRED = {
    'niri-mac: physical Win virtual modifier',
    'niri-mac: kitty physical Ctrl remains terminal Control',
    'niri-mac: Win chords dispatch to OmniWM and Hammerspoon',
    'niri-mac: ignore unbound Win chords without typing',
    'niri-mac: kitty Linux physical Ctrl and Alt+C/V clipboard',
    'niri-mac: physical Ctrl+Alt follows Linux movement shortcuts on swapped keyboards',
}

def update_simple(current, changes, remove=False, restore=()):
    result = list(current)
    for change in changes:
        previous = [c for c in result if c['from'] == change['from']]
        if remove:
            # Only undo a mapping that still exactly matches the managed version.
            if previous != [change]:
                continue
            result = [c for c in result if c['from'] != change['from']]
            result += [c for c in restore if c['from'] == change['from']]
        else:
            result = [c for c in result if c['from'] != change['from']] + [change]
    return result

def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--apply', action='store_true')
    parser.add_argument('--remove', action='store_true')
    parser.add_argument('--backup-dir', type=Path)
    args = parser.parse_args()
    root = Path.home() / '.dotfiles/macos'
    live = Path.home() / '.config/karabiner/karabiner.json'
    data = json.loads(live.read_text())
    before = json.loads(json.dumps(data))
    selected = [p for p in data['profiles'] if p.get('selected')]
    if len(selected) != 1:
        raise SystemExit('Expected exactly one selected Karabiner profile.')
    profile = selected[0]
    owned_rules = json.loads((root / 'karabiner/physical-control.json').read_text())['rules']
    owned = {r['description'] for r in owned_rules} | RETIRED
    if any(not r['description'].startswith('niri-mac: ') for r in owned_rules):
        raise SystemExit('Asset contains an unmanaged rule.')
    old = profile.setdefault('complex_modifications', {}).setdefault('rules', [])
    keep = [r for r in old if r.get('description') not in owned]
    profile['complex_modifications']['rules'] = ([] if args.remove else owned_rules) + keep
    mods = json.loads((root / 'karabiner/device-modifications.json').read_text())
    # Retire only exact mappings previously owned by this workflow.
    current_global = update_simple(profile.get('simple_modifications', []), mods.get('retired_global', []), True)
    profile['simple_modifications'] = update_simple(current_global, mods['global'], args.remove)
    for device in mods['devices']:
        entries = profile.setdefault('devices', [])
        found = [d for d in entries if d['identifiers'] == device['identifiers']]
        if len(found) > 1:
            raise SystemExit('Duplicate device entries; refusing to guess.')
        if found:
            target = found[0]
        elif args.remove:
            continue
        else:
            target = {'identifiers': device['identifiers']}
            entries.append(target)
        target['simple_modifications'] = update_simple(target.get('simple_modifications', []),
            device['simple_modifications'], args.remove, device.get('remove_restore', []))
    changed = before != data
    print(json.dumps({'profile': profile['name'], 'changed': changed, 'managedRules': 0 if args.remove else len(owned_rules),
                      'preservedRules': len(keep), 'apply': args.apply}))
    if not args.apply or not changed:
        return
    if args.backup_dir is None:
        raise SystemExit('--backup-dir is required before changing live settings.')
    args.backup_dir.mkdir(parents=True, exist_ok=True)
    stamp = datetime.datetime.now().strftime('%Y%m%d-%H%M%S')
    shutil.copy2(live, args.backup_dir / ('karabiner-before-' + stamp + '.json'))
    target = live.resolve()
    temp = target.with_name(target.name + '.niri-mac.tmp')
    temp.write_text(json.dumps(data, ensure_ascii=False, indent=2) + '\n')
    os.chmod(temp, target.stat().st_mode & 0o777)
    temp.replace(target)

if __name__ == '__main__':
    main()
