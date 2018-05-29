SYNFALG2 ;ven/gpl - fhir loader utilities ; 2/20/18 4:11am
 ;;1.0;fhirloader;;oct 19, 2017;Build 2
 ;
 ; Authored by George P. Lilly 2017-2018
 ; (c) Sam Habiel 2018
 ;
 q
 ;
MEDALGY(dfn,root,json,zi,eval,jlog,args) ; allergy is rxnorm
 ;
 n SYNDFN,SYNRXN,SYNDF,SYNPA,SYNDUZ,SYNSS,SYNDATE,SYNCOMM
 ;
 S SYNDFN=dfn
 d log(jlog,"Patient DFN: "_SYNDFN)
 s eval("allergy",zi,"vars","dfn")=SYNDFN
 ;
 s SYNRXN=$get(json("entry",zi,"resource","code","coding",1,"code"))
 d log(jlog,"Allergin is RxNorm: "_SYNRXN)
 set eval("allergy",zi,"vars","code")=SYNRXN
 ;
 S SYNDUZ=$$USERDUZ
 d log(jlog,"Provider DUZ: "_SYNDUZ)
 s eval("allergy",zi,"vars","duz")=SYNDUZ
 ;
 new onsetdate set onsetdate=$get(json("entry",zi,"resource","assertedDate"))
 do log(jlog,"onsetDateTime is: "_onsetdate)
 set eval("allergy",zi,"vars","onsetDateTime")=onsetdate
 new fmOnsetDateTime s fmOnsetDateTime=$$fhirTfm^SYNFUTL(onsetdate)
 i $l(fmOnsetDateTime)=14 s fmOnsetDateTime=$e(fmOnsetDateTime,1,12)
 d log(jlog,"fileman onsetDateTime is: "_fmOnsetDateTime)
 set eval("allergy",zi,"vars","fmOnsetDateTime")=fmOnsetDateTime ;
 S SYNDATE=fmOnsetDateTime
 ;
 s eval("allergy",zi,"status","loadstatus")="readyToLoad"
 ;
 if $g(args("load"))=1 d  ; only load if told to
 . n ien s ien=$$dfn2ien^SYNFUTL(dfn) ;
 . if $g(ien)'="" if $$loadStatus^SYNFALG("allergy",zi,ien)=1 do  quit  ;
 . . d log(jlog,"Allergy already loaded, skipping")
 . d log(jlog,"Calling ADDMEDADR^SYNFALG2 to add allergy")
 . n ok
 . s ok=$$ADDMEDADR(SYNDFN,SYNRXN,,,SYNDUZ,,SYNDATE) ; 
 . m eval("allergy",zi,"status")=ok
 . d log(jlog,"Return from data loader was: "_ok)
 . if +$g(ok)=1 do  ;
 . . s eval("status","loaded")=$g(eval("status","loaded"))+1
 . . s eval("allergy",zi,"status","loadstatus")="loaded"
 . else  d  ;
 . . s eval("status","errors")=$g(eval("status","errors"))+1
 . . s eval("allergy",zi,"status","loadstatus")="notLoaded"
 . . s eval("allergy",zi,"status","loadMessage")=ok
 . n root s root=$$setroot^%wd("fhir-intake")
 . i $g(ien)'="" d  ;
 . . k @root@(ien,"load","allergy",zi)
 . . m @root@(ien,"load","allergy",zi)=eval("allergy",zi)
 ;
 q
 ;
USERDUZ() ; extrinsic returning the DUZ of the user
 n npi,duz
 s npi=$$MAP^SYNQLDM("OP","provider") ; map should return the NPI number
 s duz=$O(^VA(200,"ANPI",npi,""))
 q duz
 ;
log(ary,txt) ; adds a text line to @ary@("log")
 s @ary@("log",$o(@ary@("log",""),-1)+1)=$g(txt)
 q
 ;
