SYNSYNCH ;ven/gpl - fhir loader utilities ;2018-08-17  3:27 PM
 ;;0.1;VISTA SYNTHETIC DATA LOADER;;Aug 17, 2018;Build 45
 ;
 ; Authored by George P. Lilly 2017-2018
 ;
 q
 ;
URL(WHICH) ; 
 ;q:WHICH="SYN" "http://syn.vistaplex.org/"
 q:WHICH="SYN" "206.189.178.171"
 q ""
 ;
WSIDSYNC(RTN,FILTER) ; identify patients to synch
 ; FILTER("source")=name of the source
 ; FILTER("url")=url to the source system RGNET services
 ;
 n rslt
 ;
 q:'$$getlist(.RTN,.FILTER,.rslt)
 ;
 d clean("vista-synch")
 ;
 d match("vista-synch",.rslt)
 ;
 d ENCODE^VPRJSON("rslt","RTN")
 q
 ;
getlist(RTN,FILTER,rslt) ; extrinsic puts list in a graph returns 0 on fail
 ;
 n name,url
 s name=$g(FILTER("source"))
 s url=$g(FILTER("url"))
 i name="" s name="not found"
 s rslt("result","source")=name
 i url="" s url=$$URL(name)
 i url="" s url="not found"
 s rslt("result","url")=url
 i url="not found" d  q 0
 . s rslt("result","status")="url not provided, aborting"
 . d ENCODE^VPRJSON("rslt","RTN")
 s url=url_"/DHPPATICNALL?JSON=J"
 n gname s gname="vista-synch"
 n root s root=$$setroot^%wd(gname)
 ;
 d  ;
 . n gtmp s gtmp=$g(@root@(0))
 . k @root
 . s @root@(0)=gtmp
 . s rslt("result","graph")=gtmp
 ;
 n zret,json,jtmp
 ;s zret=$$%^%WC(.json,"GET",url)
 s zret=$$GETURL^XTHC10(url,,"jtmp")
 s rslt("result","status")=zret
 d assemble^SYNFPUL("jtmp","json")
 ;w !,"return is: ",zret,!
 ;zwrite json
 ;
 n lien,jary
 s lien=$o(@root@("B",name,""))
 i lien'="" k @root@(lien)
 e  set lien=$order(@root@(" "),-1)+1
 s @root@("B",name,lien)=""
 ;
 set gr=$name(@root@(lien,"list"))
 do DECODE^VPRJSON("json",gr)
 s @gr@("name")=name
 ;
 q 1
 ;
clean(zgr) ; clean graph zgr - remove "/s" nodes
 n root s root=$$setroot^%wd(zgr)
 q:root=""
 n groot s groot=$na(@root@(1,"list"))
 n zi s zi=""
 f  s zi=$o(@groot@(zi)) q:zi=""  d  ;
 . i $d(@groot@(zi,"\s")) k @groot@(zi,"\s")
 q
 ; 
match(graph,rslt) ; matches ICNs to local system
 ;
 n root s root=$$setroot^%wd(graph)
 n groot s groot=$na(@root@(1,"list"))
 n intake s intake=$$setroot^%wd("fhir-intake")
 n icndex s icndex=$na(@intake@("POS","ICN"))
 ;
 n matcnt,syncnt,cnt
 s (matcnt,syncnt,cnt)=0
 n zi s zi=""
 f  s zi=$o(@groot@(zi)) q:+zi=0  d  ;
 . s cnt=cnt+1
 . n fien
 . s fien=$o(@icndex@(zi,""))
 . i fien'="" d  ;
 . . s matcnt=matcnt+1
 . . s @groot@(zi,"match")=""
 . . s @groot@(zi,"fien")=fien
 . . n dfn
 . . s dfn=$$ien2dfn^SYNFUTL(fien)
 . . s @groot@(zi,"dfn")=dfn
 . . n newicn
 . . s newicn=$$newIcn2^SYNFPAT(dfn)
 . . i zi'=newicn d  ;
 . . . s @groot@("zi","newIcn")=newicn
 . . . s @groot@("newIcn",newicn)=""
 . . . s @groot@("newIcn",newicn,"oldIcn")=zi
 . . . s @groot@("newIcn",newicn,"dfn",dfn)=""
 . i fien=""  d  ;
 . . s syncnt=syncnt+1
 . . s @groot@(zi,"synch")=""
 . . s @groot@("synch",zi)=""
 s rslt("result","match","icntotal")=cnt
 s rslt("result","match","matchcount")=matcnt
 s rslt("result","match","synchcount")=syncnt
 q
 ;
