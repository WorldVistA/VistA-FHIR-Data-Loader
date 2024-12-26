C0XGET1 ; GPL - Fileman Triples entry point routine ;1/12/12  17:05
 ;;1.0;FILEMAN TRIPLE STORE;;Sep 26, 2012;Build 11
 ;Copyright 2011 George Lilly.  Licensed under the terms of the GNU
 ;General Public License See attached copy of the License.
 ;
 ;This program is free software; you can redistribute it and/or modify
 ;it under the terms of the GNU General Public License as published by
 ;the Free Software Foundation; either version 2 of the License, or
 ;(at your option) any later version.
 ;
 ;This program is distributed in the hope that it will be useful,
 ;but WITHOUT ANY WARRANTY; without even the implied warranty of
 ;MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 ;GNU General Public License for more details.
 ;
 ;You should have received a copy of the GNU General Public License along
 ;with this program; if not, write to the Free Software Foundation, Inc.,
 ;51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
 ;
 Q
 ;
LSSUBJ(RTN,ZSUBJ,C0XFARY) ; LIST NODES WITH SUBJECT ZSUBJ
 ;
 I '$D(C0XFARY) D INITFARY^C0XF2N("C0XFARY")
 D USEFARY^C0XF2N("C0XFARY")
 Q
 ;
graph(sub,pred,obj,form,fary) ; extrinsic which returns a graph name
 I '$D(fary) D  ;
 . S fary="C0XFARY"
 . D INITFARY^C0XF2N(fary)
 D USEFARY^C0XF2N(fary)
 k triplertn ; start with a clean return
 n zsub,zpred,zobj,zgraph,tmprtn
 s zsub=$$IENOF($$EXT^C0XUTIL($g(sub)),fary) ; ien of subject
 s zpred=$$IENOF($$EXT^C0XUTIL($g(pred)),fary) ; ien of predicate
 s zobj=$$IENOF($$EXT^C0XUTIL($g(obj)),fary) ; ien of object
 s zgraph=$$IENOF($g(graph),fary) ; ien of graph
 I $G(DEBUG) W !,"s:",zsub," p:",zpred," o:",zobj
 d trip(.tmprtn,zsub,zpred,zobj,zgraph,fary)
 n ztmp
 d trip(.ztmp,$g(sub),$g(pred),$g(obj),"",$g(fary))
 n zi,zg,zrtn
 s zi=$o(tmprtn(""))
 s zg=$$GET1^DIQ(C0XTFN,zi,.02,"E") ;
 i zg="" q ""
 s zrtn=zg
 i $o(tmprtn(zi))'="" d  
 . s zrtn=""
 q zrtn
 ;
GRAPHS(RTN,C0XFARY) ; LIST ALL GRAPHS
 ;
 I '$D(C0XFARY) D INITFARY^C0XF2N("C0XFARY")
 D USEFARY^C0XF2N("C0XFARY")
 N ZI S ZI=""
 F  S ZI=$O(@C0XTN@("G",ZI)) Q:ZI=""  D  ;
 . S RTN(ZI,$$STR(ZI))=""
 Q
 ;
STR(ZIN,C0XFARY) ; EXTRINSIC RETURNS A STRING
 I '$D(C0XFARY) D INITFARY^C0XF2N("C0XFARY")
 Q $$GET1^DIQ(C0XSFN,ZIN,.01,"E")
 ;
SPO(ZRTN,ZNODE,C0XFARY) 
 I '$D(C0XFARY) D INITFARY^C0XF2N("C0XFARY")
 N ZI S ZI=$$NXT(.ZRTN)
 S ZRTN(ZI,"S")=$$S(ZNODE)
 S ZRTN(ZI,"P")=$$P(ZNODE)
 S ZRTN(ZI,"O")=$$O(ZNODE)
 Q
 ;
S(ZNODE,C0XFARY) ; EXTRINSIC RETURNING THE SUBJECT
 Q $$STR($$GET1^DIQ(C0XTFN,ZNODE,.03,"I")) ;
 ;
