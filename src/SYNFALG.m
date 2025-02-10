SYNFALG ;ven/gpl - fhir loader utilities ;2019-06-21  3:40 PM
 ;;0.3;VISTA SYNTHETIC DATA LOADER;;Jul 01, 2019;Build 13
 ;
 ; Copyright (c) 2017-2018 George P. Lilly
 ; Copyright (c) 2018 Sam Habiel
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
 q
 ;
importAllergy(rtn,ien,args) ; entry point for loading Allergy for a patient
 ; calls the intake Allergy web service directly
 ;
 n grtn
 d wsIntakeAllergy(.args,,.grtn,ien)
 s rtn("allergyStatus","status")=$g(grtn("status","status"))
 s rtn("allergyStatus","loaded")=+$g(grtn("status","loaded"))
 s rtn("allergyStatus","errors")=+$g(grtn("status","errors"))
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
 ;
 i '$d(json) q  ;
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
 . . q:dfn=""
 . . s ien=$$dfn2ien^SYNFUTL(dfn)
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
 . ; determine the codesystem of the allergy
 . ;
 . new codesystem set codesystem=$get(json("entry",zi,"resource","code","coding",1,"system"))
 . do log(jlog,"code system is: "_codesystem)
 . set eval("allergy",zi,"vars","codeSystem")=codesystem
 . ;
 . ; if rxnorm, call meds routine
 . ;
 . i codesystem["rxnorm" do  q  ;
 . . d MEDALGY^SYNFALG2(dfn,.root,.json,zi,.eval,.jlog,.args)
 . ;
 . ; determine Allergy snomed code  and display text
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
 . ; determine the onset date and time
 . ;
 . ; json("entry",439,"resource","recordedDate")="1988-06-30T13:15:44-04:00"
 . new onsetdate   set onsetdate=$get(json("entry",zi,"resource","assertedDate"))
 . if onsetdate="" set onsetdate=$get(json("entry",zi,"resource","recordedDate"))
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
 . ;s ISIMISC("ORIGINTR")="USER,THREE"
 . s ISIMISC("ORIGINTR")=$$USERNAME^SYNFALG
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
 . . n myresult s myresult=$$ALLERGY^ISIIMP10(.RESTA,.ISIMISC)
 . . m eval("allergy",zi,"status")=RESTA
 . . d log(jlog,"Return from data loader was: "_myresult)
 . . if myresult=1 do  ;
 . . . s eval("allergy","status","loaded")=$g(eval("allergy","status","loaded"))+1
 . . . s eval("allergy",zi,"status","loadstatus")="loaded"
 . . else  d  ;
 . . . s eval("allergy","status","errors")=$g(eval("allergy","status","errors"))+1
 . . . s eval("allergy",zi,"status","loadstatus")="notLoaded"
 . . . s eval("allergy",zi,"status","loadMessage")=$g(RESTA)
 . . n root s root=$$setroot^SYNWD("fhir-intake")
 . . i $g(ien)'="" d  ;
 . . . k @root@(ien,"load","allergy",zi)
 . . . m @root@(ien,"load","allergy",zi)=eval("allergy",zi)
 ;
 if $get(args("debug"))=1 do  ;
 . m jrslt("source")=json
 . m jrslt("args")=args
 . m jrslt("eval")=eval
 m jrslt("allergyStatus")=eval("allergyStatus")
 set jrslt("result","status")="ok"
 set jrslt("result","loaded")=$g(eval("allergy","status","loaded"))
 set jrslt("result","errors")=$g(eval("allergy","status","errors"))
 m result("status")=jrslt("result")
 q
 ;
USERNAME() ; extrinsic returns the name of the user
 n duz
 s duz=$$USERDUZ^SYNFALG2
 q:duz="" -1
 q $p(^VA(200,duz,0),"^",1)
 ;
log(ary,txt) ; adds a text line to @ary@("log")
 s @ary@("log",$o(@ary@("log",""),-1)+1)=$g(txt)
 q
 ;
loadStatus(typ,zx,zien) ; extrinsic return 1 if resource was loaded
 n root s root=$$setroot^SYNWD("fhir-intake")
 n rt s rt=0
 i $g(zx)="" i $d(@root@(zien,"load",typ)) s rt=1 q rt
 i $get(@root@(zien,"load",typ,zx,"status","loadstatus"))="loaded" s rt=1
 q rt
 ;
testall ; run the allergy import on all imported patients
 new root s root=$$setroot^SYNWD("fhir-intake")
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
 new root s root=$$setroot^SYNWD("fhir-intake")
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
ISGMR(CDE) ; extrinsic return the ien and allergy name in GMR ALLERGIES if any
 ; CDE is a snomed code. returns -1 if not found
 N VUID
 S VUID=$$MAP^SYNQLDM(CDE,"gmr-allergies")
 ;W !,CDE," VUID:",VUID
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
 n root s root=$$setroot^SYNWD("fhir-intake")
 n groot s groot=$na(@root@(ien,"load","ALLERGY2ADD"))
 n aien s aien=$o(@groot@(" "),-1)+1
 s @groot@(aien,"allergy")=$g(ALGY)
 s @groot@(aien,"date")=$g(ADATE)
 q
 ;
