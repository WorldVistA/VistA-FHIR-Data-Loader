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
 . k @eval
 ; todo: locate the patient and add the labs in BODY to the graph
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
 . ; insure that the resourceType is DiagnosticReports
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
 . q:catcode'["LAB"
 . new obstype,obsdisplay,loinc s (obstype,obsdisplay,loinc)=""
 . if obstype="" do  ; category is missing, try mapping the code
 . . new trycode,trydisp,tryy
 . . set trycode=$g(@json@("entry",SYNZI,"resource","code","coding",1,"code"))
 . . set loinc=trycode
 . . set trydisp=$g(@json@("entry",SYNZI,"resource","code","coding",1,"display"))
 . . ;b
 . . ;s tryy=$$loinc2sct(trycode)
 . . ;if tryy="" d  quit  ;
 . . ;. d log(jlog,"Cannot determin DiagnosticReport Category ; code is: "_trycode_" "_trydisp)
 . . ;if tryy'="" set obstype="panel"
 . . if trydisp["panel" d  ;
 . . . s obstype="panel"
 . . . s obsdisplay=trycode_"^"_trydisp
 . . e  s obstype=obsdisplay
 . . ;d log(jlog,"Derived category is "_obstype)
 . ;
 . if obstype'="panel" do  quit  ;
 . . ;set @eval@("panels",SYNZI,"vars","observationCategory")=obsdisplay
 . . ;do log(jlog,"DiagnosticReport Category is not panel, skipping")
 . set @eval@("panels",SYNZI,"vars","observationCategory")=obsdisplay
 . set @eval@("panels",SYNZI,"vars","resourceType")=type
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
 . ;do log(jlog,"Panel type is: "_paneltype)
 . do log(jlog,"Panel type is: "_obsdisplay)
 . set @eval@("panels",SYNZI,"vars","type")=obsdisplay
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
 . n rien s rien=""
 . n zj s zj=0
 . f  s zj=$o(@atomptr@(zj)) q:+zj=0  d  ;
 . . n atomdisp s atomdisp=$get(@atomptr@(zj,"display"))
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
 . . if +$g(RESTA)=1 do  ;
 . . . s @eval@("panels","status","loaded")=$g(@eval@("panels","status","loaded"))+1
 . . . s @eval@("panels",SYNZI,"status","loadstatus")="loaded"
 . . else  s @eval@("panels","status","errors")=$g(@eval@("panels","status","errors"))+1
 . ;b
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
 q 0
 ;
ONELAB(MISCARY,json,ien,zj,jlog,eval,lablog)
 ;
 d  ;
 . new obscode set obscode=$get(@json@("entry",ien,"resource","code","coding",1,"code"))
 . do log(lablog,"result "_zj_" code is: "_obscode)
 . do log(jlog,"result "_zj_" code is: "_obscode)
 . set @eval@("labs",SYNZI,"vars",zj_" code")=obscode
 . ;
 . ;
 . new codesystem set codesystem=$get(@json@("entry",ien,"resource","code","coding",1,"system"))
 . do log(jlog,"result "_zj_" code system is: "_codesystem)
 . do log(lablog,"result "_zj_" code system is: "_codesystem)
 . set @eval@("labs",SYNZI,"vars",zj_" codeSystem")=codesystem
 . ;
 . ; determine the value and units
 . ;
 . new value set value=$get(@json@("entry",ien,"resource","valueQuantity","value"))
 . if value="" d  ;
 . . new sctcode,scttxt
 . . s sctcode=$get(@json@("entry",ien,"resource","valueCodeableConcept","coding",1,"code"))
 . . s scttxt=$get(@json@("entry",ien,"resource","valueCodeableConcept","coding",1,"display"))
 . . s value=sctcode_"^"_scttxt
 . . d ADJUST(.value)
 . do log(jlog,"result "_zj_" value is: "_value)
 . do log(lablog,"result "_zj_" value is: "_value)
 . set @eval@("labs",SYNZI,"vars",zj_" value")=value
 . ;
 . ;new unit set unit=$get(@json@("entry",SYNZI,"resource","valueQuantity","unit"))
 . ;do log(jlog,"units are: "_unit)
 . ;set @eval@("labs",SYNZI,"vars","units")=unit
 . ;
 . ; add to MISCARY
 . ;
 . n VLAB ; VistA lab name
 . s VLAB=$$MAP^SYNQLDM(obscode,"labs")
 . i VLAB="" d  quit
 . . do log(jlog,"result "_zj_" VistA Lab not found for loinc="_obscode)
 . . do log(lablog,"result "_zj_" VistA Lab not found for loinc="_obscode)
 . d log(jlog,"result "_zj_" VistA Lab for "_obscode_" is: "_VLAB)
 . d log(lablog,"result "_zj_" VistA Lab for "_obscode_" is: "_VLAB)
 . i $l(value)<12 s MISCARY("LAB_TEST",VLAB)=value
 . ;
 . d log(lablog,"Return from LAB^ISIIMP12 was: 1^Part of a Lab Panel "_SYNZI)
 . s @eval@("labs",ien,"status","loadstatus")="loaded"
 . s @eval@("labs","status","loaded")=$g(@eval@("labs","status","loaded"))+1
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
 Q
 ;
MISC()
 do  ;
 . ;
 . ; determine the effective date
 . ;
 . new effdate set effdate=$get(@json@("entry",SYNZI,"resource","effectiveDateTime"))
 . do log(jlog,"effectiveDateTime is: "_effdate)
 . set @eval@("labs",SYNZI,"vars","effectiveDateTime")=effdate
 . new fmtime s fmtime=$$fhirTfm^SYNFUTL(effdate)
 . d log(jlog,"fileman dateTime is: "_fmtime)
 . set @eval@("labs",SYNZI,"vars","fmDateTime")=fmtime ;
 . new hl7time s hl7time=$$fhirThl7^SYNFUTL(effdate)
 . d log(jlog,"hl7 dateTime is: "_hl7time)
 . set @eval@("labs",SYNZI,"vars","hl7DateTime")=hl7time ;
 . ;
 . ; set up to call the data loader
 . ;
 . n RETSTA,DHPPAT,DHPSCT,DHPOBS,DHPUNT,DHPDTM,DHPPROV,DHPLOC,DHPLOINC
 . ;
 . s DHPPAT=$$dfn2icn^SYNFUTL(dfn)
 . s @eval@("labs",SYNZI,"parms","DHPPAT")=DHPPAT
 . ;
 . ;n vistalab s vistalab=$$MAP^SYNQLDM(obscode)
 . s DHPLOINC=obscode
 . d log(jlog,"LOINC code is: "_DHPLOINC)
 . s @eval@("labs",SYNZI,"parms","DHPLOINC")=DHPLOINC
 . ;
 . n vistalab s vistalab=$$graphmap^SYNGRAPH("loinc-lab-map",obscode)
 . i +vistalab=-1 s vistalab=$$graphmap^SYNGRAPH("loinc-lab-map"," "_obscode)
 . i +vistalab=-1 s vistalab=$$covid^SYNGRAPH(obscode)
 . i +vistalab'=-1 d
 .. d log(jlog,"Lab found in graph: "_vistalab)
 .. s @eval@("labs",SYNZI,"parms","vistalab")=vistalab
 . if +vistalab=-1 s vistalab=labtype
 . s vistalab=$$TRIM^XLFSTR(vistalab) ; get rid of trailing blanks
 . ;n sct s sct=$$loinc2sct(obscode) ; find the snomed code
 . ;i vistalab="" d  quit
 . ;. d log(jlog,"VistA lab not found for loinc code: "_obscode_" "_labtype_" -- skipping")
 . ;. s @eval@("labs",SYNZI,"status","loadstatus")="cannotLoad"
 . ;. s @eval@("labs",SYNZI,"status","issue")="VistA lab not found for loinc code: "_obscode_" "_labtype_" -- skipping"
 . ;. s @eval@("status","errors")=$g(@eval@("status","errors"))+1
 . s @eval@("labs",SYNZI,"parms","DHPLAB")=vistalab
 . d log(jlog,"VistA Lab is: "_vistalab)
 . s DHPLAB=vistalab
 . ;
 . s DHPOBS=value
 . s recien=$o(^LAB(60,"B",DHPLAB,""))
 . i recien="" d  ; oops lab test not found!!
 . . S DHPLAB=$$UP^XLFSTR(DHPLAB)
 . . s vistalab=DHPLAB
 . . s recien=$o(^LAB(60,"B",DHPLAB,""))
 . . d log(jlog,"VistA Lab is: "_vistalab)
 . ;
 . ; the following was made obsolete by changes Sam made to the Lab Data Import
 . ;n xform s xform=$$GET1^DIQ(60,recien_",",410)
 . ;n dec s dec=0
 . ;i xform["S Q9=" d
 . ;. s dec=+$p($p(xform,"""",2),",",3)
 . ;;i $l($p(DHPOBS,".",2))>1 d
 . ;i $l($p(DHPOBS,".",2))>0 d
 . ;. s DHPOBS=$s(dec<4:$j(DHPOBS,1,dec),dec>3:$j(DHPOBS,1,3),1:$j(DHPOBS,1,0)) ; fix results with too many decimal places
 . ; added for Covid tests
 . i DHPOBS="" d  ; no quant value
 . . n vtxt ; value text
 . . s vtxt=$get(@json@("entry",SYNZI,"resource","valueCodeableConcept","text"))
 . . ;i vtxt["Negative" s DHPOBS="Negative" ; 260385009
 . . i vtxt["Negative" s DHPOBS="Not Detected" ; 260385009
 . . ;i vtxt["Positive" s DHPOBS="Positive" ; 10828004
 . . i vtxt["Positive" s DHPOBS="DETECTED" ; 10828004
 . . i vtxt["Detected" s DHPOBS="DETECTED" ; 260373001
 . . i vtxt["Not detected" s DHPOBS="Not Detected" ; 260415000
 . . i vtxt["Confirmed" s DHPOBS="CONFIRMED" ; 
 . s @eval@("labs",SYNZI,"parms","DHPOBS")=DHPOBS
 . d log(jlog,"Value is: "_DHPOBS)
 . ;
 . i DHPLOINC="33914-3" d  q  ;
 . . d log(jlog,"Skipping Estimated Glomerular Filtration Rate LOINC: 33914-3")
 . ;
 . s DHPUNT=unit
 . s @eval@("labs",SYNZI,"parms","DHPUNT")=unit
 . d log(jlog,"Units are: "_unit)
 . ;
 . s DHPDTM=hl7time
 . s @eval@("labs",SYNZI,"parms","DHPDTM")=hl7time
 . d log(jlog,"HL7 DateTime is: "_hl7time)
 . ;
 . s DHPPROV=$$MAP^SYNQLDM("OP","provider")
 . n DHPPROVIEN s DHPPROVIEN=$o(^VA(200,"B",DHPPROV,""))
 . if DHPPROVIEN="" S DHPPROVIEN=3
 . s @eval@("labs",SYNZI,"parms","DHPPROV")=DHPPROVIEN
 . d log(jlog,"Provider for outpatient is: #"_DHPPROVIEN_" "_DHPPROV)
 . ;
 . s DHPLOC=$$MAP^SYNQLDM("OP","location")
 . n DHPLOCIEN s DHPLOCIEN=$o(^SC("B",DHPLOC,""))
 . if DHPLOCIEN="" S DHPLOCIEN=4
 . s @eval@("labs",SYNZI,"parms","DHPLOC")=DHPLOC
 . d log(jlog,"Location for outpatient is: #"_DHPLOCIEN_" "_DHPLOC)
 . ;
 . s @eval@("labs",SYNZI,"status","loadstatus")="readyToLoad"
 . ;
 . ;i vistalab="PDW" q  ; skipping because it hangs - gpl wvehr 1/7/21
 . ;i vistalab="SGPT" q  ; skipping it hangs loinc 1742-6 - gpl wvehr 1/7/21
 . ;i vistalab="INFLUENZA A RNA" Q  ; likewise
 . ;i vistalab="INFLUENZA B RNA" Q  ; likewise
 . ;i vistalab="METAPNEUMOVIRUS RNA" Q  ; likewise
 . ;
 q 0
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
 . s ien=4
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
