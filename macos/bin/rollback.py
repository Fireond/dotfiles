#!/opt/homebrew/bin/python3
"""Restore this migration's config and services; preserve applications and Zotero data."""
import argparse,datetime,json,os,pathlib,shutil,subprocess

def main():
    ap=argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--backup',required=True,type=pathlib.Path)
    ap.add_argument('--apply',action='store_true',help='Execute; without this flag only show the plan')
    args=ap.parse_args()
    manifest=json.loads((args.backup/'manifest.json').read_text())
    home=pathlib.Path.home();root=home/'.dotfiles/macos'
    paths=[home/'.config/kitty/kitty.conf',home/'.hammerspoon/init.lua',home/'.config/omniwm/settings.toml',home/'.dotfiles/zsh/.zshrc']
    for p in paths:
        entry=manifest['files'][str(p)]
        if entry.get('backup') and not pathlib.Path(entry['backup']).is_file():raise RuntimeError('Missing backup: '+entry['backup'])
    labels=['local.niri-mac.omniwm','local.niri-mac.hammerspoon']
    original=[label for label,state in manifest['services'].items() if state['loaded']]
    print('将恢复 kitty、Hammerspoon、OmniWM 配置入口和 zsh；停用新增登录项。')
    print('将恢复原先运行的服务：'+', '.join(original))
    print('当前 Mac 配置先归档；保留安装的应用、Better BibTeX 和文献库。')
    if not args.apply:
        print('预览完成，没有修改。加 --apply 才会执行。');return
    archive=args.backup/('rollback-'+datetime.datetime.now().strftime('%Y%m%d-%H%M%S'))
    archive.mkdir()
    # Preserve every replaced object, including symlink identity, before mutation.
    for p in paths:
        if p.exists() or p.is_symlink():
            q=archive/p.relative_to(home);q.parent.mkdir(parents=True,exist_ok=True)
            if p.is_symlink():q.symlink_to(os.readlink(p))
            else:shutil.copy2(p,q)
    domain=f'gui/{os.getuid()}'
    def run(argv):
        result=subprocess.run(argv,capture_output=True,text=True)
        if result.returncode and result.stderr.strip():print('提示：'+result.stderr.strip())
        return result
    for label in labels:
        run(['launchctl','bootout',domain+'/'+label])
        p=home/'Library/LaunchAgents'/(label+'.plist')
        if p.exists() or p.is_symlink():
            q=archive/'login-items'/p.name;q.parent.mkdir(exist_ok=True)
            shutil.move(p,q)
    for app in ['OmniWM','Hammerspoon']:run(['pkill','-TERM','-u',str(os.getuid()),'-x',app])
    for p in paths:
        e=manifest['files'][str(p)]
        if p.exists() or p.is_symlink():p.unlink()
        if e['exists']:
            p.parent.mkdir(parents=True,exist_ok=True)
            if 'symlink' in e:p.symlink_to(e['symlink'])
            else:shutil.copy2(e['backup'],p)
    if root.exists():shutil.move(root,archive/'macos-config')
    # Stale yabai jobs were not running before migration, so leave those stopped.
    for label in original:
        run(['launchctl','enable',domain+'/'+label])
        p=home/'Library/LaunchAgents'/(label+'.plist')
        if p.exists():run(['launchctl','bootstrap',domain,str(p)])
    print('回滚完成。当前配置已保存在：'+str(archive))
    print('重新打开终端以载入旧 zsh；已打开的 kitty 可重启或重载配置。')

if __name__=='__main__':main()
