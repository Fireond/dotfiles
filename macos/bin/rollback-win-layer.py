#!/opt/homebrew/bin/python3
"""Restore the previous Option layer, preserving later monitor/layout settings."""
import argparse
import datetime
import hashlib
import json
import os
from pathlib import Path
import re
import shutil
import subprocess
import tomllib

def file_hash(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()

def json_hash(path):
    value = json.loads(Path(path).read_text())
    return hashlib.sha256(json.dumps(value, sort_keys=True, separators=(',', ':')).encode()).hexdigest()

def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('manifest', nargs='?', type=Path,
                        default=Path(__file__).with_name('回退Win层信息.json'))
    parser.add_argument('--apply', action='store_true')
    args = parser.parse_args()
    data = json.loads(args.manifest.read_text())
    settings = Path(data['settings'])
    current = tomllib.loads(settings.read_text())
    if current['hotkeys'] != data['expectedHotkeys']:
        raise SystemExit('OmniWM hotkeys were changed later; refusing to overwrite them.')
    if json_hash(data['karabiner']) != data['expectedKarabinerHash']:
        raise SystemExit('Karabiner settings were changed later; refusing to overwrite them.')
    for entry in data['files']:
        path = Path(entry['path'])
        if not path.exists() or file_hash(path) != entry['expectedHash']:
            raise SystemExit('File changed later; refusing to overwrite: ' + str(path))
        if entry.get('backup') and not Path(entry['backup']).is_file():
            raise SystemExit('Missing backup: ' + entry['backup'])
    text = settings.read_text()
    for before, after in zip(data['oldHotkeys'], data['expectedHotkeys']):
        if before['binding'] == after['binding']:
            continue
        pattern = r'(\[\["hotkeys"\]\]\n"id" = "' + re.escape(after['id']) + r'"\n"binding" = ")' + re.escape(after['binding']) + '("\n)'
        text, count = re.subn(pattern, lambda m: m[1] + before['binding'] + m[2], text)
        if count != 1:
            raise SystemExit('Unsupported settings formatting; refusing to guess: ' + after['id'])
    assert tomllib.loads(text)['hotkeys'] == data['oldHotkeys']
    print(json.dumps({'checksPassed': True, 'apply': args.apply,
                      'restores': 'Previous Option workflow', 'monitorSettingsPreserved': True}))
    if not args.apply:
        return
    saved = Path(data['workdir']) / ('rollback-backup-' + datetime.datetime.now().strftime('%Y%m%d-%H%M%S'))
    saved.mkdir(parents=True)
    shutil.copy2(settings, saved / 'settings-before.toml')
    shutil.copy2(data['karabiner'], saved / 'karabiner-before.json')
    for index, entry in enumerate(data['files']):
        path = Path(entry['path'])
        shutil.copy2(path, saved / (str(index) + '-' + path.name))
        if entry.get('backup'):
            shutil.copy2(entry['backup'], path)
        else:
            path.unlink()
    # Only replace hotkey records. Keep current display/bar/workspace configuration.
    settings.write_text(text)
    active = Path(data['karabiner'])
    temp = active.with_name(active.name + '.rollback-win.tmp')
    shutil.copy2(data['karabinerBackup'], temp)
    temp.replace(active)
    hs = '/Applications/Hammerspoon.app/Contents/Frameworks/hs/hs'
    subprocess.run([hs, '-c', 'hs.reload()'], capture_output=True, timeout=8)
    for socket in Path(os.environ.get('TMPDIR', '/tmp')).glob('niri-mac-kitty-*'):
        subprocess.run(['/Applications/kitty.app/Contents/MacOS/kitten', '@', '--to', 'unix:' + str(socket),
                        'load-config'], capture_output=True, timeout=6)
    print('已回到上一轮 Option 方案。回退前的配置另存于：' + str(saved))

if __name__ == '__main__':
    main()
