SYNFLAB ;ven/gpl - fhir loader utilities ;2018-05-08  4:23 PM
 ;;0.7;VISTA SYN DATA LOADER;;Mar 18, 2025
 ;
 ; Copyright (c) 2017-2022 George P. Lilly
 ; Copyright (c) 2018-2019 Sam Habiel
 ; Copyright (c) 2025 DocMe360 LLC
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
 q
 ;
importLabs(rtn,ien,args) ; entry point for loading labs for a patient
 ; calls the intake Labs web service directly
 ;
 n grtn
 n root s root=$$setroot^SYNWD("fhir-intake")
 n % s %=$$wsIntakeLabs(.args,,.grtn,ien)
 ;i $d(grtn) d  ; something was returned
 ;. k @root@(ien,"load","labs")
 ;. m @root@(ien,"load","labs")=grtn("labs")
 ;. if $g(args("debug"))=1 m rtn=grtn
 if $g(args("debug"))=1 m rtn=grtn
 s rtn("labsStatus","status")=grtn("status","status")
 s rtn("labsStatus","loaded")=grtn("status","loaded")
 s rtn("labsStatus","errors")=grtn("status","errors")
 s rtn("panelsStatus","loaded")=grtn("panelStatus","loaded")
 s rtn("panelsStatus","errors")=grtn("panelStatus","errors")
 q
 ;
