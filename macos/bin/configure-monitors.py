#!/opt/homebrew/bin/python3
"""Prefer the single external display without relying on unstable display IDs."""
import json,pathlib,sys,tomllib,uuid
ROOT=pathlib.Path.home()/'.dotfiles/macos'
path=ROOT/'omniwm/settings.toml'
def value(v):
    if isinstance(v,bool):return str(v).lower()
    if isinstance(v,(str,int,float)):return json.dumps(v,ensure_ascii=False)
    if isinstance(v,list):return '['+', '.join(value(x) for x in v)+']'
    raise TypeError(type(v))
def dump(obj,prefix=''):
    lines=[]
    for k,v in obj.items():
        if not isinstance(v,dict) and not (isinstance(v,list) and v and isinstance(v[0],dict)):lines.append(f'{json.dumps(k)} = {value(v)}')
    for k,v in obj.items():
        name=(prefix+'.' if prefix else '')+json.dumps(k)
        if isinstance(v,dict):lines+=['',f'[{name}]',*dump(v,name)]
        elif isinstance(v,list) and v and isinstance(v[0],dict):
            for row in v:lines+=['',f'[[{name}]]',*dump(row,name)]
    return lines
def configure(screens):
    if not screens:return False
    d=tomllib.loads(path.read_text())
    builtin=[s for s in screens if s.get('builtIn')]
    external=[s for s in screens if not s.get('builtIn')]
    # The known P275MV gets priority if a DisplayLink/virtual screen is also present.
    external.sort(key=lambda s:s['uuid']!='7B4E6EDD-D372-477B-8A88-09D69E5B3A3B')
    main=(external or builtin or screens)[0]
    auxiliary=(builtin or [main])[0]
    changed=False
    # v0.6.10 centers the bar, then clamps its NSPanel to the screen edges.
    # The built-in bar uses a negative half-width offset to stay left-aligned;
    # external bars use zero offset to stay centered as their contents change.
    for screen in screens:
        width=screen.get('width')
        if not width or width<=0:continue
        override=next((r for r in d['monitorBarOverrides'] if r.get('monitorDisplayUUID')==screen['uuid']),None)
        if override is None:
            override={'id':str(uuid.uuid5(uuid.NAMESPACE_URL,'niri-mac:bar:'+screen['uuid'])).upper(),
                      'monitorName':screen['name'],'monitorDisplayUUID':screen['uuid'],'monitorDisplayId':screen['id']}
            d['monitorBarOverrides'].append(override);changed=True
        # Both display types share the native menu-bar row without extra space.
        # Split-notch mode is off because the built-in bar sits on the left.
        options={'xOffset':-float(width)/2 if screen.get('builtIn') else 0.0,
                 'position':'overlappingMenuBar','reserveLayoutSpace':False,
                 'notchMode':'off','yOffset':0.0}
        for key,value in options.items():
            if override.get(key)!=value:override[key]=value;changed=True
    for ws in d['workspaces']:
        if ws['name'] not in [str(i) for i in range(1,10)]:continue
        screen=main if int(ws['name'])<=7 else auxiliary
        assignment={'type':'specificDisplay','output':{'name':screen['name'],'displayUUID':screen['uuid'],'displayId':screen['id']}}
        if ws['monitorAssignment']!=assignment:ws['monitorAssignment']=assignment;changed=True
    if changed:
        text='\n'.join(dump(d))+'\n';assert tomllib.loads(text)==d
        # Resolve the symlink before replacing; preserve repository ownership.
        target=path.resolve();tmp=target.with_suffix('.toml.tmp');tmp.write_text(text);tmp.replace(target)
    print(json.dumps({'changed':changed,'main':main['name'],'auxiliary':auxiliary['name'],'screens':len(screens),'barAlignment':{'builtIn':'left','external':'center'}}))
    return changed
if __name__=='__main__':configure(json.loads(sys.argv[1]))