ADDMEDADR(SYNDFN,SYNRXN,SYNDF,SYNPA,SYNDUZ,SYNSS,SYNDATE,SYNCOMM) ; [Public] Add an allergy/adrxn using a Medications RxNorm Code
 ; Uses IA#4682 to record an allergy in the patient's chart
 ;
 ; Input:
 ; - SYNDFN   (r) = DFN
 ; - SYNRXN   (r) = RxNorm Ingredient or Clinical Drug code
 ; - SYNDF    (o) = "D"rug or "F"ood
 ; - SYNPA    (o) = Nature of Reaction: "P"harmacologic or "A"llergic
 ; - SYNDUZ   (o) = Recorder of reaction
 ; - SYNSS    (o) = ";" delimited list of signs and symptoms
 ; - SYNDATE  (o) = Date of recording of signs and symptoms
 ; - .SYNCOMM (o) = Comments in 1,2,3 etc passed by reference
 ;
 ; Output:
 ; - Can be called as a routine; but you won't get any error information
 ; - with $$, you will get:
 ; - 0^note to sign (if any) or -1^error message
 ; 
 ; Translate RXN to VUID
 new numVUID set numVUID=+$$RXN2OUT^ETSRXN(SYNRXN)
 if 'numVUID quit:$quit "-1^vuid-not-found" quit
 ;
 ; loop through VUIDs, and grab a good one (CD or IN)
 ; ^TMP("ETSOUT",69531,831533,"VUID",1,0)="296833^831533^VANDF^AB^4031994^N"
 ; ^TMP("ETSOUT",69531,831533,"VUID",1,1)="ERRIN 0.35MG TAB,28"
 new done s done=0
 new vuid
 new drugName
 new type
 new i for i=0:0 set i=$o(^TMP("ETSOUT",$J,SYNRXN,"VUID",i)) quit:'i  do  quit:done
 . new node0 set node0=^TMP("ETSOUT",$J,SYNRXN,"VUID",i,0)
 . new node1 set node1=^TMP("ETSOUT",$J,SYNRXN,"VUID",i,1)
 . set type=$p(node0,U,4)
 . if "^CD^IN^"'[(U_type_U) quit
 . ;
 . ; We have a preliminary match; we are done with the finding
 . set vuid=$p(node0,U,5)
 . set drugName=node1
 . set done=1
 ;
 if 'done quit:$quit "-2^no-suitable-vuid-term-was-CD-or-IN" quit
 ;
 kill ^TMP("SYN",$J) ; we put all the reactant info here
 ;
 ; find variable pointer
 new synvuid ; For Searching Compound Index
 set synvuid(1)=vuid
 set synvuid(2)=1
 new file set file=$select(type="IN":50.6,type="CD":50.68,1:0)
 if 'file set $ec=",u-no-supposed-to-happen,"
 new ien set ien=$$FIND1^DIC(file,"","XQ",.synvuid,"AMASTERVUID")
 if 'ien quit:$quit "-3^VUID-not-found. Is your NDF up to date?" quit
 ;
 ; load the data into the global for the API
 set ^TMP("SYN",$J,"GMRAGNT")=drugName_U_ien_";"_$piece($$ROOT^DILFD(file),U,2) ; variable pointer syntax
 set ^TMP("SYN",$J,"GMRATYPE")=$G(SYNDF,"D") ; Allergen type: Drug OR Food (D or F)
 set ^TMP("SYN",$J,"GMRANATR")=$G(SYNPA,"U") ; nature of reaction: Allergic or Pharmacologic (default unknown)
 set ^TMP("SYN",$J,"GMRAORIG")=$G(SYNDUZ,DUZ) ; Originator
 set ^TMP("SYN",$J,"GMRAORDT")=$G(SYNDATE,DT) ; Date of recording of reaction (not date of reaction)
 new ssErr set ssErr=0
 if $get(SYNSS)]"" do
 . set ^TMP("SYN",$J,"GMRASYMP",0)=$L(SYNSS,";") ; Signs and symptoms need to be entered by IENs
 . new i for i=1:1:$l(SYNSS,";") do  q:ssErr ; put signs and symptoms in 1,2,3 etc
 .. new ssIEN set ssIEN=$$FIND1^DIC(120.83,,"QX",$piece(SYNSS,";",i),"B")
 .. if 'ssIEN set ssErr=1
 .. set ^TMP("SYN",$J,"GMRASYMP",i)=ssIEN_U_$piece(SYNSS,";",i)
 i ssErr quit:$quit "-4^one or more signs/symptoms cannot be found" quit
 set ^TMP("SYN",$J,"GMRACHT",0)=1 ; marked in chart
 set ^TMP("SYN",$J,"GMRACHT",1)=$$NOW^XLFDT() ; marked now
 set ^TMP("SYN",$J,"GMRAOBHX")="h" ; historical. No sense in doing "observed"
 if $data(SYNCOMM) merge ^TMP("SYN",$J,"GMRACMTS")=SYNCOMM
 ;
 ; call the API
 N ORY
 D UPDATE^GMRAGUI1(0,SYNDFN,$NA(^TMP("SYN",$J)))
 ;
 ; API return -1^message or 0^note to sign
 if $piece(ORY,U)=-1 quit:$quit -5_U_$piece(ORY,U,2) quit
 quit:$quit 0_U_$piece(ORY,U,2)
 quit
 ;
