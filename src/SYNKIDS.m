SYNKIDS	;ven/gpl - fhir loader utilities ;2018-08-03  11:24 AM
	;;1.0;fhirloader;;oct 19, 2017;Build 2
	;
	; Authored by George P. Lilly 2017-2018
	;
	q
	;
PRETRAN ;
 n root s root=$$setroot^%wd("kids-manifest") ; tells us what to load
 i '$d(@root@("load")) q  ; nothing to load
 n zi s zi=""
 f  s zi=$o(@root@("load",zi)) q:zi=""  d
 . n gn s gn=$$setroot^%wd(zi)
 . q:gn=""
 . m @XPDGREF@(zi)=@gn
 m @XPDGREF@("kids-manifest")=@root
 q:$q "" q
 ;
PRE ; load the transported graphs
 n zmani s zmani=$na(@XPDGREF@("kids-manifest"))
 i '$d(@zmani) q
 n zi s zi=""
 f  s zi=$o(@zmani@("load",zi)) q:zi=""  d
 . n gn s gn=$$setroot^%wd(zi)
 . i $d(@gn) d purgegraph^%wd(zi)
 . m @gn=@XPDGREF@(zi)
 q
 ;
schedload(graph) ;
 n root s root=$$setroot^%wd("kids-manifest")
 i +$$rootOf^%wd(graph)=-1 d  q  ; can't load that; doesn't exist
 . w !,"error, graph doesn't exist: "_graph
 s @root@("load",graph)=""
 q
 ;
clearmani ; clear the kids manifest
 d purgegraph^%wd("kids-manifest")
 q
 ;
schedndfrt ; schedule the loading of the ndfrt-map graph
 d schedload("ndfrt-map")
 q
 ;
schedlab ; schedule the loading of the loinc-lab-map graph
 d schedload("loinc-lab-map")
 q
 ;
