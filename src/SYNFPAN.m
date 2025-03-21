SYNFPAN ;ven/gpl - fhir loader utilities ;2018-05-08  4:23 PM
 ;;0.7;VISTA SYN DATA LOADER;;Mar 18, 2025
 ;
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
 ;
 q
 ;
importPanels(rtn,ien,args) ; entry point for loading lab panels for a patient
 ; calls the intake Labs web service directly
 ;
 n grtn
 n root s root=$$setroot^SYNWD("fhir-intake")
 n % s %=$$wsIntakePanels(.args,,.grtn,ien)
 ;i $d(grtn) d  ; something was returned
 ;. k @root@(ien,"load","panels")
 ;. m @root@(ien,"load","panels")=grtn("panels")
 ;. if $g(args("debug"))=1 m rtn=grtn
 if $g(args("debug"))=1 m rtn=grtn
 s rtn("panelStatus","status")=grtn("status","status")
 s rtn("panelStatus","loaded")=grtn("status","loaded")
 s rtn("panelStatus","errors")=grtn("status","errors")
 ;b
 ;
 ;
 q
 ;
wsIntakePanels(args,body,result,ien) ; web service entry (post)
 ; for intake of one or more Lab panel results. input are fhir resources
 ; result is json and summarizes what was done
 ; args include patientId
 ; ien is specified for internal calls, where the json is already in a graph
 ;
 n root,troot
 s root=$$setroot^SYNWD("fhir-intake")
 ;
 n jtmp,json,jrslt,eval
 ;i $g(ien)'="" if $$loadStatus("panels","",ien)=1 d  q  ;
 ;. s result("labsStatus","status")="alreadyLoaded"
 i $g(ien)'="" d  ; internal call
 . s troot=$na(@root@(ien,"type","DiagnosticReport"))
 . ;b
 . s eval=$na(@root@(ien,"load")) ; move eval to the graph
 . ;k @eval  ; this is to clear the load log during testing
 ; todo: locate the patient and add the labs in BODY to the graph
 ;   this is for the use case when we are processing an update to
 ;   the patient rather than the initial load
 ;
 i '$d(@troot) q 0  ;
 s json=$na(@root@(ien,"json"))
 ;
 ; Initialize counters
 s result("status","status")="NotStarted"
 s @eval@("panels","status","errors")=0
 s @eval@("panels","status","loaded")=0
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
 . s result("panels",1,"log",1)="Error, patient not found.. terminating"
 ;
 ;
 new SYNZI s SYNZI=0
 for  set SYNZI=$order(@troot@(SYNZI)) quit:+SYNZI=0  do  ;
 . ;
 . ; define a place to log the processing of this entry
 . ;
 . new jlog set jlog=$name(@eval@("panels",SYNZI))
 . k @jlog
 . ;
 . ; ensure that the resourceType is DiagnosticReports
 . ;
 . new type set type=$get(@json@("entry",SYNZI,"resource","resourceType"))
 . ;if type'="DiagnosticReport" do  quit  ;
 . q:type'="DiagnosticReport"
 . ;. ;set @eval@("panels",SYNZI,"vars","resourceType")=type
 . ;. ;do log(jlog,"Resource type not DiagnosticReport, skipping entry")
 . ;set @eval@("panels",SYNZI,"vars","resourceType")=type
 . ;
 . ; determine the DiagnosticReport category and quit if not a lab panel
 . ;
 . ;new obstype set obstype=$get(@json@("entry",SYNZI,"resource","category",1,"coding",1,"code"))
 . new catcode set catcode=$get(@json@("entry",SYNZI,"resource","category",1,"coding",1,"code"))
 . q:$$UP^XLFSTR(catcode)'["LAB"
 . new loinc s loinc=""
 . set loinc=$g(@json@("entry",SYNZI,"resource","code","coding",1,"code"))
 . d log(jlog,"Panel loinc code is  "_loinc)
 . ;
 . ; see if this resource has already been loaded. if so, skip it
 . ;
 . if $g(ien)'="" if $$loadStatus("panels",SYNZI,ien)=1 do  quit  ;
 . . d log(jlog,"Panel already loaded, skipping")
 . ;
 . ; determine Panel type, code, coding system, and display text
 . ;
 . new paneltype set paneltype=$get(@json@("entry",SYNZI,"resource","code","text"))
 . if paneltype="" set paneltype=$get(@json@("entry",SYNZI,"resource","code","coding",1,"display"))
 . do log(jlog,"Panel type is: "_paneltype)
 . ;do log(jlog,"Panel type is: "_obsdisplay)
 . set @eval@("panels",SYNZI,"vars","type")=paneltype
 . ;
 . ; determine the id of the resource
 . ;
 . new id set id=$get(@json@("entry",SYNZI,"resource","id"))
 . set @eval@("panels",SYNZI,"vars","id")=id
 . d log(jlog,"ID is: "_id)
 . ;
 . ;Here's the spec for uploading a panel:
 . ;KBANTEST ;
 . ;N %,SAM,RC
 . ;S SAM("LAB_PANEL")="CHEM 7"
 . ;S SAM("LAB_TEST","BUN")=10
 . ;S SAM("LAB_TEST","CO2")=34
 . ;S SAM("LAB_TEST","GLUCOSE")=180
 . ;S SAM("PAT_SSN")="999504449"
 . ;S SAM("RESULT_DT")="NOW"
 . ;S SAM("LOCATION")="3E NORTH"
 . ;S SAM("COLLECTION_SAMPLE")="BLOOD" ; optional
 . ;S %=$$LAB^ISIIMP12(.RC,.SAM)
 . ;ZWRITE RC
 . ;QUIT
 . ;
 . ; starting the parameter array with the panel level elements
 . ;
 . n MISC ; parameter array
 . ;
 . ; lab panel
 . ;
 . N PANEL
 . S PANEL=$$MAP^SYNQLDM(loinc,"vistapanel")
 . i PANEL="" do  quit
 . . d fail(jlog,eval,SYNZI,"Return: -1^Panel with loinc "_loinc_" has no mapping to a VistA Lab Panel")
 . d log(jlog,"VistA panel is: "_PANEL)
 . S MISC("LAB_PANEL")=PANEL
 . ;
 . ; patient
 . ;
 . s MISC("PAT_SSN")=$$GET1^DIQ(2,dfn_",","SSN")
 . ;
 . ; result date/time
 . ;
 . new effdate set effdate=$get(@json@("entry",SYNZI,"resource","effectiveDateTime"))
 . do log(jlog,"effectiveDateTime is: "_effdate)
 . set @eval@("panels",SYNZI,"vars","effectiveDateTime")=effdate
 . new fmtime s fmtime=$$fhirTfm^SYNFUTL(effdate)
 . ; time adjustment to avoid duplicates
 . ;i $d(FMTIME(fmtime)) d  ;
 . ;. ;ZWR FMTIME
 . ;. n i s i=fmtime
 . ;. f fmtime=i:.000001 q:'$d(FMTIME(fmtime))
 . ;s FMTIME(fmtime)=""
 . d log(jlog,"fileman dateTime is: "_fmtime)
 . set @eval@("panels",SYNZI,"vars","fmDateTime")=fmtime ;
 . new hl7time s hl7time=$$fhirThl7^SYNFUTL(effdate)
 . d log(jlog,"hl7 dateTime is: "_hl7time)
 . set @eval@("panels",SYNZI,"vars","hl7DateTime")=hl7time ;
 . s MISC("RESULT_DT")=fmtime
 . ;
 . ; location
 . ;
 . s DHPLOC=$$MAP^SYNQLDM("OP","location")
 . n DHPLOCIEN s DHPLOCIEN=$o(^SC("B",DHPLOC,""))
 . if DHPLOCIEN="" S DHPLOCIEN=4
 . ;s @eval@("labs",SYNZI,"parms","DHPLOC")=DHPLOC
 . d log(jlog,"Location for outpatient is: #"_DHPLOCIEN_" "_DHPLOC)
 . s MISC("LOCATION")=DHPLOC
 . ;
 . ; collection sample
 . ;
 . n CSAMP
 . S CSAMP=$$GET1^DIQ(95.3,$p(loinc,"-"),4)
 . I CSAMP["SER/PLAS" S CSAMP="SERUM"
 . I CSAMP["Whole blood" S CSAMP="BLOOD"
 . I CSAMP["Blood venous" S CSAMP="BLOOD"
 . I CSAMP["Urine Sediment" S CSAMP="URINE"
 . I CSAMP["Platelet poor plasma" S CSAMP="PLASMA"
 . I CSAMP["Blood arterial" S CSAMP="ARTERIAL BLOOD"
 . d log(jlog,"Collection sample is: "_CSAMP)
 . s MISC("COLLECTION_SAMPLE")=CSAMP
 . ;
 . ;  ; add code to process DiagnosticReport results here
 . ;
 . n triples s triples=$na(@root@(ien))
 . n atomptr s atomptr=$na(@json@("entry",SYNZI,"resource","result"))
 . n atomdisp s atomdisp=""
 . n success s success="" ; array of labs to be marked as loaded on success
 . n rien s rien=""
 . n zj s zj=0
 . f  s zj=$o(@atomptr@(zj)) q:+zj=0  d  ;
 . . s atomdisp=$get(@atomptr@(zj,"display"))
 . . n atomref s atomref=$get(@atomptr@(zj,"reference"))
 . . s rien=$o(@triples@("SPO",atomref,"rien",""))
 . . d log(jlog,zj_" result "_atomdisp_" rien="_rien)
 . . ;
 . . ; call one result lab
 . . ;
 . . n lablog s lablog=$na(@root@(ien,"load","labs",rien))
 . . D ONELAB(.MISC,json,rien,zj,jlog,eval,lablog,.success,atomdisp)
 . . ;
 . m @eval@("panels",SYNZI,"vars","MISC")=MISC ;
 . ;
 . if $g(args("load"))=1 d  ; only load if told to
 . . if $g(ien)'="" if $$loadStatus("panels",SYNZI,ien)=1 do  quit  ;
 . . . d log(jlog,"Panel already loaded, skipping")
 . . d log(jlog,"Calling LAB^ISIIMP12 to add panel")
 . . n RESTA,RC
 . . s (RESTA,RC)=""
 . . ;i $g(DEBUG)=1 ZWRITE MISC
 . . S RESTA=$$LAB^ISIIMP12(.RC,.MISC)
 . . ;
 . . ;i $g(DEBUG)=1 ZWRITE RESTA
 . . ;i $g(DEBUG)=1 ZWRITE RC
 . . if +RESTA=1 do  ;
 . . . d log(jlog,"Return from LAB^ISIIMP12 was: "_$g(RESTA))
 . . . s @eval@("panels","status","loaded")=@eval@("panels","status","loaded")+1
 . . . s @eval@("panels",SYNZI,"status","loadstatus")="loaded"
 . . . d SUCCESS(SYNZI,.success,eval,ien) ; mark labs as loaded
 . . else  d fail(jlog,eval,SYNZI,"Return from LAB^ISIIMP12 was: "_$g(RESTA))
 ;
 if $get(args("debug"))=1 do  ;
 . m jrslt("source")=@json
 . m jrslt("args")=args
 . m jrslt("eval")=@eval
 m jrslt("labsStatus")=@eval@("labsStatus")
 set jrslt("result","status")="ok"
 set jrslt("result","loaded")=@eval@("panels","status","loaded")
 set jrslt("result","errors")=@eval@("panels","status","errors")
 m result("status")=jrslt("result")
 q:$Q 0 Q
 ;
SUCCESS(SYNZI,success,eval,ien) ; after a panel has loaded, mark the successful lab tests as loaded
 ;
 n root s root=$$setroot^SYNWD("fhir-intake")
 ;
 n sucien s sucien=""
 f  s sucien=$o(success(sucien)) q:sucien=""  d  ;
 . n lablog s lablog=$na(@root@(ien,"load","labs",sucien))
 . d log(lablog,"Return from LAB^ISIIMP12 was: 1^Part of a Lab Panel "_SYNZI)
 . s @eval@("labs",sucien,"status","loadstatus")="loaded"
 . i '$d(@eval@("labs","status","loaded")) s @eval@("labs","status","loaded")=0
 . s @eval@("labs","status","loaded")=@eval@("labs","status","loaded")+1
 ;
 Q
 ;
ONELAB(MISCARY,json,ien,zj,jlog,eval,lablog,callbak,atomdisp)
 ;
 new obscode set obscode=$get(@json@("entry",ien,"resource","code","coding",1,"code"))
 do log(lablog,"result "_zj_" code is: "_obscode)
 do log(jlog,"result "_zj_" code is: "_obscode)
 set @eval@("labs",SYNZI,"vars",zj_" code")=obscode
 ;
 I $G(DEBUG2) W !,obscode," ",atomdisp
 ;
 new codesystem set codesystem=$get(@json@("entry",ien,"resource","code","coding",1,"system"))
 do log(jlog,"result "_zj_" code system is: "_codesystem)
 do log(lablog,"result "_zj_" code system is: "_codesystem)
 set @eval@("labs",SYNZI,"vars",zj_" codeSystem")=codesystem
 ;
 ; determine the value and units
 ;
 new value set value=$get(@json@("entry",ien,"resource","valueQuantity","value"))
 if value="" d  ;
 . new sctcode,scttxt
 . s sctcode=$get(@json@("entry",ien,"resource","valueCodeableConcept","coding",1,"code"))
 . s scttxt=$get(@json@("entry",ien,"resource","valueCodeableConcept","coding",1,"display"))
 . s value=sctcode_"^"_scttxt
 . do log(jlog,"result "_zj_" value before adjust is: "_value)
 . d ADJUST(.value)
 . do log(jlog,"result "_zj_" value after adjust is: "_value)
 else  d  ;
 . ;
 . ; source: https://doi.org/10.30574/gscbps.2023.22.2.0091
 . ;
 . if obscode="5792-7" d  ; Glucose
 . . n x s x=value
 . . s value=$s(x<100:"NEG",x<250:"TRACE",x<500:"1+",x<1000:"2+",x<2000:"3+",1:"4+")
 . if obscode="5804-0" d  ; Protein
 . . n x s x=value
 . . s value=$s(x<15:"NEG",x<30:"TRACE",x<100:"1+",x<300:"2+",x<1000:"3+",1:"4+")
 . if atomdisp["[Presence]" d  ; Various presence values
 . . s value=$s(value=0:"NEG",1:value)
 ;
 i value="" d  quit
 . do log(jlog,"result "_zj_" value is null, quitting")
 . do log(lablog,"result "_zj_" value is null, quitting")
 do log(jlog,"result "_zj_" value is: "_value)
 do log(lablog,"result "_zj_" value is: "_value)
 set @eval@("labs",SYNZI,"vars",zj_" value")=value
 ;
 ;new unit set unit=$get(@json@("entry",SYNZI,"resource","valueQuantity","unit"))
 ;do log(jlog,"units are: "_unit)
 ;set @eval@("labs",SYNZI,"vars","units")=unit
 ;
 ; add to MISCARY
 ;
 n VLAB ; VistA lab name
 s VLAB=$$MAP^SYNQLDM(obscode,"labs")
 i VLAB="" d  quit
 . do log(jlog,"result "_zj_" VistA Lab not found for loinc="_obscode)
 . do log(lablog,"result "_zj_" VistA Lab not found for loinc="_obscode)
 . i $g(DEBUG2) W !,"result "_zj_" VistA Lab not found for loinc="_obscode
 ;
 ; Check if lab is member of a panel; if not, don't add, lab filer will file it later
 I '$$PMEM^ISIIMPU7(MISCARY("LAB_PANEL"),VLAB) d  quit
 . do log(jlog,"result "_zj_" Lab "_VLAB_" not in Panel "_MISCARY("LAB_PANEL"))
 . do log(lablog,"result "_zj_" Lab "_VLAB_" not in Panel "_MISCARY("LAB_PANEL"))
 ;
 d log(jlog,"result "_zj_" VistA Lab for "_obscode_" is: "_VLAB)
 d log(lablog,"result "_zj_" VistA Lab for "_obscode_" is: "_VLAB)
 i $g(DEBUG2) W !,"result "_zj_" VistA Lab for "_obscode_" is: "_VLAB
 s MISCARY("LAB_TEST",VLAB)=value
 ;
 s callbak(ien,VLAB)="" ; call back pointer to be used if panel is successful to mark the lab as loaded
 ;
 ;
 Q
 ;
ADJUST(ZV) ; adjust the value for specific text based values
 ;
 i ZV["^",$L(ZV)=1 S ZV="" Q
 i ZV["394717006^Urine leukocytes not detected (finding)" S ZV="NEG" Q
 i ZV["314137006^Nitrite detected in urine (finding)" S ZV="NEG" Q
 i ZV["394712000^Urine leukocyte test one plus (finding)" S ZV="1+" Q
 i ZV["276409005^Mucus in urine (finding)" S ZV="1+" Q
 i ZV["167287002^Urine ketones not detected (finding)" S ZV="NEG" Q
 i ZV["167336003^Urine microscopy: no casts (finding)" S ZV="NoneObs" Q
 i ZV["365691004^Finding of presence of bacteria (finding)" S ZV="1+" Q
 i ZV["+" D  Q
 . i ZV["++++" S ZV="4+" Q
 . i ZV["+++"  S ZV="3+" Q
 . i ZV["++"   S ZV="2+" Q
 . i ZV["+"    S ZV="1+" Q
 s:ZV["Brown" ZV="BROWN"
 s:ZV["Redish" ZV="REDISH"
 s:ZV["Cloudy" ZV="CLOUDY"
 s:ZV["Translucent" ZV="BROWN"
 s:ZV["Foul" ZV="FOUL"
 s:ZV["not detected in urine" ZV="NEG"
 s:ZV["Finding of bilirubin in urine" ZV="1+"
 i ZV["trace" S ZV="TRACE"
 Q
 ;
INITMAPS(LOC) ; initialize mapping table for panels
 ;
 ; This routine is called by INITMAPS^SYNQLDM - don't run it directly
 ;
 N MAP
 ; vistapanel
 S MAP="vistapanel"
 ; Panel type is: 24321-2 Basic metabolic 2000 panel - Serum or Plasma
 S @LOC@(MAP,"CODE","24321-2","BASIC METABOLIC PANEL")=""
 ; Panel type is: 51990-0 Basic metabolic panel - Blood
 S @LOC@(MAP,"CODE","51990-0","BASIC METABOLIC PANEL")=""
 ; Panel type is: 24357-6 Urinalysis macro (dipstick) panel - Urine
 S @LOC@(MAP,"CODE","24357-6","URINALYSIS")=""
 ; Panel type is: 24356-8 Urinalysis complete panel - Urine
 S @LOC@(MAP,"CODE","24356-8","URINALYSIS")=""
 ; Panel type is: 57698-3 Lipid panel with direct LDL - Serum or Plasma
 S @LOC@(MAP,"CODE","57698-3","LIPID PROFILE")=""
 ; Panel type is: 58410-2 CBC panel - Blood by Automated count
 S @LOC@(MAP,"CODE","58410-2","CBC")=""
 ; Panel type is: 24323-8 Comprehensive metabolic 2000 panel - Serum or Plasma
 S @LOC@(MAP,"CODE","24323-8","CMP")=""
 ; Panel type is: 50190-8 Iron and Iron binding capacity panel - Serum or Plasma
 S @LOC@(MAP,"CODE","50190-8","IRON GROUP")=""
 ; Panel type is: 75689-0 Iron panel - Serum or Plasma
 ;S @LOC@(MAP,"CODE","75689-0","IRON GROUP")=""
 ; Panel type is:  89577-1 Troponin I.cardiac panel - Serum or Plasma by High sensitivity method
 ;S @LOC@(MAP,"CODE","89577-1","TROPONIN")=""
 ; Panel type is:  34528-0 PT panel - Platelet poor plasma by Coagulation assay
 S @LOC@(MAP,"CODE","34528-0","COAG PROFILE")=""
 ; CBC W Differential panel, method unspecified - Blood (69742-5) -> CBC
 S @LOC@(MAP,"CODE","69742-5","CBC")=""
 ; Auto Differential panel - Blood (57023-4) -> DIFFERENTIAL COUNT
 S @LOC@(MAP,"CODE","57023-4","DIFFERENTIAL COUNT")=""
 ; Gas panel - Venous blood (24339-4) -> BLOOD GASES
 S @LOC@(MAP,"CODE","24339-4","BLOOD GASES")=""
 ;
 Q
 ;
fail(jlog,eval,zrien,zmsg) ; standard way to mark a lab as failed and increment error count
 ;
 s @eval@("panels",zrien,"status","loadstatus")="readyToLoad"
 d log(jlog,zmsg)
 i '$d(@eval@("panels","status","errors")) s @eval@("panels","status","errors")=0
 s @eval@("panels","status","errors")=@eval@("panels","status","errors")+1
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
 ;
testall ; run the panels import on all imported patients
 new root s root=$$setroot^SYNWD("fhir-intake")
 new indx s indx=$na(@root@("POS","DFN"))
 n dfn,ien,filter,reslt
 s dfn=0
 n cnt s cnt=0
 f  s dfn=$o(@indx@(dfn)) q:+dfn=0  q:cnt>0  d  ;
 . s ien=$o(@indx@(dfn,""))
 . s ien=196
 . w !,"ien= "_ien
 . q:ien=""
 . s cnt=cnt+1
 . s filter("dfn")=dfn
 . s filter("load")=1
 . s filter("debug")=1
 . k reslt
 . d wsIntakePanels(.filter,,.reslt,ien)
 q
 ;
panelsum ; summary of panel tests for patient ien pien
 n root s root=$$setroot^SYNWD("fhir-intake")
 n table
 n zzi s zzi=0
 f  s zzi=$o(@root@(zzi)) q:+zzi=0  d  ;
 . n panels
 . d getIntakeFhir^SYNFHIR("panels",,"DiagnosticReport",zzi,1)
 . n zi s zi=0
 . f  s zi=$o(panels("entry",zi)) q:+zi=0  d  ;
 . . n groot s groot=$na(panels("entry",zi,"resource"))
 . . i $g(@groot@("category",1,"coding",1,"code"))'="LAB" q  ;
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
