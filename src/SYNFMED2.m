SYNFMED2	;ven/gpl - fhir loader utilities ; 2/20/18 4:11am
	;;1.0;fhirloader;;oct 19, 2017;Build 10
	;
	; Authored by George P. Lilly 2017-2018
	;
	q
	;
importMeds(rtn,ien,args)	; entry point for loading Medications for a patient
	; calls the intake Medications web service directly
	;
	n grtn
	n root s root=$$setroot^%wd("fhir-intake")
	d wsIntakeMeds(.args,,.grtn,ien)
	i $d(grtn) d  ; something was returned
	. k @root@(ien,"load","meds")
	. m @root@(ien,"load","meds")=grtn("meds")
	. if $g(args("debug"))=1 m rtn=grtn
	s rtn("conditionsStatus","status")=$g(grtn("status","status"))
	s rtn("conditionsStatus","loaded")=$g(grtn("status","loaded"))
	s rtn("conditionsStatus","errors")=$g(grtn("status","errors"))
	;b
	;
	;
	q
	;
wsIntakeMeds(args,body,result,ien)	; web service entry (post)
	; for intake of one or more Meds. input are fhir resources
	; result is json and summarizes what was done
	; args include patientId
	; ien is specified for internal calls, where the json is already in a graph
	n jtmp,json,jrslt,eval
	;i $g(ien)'="" if $$loadStatus("meds","",ien)=1 d  q  ;
	;. s result("medstatus","status")="alreadyLoaded"
	i $g(ien)'="" d  ; internal call
	. d getIntakeFhir^SYNFHIR("json",,"MedsIntolerance",ien,1)
	e  d  ; 
	. s args("load")=0
	. merge jtmp=BODY
	. do DECODE^VPRJSON("jtmp","json")
	;
	i '$d(json) d getRandomMeds(.json)
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
	. s result("meds",1,"log",1)="Error, patient not found.. terminating"
	;
	new zi s zi=0
	for  set zi=$order(json("entry",zi)) quit:+zi=0  do  ;
	. ;
	. ; define a place to log the processing of this entry
	. ;
	. new jlog set jlog=$name(eval("meds",zi))
	. ;
	. ; insure that the resourceType is MedsIntolerance
	. ;
	. new type set type=$get(json("entry",zi,"resource","resourceType"))
	. if type'="MedsIntolerance" do  quit  ;
	. . set eval("meds",zi,"vars","resourceType")=type
	. . do log(jlog,"Resource type not MedsIntolerance, skipping entry")
	. set eval("meds",zi,"vars","resourceType")=type
	. ;
	. ; see if this resource has already been loaded. if so, skip it
	. ;
	. if $g(ien)'="" if $$loadStatus("meds",zi,ien)=1 do  quit  ;
	. . d log(jlog,"Meds already loaded, skipping")
	. ;
	. ; determine Meds snomed code, coding system, and display text
	. ;
	. ;
	. ; determine the id of the resource
	. ;
	. ;new id set id=$get(json("entry",zi,"resource","id"))
	. ;set eval("meds",zi,"vars","id")=id
	. ;d log(jlog,"ID is: "_id)
	. ;
	. new sctcode set sctcode=$get(json("entry",zi,"resource","code","coding",1,"code"))
	. do log(jlog,"code is: "_sctcode)
	. set eval("meds",zi,"vars","code")=sctcode
	. ;
	. ;
	. new codesystem set codesystem=$get(json("entry",zi,"resource","code","coding",1,"system"))
	. do log(jlog,"code system is: "_codesystem)
	. set eval("meds",zi,"vars","codeSystem")=codesystem
	. ;
	. ; determine the onset date and time
	. ;
	. new onsetdate set onsetdate=$get(json("entry",zi,"resource","assertedDate"))
	. do log(jlog,"onsetDateTime is: "_onsetdate)
	. set eval("meds",zi,"vars","onsetDateTime")=onsetdate
	. new fmOnsetDateTime s fmOnsetDateTime=$$fhirTfm^SYNFUTL(onsetdate)
	. d log(jlog,"fileman onsetDateTime is: "_fmOnsetDateTime)
	. set eval("meds",zi,"vars","fmOnsetDateTime")=fmOnsetDateTime ;
	. new hl7OnsetDateTime s hl7OnsetDateTime=$$fhirThl7^SYNFUTL(onsetdate)
	. d log(jlog,"hl7 onsetDateTime is: "_hl7OnsetDateTime)
	. set eval("meds",zi,"vars","hl7OnsetDateTime")=hl7OnsetDateTime ;
	. ;
	. ; determine clinical status (active vs inactive)
	. ;
	. n clinicalstatus set clinicalstatus=$get(json("entry",zi,"resource","verificationStatus"))
	. ;
	. ;
	. ; set up to call the data loader
	. ;
	. ;MEDS^ISIIMP10(ISIRESUL,ISIMISC)          
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
	. ;n algy s algy=$$ISGMR(sctcode)
	. ;i algy'=-1 s ISIMISC("ALLERGEN")=$p(algy,"^",2)
	. s eval("meds",zi,"parms","ALLERGEN")=ISIMISC("ALLERGEN")
	. ;
	. s ISIMISC("SYMPTOM")=$get(json("entry",zi,"resource","reaction",1,"description"))
	. s eval("meds",zi,"parms","SYMPTOM")=ISIMISC("SYMPTOM")
	. ;
	. s ISIMISC("ORIGINTR")="USER,THREE"
	. s eval("meds",zi,"parms","ORIGINTR")=ISIMISC("ORIGINTR")
	. ;
	. s DHPPAT=$$dfn2icn^SYNFUTL(dfn)
	. s eval("meds",zi,"parms","DHPPAT")=DHPPAT
	. s ISIMISC("PAT_SSN")=$$GET1^DIQ(2,dfn_",",.09)
	. s eval("meds",zi,"parms","PAT_SSN")=ISIMISC("PAT_SSN")
	. ;
	. s DHPSCT=sctcode
	. s eval("meds",zi,"parms","DHPSCT")=DHPSCT
	. ;
	. s DHPCLNST=$S(clinicalstatus="Active":"A",1:"I")
	. s eval("meds",zi,"parms","DHPCLNST")=DHPCLNST
	. ;
	. s DHPONS=hl7OnsetDateTime
	. s eval("meds",zi,"parms","DHPONS")=DHPONS
	. s ISIMISC("ORIG_DATE")=fmOnsetDateTime
	. s eval("meds",zi,"parms","ORIG_DATE")=ISIMISC("ORIG_DATE")
	. s ISIMISC("HISTORIC")=1
	. s eval("meds",zi,"parms","HISTORIC")=ISIMISC("HISTORIC")
	. ;
	. s DHPPROV=$$MAP^SYNQLDM("OP","provider") ; map should return the NPI number
	. s eval("meds",zi,"parms","DHPPROV")=DHPPROV
	. d log(jlog,"Provider NPI for outpatient is: "_DHPPROV)
	. ;
	. ;s DHPLOC=$$MAP^SYNQLDM("OP","location")
	. ;n DHPLOCIEN s DHPLOCIEN=$o(^SC("B",DHPLOC,""))
	. ;if DHPLOCIEN="" S DHPLOCIEN=4
	. ;s eval("meds",zi,"parms","DHPLOC")=DHPLOCIEN
	. ;d log(jlog,"Location for outpatient is: #"_DHPLOCIEN_" "_DHPLOC)
	. ;
	. s eval("meds",zi,"status","loadstatus")="readyToLoad"
	. ;
	. if $g(args("load"))=1 d  ; only load if told to
	. . if $g(ien)'="" if $$loadStatus("meds",zi,ien)=1 do  quit  ;
	. . . d log(jlog,"Meds already loaded, skipping")
	. . d log(jlog,"Calling MEDS^ISIIMP10 to add meds")
	. . D MEDS^ISIIMP10(.RETSTA,.ISIMISC)
	. . m eval("meds",zi,"status")=RESTA
	. . d log(jlog,"Return from data loader was: "_$g(ISIRC))
	. . if +$g(RETSTA)=1 do  ;
	. . . s eval("status","loaded")=$g(eval("status","loaded"))+1
	. . . s eval("meds",zi,"status","loadstatus")="loaded"
	. . else  d  ;
	. . . s eval("status","errors")=$g(eval("status","errors"))+1
	. . . s eval("meds",zi,"status","loadstatus")="notLoaded"
	. . . s eval("meds",zi,"status","loadMessage")=$g(RETSTA)
	. . n root s root=$$setroot^%wd("fhir-intake")
	. . k @root@(ien,"load","meds",zi)
	. . m @root@(ien,"load","meds",zi)=eval("meds",zi)
	;
	if $get(args("debug"))=1 do  ;
	. m jrslt("source")=json
	. m jrslt("args")=args
	. m jrslt("eval")=eval
	m jrslt("medsStatus")=eval("medsStatus")
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
log(ary,txt)	; adds a text line to @ary@("log")
	s @ary@("log",$o(@ary@("log",""),-1)+1)=$g(txt)
	q
	;