TEST D EN^%ut($T(+0),3) quit
STARTUP ; M-UNIT STARTUP
 ; Delete all traces of patients allergies from DFN 1
 S DFN=1
 N DIK,DA
 S DIK=$$ROOT^DILFD(120.86),DA=DFN D ^DIK
 S DIK="^GMR(120.8,"
 S DA=0
 F  S DA=$O(^GMR(120.8,"B",1,DA)) Q:'DA  D ^DIK 
 QUIT
 ;
TADDMEDADR1 ; @TEST Simple allergen NOS - Contraceptive CD.
 N % S %=$$ADDMEDADR(DFN,831533)
 D CHKTF^%ut(+%=0)
 quit
 ;
TADDMEDADR2 ; @TEST Allergen as "food" (really penicillin IN)
 N % S %=$$ADDMEDADR(DFN,70618,"F")
 D CHKTF^%ut(+%=0)
 quit
 ;
TADDMEDADR3 ; @TEST Pharmacological or Allergic (Simvastatin CD)
 N % S %=$$ADDMEDADR(DFN,198211,"D","P")
 D CHKTF^%ut(+%=0)
 quit
 ;
TADDMEDADR4 ; @TEST Different Originator (Tamoxifen CD)
 N ORIG S ORIG=$O(^XUSEC("PROVIDER",""))
 N % S %=$$ADDMEDADR(DFN,313195,"D","P",ORIG)
 D CHKTF^%ut(+%=0)
 quit
 ;
TADDMEDADR5 ; @TEST Different Origination date (Aliskiren/Amlodipine IN)
 N ORIG S ORIG=$O(^XUSEC("PROVIDER",""))
 N % S %=$$ADDMEDADR(DFN,1009219,"D","P",ORIG,,$$FMADD^XLFDT(DT,-120))
 D CHKTF^%ut(+%=0)
 quit
 ;
TADDMEDADR6 ; @TEST Signs and symptoms singular (Cephalexin CD)
 N ORIG S ORIG=$O(^XUSEC("PROVIDER",""))
 N % S %=$$ADDMEDADR(DFN,309110,"D","A",ORIG,"HIVES",$$FMADD^XLFDT(DT,-120))
 D CHKTF^%ut(+%=0)
 quit
 ;
TADDMEDADR7 ; @TEST Signs and symptoms plural (Cephalexin IN)
 N ORIG S ORIG=$O(^XUSEC("PROVIDER",""))
 N % S %=$$ADDMEDADR(DFN,2231,"D","A",ORIG,"HIVES;RHINITIS;WHEEZING",$$FMADD^XLFDT(DT,-120))
 D CHKTF^%ut(+%=0)
 quit
 ;
TADDMEDADR8 ; @TEST Comments (Levothyroxine IN)
 N ORIG S ORIG=$O(^XUSEC("PROVIDER",""))
 N COMM S COMM(1)="This seems to only happen with specific forumlations of Synthroid"
 S COMM(2)="I think it's just the 125mcg (pink one)"
 N % S %=$$ADDMEDADR(DFN,10582,"D","A",ORIG,"HIVES;RHINITIS;WHEEZING",$$FMADD^XLFDT(DT,-120),.COMM)
 D CHKTF^%ut(+%=0)
 quit
 ;
TADDMEDERR1 ; @TEST Test error messages: -1 Bad Rxn
 N % S %=$$ADDMEDADR(DFN,83153328978194871234)
 D CHKTF^%ut(+%=-1)
 quit
TADDMEDERR2 ; @TEST Test error messages: -2 No VUID for Rxn - too hard
 quit
 ;
TADDMEDERR3 ; @TEST Test error messages: -3 NDF product cannot be found - too hard
 quit
 ;
TADDMEDERR4 ; @TEST Test error messages: -4 Bad S/S
 N ORIG S ORIG=$O(^XUSEC("PROVIDER",""))
 N % S %=$$ADDMEDADR(DFN,309110,"D","A",ORIG,"OIUSLDFKJLSKDJF",$$FMADD^XLFDT(DT,-120))
 D CHKTF^%ut(+%=-4)
 quit
 ;
TADDMEDERR5 ; @TEST Test error message: -5 API error
 N ORIG S ORIG=$O(^XUSEC("PROVIDER",""))
 N % S %=$$ADDMEDADR(DFN,2231,"D","A",ORIG,"HIVES;RHINITIS;WHEEZING",$$FMADD^XLFDT(DT,-120))
 D CHKTF^%ut(+%=-5)
 quit
 ;
SHUTDOWN ; M-UNIT SHUTDOWN
 K DFN
 QUIT
 ;
