SYNFPAN ;ven/gpl - fhir loader utilities ;2018-05-08  4:23 PM
 ;;0.3;VISTA SYNTHETIC DATA LOADER;;Dec 27, 2024;Build 12
 ;
 ; Authored by George P. Lilly 2017-2025
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
 s rtn("panelStatus","status")=$g(grtn("status","status"))
 s rtn("panelStatus","loaded")=$g(grtn("status","loaded"))
 s rtn("panelStatus","errors")=$g(grtn("status","errors"))
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
 . ;k @jlog
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
 . . s @eval@("panels","status","errors")=$g(@eval@("panels","status","errors"))+1
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
 . d log(jlog,"Collection sample is: "_CSAMP)
 . s MISC("COLLECTION_SAMPLE")=CSAMP
 . ;
 . ;  ; add code to process DiagnosticReport results here
 . ;
 . n triples s triples=$na(@root@(ien))
 . n atomptr s atomptr=$na(@json@("entry",SYNZI,"resource","result"))
 . n atomdisp s atomdisp=""
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
 . . D ONELAB(.MISC,json,rien,zj,jlog,eval,lablog)
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
 . . d log(jlog,"Return from LAB^ISIIMP12 was: "_$g(RESTA))
 . . ;i $g(DEBUG)=1 ZWRITE RESTA
 . . ;i $g(DEBUG)=1 ZWRITE RC
 . . if +RESTA=1 do  ;
 . . . s @eval@("panels","status","loaded")=$g(@eval@("panels","status","loaded"))+1
 . . . s @eval@("panels",SYNZI,"status","loadstatus")="loaded"
 . . else  s @eval@("panels","status","errors")=$g(@eval@("panels","status","errors"))+1
 ;
 if $get(args("debug"))=1 do  ;
 . m jrslt("source")=@json
 . m jrslt("args")=args
 . m jrslt("eval")=@eval
 m jrslt("labsStatus")=@eval@("labsStatus")
 set jrslt("result","status")="ok"
 set jrslt("result","loaded")=$g(@eval@("panels","status","loaded"))
 set jrslt("result","errors")=$g(@eval@("labs","status","errors"))
 m result("status")=jrslt("result")
 q:$Q 0 Q
 ;
ONELAB(MISCARY,json,ien,zj,jlog,eval,lablog)
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
 . d ADJUST(.value)
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
 d log(lablog,"Return from LAB^ISIIMP12 was: 1^Part of a Lab Panel "_SYNZI)
 s @eval@("labs",ien,"status","loadstatus")="loaded"
 s @eval@("labs","status","loaded")=$g(@eval@("labs","status","loaded"))+1
 Q
 ;
ADJUST(ZV) ; adjust the value for specific text based values
 ;
 s:ZV["Brown" ZV="BROWN"
 s:ZV["Redish" ZV="REDISH"
 s:ZV["Cloudy" ZV="CLOUDY"
 s:ZV["Translucent" ZV="BROWN"
 s:ZV["Foul" ZV="FOUL"
 s:ZV["not detected in urine" ZV="NEG"
 s:ZV["Finding of bilirubin in urine" ZV="1+"
 i ZV["trace" S ZV="TRACE"
 i ZV["++++" S ZV="4+" Q
 i ZV["+++"  S ZV="3+" Q
 i ZV["++"   S ZV="2+" Q
 i ZV["+"    S ZV="1+" Q
 I $G(DEBUG2) W !,"ZV= ",ZV
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
 ;  Panel type is: 51990-0 Basic metabolic panel - Blood
 S @LOC@(MAP,"CODE","51990-0","BASIC METABOLIC PANEL")=""
 ; Panel type is: 24357-6 Urinalysis macro (dipstick) panel - Urine
 S @LOC@(MAP,"CODE","24357-6","URINALYSIS")=""
 ; Panel type is: 57698-3 Lipid panel with direct LDL - Serum or Plasma
 S @LOC@(MAP,"CODE","57698-3","LIPID PROFILE")=""
 ; Panel type is: 58410-2 CBC panel - Blood by Automated count
 S @LOC@(MAP,"CODE","58410-2","CBC")=""
 ; 
 Q
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
testall ; run the panels import on all imported patients
 new root s root=$$setroot^SYNWD("fhir-intake")
 new indx s indx=$na(@root@("POS","DFN"))
 n dfn,ien,filter,reslt
 s dfn=0
 n cnt s cnt=0
 f  s dfn=$o(@indx@(dfn)) q:+dfn=0  q:cnt>0  d  ;
 . s ien=$o(@indx@(dfn,""))
 . s ien=9
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