P(ZNODE,C0XFARY) ; EXTRINSIC RETURNING THE PREDICATE
 Q $$STR($$GET1^DIQ(C0XTFN,ZNODE,.04,"I")) ;
 ;
O(ZNODE,C0XFARY) ; EXTRINSIC RETURNING THE OBJECT
 Q $$STR($$GET1^DIQ(C0XTFN,ZNODE,.05,"I")) ;
 ;
NXT(ZRTN) ;EXTRINSIC FOR THE NEXT NODE IN ARRAY ZRTN, PASSED BY REF
 I '$D(ZRTN) S ZRTN=""
 Q $O(ZRTN(""),-1)+1
 ;
SING(ZRTN,ZG) ; SUBJECTS IN GRAPH
 ;
 I '$D(C0XFARY) D INITFARY^C0XF2N("C0XFARY")
 I '$D(ZRTN) S ZRTN=""
 N ZI,ZN S ZI=""
 F  S ZI=$O(@C0XTN@("GSPO",ZG,ZI)) Q:ZI=""  D  ;
 . S ZRTN($$NXT(.ZRTN),"S")=$$STR(ZI)
 Q
 ;
qparse(qrtn,zquery) ; parses the query
 ; want this to be able to handle the WHERE clause of SPARQL eventually
 ;
 n q1,q2,q3,qq
 ;s qq=$tr(zquery,"  ","^")
 s qq=query ; really want to remove whitespace here
 s q1=$p(qq," ",1)
 i q1["?" s q1=""
 s q2=$p(qq," ",2)
 i q2["?" s q2=""
 s q3=$p(qq," ",3)
 i q3["?" s q3=""
 s qrtn(1)=q1_"^"_q2_"^"_q3 ; more lines to come later
 q
 ;
getGraph(zrtn,zgrf,form) ; get all triples in graph zgrf
 ; forms planned: "rdf" "json" "array" "turtle" "triples" "raw"
 ; forms supported: "rdf" "json" "array" "raw"
 I '$D(form) S form="rdf"
 N ZIENS,ZTRIP
 D TING^C0XF2N(.ZIENS,zgrf)
 I '$D(ZIENS) Q  ;
 D ien2tary(.ZTRIP,"ZIENS")
 I form="json" d jsonout(.zrtn,.ZTRIP) q  ; what follows is else
 i form="rdf" d rdfout^C0XRDF(.zrtn,.ZTRIP) q  ;
 i form="array" d arrayout^C0XGET1(.zrtn,.ZTRIP) q  ;
 i form="raw" d rawout^C0XGET1(.zrtn,.ZTRIP) q  ;
 W !,"Form not supported: ",form
 Q
 ;
rpctrip(rtn,query,limit,offset) ; rpc to access triples with a query
 ;
 n zoff,zlim,zcount,zq
 k rtn
 i '$d(limit) s limit=250
 i '$d(offset) s offset=0
 d qparse(.zq,query) ; parse the query
 n qsub,qpred,qobj,qtmp
 W !,zq(1)
 s qsub=$p(zq(1),"^",1)
 s qpred=$p(zq(1),"^",2)
 s qobj=$p(zq(1),"^",3)
 d SYNFARY^SYNFHIR2("FHIRARY",122)
 d triples(.qtmp,qsub,qpred,qobj,"","raw","FHIRARY")
 f zcount=offset+1:1:offset+limit q:'$d(qtmp(zcount))  d  ;
 . s rtn(zcount)=qtmp(zcount)
 q
 ;
triples(triplertn,sub,pred,obj,graph,form,fary) ; returns triples
 I '$D(fary) D  ;
 . D INITFARY^C0XF2N("C0XFARY")
 . S fary="C0XFARY"
 D USEFARY^C0XF2N(fary)
 I '$D(form) S form="json"
 k triplertn ; start with a clean return
 n zsub,zpred,zobj,zgraph,tmprtn
 i $g(FMTSSTYLE)="F2N" d  ;
 . s zsub=$$IENOF($$EXT^C0XUTIL($g(sub)),fary) ; ien of subject
 . s zpred=$$IENOF($$EXT^C0XUTIL($g(pred)),fary) ; ien of predicate
 . s zobj=$$IENOF($$EXT^C0XUTIL($g(obj)),fary) ; ien of object
 . s zgraph=$$IENOF($g(graph),fary) ; ien of graph
 e  d  ;
 . s zsub=sub
 . s zpred=pred
 . s zobj=obj
 . s zgraph=graph
 I $G(DEBUG) W !,"s:",zsub," p:",zpred," o:",zobj
 d trip(.tmprtn,zsub,zpred,zobj,zgraph,fary)
 d ien2tary(.zrary,"tmprtn") ; convert to triples
 ;
 ;zwr zrary
 ;b
 ;
 i form="json" d jsonout(.triplertn,.zrary) q  ; what follows is 'else'
 i form="rdf" d rdfout^C0XRDF(.triplertn,.zrary) q  ;
 i form="array" d arrayout(.triplertn,.zrary) q  ;
 i form="raw" d rawout(.triplertn,.zrary) q  ;
 w !,"form not supported: ",form 
 q
 ;
subjects(listrtn,pred,obj,graph,form,fary) ; return list of subjects
 d onelist("S",,$g(pred),$g(obj),$g(fary)) ;subjects
 q
 ;
subject(pred,obj,graph,form,fary) ; extrinsic which returns the first
 ; multiple of return from subjects - returns null if more than one
 ; subjects(.G,sub,pred)
 ; G("nodeID:1234") ==> "nodeID:1234"
 n zin,zrtn
 d subjects(.zin,$g(pred),$g(obj),$g(form),$g(fary))
 s zrtn=$o(zin(""))
 i $o(zin(zrtn))'="" s zrtn=""
 q zrtn
 ;
preds(listrtn,sub,obj,graph,form,fary) ; return list of subjects
 d onelist("P",$g(sub),,$g(obj),$g(fary)) ;subjects
 q
 ;
objects(listrtn,sub,pred,graph,form,fary) ; return list of subjects
 d onelist("O",$g(sub),$g(pred),"",$g(fary)) ;subjects
 q
 ;
object(sub,pred,graph,form,fary) ; extrinsic which returns the first
 ; multiple of return from objects - returns null if more than one
 ; objects(.G,sub,pred)
 ; G("location") ==> "location"
 n zin,zrtn
 d objects(.zin,$g(sub),$g(pred),$g(form),$g(fary))
 s zrtn=$o(zin(""))
 i $o(zin(zrtn))'="" s zrtn=""
 q zrtn
 ;
onelist(zw,sub,pred,obj,fary) ; returns list
 ; zw is S P or O depending on what should be returned
 I $g(fary)="" D  ;
 . D INITFARY^C0XF2N("C0XFARY")
 . S fary="C0XFARY"
 D USEFARY^C0XF2N(fary)
 I '$D(form) S form="json"
 k listrtn ; start with a clean return
 n zsub,zpred,zobj,zgraph,tmprtn
 i $g(FMTSSTYLE)="F2N" d  ;
 . s zsub=$$IENOF($$EXT^C0XUTIL($g(sub)),fary) ; ien of sub
 . s zpred=$$IENOF($$EXT^C0XUTIL($g(pred)),fary) ; ien of pred
 . s zobj=$$IENOF($$EXT^C0XUTIL($g(obj)),fary) ; ien of obj
 . s zgraph=$$IENOF($g(graph),fary) ; ien of graph
 e  d  ;
 . s zsub=$g(sub)
 . s zpred=$g(pred)
 . s zobj=$g(obj)
 . s zgraph=$g(graph)
 I $G(DEBUG) W !,"s:",zsub," p:",zpred," o:",zobj
 n c0xflag,zi,zx,zt
 s zt=$s($g(C0XTN)'="":C0XTN,1:$na(^C0X(101))) ; 
 s c0xflag=$$mask(zsub,zpred,zobj) ; get mask flags
 k tmprtn
 n itbl,ii,ix
 s ii=$s(zw="S":"SPO",zw="P":"POS",zw="O":"OSP") ; no constraint
 s itbl("I000",ii)="d zip(.tmprtn,zt,zi)"
 s ii=$s(zw="S":"OSP",zw="P":"OPS",zw="O":"OSP") ; obj constraint
 s ix=$s(zw="O":"d just(zobj)",1:"d zip1(.tmprtn,zt,zi,zobj)")
 s itbl("I001",ii)=ix
 s ii=$s(zw="S":"PSO",zw="P":"POS",zw="O":"POS") ; pred constraint
 s ix=$s(zw="P":"d just(zpred)",1:"d zip1(.tmprtn,zt,zi,zpred)")
 s itbl("I010",ii)=ix
 s ii=$s(zw="S":"POS",zw="P":"OPS",zw="O":"OSP") ; pred + obj constraint
 s ix=$s(zw="S":"d zip2(.tmprtn,zt,zi,zpred,zobj)",zw="P":"d just(zpred)",zw="O":"d just(zobj)",1:"d just(zobj)")
 s itbl("I011",ii)=ix
 s ii=$s(zw="S":"SPO",zw="P":"SPO",zw="O":"SOP") ; sub constraint
 s ix=$s(zw="S":"d just(zsub)",1:"d zip1(.tmprtn,zt,zi,zsub)")
 s itbl("I100",ii)=ix
 s ii=$s(zw="S":"SPO",zw="P":"SOP",zw="O":"OSP") ; sub + obj constraint
 s ix=$s(zw="P":"d zip2(.tmprtn,zt,zi,zsub,zobj)",zw="S":"d just(zsub)",zw="O":"d just(zobj)",1:"d just(zobj)")
 s itbl("I101",ii)=ix
 s ii=$s(zw="S":"SPO",zw="P":"POS",zw="O":"SPO") ; sub + pred constraint
 s ix=$s(zw="O":"d zip2(.tmprtn,zt,zi,zsub,zpred)",zw="S":"d just(zsub)",zw="P":"d just(zpred)",1:"d just(zsub)")
 s itbl("I110",ii)=ix
 s ii=$s(zw="S":"SPO",zw="P":"POS",zw="O":"OSP") ; sub + pred + obj constraint
 s ix=$s(zw="O":"d just(zobj)",zw="S":"d just(zsub)",zw="P":"d just(zpred)",1:"d just(zsub)")
 s itbl("I111",ii)=ix
 ; end itbl definition
 ;
 s zi=$o(itbl(c0xflag,"")) ; find index to use
 s zx=itbl(c0xflag,zi) ; executable instruction to run
 ;i $g(ngraph)'="" s zi="G"_zi ; this is wrong.. don't do graphs yet
 i $g(DEBUG) w !,c0xflag," ",zw," ",zt," ",zi," ",zx,!
 ;zwr itbl
 x zx
 k listrtn
 d strings(.listrtn,"tmprtn") ; convert pointer to strings
 q
 ;
just(zin) ; add one element to tmprtn
 s tmprtn(zin)=""
 q
 ;
zip(zrtn,zt,zi) ; pull out just the first element of the index
 ;
 n zii s zii=""
 f  s zii=$o(@zt@(zi,zii)) q:zii=""  d  ;
 . s zrtn(zii)=""
 q
 ;
zip1(zrtn,zt,zi,zn) ; pull out just the first element of the index
 ;
 n zii s zii=""
 f  s zii=$o(@zt@(zi,zn,zii)) q:zii=""  d  ;
 . s zrtn(zii)=""
 q
 ;
zip2(zrtn,zt,zi,zn,zn1) ; pull out just the first element of the index
 ;
 n zii s zii=""
 f  s zii=$o(@zt@(zi,zn,zn1,zii)) q:zii=""  d  ;
 . s zrtn(zii)=""
 q
 ;
arrayout(rtn,zary) ; output an array of triples
 ;
 s zrsub=""
 s zcnt=1
 f  s zrsub=$o(zary(zrsub)) q:zrsub=""  d  ; organized by subject
 . s zzz=""
 . f  s zzz=$o(zary(zrsub,zzz)) q:zzz=""  d  ; pred and obj
 . . s rtn(zcnt)=zrsub_"^"_zzz
 . . s zcnt=zcnt+1
 q
 ;
rawout(rtn,zary) ; output a mumps array of triples
 ;
 s zrsub=""
 ;s zcnt=1
 f  s zrsub=$o(zary(zrsub)) q:zrsub=""  d  ; organized by subject
 . s zzz=""
 . f  s zzz=$o(zary(zrsub,zzz)) q:zzz=""  d  ; pred and obj
 . . s rtn(zrsub,$p(zzz,"^",1))=$p(zzz,"^",2)
 . . ;s zcnt=zcnt+1
 q
 ;
strings(zrary,zinary) ; convert pointers to strings
 ;
 k zrary
 n zzz s zzz=""
 f  s zzz=$o(@zinary@(zzz)) q:zzz=""  d  ;
 . n zs
 . ;s zs=$$GET1^DIQ(C0XSFN,zzz_",",.01)
 . s zs=$$NSP^C0XUTIL(zzz) ; get namespaced string
 . q:zs=""
 . s zrary(zs)="" ; 
 q
 ;
ien2tary(zrary,zinary) ; zinary is an array of iens passed by name
 ; zrary is passed by reference and is return array of triples
 ; format zrary(zsub,"zpred^zobj")=""
 ;
 k zrary ; start out clean
 n zzz,zrsub,zrpred,zrobj,zgraph,zcnt
 s zzz=""
 f  s zzz=$o(@zinary@(zzz)) q:zzz=""  d  ;
 . i $g(FMTSSTYLE)="F2N" d  ; 
 . . s zrsub=$$GET1^DIQ(C0XTFN,zzz_",",.03,"E")
 . . s zrpred=$$GET1^DIQ(C0XTFN,zzz_",",.04,"E")
 . . s zrobj=$$GET1^DIQ(C0XTFN,zzz_",",.05,"E")
 . . s zrgraph=$$GET1^DIQ(C0XTFN,zzz_",",.02,"E")
 . . s zrary(zrsub,zrpred_"^"_zrobj)=""
 . e  d  ;
 . . s zrsub=$p(zzz,"^",1)
 . . s zrpred=$p(zzz,"^",2)
 . . s zrobj=$p(zzz,"^",3)
 . . s zrary(zrsub,zrpred_"^"_zrobj)=""
 q
 ;
jsonout(jout,zary) ; 
 d REPLYSTART^FMQLJSON("jout")
 d LISTSTART^FMQLJSON("jout","results")
 n zi s zi=""
 f  s zi=$o(zary(zi)) q:zi=""  d  ; for each subject
 . n zii s zii=""
 . D DICTSTART^FMQLJSON("jout",zi)
 . f  s zii=$o(zary(zi,zii)) q:zii=""  d  ; for each pred^obj pair
 . . d DASSERT^FMQLJSON("jout",$p(zii,"^",1),$p(zii,"^",2))
 . D DICTEND^FMQLJSON("jout")
 d LISTEND^FMQLJSON("jout")
 d REPLYEND^FMQLJSON("jout")
 q
 ;
mask(zsub,zpred,zobj) ; function to return mask information
 ; about the inputs ie I100 for just a subject and no pred or obj
 n zf1,zf2,zf3,zflag
 s zf1=$s($g(zsub)="":0,1:1)
 s zf2=$s($g(zpred)="":0,1:1)
 s zf3=$s($g(zobj)="":0,1:1)
 s zflag="I"_zf1_zf2_zf3
 q zflag
 ;
trip(triprtn,nsub,npred,nobj,ngraph,fary) ; returns triples iens
 ; nsub,npred,nobj are all optional
 ; graf is also optional, and will limit the search to a particular ngraph
 ; fary is which triple store (not implemented yet)
 n c0xflag,zi,zx,zt
 s zt=$s(C0XTN'="":C0XTN,1:$na(^C0X(101))) ; 
 s c0xflag=$$mask(nsub,npred,nobj) ; get mask flags
 n itbl
 s itbl("I000","SPO")="d do3(.triprtn,zt,zi)"
 s itbl("I001","OSP")="d do2(.triprtn,zt,zi,nobj)"
 s itbl("I010","PSO")="d do2(.triprtn,zt,zi,npred)"
 s itbl("I011","POS")="d do1(.triprtn,zt,zi,npred,nobj)"
 s itbl("I100","SPO")="d do2(.triprtn,zt,zi,nsub)"
 s itbl("I101","SOP")="d do1(.triprtn,zt,zi,nsub,nobj)"
 s itbl("I110","SPO")="d do1(.triprtn,zt,zi,nsub,npred)"
 s itbl("I111","SPO")="d do0(.triprtn,zt,zi,nsub,npred,nobj)"
 s zi=$o(itbl(c0xflag,""))
 s zx=itbl(c0xflag,zi) ; executable instruction to run
 i $g(ngraph)'="" s zi="G"_zi
 i $g(DEBUG) w !,zx
 x zx
 q
 ;
do0(dortn,zt,zi,z1,z2,z3) 
 ; looking for only one triple
 n zz
 s zz=$o(@zt@(zi,z1,z2,z3,""))
 s:zz="" zz=z1_"^"_z2_"^"_z3
 s dortn(zz)=""
 q
 ;
do1(dortn,zt,zi,z1,z2) ; have 2, looking for one
 n zr,zx1
 s zx1=""
 f  s zx1=$o(@zt@(zi,z1,z2,zx1)) q:zx1=""  d  ;
 . s zr=$o(@zt@(zi,z1,z2,zx1,""))
 . s:zr="" zr=z1_"^"_z2_"^"_zx1
 . s dortn(zr)=""
 q
 ;
do2(dortn,zt,zi,z1) ; have one, looking for 2
 n zr,zx1,zx2
 s (zx1,zx2)=""
 f  s zx1=$o(@zt@(zi,z1,zx1)) q:zx1=""  d  ;
 . f  s zx2=$o(@zt@(zi,z1,zx1,zx2)) q:zx2=""  d  ;
 . . s zr=$o(@zt@(zi,z1,zx1,zx2,""))
 . . s:zr="" zr=z1_"^"_zx1_"^"_zx2
 . . s dortn(zr)=""
 q
 ;
do3(dortn,zt,zi) ; have none, looking for three
 n zr,zx1,zx2,zx3
 s (zx1,zx2,zx3)=""
 f  s zx1=$o(@zt@(zi,zx1)) q:zx1=""  d  ;
 . f  s zx2=$o(@zt@(zi,zx1,zx2)) q:zx2=""  d  ;
 . . f  s zx3=$o(@zt@(zi,zx1,zx2,zx3)) q:zx3=""  d  ;
 . . . s zr=$o(@zt@(zi,zx1,zx2,zx3,""))
 . . . s:zr="" zr=zx1_"^"_zx2_"^"_zx3
 . . . s dortn(zr)=""
 q
 ;
IENOF(ZSTRING,FARY) ; EXTRINSIC WHICH RETURNS THE IEN OF ZS IN THE STRINGS FILE
 I '$D(FARY) D  ;
 . D INITFARY^C0XF2N("C0XFARY")
 . S FARY="C0XFARY"
 N ZIEN
 I $G(ZSTRING)="" Q "" ; NO STRING
 S ZIEN=$O(@C0XSN@("B",$$EXT^C0XUTIL(ZSTRING),""))
 I ZIEN="" S ZIEN=-1
 Q ZIEN
 ;
IENOFA(ZOUTARY,INARY,FARY) ; RESOLVE STRINGS TO IEN IN STRINGS FILE 
 ; RETURNS IN ZOUTARY OF THE FORM ZOUTARY("IEN","VAR",IEN)=""
 I '$D(FARY) D  ;
 . D INITFARY^C0XF2N("C0XFARY")
 . S FARY="C0XFARY"
 K ZOUTARY ; START WITH CLEAN RESULTS
 K C0XFDA2 ; USE A SEPARATE FDA FOR THIS
 I '$D(C0XVOC) D VOCINIT^C0XUTIL
 N ZINARY 
 N ZI S ZI=""
 F  S ZI=$O(INARY(ZI)) Q:ZI=""  D  ;
 . N ZK
 . S ZK=$O(INARY(ZI,""))
 . S ZINARY($$EXT^C0XUTIL(ZI),$$EXT^C0XUTIL(ZK))=""
 N ZV,ZIEN
 N ZCNT S ZCNT=0
 F  S ZI=$O(ZINARY(ZI)) Q:ZI=""  D  ; LOOK FOR MISSING STRINGS
 . S ZV=$O(ZINARY(ZI,""))
 . I ZV["^" S ZV=$TR(ZV,"^","|")
 F  S ZI=$O(ZINARY(ZI)) Q:ZI=""  D  ; NOW GET ALL IENS
 . S ZV=$O(ZINARY(ZI,""))
 . I ZV["^" S ZV=$TR(ZV,"^","|")
 . S ZIEN=$O(@C0XSN@("B",ZV,"")) ; THEY SHOULD BE THERE NOW
 . I ZIEN="" S ZOUTARY("IEN",ZI)=""
 . E  S ZOUTARY("IEN",ZI,ZIEN)=""
 Q
 ;
output(zwhat,zfname,zdir) ; function to write an array to a host file
 ; if zdir is ommitted, will output to the CCR directory
 ; ^TMP("C0CCCR","ODIR")
 ; if fname is ommitted, will output yyyy-mm-dd-hh-mm-ss-C0XOUT.out
 ; zwhat is passed by name
 ;
 i '$d(zdir) s zdir=$G(^TMP("C0CCCR","ODIR"))
 i '$d(zfname) d  ;
 . s zfname=$$FMTE^XLFDT($$NOW^XLFDT,7)
 . s zfname=$tr(zfname,"/","-")
 . s zfname=$tr(zfname,"@","-")
 . s zfname=$tr(zfname,":","-")
 . s zfname=zfname_".out"
 i $e(zwhat,1,1)'="^" d  ; not a global
 . k ^TMP("C0XOUT",$J)
 . m ^TMP("C0XOUT",$J)=@zwhat
 . s zwhat=$na(^TMP("C0XOUT",$J,1))
 n zout s zout=""
 s zout=$$OUTPUT^C0CXPATH(zwhat,zfname,zdir)
 K ^TMP("C0XOUT",$J)
 Q zout
 ;
tagText(ztag) ; extrinsic which returns the location of the text
 ; associated with ztag
 n zs,zo
 s zs=$$subject("fmts:fileTag",ztag)
 i zs="" d  q "" ;
 . w !,"error, tag is either missing or there are more than one ",ztag
 s zo=$$object(zs,"fmts:fileSource")
 i zo="" d  q "" ;
 . w !,"error, tag source not found ",zs
 w !,zo
 q $$WHERETXT^C0XF2N(zo)
 ;
tagRoot(ztag) ; extrinsic which returns the root for graphs and subjects
 ; associated with ztag
 n zs,zo
 s zs=$$subject("fmts:fileTag",ztag)
 i zs="" d  q "" ;
 . w !,"error, tag is either missing or there are more than one ",ztag
 s zo=$$object(zs,"fmts:root")
 i zo="" d  q "" ;
 . w !,"error, root not found ",zs
 ;w !,zo
 q zo
 ;
