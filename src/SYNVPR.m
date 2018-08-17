SYNVPR  ; GPL - VPR viewing routines ;2018-08-17  3:25 PM
 ;;0.1;VISTA SYNTHETIC DATA LOADER;;Aug 17, 2018;Build 2
 ;
 ; Authored by George P. Lilly 2013-2018
 ;
 Q
 ;
SELPART()       ; extrinsic which returns the part of the VPR selected
 N ZT
 S ZT(1)="all"
 S ZT(2)="demographics"
 S ZT(3)="reactions"
 S ZT(4)="problems"
 S ZT(5)="vitals"
 S ZT(6)="labs"
 S ZT(7)="meds"
 S ZT(8)="immunizations"
 S ZT(9)="observation"
 S ZT(10)="visits"
 S ZT(11)="appointments"
 S ZT(12)="documents"
 S ZT(13)="procedures"
 S ZT(14)="consults"
 S ZT(15)="flags"
 S ZT(16)="factors"
 S ZT(17)="skinTests"
 S ZT(18)="exams"
 S ZT(19)="education"
 S ZT(20)="insurance"
 K DIR
 S DIR(0)="SO^"
 F ZI=1:1:20 S DIR(0)=DIR(0)_ZI_":"_ZT(ZI)_";"
 S DIR("B")=1
 S DIR("L")="Please select clinical category to view: "
 S DIR("L",1)="1 all          6 labs          11 appointments 16 factors"
 S DIR("L",2)="2 demographics 7 meds          12 documents    17 skinTests"
 S DIR("L",3)="3 reactions    8 immunizations 13 procedures   18 exams"
 S DIR("L",4)="4 problems     9 observation   14 consults     19 education"
 S DIR("L",5)="5 vitals       10 visits       15 flags        20 insurance"
 D ^DIR
 Q ZT(X)
 ;
SELPART2()      ; extrinsic which returns the part of the NHIN extract selected
 N ZT
 S ZT(1)="all"
 S ZT(2)="patient"
 S ZT(3)="allergy"
 S ZT(4)="problem"
 S ZT(5)="vital"
 S ZT(6)="lab"
 S ZT(7)="med"
 S ZT(8)="immunization"
 S ZT(9)="visit"
 S ZT(10)="appointment"
 S ZT(11)="procedure"
 K DIR
 S DIR(0)="SO^"
 F ZI=1:1:11 S DIR(0)=DIR(0)_ZI_":"_ZT(ZI)_";"
 S DIR("B")=1
 S DIR("L")="Please select clinical category to view: "
 S DIR("L",1)="1 all      6 lab          11 procedure"
 S DIR("L",2)="2 patient  7 med          "
 S DIR("L",3)="3 allergy  8 immunization"
 S DIR("L",4)="4 problems 9 visit"
 S DIR("L",5)="5 vitals   10 appointment"
 D ^DIR
 Q ZT(X)
 ;
