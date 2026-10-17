#!/opt/homebrew/bin/python3
"""CLI-only operations missing a direct v0.6.10 hotkey, without moving windows by pixels."""
import json,os,pathlib,re,subprocess,sys,tomllib
CTL='/opt/homebrew/bin/omniwmctl'
ROOT=pathlib.Path.home()/'.dotfiles/macos'
CONFIG=ROOT/'omniwm/settings.toml'
def cli(*args):
    p=subprocess.run([CTL,*args,'--json'],capture_output=True,text=True,timeout=8)
    try:r=json.loads(p.stdout)
    except ValueError:raise RuntimeError(p.stderr.strip() or 'OmniWM IPC unavailable; finish permissions and start OmniWM')
    if not r.get('ok') and r.get('code')!='no_change':raise RuntimeError(str(r.get('error') or r))
    return (r.get('result') or {}).get('payload',{})
def query(name,*args):return cli('query',name,*args)
def directional_target(displays,direction,config):
    current=next((d for d in displays if d.get('isCurrent')),None)
    if not current:return None
    positions={}
    routing=config.get('routing',{})
    if routing.get('mode')=='custom':
        candidates=[]
        for order,a in enumerate(routing.get('arrangements',[])):
            rows=a.get('monitors',[]);matched={}
            for d in displays:
                row=next((r for r in rows if str(r.get('monitorDisplayId',''))==str(d['id']) or r.get('monitorName')==d['name']),None)
                if row:matched[str(d['id'])]=(row['gridColumn'],row['gridRow'])
            if len(matched)==len(displays):candidates.append((len(rows),order,matched))
        if candidates:positions=min(candidates,key=lambda x:x[:2])[2]
        # Reject incomplete/custom geometry instead of guessing a different map.
        if not positions:raise RuntimeError('OmniWM 自定义方向图尚未覆盖当前屏幕，请运行 Monitor Setup')
    else:
        for d in displays:
            f=d['frame'];positions[str(d['id'])]=(f['x']+f['width']/2,-f['y']-f['height']/2)
    origin=positions[str(current['id'])];choices=[]
    for d in displays:
        if d['id']==current['id']:continue
        p=positions[str(d['id'])];dx=p[0]-origin[0];dy=p[1]-origin[1]
        primary={'left':-dx,'right':dx,'up':-dy,'down':dy}[direction]
        secondary=abs(dy if direction in ('left','right') else dx)
        if primary<=0:continue
        if routing.get('mode')=='custom' and secondary!=0:continue
        # In macOS mode, prefer a direction whose angular distance is <=45°.
        if routing.get('mode')!='custom' and secondary>primary:continue
        choices.append((primary+secondary,d))
    return min(choices,key=lambda x:x[0])[1] if choices else None
def monitor(mode,direction):
    displays=query('displays')['displays'];config=tomllib.loads(CONFIG.read_text())
    target=directional_target(displays,direction,config)
    if not target:return
    workspace=target.get('activeWorkspace')
    if not workspace:raise RuntimeError('目标显示器没有活动工作区；请先完成 Monitor Setup')
    name=workspace['rawName']
    if mode=='focus-monitor':cli('workspace','focus-name',name)
    else:cli('command','move-column-to-workspace',name)
def focus_app(bundle):
    try:
        windows=query('windows','--bundle-id',bundle).get('windows',[])
        if windows:cli('window','navigate',windows[0]['id']);return
    except RuntimeError:pass
    subprocess.run(['/usr/bin/open','-b',bundle],check=True)
def focus_layer():
    windows=query('windows','--visible').get('windows',[])
    focused=next((w for w in windows if w.get('isFocused')),None)
    if not focused:return
    opposite=[w for w in windows if (w.get('mode')=='floating')!=(focused.get('mode')=='floating') and w.get('workspace')==focused.get('workspace')]
    if opposite:cli('window','navigate',opposite[0]['id'])
def toggle_hotkeys(value):
    text=CONFIG.read_text()
    changed,count=re.subn(r'(?m)^("?hotkeysEnabled"?\s*=\s*)(true|false)\s*$',r'\g<1>'+value,text)
    if count!=1:raise RuntimeError('Cannot identify general.hotkeysEnabled')
    CONFIG.write_text(changed)
def main():
    mode=sys.argv[1]
    if mode in ('focus-monitor','column-monitor'):monitor(mode,sys.argv[2])
    elif mode=='focus-app':focus_app(sys.argv[2])
    elif mode=='focus-layer':focus_layer()
    elif mode=='hotkeys':toggle_hotkeys(sys.argv[2])
    else:raise RuntimeError('Unknown operation')
if __name__=='__main__':
    try:main()
    except Exception as error:print(str(error),file=sys.stderr);sys.exit(1)
