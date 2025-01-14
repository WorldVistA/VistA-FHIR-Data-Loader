SYNFHIR2 ;ven/gpl - fhir loader utilities ;2019-05-30  6:02 PM
 ;;0.3;VISTA SYNTHETIC DATA LOADER;;Jul 01, 2019;Build 46
 ;
 ; Authored by George P. Lilly 2017-2025
 ;
 q
 ;
isLoaded(name) ; extrinsic which returns the ien of the patient name, -1 if not found
 ;
 n root s root=$$setroot^SYNWD("fhir-intake")
 n fname,lname,rtn
 s rtn=-1
 if name["_" d  ;
 . s fname=$p(name,"_",1)
 . s lname=$p(name,"_",2)
 . n zname s zname=fname_","_lname
 . i $d(@root@("name",zname)) d
 . . s rtn=$o(@root@("name",zname,""))
 . w !,zname
 q rtn
 ;
SYNFARY(ZFARY,ien) ; INITIALIZE FILE NUMBERS AND OTHER USEFUL THINGS
 ; FOR THE DEFAULT TRIPLE STORE. USE OTHER VALUES FOR SUPPORTING ADDITIONAL
 ; TRIPLE STORES
 I $D(@ZFARY) Q  ; ALREADY INITIALIZED
 ;S @ZFARY@("C0XTFN")=172.101 ; TRIPLES FILE NUMBER
 ;S @ZFARY@("C0XSFN")=172.201 ; TRIPLES STRINGS FILE NUMBER
 N ROOT S ROOT=$$setroot^SYNWD("fhir-intake")
 S @ZFARY@("C0XTN")=$NA(@ROOT@(ien))
 ;S @ZFARY@("C0XTN")=$NA(^C0X(101)) ; TRIPLES GLOBAL NAME
 ;S @ZFARY@("C0XSN")=$NA(^C0X(201)) ; STRING FILE GLOBAL NAME
 ;S @ZFARY@("C0XDIR")="/home/glilly/fmts/trunk/samples/smart-new/"
 S @ZFARY@("C0XDIR")="/tmp/"
 ;S @ZFARY@("BLKLOAD")=1 ; this file supports block load
 S @ZFARY@("BLKLOAD")=0 ; this file does not support block load
 ;S @ZFARY@("FMTSSTYLE")="F2N" ; fileman style
 S @ZFARY@("FMTSSTYLE")="FHIR1" ; fileman style
 S @ZFARY@("REPLYFMT")="JSON"
 D USEFARY^C0XF2N(ZFARY)
 Q
 ;
TEST1()
 ;
 N FHIRARY
 D SYNFARY("FHIRARY",122)
 D triples^C0XGET1(.g,"","rien","","","raw","FHIRARY")
 ZWR g
 q
 ;
PANEL(ien) ;
 ;
 n root s root=$$setroot^SYNWD("fhir-intake")
 n jroot s jroot=$na(@root@(ien,"json"))
 n lroot s lroot=$na(@root@(ien,"load","labs"))
 ;
 n panel,paneltype,panelien,atomurn,atomien
 n atomtype,atomloinc,atomdisp
 ;
 s panel=""
 f  s panel=$o(@root@(ien,"POS","type","DiagnosticReport",panel)) q:panel=""  d  ;
 . w !!,panel
 . s paneltype=$o(@root@(ien,"SPO",panel,"type",""))
 . s panelien=$o(@root@(ien,"SPO",panel,"rien",""))
 . n paneloinc s paneloinc=$g(@jroot@(ien,"resource","code","coding",1,"code"))
 . n paneldisp s paneldisp=$g(@jroot@(ien,"resource","code","coding",1,"display"))
 . i paneldisp="" s paneldisp=$g(@jroot@(ien,"resource","code","text"))
 . ;
 . w !,"panel loinc: ",paneloinc," ",paneldisp
 . w " ",paneltype," ien=",panelien
 . ;zwr @root@(ien,"json","entry",panelien,*)
 . n atomcnt s atomcnt=0
 . s atomurn=""
 . n proot s proot=$na(@root@(ien,"json","entry",panelien,"resource","result"))
 . f  s atomcnt=$o(@proot@(atomcnt)) q:atomcnt=""  d  ;
 . . s atomurn=@proot@(atomcnt,"reference")
 . . s atomdisp=@proot@(atomcnt,"display")
 . . s atomien=$o(@root@(ien,"SPO",atomurn,"rien",""))
 . . w !,atomcnt," ","urn=",atomurn," ",atomdisp
 . . n atomloinc s atomloinc=$g(@root@(ien,"json","entry",atomien,"resource","code","coding",1,"code"))
 . . n atomroot s atomroot=$na(@lroot@(atomien))
 . . n atomstat s atomstat=$g(@lroot@(atomien,"status","loadstatus"))
 . . n atomlog s atomlog=$g(@lroot@(atomien,"log",19))
 . . w !,"loinc: ",atomloinc," ",atomdisp," status: ",atomstat," ",atomlog
 q
 ;
