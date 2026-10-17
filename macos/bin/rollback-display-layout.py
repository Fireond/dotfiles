#!/opt/homebrew/bin/python3
"""Preview or undo this display-origin/routing change, preserving other settings."""
import argparse
import datetime
import importlib.util
import json
from pathlib import Path
import shutil
import subprocess
import tomllib

def load_module(path, name):
    spec = importlib.util.spec_from_file_location(name, path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module

def signature(rows):
    return sorted((r['uuid'], r['x'], r['y'], r['width'], r['height'], r['main']) for r in rows)

def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('manifest', type=Path)
    parser.add_argument('--apply', action='store_true')
    args = parser.parse_args()
    info = json.loads(args.manifest.read_text())
    backup = Path(info['backup'])
    settings = Path(info['settings'])
    original_text = settings.read_text()
    config = tomllib.loads(original_text)
    if config['routing'] != info['expectedRouting']:
        raise SystemExit('跨屏方向设置已有后续修改，停止回退，避免覆盖。')
    native = load_module(Path(info['helper']), 'display_origin_api')
    current = native.snapshot()
    expected = json.loads((backup / 'display-origins.expected.json').read_text())
    before = json.loads((backup / 'display-origins.before.json').read_text())
    if signature(current) != signature(expected):
        raise SystemExit('显示器连接、分辨率或坐标已有变化，停止自动回退。')
    print(json.dumps({'apply': args.apply, 'restore': '此前系统屏幕排列和 OmniWM 跨屏方向图',
        'preserve': '快捷键、工作区、状态栏与其他设置'}, ensure_ascii=False))
    if not args.apply:
        return
    stamp = datetime.datetime.now().strftime('%Y%m%d-%H%M%S')
    current_backup = backup / ('before-rollback-' + stamp)
    current_backup.mkdir()
    shutil.copy2(settings, current_backup / 'settings.toml')
    (current_backup / 'display-origins.json').write_text(json.dumps(current, indent=2) + '\n')
    config['routing'] = info['originalRouting']
    serializer = load_module(Path.home() / '.dotfiles/macos/bin/configure-monitors.py', 'monitor_serializer')
    new_text = '\n'.join(serializer.dump(config)) + '\n'
    assert tomllib.loads(new_text) == config
    if settings.read_text() != original_text:
        raise SystemExit('配置在预览后发生变化，停止回退。')
    temp = settings.with_suffix('.toml.tmp')
    temp.write_text(new_text)
    temp.replace(settings)
    try:
        native.apply(before, permanent=True)
    except Exception:
        if settings.read_text() == new_text:
            settings.write_text(original_text)
        raise
    print('已恢复此前双屏排列；回退前状态备份于 ' + str(current_backup))

if __name__ == '__main__':
    main()
