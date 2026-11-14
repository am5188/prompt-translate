import re,sys,urllib.request,html
def get(u):
    req=urllib.request.Request(u,headers={'User-Agent':'Mozilla/5.0'})
    with urllib.request.urlopen(req,timeout=90) as r: t=r.read().decode('utf-8','ignore')
    t=re.sub(r'(?is)<(script|style|math)[^>]*>.*?</\1>',' ',t)
    t=re.sub(r'(?s)<[^>]+>',' ',t)
    t=html.unescape(t); t=re.sub(r'\s+',' ',t)
    return t
def show(u,kws,limit=6):
    t=get(u); print('\n#####',u,len(t))
    sents=re.split(r'(?<=[.!?])\s+',t)
    for kw in kws:
        n=0
        for s in sents:
            if kw.lower() in s.lower() and ('%' in s or re.search(r'\d',s)):
                print(f'[{kw}] {s[:420]}'); n+=1
                if n>=limit: break
if __name__=='__main__':
    u=sys.argv[1]; kws=sys.argv[2].split('|')
    show(u,kws,int(sys.argv[3]) if len(sys.argv)>3 else 6)