loadStatus(typ,zx,zien)	; extrinsic return 1 if resource was loaded
	n root s root=$$setroot^%wd("fhir-intake")
	n rt s rt=0
	i $g(zx)="" i $d(@root@(zien,"load",typ)) s rt=1 q rt
	i $get(@root@(zien,"load",typ,zx,"status","loadstatus"))="loaded" s rt=1
	q rt
	;
testall	; run the meds import on all imported patients
	new root s root=$$setroot^%wd("fhir-intake")
	new indx s indx=$na(@root@("POS","DFN"))
	n dfn,ien,filter,reslt
	s dfn=0
	f  s dfn=$o(@indx@(dfn)) q:+dfn=0  d  ;
	. s ien=$o(@indx@(dfn,""))
	. q:ien=""
	. s filter("dfn")=dfn
	. k reslt
	. d wsIntakeMeds(.filter,,.reslt,ien)
	q
	;
testone(reslt,doload)	; run the meds import on one imported patient
	new root s root=$$setroot^%wd("fhir-intake")
	new indx s indx=$na(@root@("POS","DFN"))
	n dfn,ien,filter
	n done s done=0
	s dfn=0
	f  s dfn=$o(@indx@(dfn)) q:+dfn=0  q:done   d  ;
	. s ien=$o(@indx@(dfn,""))
	. q:ien=""
	. q:$d(@root@(ien,"load","meds"))
	. s filter("dfn")=dfn
	. s filter("debug")=1
	. i $g(doload)=1 s filter("load")=1
	. k reslt
	. d wsIntakeMeds(.filter,,.reslt,ien)
	. s done=1
	q
	;
