SYNFGRAPH	;ven/gpl - fhir loader utilities ; 2/20/18 4:11am
	;;1.0;fhirloader;;oct 19, 2017;Build 2
	;
	; Authored by George P. Lilly 2017-2018
	;
	q
	;
index(graph) ; will create a pos and ops index at the place pointed to by graph
 ; graph is passed by name
 ; 
 i $d(@graph@("pos")) k @graph@("pos")
 i $d(@graph@("ops")) k @graph@("ops")
 n zi s zi=0
 f  s zi=$o(@graph@(zi)) q:+zi=0  d  ;
 . n zj,zv
 . s zj=""
 . f  s zj=$o(@graph@(zi,zj)) q:zj=""  d  ;
 . . s zv=$g(@graph@(zi,zj))
 . . q:zv=""
 . . s @graph@("pos",zj,zv,zi)=""
 . . s @graph@("ops",zv,zj,zi)=""
 q
 ;
graphmap(graph,code,otype,itype) ; extrinsic mapping function using a graph
 ; graph is a pointer to the graph passed by name
 ; code is the subject to map
 ; otype is the predicate for the result
 ; itype is the predicate for the subject (optional)
 ;
 ;i '$d(@graph@("pos")) d  ;
 i $e(graph,1,1)'="^" d  ;
 . n root s root=$$setroot^%wd(graph)
 . s graph=$g(@root@("index","root"))
 i '$d(@graph@("pos")) q "-1^Error, can't find index"
 n gien,ipred,opred
 s ipred=$g(itype)
 i ipred="" s ipred=$o(@graph@("ops",code,""))
 ;w !,"ipred= "_ipred
 i ipred="" q "-1^Code not found"
 s gien=$o(@graph@("ops",code,ipred,""))
 ;w !,"gien= "_gien,!
 ;zwr @graph@(gien,*) 
 ;w !,graph
 s opred=$g(otype)
 i opred="" s opred=$o(@graph@(gien,ipred))
 i opred="" s opred=$o(@graph@(gien,ipred),-1)
 ;w !,"opred= "_opred
 q $g(@graph@(gien,opred))
 ;
 s gien=$o(@graph@("ops")) 
 n ugraph s ugraph=""
 i '$d(@graph@("pos")) d  ; fix the pointer 
 . i $d(@graph@("graph","pos")) s ugraph=$na(@graph@("graph"))
 . n graphname s graphname=$o(@graph@("graph",""))
 . i graphname="" s ugraph="" q  ; don't understand this graph
 . i $d(@graph@("graph",graphname,"pos")) s ugraph=$na(@graph@("graph",graphname))
 q
 ;
getGraphMap(rtn,graph,ipred,iobj,opred,oobj) ; retrieve a section of the graph
 ; extrinsic return 1 on success and -1 on failure
 ; identified by predicate ipred with object iobj
 ; if opred (output predicate) and/or oobj (output object) are specified, 
 ;  they are treated and a "and" condition on the retrieval
 ;
 n root s root=$$setroot^%wd(graph)
 n groot s groot=$g(@root@("index","root"))
 i groot="" q "-1^can't find graph root"
 i '$d(@groot@("pos")) q "-1^can't find graph index"
 k @rtn
 ;
 n gien
 i $g(iobj)'="" i $o(@groot@("ops",iobj,""))'="" d  ;
 . i $g(ipred)'="" d  q  ;
 . . s gien=$o(@groot@("pos",ipred,iobj,""))
 . . m @rtn=@groot@(gien)
 . n tpred
 . s tpred=$o(@groot@("ops",iobj,""))
 . s gien=$o(@groot@("pos",tpred,iobj,""))
 . m @rtn=@groot@(gien)
 i $d(@rtn) q 1
 q "-1^No Match"
 ;
getGraph(url,gname) ; get a graph from a web service
 ;
 q:'$d(gname)
 i $$rootOf^%wd(gname)'=-1 d  q  ;
 . w !,"error, graph exists: "_gname
 n root s root=$$setroot^%wd(gname)
 n %,json,grf
 s %=$$%^%WC(.json,"GET",url)
 w !,"result= ",%
 i '$d(json) d  q  ;
 . w !,"error, nothing returned"
 d DECODE^VPRJSON("json","grf")
 m @root=grf
 n indx,rindx
 s indx=$o(@root@(0))
 s rindx=$na(@root@(indx))
 s @root@("index","root")=rindx
 d index(rindx)
 q
 ;
