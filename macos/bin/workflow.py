#!/opt/homebrew/bin/python3
"""macOS adapters for the existing niri PDF and Better BibTeX workflows."""
import json,os,pathlib,subprocess,sys,time,urllib.request

RPC=os.environ.get('NIRI_MAC_RPC_URL','http://127.0.0.1:23119/better-bibtex/json-rpc')
OPENER=urllib.request.build_opener(urllib.request.ProxyHandler({}))
def rpc(method,params):
    req=urllib.request.Request(RPC,json.dumps(dict(jsonrpc='2.0',id=1,method=method,params=params)).encode(),{'Content-Type':'application/json','Accept':'application/json'})
    with OPENER.open(req,timeout=15) as r: data=json.load(r)
    if 'error' in data: raise RuntimeError(f"Better BibTeX {method}: {data['error']}")
    if 'result' not in data: raise RuntimeError('Better BibTeX response has no result')
    return data['result']
def ready():
    try: return rpc('api.ready',[])
    except (OSError,urllib.error.URLError):
        subprocess.run(['/usr/bin/open','-b','org.zotero.zotero'],check=True)
        for _ in range(15):
            time.sleep(1)
            try: return rpc('api.ready',[])
            except (OSError,urllib.error.URLError): pass
        raise RuntimeError('Zotero / Better BibTeX 接口未就绪。请确认插件已启用并完成首次索引。')
def choose(data,prompt,zero=False,extra=()):
    args=['fzf','--prompt='+prompt,'--height=80%','--layout=reverse','--border',*extra]
    if zero: args += ['--read0','--print0']
    p=subprocess.run(args,input=data,stdout=subprocess.PIPE)
    if p.returncode in (1,130): return None
    if p.returncode: raise RuntimeError(f'fzf exited {p.returncode}')
    return p.stdout.rstrip(b'\0' if zero else b'\n').decode()
def search_pdf():
    p=subprocess.Popen(['fd','--type','f','--extension','pdf','--print0','.',str(pathlib.Path.home())],stdout=subprocess.PIPE,stderr=subprocess.DEVNULL)
    f=subprocess.run(['fzf','--read0','--print0','--prompt=PDF> ','--layout=reverse','--border'],stdin=p.stdout,stdout=subprocess.PIPE)
    p.stdout.close()
    # Selecting or cancelling fzf should also stop this invocation's scan.
    if p.poll() is None:p.terminate()
    p.wait()
    if f.returncode in (1,130):return
    if f.returncode:raise RuntimeError(f'fzf exited {f.returncode}')
    file=f.stdout.rstrip(b'\0').decode()
    if file:subprocess.run(['/usr/bin/open','-a',os.environ.get('NIRI_MAC_PDF_APP','Skim'),file],check=True)
def items():
    ready()
    return rpc('item.search',[[['ignore_feeds'],['itemType','isNot','attachment']]])
def rows(entries):
    result=[]
    for item in entries:
        key=item.get('citekey') or item.get('citation-key')
        if not key:continue
        authors=', '.join(a.get('family') or a.get('literal') or a.get('given') or '' for a in (item.get('author') or item.get('editor') or []))
        parts=(item.get('issued') or {}).get('date-parts') or [[]]
        year=parts[0][0] if parts and parts[0] else ''
        cells=[key,item.get('title') or '[no title]',authors,year]
        result.append('\t'.join(str(c).replace('\t',' ').replace('\n',' ') for c in cells))
    return ('\n'.join(result)+'\n').encode() if result else b''
def attachment(key):
    attachments=rpc('item.attachments',[key,'*'])
    if not attachments:raise RuntimeError('所选文献没有可打开的附件')
    uri=next((a.get('open') for a in attachments if a.get('open')),None)
    if not uri or not uri.startswith('zotero://open-pdf/'):raise RuntimeError('Better BibTeX 没有返回有效的 Zotero PDF 地址')
    return uri
def zotero(mode,key=None):
    if key is None:
        data=rows(items())
        if not data:raise RuntimeError('文献列表中没有 citekey；请检查 Better BibTeX 初始索引')
        selection=choose(data,'Zotero title> ' if mode=='copy' else 'Open Zotero paper> ',extra=('--delimiter=\t','--with-nth=2,3,4'))
        if not selection:return
        key=selection.split('\t',1)[0]
    else:ready()
    if mode=='copy':
        subprocess.run(['/usr/bin/pbcopy'],input=key.encode(),check=True)
        print('Copied citekey: '+key)
    else:
        uri=attachment(key)
        # Linux's old target "read" is absent in the source workspace list.
        # The Mac rule consistently uses the configured Zotero workspace 2.
        subprocess.run(['/opt/homebrew/bin/omniwmctl','workspace','focus-name','2'],stdout=subprocess.DEVNULL,stderr=subprocess.DEVNULL)
        subprocess.run(['/usr/bin/open',uri],check=True)
def main():
    mode=sys.argv[1]
    if mode=='pdf':search_pdf()
    elif mode=='copy':zotero('copy')
    elif mode=='open':zotero('open')
    elif mode=='open-key':zotero('open',sys.argv[2])
    elif mode=='probe':
        ready(); entries=items();print(json.dumps({'ready':True,'items':len(entries),'citekeys':len(rows(entries).splitlines())}))
    else:raise RuntimeError('Unknown workflow '+mode)
if __name__=='__main__':
    try:main()
    except KeyboardInterrupt:sys.exit(130)
    except Exception as error:print(str(error),file=sys.stderr);sys.exit(1)