wsIntakeLabs(args,body,result,ien) ; web service entry (post)
 ; for intake of one or more Lab results. input are fhir resources
 ; result is json and summarizes what was done
 ; args include patientId
 ; ien is specified for internal calls, where the json is already in a graph
 n root,troot
 s root=$$setroot^SYNWD("fhir-intake")
 ;
 n jtmp,json,jrslt,eval
 ;i $g(ien)'="" if $$loadStatus("labs","",ien)=1 d  q  ;
 ;. s result("labsStatus","status")="alreadyLoaded"
 i $g(ien)'="" d  ; internal call
 . s troot=$na(@root@(ien,"type","Observation"))
 . s eval=$na(@root@(ien,"load")) ; move eval to the graph
 . ;d getIntakeFhir^SYNFHIR("json",,"Observation",ien,1)
 e  q 0  ; sending not decoded json in BODY to this routine is not done
 ; todo: locate the patient and add the labs in BODY to the graph
 ;. ;s args("load")=0
 i '$d(@troot) q 0  ;
 s json=$na(@root@(ien,"json"))
 ;
 ; Initialize counters
 s result("status","status")="NotStarted"
 s @eval@("labs","status","errors")=0
 i '$d(@eval@("labs","status","loaded")) s @eval@("labs","status","loaded")=0
 ;
 ; first intake all the lab panels
 d importPanels^SYNFPAN(.result,ien,.args)
 ;
 ; determine the patient
 ;
 n dfn
 if $g(ien)'="" d  ;
 . s dfn=$$ien2dfn^SYNFUTL(ien) ; look up dfn in the graph
 else  d  ;
 . s dfn=$g(args("dfn"))
 . i dfn="" d  ;
 . . n icn s icn=$g(args("icn"))
 . . i icn'="" s dfn=$$icn2dfn^SYNFUTL(icn)
 i $g(dfn)="" do  quit 0  ; need the patient
 . s result("labs",1,"log",1)="Error, patient not found.. terminating"
 ;
 ;
 new zi s zi=0
 for  set zi=$order(@troot@(zi)) quit:+zi=0  do  ;
 . ;
 . ; define a place to log the processing of this entry
 . ;
 . new jlog set jlog=$name(@eval@("labs",zi))
 . ;
 . ; ensure that the resourceType is Observation
 . ;
 . new type set type=$get(@json@("entry",zi,"resource","resourceType"))
 . if type'="Observation" do  quit  ;
 . . ;set @eval@("labs",zi,"vars","resourceType")=type
 . . ;do log(jlog,"Resource type not Observation, skipping entry")
 . ;set @eval@("labs",zi,"vars","resourceType")=type
 . ;
 . ; determine the Observation category and quit if not labs
 . ;
 . new obstype set obstype=$get(@json@("entry",zi,"resource","category",1,"coding",1,"code"))
 . if obstype="" do  ; category is missing, try mapping the code
 . . new trycode,trydisp,tryy
 . . set trycode=$g(@json@("entry",zi,"resource","code","coding",1,"code"))
 . . set trydisp=$g(@json@("entry",zi,"resource","code","coding",1,"display"))
 . . s tryy=$$loinc2sct(trycode)
 . . if tryy="" d  quit  ;
 . . . d log(jlog,"Observation Category missing, not vital signs; code is: "_trycode_" "_trydisp)
 . . if tryy'="" set obstype="laboratory"
 . . d log(jlog,"Derived category is "_obstype)
 . ;
 . if obstype'="laboratory" do  quit  ;
 . . ;set @eval@("labs",zi,"vars","observationCategory")=obstype
 . . ;do log(jlog,"Observation Category is not laboratory, skipping")
 . set @eval@("labs",zi,"vars","observationCategory")=obstype
 . ;
 . ; see if this resource has already been loaded. if so, skip it
 . ;
 . if $g(ien)'="" if $$loadStatus("labs",zi,ien)=1 do  quit  ;
 . . d log(jlog,"Lab already loaded, skipping")
 . ;
 . ; determine Labs type, code, coding system, and display text
 . ;
 . new labtype set labtype=$get(@json@("entry",zi,"resource","code","text"))
 . if labtype="" set labtype=$get(@json@("entry",zi,"resource","code","coding",1,"display"))
 . do log(jlog,"Labs type is: "_labtype)
 . set @eval@("labs",zi,"vars","type")=labtype
 . ;
 . ; determine the id of the resource
 . ;
 . new id set id=$get(@json@("entry",zi,"resource","id"))
 . set @eval@("labs",zi,"vars","id")=id
 . d log(jlog,"ID is: "_id)
 . ;
 . new obscode set obscode=$get(@json@("entry",zi,"resource","code","coding",1,"code"))
 . do log(jlog,"code is: "_obscode)
 . set @eval@("labs",zi,"vars","code")=obscode
 . ;
 . ;
 . new codesystem set codesystem=$get(@json@("entry",zi,"resource","code","coding",1,"system"))
 . do log(jlog,"code system is: "_codesystem)
 . set @eval@("labs",zi,"vars","codeSystem")=codesystem
 . ;
 . ; determine the value and units
 . ;
 . new value set value=$get(@json@("entry",zi,"resource","valueQuantity","value"))
 . if value="" d  ;
 . . new sctcode,scttxt
 . . s sctcode=$get(@json@("entry",zi,"resource","valueCodeableConcept","coding",1,"code"))
 . . s scttxt=$get(@json@("entry",zi,"resource","valueCodeableConcept","coding",1,"display"))
 . . s value=sctcode_"^"_scttxt
 . . do log(jlog,"value before adjust is: "_value)
 . . d ADJUST^SYNFPAN(.value)
 . . do log(jlog,"value after adjust is: "_value)
 . . i value["^" s value=""
 . else  d  ;
 . . ;
 . . ; source: https://doi.org/10.30574/gscbps.2023.22.2.0091
 . . ;
 . . if obscode="5792-7" d  ; Glucose
 . . . n x s x=value
 . . . s value=$s(x<100:"NEG",x<250:"TRACE",x<500:"1+",x<1000:"2+",x<2000:"3+",1:"4+")
 . . if obscode="5804-0" d  ; Protein
 . . . n x s x=value
 . . . s value=$s(x<15:"NEG",x<30:"TRACE",x<100:"1+",x<300:"2+",x<1000:"3+",1:"4+")
 . ;
 . i value="" d  quit
 . . s @eval@("labs",zi,"status","issue")="Lab value not found for loinc code: "_obscode_" "_labtype
 . . d fail(jlog,eval,zi,"Error, value is null, quitting")
 . do log(jlog,"value is: "_value)
 . set @eval@("labs",zi,"vars","value")=value
 . ;
 . new unit set unit=$get(@json@("entry",zi,"resource","valueQuantity","unit"))
 . do log(jlog,"units are: "_unit)
 . set @eval@("labs",zi,"vars","units")=unit
 . ;
 . ; determine the effective date
 . ;
 . new effdate set effdate=$get(@json@("entry",zi,"resource","effectiveDateTime"))
 . do log(jlog,"effectiveDateTime is: "_effdate)
 . set @eval@("labs",zi,"vars","effectiveDateTime")=effdate
 . new fmtime s fmtime=$$fhirTfm^SYNFUTL(effdate)
 . d log(jlog,"fileman dateTime is: "_fmtime)
 . set @eval@("labs",zi,"vars","fmDateTime")=fmtime ;
 . new hl7time s hl7time=$$fhirThl7^SYNFUTL(effdate)
 . d log(jlog,"hl7 dateTime is: "_hl7time)
 . set @eval@("labs",zi,"vars","hl7DateTime")=hl7time ;
 . ;
 . ; set up to call the data loader
 . ;
 . n RETSTA,DHPPAT,DHPSCT,DHPOBS,DHPUNT,DHPDTM,DHPPROV,DHPLOC,DHPLOINC
 . ;
 . s DHPPAT=$$dfn2icn^SYNFUTL(dfn)
 . s @eval@("labs",zi,"parms","DHPPAT")=DHPPAT
 . ;
 . ;n vistalab s vistalab=$$MAP^SYNQLDM(obscode)
 . s DHPLOINC=obscode
 . d log(jlog,"LOINC code is: "_DHPLOINC)
 . s @eval@("labs",zi,"parms","DHPLOINC")=DHPLOINC
 . ;
 . n vistalab s vistalab=$$graphmap^SYNGRAPH("loinc-lab-map",obscode)
 . i +vistalab=-1 s vistalab=$$graphmap^SYNGRAPH("loinc-lab-map"," "_obscode)
 . i +vistalab=-1 s vistalab=$$covid^SYNGRAPH(obscode)
 . i +vistalab=-1 s vistalab=$$MAP^SYNQLDM(obscode,"labs")
 . i +vistalab'=-1 d
 .. d log(jlog,"Lab found in graph: "_vistalab)
 .. s @eval@("labs",zi,"parms","vistalab")=vistalab
 . if +vistalab=-1 s vistalab=""
 . s vistalab=$$TRIM^XLFSTR(vistalab) ; get rid of trailing blanks
 . ;n sct s sct=$$loinc2sct(obscode) ; find the snomed code
 . i vistalab="" d  quit
 . . d log(jlog,"VistA lab not found for loinc code: "_obscode_" "_labtype_" -- skipping")
 . . s @eval@("labs",zi,"status","issue")="VistA lab not found for loinc code: "_obscode_" "_labtype_" -- skipping"
 . . d fail(jlog,eval,zi,"Error - VistA lab not found for loinc code: "_obscode_" "_labtype_" -- skipping")
 . s @eval@("labs",zi,"parms","DHPLAB")=vistalab
 . d log(jlog,"VistA Lab is: "_vistalab)
 . s DHPLAB=vistalab
 . ;
 . s DHPOBS=value
 . ;
 . ; Collection sample
 . ;
 . n CSAMP
 . S CSAMP=$$GET1^DIQ(95.3,$p(obscode,"-"),4)
 . I CSAMP["SER/PLAS" S CSAMP="SERUM"
 . I CSAMP["Whole blood" S CSAMP="BLOOD"
 . I CSAMP["Blood venous" S CSAMP="BLOOD"
 . I CSAMP["Urine Sediment" S CSAMP="URINE"
 . I CSAMP["Platelet poor plasma" S CSAMP="PLASMA"
 . I CSAMP["Blood arterial" S CSAMP="ARTERIAL BLOOD"
 . d log(jlog,"Collection sample is: "_CSAMP)
 . s @eval@("labs",zi,"parms","DHPCSAMP")=CSAMP
 . ;
 . ; added for Covid tests
 . i DHPOBS="" d  ; no quant value
 . . n vtxt ; value text
 . . s vtxt=$get(@json@("entry",zi,"resource","valueCodeableConcept","text"))
 . . ;i vtxt["Negative" s DHPOBS="Negative" ; 260385009
 . . i vtxt["Negative" s DHPOBS="Not Detected" ; 260385009
 . . ;i vtxt["Positive" s DHPOBS="Positive" ; 10828004
 . . i vtxt["Positive" s DHPOBS="DETECTED" ; 10828004
 . . i vtxt["Detected" s DHPOBS="DETECTED" ; 260373001
 . . i vtxt["Not detected" s DHPOBS="Not Detected" ; 260415000
 . . i vtxt["Confirmed" s DHPOBS="CONFIRMED" ;
 . s @eval@("labs",zi,"parms","DHPOBS")=DHPOBS
 . d log(jlog,"Value is: "_DHPOBS)
 . ;
 . s DHPUNT=unit
 . s @eval@("labs",zi,"parms","DHPUNT")=unit
 . d log(jlog,"Units are: "_unit)
 . ;
 . s DHPDTM=hl7time
 . s @eval@("labs",zi,"parms","DHPDTM")=hl7time
 . d log(jlog,"HL7 DateTime is: "_hl7time)
 . ;
 . s DHPPROV=$$MAP^SYNQLDM("OP","provider")
 . n DHPPROVIEN s DHPPROVIEN=$o(^VA(200,"B",DHPPROV,""))
 . if DHPPROVIEN="" S DHPPROVIEN=3
 . s @eval@("labs",zi,"parms","DHPPROV")=DHPPROVIEN
 . d log(jlog,"Provider for outpatient is: #"_DHPPROVIEN_" "_DHPPROV)
 . ;
 . s DHPLOC=$$MAP^SYNQLDM("OP","location")
 . n DHPLOCIEN s DHPLOCIEN=$o(^SC("B",DHPLOC,""))
 . if DHPLOCIEN="" S DHPLOCIEN=4
 . s @eval@("labs",zi,"parms","DHPLOC")=DHPLOC
 . d log(jlog,"Location for outpatient is: #"_DHPLOCIEN_" "_DHPLOC)
 . ;
 . s @eval@("labs",zi,"status","loadstatus")="readyToLoad"
 . ;
 . if $g(args("load"))=1 d  ; only load if told to
 . . if $g(ien)'="" if $$loadStatus("labs",zi,ien)=1 do  quit  ;
 . . . d log(jlog,"Lab already loaded, skipping")
 . . d log(jlog,"Calling LABADD^SYNDHP63 to add lab")
 . . D LABADD^SYNDHP63(.RETSTA,DHPPAT,DHPLOC,DHPLAB,DHPOBS,DHPDTM,DHPLOINC,CSAMP)     ; labs update
 . . d log(jlog,"Return from LABADD^SYNDHP63 was: "_$g(RETSTA))
 . . ;i $g(DEBUG)=1 ZWRITE RETSTA
 . . if +$g(RETSTA)=1 do  ;
 . . . s @eval@("labs","status","loaded")=@eval@("labs","status","loaded")+1
 . . . s @eval@("labs",zi,"status","loadstatus")="loaded"
 . . else  s @eval@("labs","status","errors")=@eval@("labs","status","errors")+1
 ;
 if $get(args("debug"))=1 do  ;
 . m jrslt("source")=@json
 . m jrslt("args")=args
 . m jrslt("eval")=@eval
 m jrslt("labsStatus")=@eval@("labsStatus")
 set jrslt("result","status")="ok"
 set jrslt("result","loaded")=@eval@("labs","status","loaded")
 set jrslt("result","errors")=@eval@("labs","status","errors")
 m result("status")=jrslt("result")
 q 1
 ;
fail(jlog,eval,zrien,zmsg) ; standard way to mark a lab as failed and increment error count
 ;
 s @eval@("labs",zrien,"status","loadstatus")="readyToLoad"
 d log(jlog,"Return: -1^"_zmsg)
 s @eval@("labs","status","errors")=@eval@("labs","status","errors")+1
 ;
 q
 ;
log(ary,txt) ; adds a text line to @ary@("log")
 s @ary@("log",$o(@ary@("log",""),-1)+1)=$g(txt)
 w:$G(DEBUG) !,"      ",$G(txt)
 q
 ;
loadStatus(typ,zx,zien) ; extrinsic return 1 if resource was loaded
 n root s root=$$setroot^SYNWD("fhir-intake")
 n rt s rt=0
 i $g(zx)="" i $d(@root@(zien,"load",typ)) s rt=1 q rt
 i $get(@root@(zien,"load",typ,zx,"status","loadstatus"))="loaded" s rt=1
 q rt
loinc2sct(loinc) ; extrinsic returns a Snomed code for a Loinc code
 ; for labs
 ; thanks to Ferdi for the Snomed mapping
 ;
 ;
 S SCTA("29463-7",27113001)="9^Body weight"
 S SCTA("8302-2",50373000)="8^Body height"
 S SCTA("55284-4",75367002)="1^Blood pressure"
 S SCTA(78564009)="5^Pulse rate"
 S SCTA("8331-1",386725007)="2^Body Temperature"
 S SCTA(86290005)="3^Respiration"
 S SCTA(48094003)="10^Abdominal girth measurement"
 S SCTA(21727005)="11^Audiometry"
 S SCTA(252465000)="21^Pulse oximetry"
 S SCTA(22253000)="22^Pain"
 ;
 q $o(SCTA(loinc,""))
 ;
testall ; run the labs import on all imported patients
 new root s root=$$setroot^SYNWD("fhir-intake")
 new indx s indx=$na(@root@("POS","DFN"))
 n dfn,ien,filter,reslt
 s dfn=0
 f  s dfn=$o(@indx@(dfn)) q:+dfn=0  d  ;
 . s ien=$o(@indx@(dfn,""))
 . q:ien=""
 . s filter("dfn")=dfn
 . k reslt
 . d wsIntakeLabs(.filter,,.reslt,ien)
 q
 ;
labsum ; summary of lab tests for patient ien pien
 n root s root=$$setroot^SYNWD("fhir-intake")
 n table
 n zzi s zzi=0
 f  s zzi=$o(@root@(zzi)) q:+zzi=0  d  ;
 . n labs
 . d getIntakeFhir^SYNFHIR("labs",,"Observation",zzi,1)
 . n zi s zi=0
 . f  s zi=$o(labs("entry",zi)) q:+zi=0  d  ;
 . . n groot s groot=$na(labs("entry",zi,"resource"))
 . . i $g(@groot@("category",1,"coding",1,"code"))'="laboratory" q  ;
 . . n loinc
 . . s loinc=$g(@groot@("code","coding",1,"code"))
 . . q:loinc=""
 . . ;i loinc="6082-2" b  ;
 . . n text s text=$g(@groot@("code","coding",1,"display"))
 . . i $d(table(loinc_" "_text)) d  ;
 . . . s table(loinc_" "_text)=table(loinc_" "_text)+1
 . . e  d  ;
 . . . s table(loinc_" "_text)=1
 . . . w !,"patient= "_zzi_" entry= "_zi,!
 . . . n rptary m rptary=@root@(zzi,"json","entry",zi,"resource")
 . . . ;zwrite rptary
 ;zwrite table
 q
 ;
