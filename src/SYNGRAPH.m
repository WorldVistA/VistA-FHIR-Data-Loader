SYNFGRAPH       ;ven/gpl - fhir loader utilities ;2018-08-17  3:26 PM
 ;;0.7;VISTA SYN DATA LOADER;;Mar 18, 2025
 ;
 ; Copyright (c) 2017-2018 George P. Lilly
 ;
 ;Licensed under the Apache License, Version 2.0 (the "License");
 ;you may not use this file except in compliance with the License.
 ;You may obtain a copy of the License at
 ;
 ;    http://www.apache.org/licenses/LICENSE-2.0
 ;
 ;Unless required by applicable law or agreed to in writing, software
 ;distributed under the License is distributed on an "AS IS" BASIS,
 ;WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 ;See the License for the specific language governing permissions and
 ;limitations under the License.
 ;
 ;
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
 . n root s root=$$setroot^SYNWD(graph)
 . s graph=$g(@root@("index","root"))
 i $g(graph)="" q "-1^Error, can't find graph"
 i '$d(@graph@("pos")) q "-1^Error, can't find index"
 i $g(code)="" q "-1^Error, code not provided"
 n gien,ipred,opred
 s ipred=$g(itype)
 i ipred="" s ipred=$o(@graph@("ops",code,""))
 ;w !,"ipred= "_ipred
 i ipred="" q "-1^Code not found"
 s gien=$o(@graph@("ops",code,ipred,""))
 ;w !,"gien= "_gien,!
 ;zwrite @graph@(gien,*)
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
 n root s root=$$setroot^SYNWD(graph)
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
loincMap() ; create the lonic-lab-map
 n root s root=$$setroot^SYNWD("loinc-lab-map")
 k @root
 n src s src=$$rootOf^SYNWD("loinc-code-map")
 s src=$na(@src@("loinc-codes-map-1.csv"))
 n zi s zi=0
 f  s zi=$o(@src@(zi)) q:+zi=0  d  ;
 . n zj s zj=""
 . f  s zj=$o(@src@(zi,zj)) q:zj=""  d  ;
 . . n zt s zt=$$TRIM^XLFSTR(@src@(zi,zj))
 . . q:zt=""
 . . s @root@("graph","map",zi,zj)=zt
 s rindx=$na(@root@("graph","map"))
 s @root@("index","root")=rindx
 d index(rindx)
 q
 ;
covid(loinc) ; extrinsic returns the name of the lab test  in ^LAB(60,
 ; for the loinc code
 q -1  ; change the iens to match your covid tests before using this
 n rt,rien,LAB
 s LAB(5091)="COVID-19 (PHRL)"
 s LAB(5092)="COVID-19 CONFIRMATORY"
 s LAB("94531-1",5093)="COVID-19 PANEL"
 s LAB("92130-4",5096)="Rhinovirus RNA Ql"
 ;s LAB("92130-4",5096)="RHINOVIRUS RNA RESP"
 s LAB("92131-2",5097)="RESPSYNVIRUS RNA"
 ;s LAB("92134-6",5098)="METAPNEUMOVIRUS RNA"
 s LAB("92134-6",5098)="HUMAN METAPNEURMOVIRUS RNA Ql"
 ;s LAB("92138-7",5099)="PARAINFLUENZA VIRUS 3 RNA"
 s LAB("92138-7",5099)="PARAINFLUENZA VIRUS 3 RNA Ql"
 ;s LAB("92139-5",5100)="PARAINFLUENZA VIRUS 2 RNA"
 s LAB("92139-5",5100)="PARAINFLUENZA VIRUS 2 RNA Ql"
 ;s LAB("92140-3",5101)="PARAINFLUENZA VIRUS 1 RNA"
 s LAB("92140-3",5101)="PARAINFLUENZA VIRUS 1 RNA Ql"
 ;s LAB("92141-1",5103)="INFLUENZA B RNA"
 s LAB("92141-1",5103)="INFLUENZA B RNA Ql"
 s LAB("80383-3",5103)="INFLUENZA B RNA Ql"
 ;s LAB("92142-9",5104)="INFLUENZA A RNA"
 s LAB("92142-9",5104)="INFLUENZA A RNA Ql PCR"
 s LAB("80382-5",5104)="INFLUENZA A RNA Ql PCR"
 ;s LAB("94040-3",5105)="ADENOVIRUS A+B+C+D+E DNA"
 s LAB("94040-3",5105)="HUMAN ADENOVIRUS DNA Ql"
 s rien=$o(LAB(loinc,""))
 s rt=$g(LAB(loinc,rien))
 i rt="" s rt=-1
 q rt
 ;