getRandomMeds(ary) ; make a web service call to get random allergies
 n srvr
 s srvr="http://postfhir.vistaplex.org:9080/"
 i srvr["postfhir.vistaplex.org" s srvr="http://138.197.70.229:9080/"
 i $g(^%WURL)["http://postfhir.vistaplex.org:9080" d  q  ;
 . s srvr="localhost:9080/"
 . n url
 . s url=srvr_"randommeds"
 . n ok,r1
 . s ok=$$%^%WC(.r1,"GET",url)
 . i '$d(r1) q  ;
 . d DECODE^VPRJSON("r1","ary")
 n url
 s url=srvr_"randommeds"
 n ret,json,jtmp
 s ret=$$GETURL^XTHC10(url,,"jtmp")
 d assemble^SYNFPUL("jtmp","json")
 i '$d(json) q  ;
 d DECODE^VPRJSON("json","ary")
 q
 ;
medsum ; search all loaded patients and catelog the procedure codes
 n root,json,ien,table
 s root=$$setroot^%wd("fhir-intake")
 s ien=0
 f  s ien=$o(@root@(ien)) q:+ien=0  d  ;
 . k json
 . d getIntakeFhir^SYNFHIR("json",,"MedicationRequest",ien,1)
 . n cde,txt,rien
 . s rien=0
 . f  s rien=$o(json("entry",rien)) q:+rien=0  d  ;
 . . n med
 . . d getEntry^SYNFHIR("med",ien,rien-1) ; meds are in the previous entry
 . . n gmed s gmed=$na(med("entry",rien-1,"resource"))
 . . q:$g(@gmed@("resourceType"))'="Medication"
 . . s cde=$g(@gmed@("code","coding",1,"code"))
 . . q:cde=""
 . . s txt=$g(@gmed@("code","coding",1,"display"))
 . . n sys s sys=$g(@gmed@("code","coding",1,"system"))
 . . s sys=$re($p($re(sys),"/"))
 . . s txt=txt_" - "_sys
 . . i '$d(table(cde_" "_txt)) s table(cde_" "_txt)=1 q  ;
 . . s table(cde_" "_txt)=$g(table(cde_" "_txt))+1
 zwr table
 q
 ;
