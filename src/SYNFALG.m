SYNFALG ;ven/gpl - fhir loader utilities ; 2/20/18 4:11am
 ;;1.0;fhirloader;;oct 19, 2017;Build 2
 ;
 ; Authored by George P. Lilly 2017-2018
 ; (c) Sam Habiel 2018
 ;
 q
 ;
importAllergy(rtn,ien,args) ; entry point for loading Allergy for a patient
 ; calls the intake Allergy web service directly
 ;
 n grtn
 n root s root=$$setroot^%wd("fhir-intake")
 d wsIntakeAllergy(.args,,.grtn,ien)
 i $d(grtn) d  ; something was returned
 . k @root@(ien,"load","allergy")
 . m @root@(ien,"load","allergy")=grtn("allergy")
 . if $g(args("debug"))=1 m rtn=grtn
 s rtn("conditionsStatus","status")=$g(grtn("status","status"))
 s rtn("conditionsStatus","loaded")=$g(grtn("status","loaded"))
 s rtn("conditionsStatus","errors")=$g(grtn("status","errors"))
 ;b
 ;
 ;
 q
 ;
wsIntakeAllergy(args,body,result,ien) ; web service entry (post)
 ; for intake of one or more Allergy. input are fhir resources
 ; result is json and summarizes what was done
 ; args include patientId
 ; ien is specified for internal calls, where the json is already in a graph
 n jtmp,json,jrslt,eval
 ;i $g(ien)'="" if $$loadStatus("allergy","",ien)=1 d  q  ;
 ;. s result("allergytatus","status")="alreadyLoaded"
 i $g(ien)'="" d  ; internal call
 . d getIntakeFhir^SYNFHIR("json",,"AllergyIntolerance",ien,1)
 e  d  ; 
 . s args("load")=0
 . merge jtmp=BODY
 . do DECODE^VPRJSON("jtmp","json")
 ;
 i '$d(json) d getRandomAllergy(.json)
 ;
 i '$d(json) q  ;
 m ^gpl("gjson")=json
 ;
 ; determine the patient
 ;
 n dfn,eval
 if $g(ien)'="" d  ;
 . s dfn=$$ien2dfn^SYNFUTL(ien) ; look up dfn in the graph
 else  d  ;
 . s dfn=$g(args("dfn"))
 . i dfn="" d  ;
 . . n icn s icn=$g(args("icn"))
 . . i icn'="" s dfn=$$icn2dfn^SYNFUTL(icn)
 i $g(dfn)="" do  quit  ; need the patient
 . s result("allergy",1,"log",1)="Error, patient not found.. terminating"
 ;
 new zi s zi=0
 for  set zi=$order(json("entry",zi)) quit:+zi=0  do  ;
 . ;
 . ; define a place to log the processing of this entry
 . ;
 . new jlog set jlog=$name(eval("allergy",zi))
 . ;
 . ; insure that the resourceType is AllergyIntolerance
 . ;
 . new type set type=$get(json("entry",zi,"resource","resourceType"))
 . if type'="AllergyIntolerance" do  quit  ;
 . . set eval("allergy",zi,"vars","resourceType")=type
 . . do log(jlog,"Resource type not AllergyIntolerance, skipping entry")
 . set eval("allergy",zi,"vars","resourceType")=type
 . ;
 . ; see if this resource has already been loaded. if so, skip it
 . ;
 . if $g(ien)'="" if $$loadStatus("allergy",zi,ien)=1 do  quit  ;
 . . d log(jlog,"Allergy already loaded, skipping")
 . ;
 . ; determine Allergy snomed code, coding system, and display text
 . ;
 . ;
 . ; determine the id of the resource
 . ;
 . ;new id set id=$get(json("entry",zi,"resource","id"))
 . ;set eval("allergy",zi,"vars","id")=id
 . ;d log(jlog,"ID is: "_id)
 . ;
 . new sctcode set sctcode=$get(json("entry",zi,"resource","code","coding",1,"code"))
 . do log(jlog,"code is: "_sctcode)
 . set eval("allergy",zi,"vars","code")=sctcode
 . ;
 . ;
 . new codesystem set codesystem=$get(json("entry",zi,"resource","code","coding",1,"system"))
 . do log(jlog,"code system is: "_codesystem)
 . set eval("allergy",zi,"vars","codeSystem")=codesystem
 . ;
 . ; determine the onset date and time
 . ;
 . new onsetdate set onsetdate=$get(json("entry",zi,"resource","assertedDate"))
 . do log(jlog,"onsetDateTime is: "_onsetdate)
 . set eval("allergy",zi,"vars","onsetDateTime")=onsetdate
 . new fmOnsetDateTime s fmOnsetDateTime=$$fhirTfm^SYNFUTL(onsetdate)
 . i $l(fmOnsetDateTime)=14 s fmOnsetDateTime=$e(fmOnsetDateTime,1,12)
 . d log(jlog,"fileman onsetDateTime is: "_fmOnsetDateTime)
 . set eval("allergy",zi,"vars","fmOnsetDateTime")=fmOnsetDateTime ;
 . new hl7OnsetDateTime s hl7OnsetDateTime=$$fhirThl7^SYNFUTL(onsetdate)
 . d log(jlog,"hl7 onsetDateTime is: "_hl7OnsetDateTime)
 . set eval("allergy",zi,"vars","hl7OnsetDateTime")=hl7OnsetDateTime ;
 . ;
 . ; determine clinical status (active vs inactive)
 . ;
 . n clinicalstatus set clinicalstatus=$get(json("entry",zi,"resource","verificationStatus"))
 . ;
 . ;
 . ; set up to call the data loader
 . ;
 . ;ALLERGY^ISIIMP10(ISIRESUL,ISIMISC)          
 .;;NAME             |TYPE       |FILE,FIELD |DESC
 .;;-----------------------------------------------------------------------
 .;;ALLERGEN         |FIELD      |120.82,.01 |
 .;;SYMPTOM          |MULTIPLE   |120.83,.01 |Multiple,"|" (bar) delimited, working off #120.83
 .;;PAT_SSN          |FIELD      |120.86,.01 |PATIENT (#2, .09) pointer
 .;;ORIG_DATE        |FIELD      |120.8,4    |
 .;;ORIGINTR         |FIELD      |120.8,5    |PERSON (#200)
 .;;HISTORIC         |BOOLEEN    |           |1=HISTORICAL, 0=OBSERVED
 .;;OBSRV_DT         |FIELD      |           |Observation Date (if HISTORIC=0)
 .;
 . n RESTA,ISIMISC
 . ;
 . s ISIMISC("ALLERGEN")=$get(json("entry",zi,"resource","code","coding",1,"display"))
 . n algy s algy=$$ISGMR(sctcode)
 . i algy'=-1 s ISIMISC("ALLERGEN")=$p(algy,"^",2)
 . s eval("allergy",zi,"parms","ALLERGEN")=ISIMISC("ALLERGEN")
 . ;
 . s ISIMISC("SYMPTOM")=$get(json("entry",zi,"resource","reaction",1,"description"))
 . s eval("allergy",zi,"parms","SYMPTOM")=ISIMISC("SYMPTOM")
 . ;
 . s ISIMISC("ORIGINTR")="USER,THREE"
 . s eval("allergy",zi,"parms","ORIGINTR")=ISIMISC("ORIGINTR")
 . ;
 . s DHPPAT=$$dfn2icn^SYNFUTL(dfn)
 . s eval("allergy",zi,"parms","DHPPAT")=DHPPAT
 . s ISIMISC("PAT_SSN")=$$GET1^DIQ(2,dfn_",",.09)
 . s eval("allergy",zi,"parms","PAT_SSN")=ISIMISC("PAT_SSN")
 . ;
 . s DHPSCT=sctcode
 . s eval("allergy",zi,"parms","DHPSCT")=DHPSCT
 . ;
 . s DHPCLNST=$S(clinicalstatus="Active":"A",1:"I")
 . s eval("allergy",zi,"parms","DHPCLNST")=DHPCLNST
 . ;
 . s DHPONS=hl7OnsetDateTime
 . s eval("allergy",zi,"parms","DHPONS")=DHPONS
 . s ISIMISC("ORIG_DATE")=fmOnsetDateTime
 . s eval("allergy",zi,"parms","ORIG_DATE")=ISIMISC("ORIG_DATE")
 . s ISIMISC("HISTORIC")=1
 . s eval("allergy",zi,"parms","HISTORIC")=ISIMISC("HISTORIC")
 . ;
 . s DHPPROV=$$MAP^SYNQLDM("OP","provider") ; map should return the NPI number
 . s eval("allergy",zi,"parms","DHPPROV")=DHPPROV
 . d log(jlog,"Provider NPI for outpatient is: "_DHPPROV)
 . ;
 . ;s DHPLOC=$$MAP^SYNQLDM("OP","location")
 . ;n DHPLOCIEN s DHPLOCIEN=$o(^SC("B",DHPLOC,""))
 . ;if DHPLOCIEN="" S DHPLOCIEN=4
 . ;s eval("allergy",zi,"parms","DHPLOC")=DHPLOCIEN
 . ;d log(jlog,"Location for outpatient is: #"_DHPLOCIEN_" "_DHPLOC)
 . ;
 . s eval("allergy",zi,"status","loadstatus")="readyToLoad"
 . ;
 . if $g(args("load"))=1 d  ; only load if told to
 . . if $g(ien)'="" if $$loadStatus("allergy",zi,ien)=1 do  quit  ;
 . . . d log(jlog,"Allergy already loaded, skipping")
 . . d log(jlog,"Calling ALLERGY^ISIIMP10 to add allergy")
 . . D ALLERGY^ISIIMP10(.RETSTA,.ISIMISC)
 . . m eval("allergy",zi,"status")=RESTA
 . . d log(jlog,"Return from data loader was: "_$g(ISIRC))
 . . if +$g(RETSTA)=1 do  ;
 . . . s eval("status","loaded")=$g(eval("status","loaded"))+1
 . . . s eval("allergy",zi,"status","loadstatus")="loaded"
 . . else  d  ;
 . . . s eval("status","errors")=$g(eval("status","errors"))+1
 . . . s eval("allergy",zi,"status","loadstatus")="notLoaded"
 . . . s eval("allergy",zi,"status","loadMessage")=$g(RETSTA)
 . . n root s root=$$setroot^%wd("fhir-intake")
 . . k @root@(ien,"load","allergy",zi)
 . . m @root@(ien,"load","allergy",zi)=eval("allergy",zi)
 ;
 if $get(args("debug"))=1 do  ;
 . m jrslt("source")=json
 . m jrslt("args")=args
 . m jrslt("eval")=eval
 m jrslt("allergyStatus")=eval("allergyStatus")
 set jrslt("result","status")="ok"
 set jrslt("result","loaded")=$g(eval("status","loaded"))
 i $g(ien)'="" d  ; called internally
 . m result=eval
 . m result("status")=jrslt("result")
 . m result("dfn")=dfn
 . m result("ien")=ien
 . ;b
 e  d  ;
 . d ENCODE^VPRJSON("jrslt","result")
 . set HTTPRSP("mime")="application/json" 
 q
 ;
log(ary,txt) ; adds a text line to @ary@("log")
 s @ary@("log",$o(@ary@("log",""),-1)+1)=$g(txt)
 q
 ;
loadStatus(typ,zx,zien) ; extrinsic return 1 if resource was loaded
 n root s root=$$setroot^%wd("fhir-intake")
 n rt s rt=0
 i $g(zx)="" i $d(@root@(zien,"load",typ)) s rt=1 q rt
 i $get(@root@(zien,"load",typ,zx,"status","loadstatus"))="loaded" s rt=1
 q rt
 ;
testall ; run the allergy import on all imported patients
 new root s root=$$setroot^%wd("fhir-intake")
 new indx s indx=$na(@root@("POS","DFN"))
 n dfn,ien,filter,reslt
 s dfn=0
 f  s dfn=$o(@indx@(dfn)) q:+dfn=0  d  ;
 . s ien=$o(@indx@(dfn,""))
 . q:ien=""
 . s filter("dfn")=dfn
 . k reslt
 . d wsIntakeAllergy(.filter,,.reslt,ien)
 q
 ;
testone(reslt,doload) ; run the allergy import on one imported patient
 new root s root=$$setroot^%wd("fhir-intake")
 new indx s indx=$na(@root@("POS","DFN"))
 n dfn,ien,filter
 n done s done=0
 s dfn=0
 f  s dfn=$o(@indx@(dfn)) q:+dfn=0  q:done   d  ;
 . s ien=$o(@indx@(dfn,""))
 . q:ien=""
 . q:$d(@root@(ien,"load","allergy"))
 . s filter("dfn")=dfn
 . s filter("debug")=1
 . i $g(doload)=1 s filter("load")=1
 . k reslt
 . d wsIntakeAllergy(.filter,,.reslt,ien)
 . s done=1
 q
 ;
getRandomAllergy(ary) ; make a web service call to get random allergies
 n srvr
 s srvr="http://postfhir.vistaplex.org:9080/"
 i srvr["postfhir.vistaplex.org" s srvr="http://138.197.70.229:9080/"
 i $g(^%WURL)["http://postfhir.vistaplex.org:9080" d  q  ;
 . s srvr="localhost:9080/"
 . n url
 . s url=srvr_"randomAllergy"
 . n ok,r1
 . s ok=$$%^%WC(.r1,"GET",url)
 . i '$d(r1) q  ;
 . d DECODE^VPRJSON("r1","ary")
 n url
 s url=srvr_"randomAllergy"
 n ret,json,jtmp
 s ret=$$GETURL^XTHC10(url,,"jtmp")
 d assemble^SYNFPUL("jtmp","json")
 i '$d(json) q  ;
 d DECODE^VPRJSON("json","ary")
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
ISGMR(CDE) ; extrinsic return the ien and allergy name in GMR ALLERGIES if any
 ; CDE is a snomed code. returns -1 if not found
 N VUID
 S VUID=$$MAP^SYNQLDM(CDE)
 W !,CDE," VUID:",VUID
 I VUID="" Q -1
 N IEN
 S IEN=$O(^GMRD(120.82,"AVUID",VUID,""))
 I IEN="" Q -1
 N R1 S R1=IEN_"^"_$$GET1^DIQ(120.82,IEN_",",.01)
 Q R1
 ;
QADDALGY(ALGY,ADATE,ien) ; adds an allergy to the queue to be processed
 ; used by Problems processing include allergies in VistA allergies
 ; ALGY is the name of the allergy. ADATE is the date of the allergy
 ; ien is the patient being processed
 i '$d(ien) q  ;
 n root s root=$$setroot^%wd("fhir-intake")
 n groot s groot=$na(@root@(ien,"load","ALLERGY2ADD"))
 n aien s aien=$o(@groot@(" "),-1)+1
 s @groot@(aien,"allergy")=$g(ALGY)
 s @groot@(aien,"date")=$g(ADATE)
 q
 ;