gen     
 S G="all;demographics;reactions;problems;vitals;labs;meds;immunizations;observation;visits;appointments;documents;procedures;consults;flags;factors;skinTests;exams;education;insurance"
 S ZI=""
 F ZI=1:1 Q:$P(G,";",ZI)=""  D  ;
 . W !," S ZT("_ZI_")="""_$P(G,";",ZI)_""""
 q
 ;
gen2    
 S G="all;patient;allergy;problem;vital;lab;med;immunization;visit;appointment;procedure"
 S ZI=""
 F ZI=1:1 Q:$P(G,";",ZI)=""  D  ;
 . W !," S ZT("_ZI_")="""_$P(G,";",ZI)_""""
 q
 ;
PAT()   ; extrinsic which returns a dfn from the patient selected
 S DIC=2,DIC(0)="AEMQ" D ^DIC
 I Y<1 Q  ; EXIT
 S DFN=$P(Y,U,1) ; SET THE PATIENT
 Q +Y
 ;
tree(where,prefix,docid,zout)     ; show a tree starting at a node in MXML. 
 ; node is passed by name
 ; 
 i $g(prefix)="" s prefix="|--" ; starting prefix
 i '$d(SYNJOB) s SYNJOB=$J
 n node s node=$na(^TMP("MXMLDOM",SYNJOB,docid,where))
 n txt s txt=$$CLEAN($$ALLTXT(node))
 w:'$G(DIQUIET) !,prefix_@node_" "_txt
 d oneout(zout,prefix_@node_" "_txt)
 n zi s zi=""
 f  s zi=$o(@node@("A",zi)) q:zi=""  d  ;
 . w:'$G(DIQUIET) !,prefix_"  : "_zi_"^"_$g(@node@("A",zi))
 . d oneout(zout,prefix_"  : "_zi_"^"_$g(@node@("A",zi)))
 f  s zi=$o(@node@("C",zi)) q:zi=""  d  ;
 . d tree(zi,"|  "_prefix,docid,zout)
 q
 ;
oneout(zbuf,ztxt)       ; adds a line to zbuf
 n zi s zi=$o(@zbuf@(""),-1)+1
 s @zbuf@(zi)=ztxt
 q
 ;
ALLTXT(where)     ; extrinsic which returns all text lines from the node .. concatinated 
 ; together
 n zti s zti=""
 n ztr s ztr=""
 f  s zti=$o(@where@("T",zti)) q:zti=""  d  ;
 . s ztr=ztr_$g(@where@("T",zti))
 q ztr
 ;
CLEAN(STR)           ; extrinsic function; returns string - gpl borrowed from the CCR package
 ;; Removes all non printable characters from a string.
 ;; STR by Value
 N TR,I
 F I=0:1:31 S TR=$G(TR)_$C(I)
 S TR=TR_$C(127)
 N ZR S ZR=$TR(STR,TR)
 S ZR=$$LDBLNKS(ZR) ; get rid of leading blanks
 QUIT ZR
 ;
LDBLNKS(st)         ; extrinsic which removes leading blanks from a string
 n pos f pos=1:1:$l(st)  q:$e(st,pos)'=" "
 q $e(st,pos,$l(st))
 ;
show(what,docid,zout)     ;
 I '$D(C0XJOB) S C0XJOB=$J
 d tree(what,,docid,zout)
 q
 ; 
GET(ZRTN,ZDFN,ZTYP)     
 I ZTYP="all" S ZTYP=""
 D GET^VPRD(.ZRTN,ZDFN,ZTYP,2250101,$$NOW^XLFDT)
 Q
 ;
GET2(ZRTN,ZDFN,ZTYP)    
 I ZTYP="all" S ZTYP=""
 ;D GET^VPRD(.ZRTN,ZDFN,ZTYP)
 D GET^KBAINHIN(.ZRTN,ZDFN,ZTYP) ; CALL NHINV ROUTINES TO PULL XML
 Q
 ;
PARSE(INXML)    ; 
 K ^TMP("MXMLERR",$J)
 Q $$EN^MXMLDOM(INXML,"W")
 ;
VPR     ;
 N ZDFN,ZTYPE
 ;N ZTMP
 S ZDFN=$$PAT()
 S ZTYPE=$$SELPART()
 D GET(.ZTMP,ZDFN,ZTYPE)
 N DOCID
 S DOCID=$$PARSE(.ZTMP)
 S GN=$NA(^TMP("VPROUT",$J))
 D show(1,DOCID,GN)
 D BROWSE^DDBR(GN,"N","PATIENT "_ZDFN_" "_ZTYPE)
 K @GN,^TMP("MXMLDOM",$J),^TMP("VPR",$J),GN
 q
 ;
wsVPR(VPR,FILTER)       ; get from web service call
 I '$D(DT) N DIQUIET S DIQUIET=1 D DT^DICRW
 N ZDFN,ZTYPE
 ;N ZTMP
 S ZDFN=$G(FILTER("patientId"))
 I ZDFN="" S ZDFN=$G(FILTER("patientID"))
 I ZDFN="" S ZDFN=$G(FILTER("patientid"))
 I ZDFN="" S ZDFN=$G(FILTER("dfn"))
 I ZDFN="" D  ;
 . N ICN S ICN=$G(FILTER("icn"))
 . I ICN="" Q  ;
 . S ZDFN=$O(^DPT("AFICN",ICN,""))
 I ZDFN="" D  ; try ien
 . N IEN S IEN=$G(FILTER("ien"))
 . I IEN="" Q  ;
 . S ZDFN=$$ien2dfn^SYNFUTL(IEN)
 I ZDFN="" S ZDFN=2
 S ZTYPE=$G(FILTER("domain"),"all")
 D GET(.ZTMP,ZDFN,ZTYPE)
 I $G(FILTER("format"))="xml" D  Q  ;
 . S HTTPRSP("mime")="text/xml"
 . M VPR=ZTMP
 N DOCID
 S DOCID=$$PARSE(.ZTMP)
 S HTTPRSP("mime")="text/html"
 S VPR=$NA(^TMP("VPROUT",$J))
 K @VPR
 S @VPR="<!DOCTYPE HTML><html><head></head><body><pre>"
 D show(1,DOCID,VPR)
 S @VPR@($O(@VPR@(""),-1)+1)="</pre></body></html>"
 D ADDCRLF^VPRJRUT(.VPR)
 ;D BROWSE^DDBR(GN,"N","PATIENT "_ZDFN_" "_ZTYPE)
 ;K @GN,^TMP("MXMLDOM",$J),^TMP("VPR",$J),GN
 q
 ;
NHIN    ;
 N ZDFN,ZTYPE
 ;N ZTMP
 S ZDFN=$$PAT()
 S ZTYPE=$$SELPART2()
 D GET2(.ZTMP,ZDFN,ZTYPE)
 N DOCID
 S DOCID=$$PARSE(.ZTMP)
 S GN=$NA(^TMP("VPROUT",$J))
 D show(1,DOCID,GN)
 D BROWSE^DDBR(GN,"N","PATIENT "_ZDFN_" "_ZTYPE)
 K @GN,^TMP("MXMLDOM",$J),^TMP("VPR",$J),GN
 q
 ;
LABS    ;
 S DFN=$$PAT()
 K OUT
 D LIST^C0CLABS
 S GN=$NA(^TMP("VPROUT",$J))
 K @GN
 M @GN=OUT
 D BROWSE^DDBR(GN,"N","PATIENT "_DFN_" LABS FROM CCR PACKAGE")
 K @GN
 Q
 ; 
CCRXML  ;
 S DFN=$$PAT()
 K OUT
 D CCRRPC^C0CCCR(.OUT,DFN)
 S GN=$NA(^TMP("VPROUT",$J))
 K @GN
 M @GN=OUT
 D BROWSE^DDBR(GN,"N","PATIENT "_DFN_" CCR XML")
 K @GN
 Q
 ; 
CCR     ;
 S DFN=$$PAT()
 N ZTMP
 D CCRRPC^C0CCCR(.ZTMP,DFN)
 K ZTMP(0)
 N ZCCR S ZCCR=$NA(^TMP("SYNVPR","CCR"))
 K @ZCCR
 M @ZCCR=ZTMP
 N DOCID
 S DOCID=$$PARSE(ZCCR)
 I $D(^TMP("MXMLERR",$J)) D  ;
 . ;ZWR ^TMP("MXMLERR",$J,*)
 . B  
 I DOCID=0 B  ;
 S GN=$NA(^TMP("VPROUT",$J))
 K @GN
 D show(1,DOCID,GN)
 D BROWSE^DDBR(GN,"N","PATIENT "_DFN_" CCR XML")
 K @GN,@ZCCR
 Q
 ; 
CCDA    ;
 S DFN=$$PAT()
 N ZTMP
 D CCDARPC^KBAICDA(.ZTMP,DFN)
 K ZTMP(0)
 N ZCCDA S ZCCDA=$NA(^TMP("SYNVPR",$J,"CCDA"))
 K @ZCCDA
 M @ZCCDA=@ZTMP
 N DOCID
 S DOCID=$$PARSE(ZCCDA)
 I $D(^TMP("MXMLERR",$J)) D  ;
 . ;ZWR ^TMP("MXMLERR",$J,*)
 . B  
 I DOCID=0 B  ;
 S GN=$NA(^TMP("VPROUT",$J))
 K @GN
 D show(1,DOCID,GN)
 D BROWSE^DDBR(GN,"N","PATIENT "_DFN_" CCDA XML")
 K @GN,@ZCCDA
 Q
 ; 
listm(out,in)   ; out is passed by name in is passed by reference
 n i s i=$q(@in@(""))
 f  s i=$q(@i) q:i=""  d oneout^SYNVPR(out,i_"="_@i)
 q
 ;
SMART   ; 
 S DFN=$$PAT()
 S ZTYPE=$$SELPART2()
 K G,OUT
 D EN^C0SMART(.G,DFN,ZTYPE,"raw")
 S GN=$NA(^TMP("SYNOUT",$J))
 K @GN
 D listm(GN,"G")
 D BROWSE^DDBR(GN,"N","PATIENT "_DFN_" SMART MUMPS ARRAY")
 K @GN,G,OUT
 Q 
 ;
SMARTRDF        ; 
 S DFN=$$PAT()
 S ZTYPE=$$SELPART2()
 K G,OUT
 D EN^C0SMART(.G,DFN,ZTYPE,"rdf")
 N ZRDF S ZRDF=$NA(^TMP("SYNVPR","RDF"))
 K @ZRDF
 M @ZRDF=G
 N DOCID
 S DOCID=$$PARSE(ZRDF)
 I $D(^TMP("MXMLERR",$J)) D  ;
 . ;ZWR ^TMP("MXMLERR",$J,*)
 . B  
 I DOCID=0 B  ;
 S GN=$NA(^TMP("VPROUT",$J))
 K @GN
 D show(1,DOCID,GN)
 D BROWSE^DDBR(GN,"N","PATIENT "_DFN_" RDF XML")
 K @GN,@ZRDF
 Q 
 ;
VPRM    ;
 N ZDFN,ZTYPE
 N ZTMP
 S ZDFN=$$PAT()
 S ZTYPE=$$SELPART()
 D GETPAT^SYNVPRE(.ZTMP,ZDFN,ZTYPE)
 S GN=$NA(^TMP("VPROUT",$J))
 K @GN
 D listm(GN,"ZTMP")
 D BROWSE^DDBR(GN,"N","PATIENT "_ZDFN_" "_ZTYPE)
 K @GN,^TMP("VPR",$J),GN
 q
 ;
wsGLOBAL(OUT,FILTER)    ; dump a global to the browser as an html page
 I '$D(DT) N DIQUIET S DIQUIET=1 D DT^DICRW
 S HTTPRSP("mime")="text/html"
 S OUT=$NA(^TMP("SYNOUT",$J))
 K @OUT
 N ROOT S ROOT=$G(FILTER("root"))
 Q:ROOT=""
 I $G(FILTER("local"))'=1 S ROOT="^"_ROOT
 N ORIG,OL S ORIG=ROOT,OL=$QL(ROOT) ; Orig, Orig Length
 F  S ROOT=$Q(@ROOT) Q:$G(ROOT)=""  Q:$NA(@ROOT,OL)'=$NA(@ORIG,OL)  D
 . S @OUT@($O(@OUT@(""),-1)+1)=ROOT_"="_$$CLEAN(@ROOT)
 S @OUT="<!DOCTYPE HTML><html><head></head><body><pre>"
 S @OUT@($O(@OUT@(""),-1)+1)="</pre></body></html>"
 D ADDCRLF^VPRJRUT(.OUT)
 Q
 ;
GTREE(ROOT,DEPTH,PREFIX,LVL)    ; show a global in a tree
 I $G(PREFIX)="" S PREFIX="|--" ; STARTING PREFIX
 I '$D(DEPTH) S DEPTH=1 ; USUALLY THIS IS WHAT WE WANT
 I +$G(LVL)>DEPTH Q  ; ONLY GO THAT DEEP
 N ZGI S ZGI=""
 N ZVAL S ZVAL=$G(@ROOT)
 I $G(LVL)="" W !,ROOT_" "_$G(@ROOT@(0))
 F  S ZGI=$O(@ROOT@(ZGI)) Q:ZGI=""  D  ;
 . I $O(@ROOT@(ZGI,""))'="" D  ;
 . . I $G(@ROOT@(ZGI))'="" W !,PREFIX_ZGI_" ",@ROOT@(ZGI)
 . . E  W !,PREFIX_ZGI_" ",$G(@ROOT@(ZGI,0))
 . E  W !,PREFIX_ZGI_" "_$G(@ROOT@(ZGI))
 . D GTREE($NA(@ROOT@(ZGI)),DEPTH,"|  "_PREFIX,+$G(LVL)+1)
 Q
 ; 
