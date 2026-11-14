import sys, urllib.parse, urllib.request, xml.etree.ElementTree as ET, json, time
ns={'a':'http://www.w3.org/2005/Atom'}
def q(query, n=5, sort='relevance'):
    url='https://export.arxiv.org/api/query?search_query='+urllib.parse.quote(query)+f'&max_results={n}&sortBy={sort}'
    with urllib.request.urlopen(url, timeout=60) as r: data=r.read()
    root=ET.fromstring(data)
    out=[]
    for e in root.findall('a:entry',ns):
        out.append({'id':e.find('a:id',ns).text.strip().split('/abs/')[-1],
                    'title':' '.join(e.find('a:title',ns).text.split()),
                    'date':e.find('a:published',ns).text[:10],
                    'summary':' '.join(e.find('a:summary',ns).text.split())[:400]})
    return out
def ids(idlist):
    url='https://export.arxiv.org/api/query?id_list='+','.join(idlist)+'&max_results=50'
    with urllib.request.urlopen(url, timeout=60) as r: data=r.read()
    root=ET.fromstring(data); out=[]
    for e in root.findall('a:entry',ns):
        out.append({'id':e.find('a:id',ns).text.strip().split('/abs/')[-1],
                    'title':' '.join(e.find('a:title',ns).text.split()),
                    'date':e.find('a:published',ns).text[:10],
                    'summary':' '.join(e.find('a:summary',ns).text.split())[:600]})
    return out
if __name__=='__main__':
    mode=sys.argv[1]
    if mode=='ids':
        for p in ids(sys.argv[2].split(',')): print(json.dumps(p,ensure_ascii=False))
    else:
        for p in q(sys.argv[2], int(sys.argv[3]) if len(sys.argv)>3 else 5):
            print(json.dumps(p,ensure_ascii=False))
