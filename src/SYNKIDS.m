SYNKIDS ; OSE/SMH - Synthea Installer ; May 2 2019
 ;;0.2;VISTA SYN DATA LOADER;;Feb 07, 2019;Build 2
 ;
 ; WARNING: THIS ROUTINE IS A BAD EXAMPLE FOR ANYBODY TRYING TO WRITE GOOD CODE.
 ; I SHOUDLN'T BE DOING HALF OF THE THINGS HERE, BUT I HAVE NO CHOICE RIGHT NOW.
 ;
 ; --SAM
 ;
ENV ; [Fallthrough]
 QUIT
 ;
CACHE() Q $L($SY,",")'=2
GTM()   Q $P($SY,",")=47
 ;
TRAN ; [KIDS] - Transport from source system (BAD! SHOULD BE A FILEMAN FILE)
 M @XPDGREF@("SYN")=^SYN
 N I F I=200000000-1:0  S I=$O(^ICPT(I)) Q:'I  M @XPDGREF@("OS5",81,I)=^ICPT(I)
 N LEXF F LEXF=757,757.001,757.01,757.02,757.1,757.21 DO
 . N I F I=3000000000-1:0 S I=$O(^LEX(LEXF,I)) Q:'I  M @XPDGREF@("OS5",LEXF,I)=^LEX(LEXF,I)
 n mapRoot s mapRoot=$$setroot^SYNWD("loinc-lab-map")
 M @XPDGREF@("loinc-lab-map")=@mapRoot
 QUIT
 ;
PRE ; [KIDS] - Pre Install -- all for Cache
 ;D CACHEMAP("%web")
 ;D CACHEMAP("SYNWD")
 ;D CACHETLS
 QUIT
 ;
POST ; [KIDS] - Post Install
 ;DO POSTRO
 ;DO POSTWWW
 DO POSTSYN
 DO POSTINTRO
 DO POSTMAP
 QUIT
 ;
POSTMAP ; [Private] Add loinc-lab-map to the graph store
 new root set root=$$setroot^SYNWD("loinc-lab-map")
 kill @root
 merge @root=@XPDGREF@("loinc-lab-map")
 new rindx set rindx=$name(@root@("graph","map"))
 set @root@("index","root")=rindx
 do index^SYNGRAPH(rindx)
 quit
 ;
POSTSYN ; [Private] Restore SYN global
 ; Resore data from saved global
 ; Next line makes this safe to run in dev mode
 D MES^XPDUTL("Merging ^SYN global in. This takes time...")
 I $D(XPDGREF)#2,$D(@XPDGREF@("SYN")) D
 . K ^SYN("2002.030","sct2icd"),^("sct2icdnine"),^("sct2os5") ; **NAKED**
 . M ^SYN=@XPDGREF@("SYN")
 ;
 ; Install OS5 codes
 I $D(XPDGREF)#2,$D(@XPDGREF@("OS5")) D
 . N SYNF F SYNF=81,757,757.001,757.01,757.02,757.1,757.21 DO  ; for each file
 .. N SYNCR S SYNCR=$$ROOT^DILFD(SYNF,,1) ; closed reference
 .. N SYNOR S SYNOR=$$ROOT^DILFD(SYNF)    ; open reference
 .. N SYNI F SYNI=0:0 S SYNI=$O(@XPDGREF@("OS5",SYNF,SYNI)) Q:'SYNI  D  ; for each entry
 ... ;
 ... ; Delete old data
 ... N DA,DIK S DA=SYNI,DIK=SYNOR D ^DIK
 ... ;
 ... ; Add new data
 ... M @SYNCR@(SYNI)=@XPDGREF@("OS5",SYNF,SYNI)
 ... N DA,DIK S DA=SYNI,DIK=SYNOR D IX1^DIK
 ;
 ; Initialize Synthea
 D ^SYNINIT
 QUIT
 ;
POSTRO ; [Private] Download and Import RO Files
 D MES^XPDUTL("Downloading MASH...")
 D INSTALLRO("https://github.com/OSEHRA/VistA-FHIR-Data-Loader/releases/download/0.2/mash-graph-1p0.rsa")
 D MES^XPDUTL("Downloading MWS...")
 D INSTALLRO("https://github.com/shabiel/M-Web-Server/releases/download/1.0.4/webinit.rsa")
 D INSTALLRO("https://github.com/shabiel/M-Web-Server/releases/download/1.0.4/mws.rsa")
 QUIT
 ;
POSTWWW ; [Private] Initialize MWS
 do ^%webINIT
 do LOADHAND^webinit
 D MES^XPDUTL("Trying to open a port for the web server...")
 N PORT F PORT=9080:1 D MES^XPDUTL("Trying "_PORT) Q:$$PORTOK^webinit(PORT)
 do job^%webreq(PORT)
 N SERVER S SERVER="http://localhost:"_PORT_"/"
 D MES^XPDUTL("")
 D MES^XPDUTL("Mumps Web Services is now listening to port "_PORT)
 D MES^XPDUTL("Visit "_SERVER_" to see the home page.")
 D MES^XPDUTL("Also, try the sample web services...")
 D MES^XPDUTL(" - "_SERVER_"xml")
 D MES^XPDUTL(" - "_SERVER_"ping")
 QUIT
 ;
POSTINTRO ; [Private] Append Users to Intro Text
 N L S L=$O(^XTV(8989.3,1,"INTRO"," "),-1)+1
 I $G(^XTV(8989.3,1,"INTRO",L-1,0))["SYNPHARM123!!" QUIT  ; don't add again
 S ^XTV(8989.3,1,"INTRO",L,0)=" "
 S L=L+1
 S ^XTV(8989.3,1,"INTRO",L,0)=" SYN USER      ACCESS CODE       VERIFY CODE         ELECTRONIC SIGNATURE"
 S L=L+1
 S ^XTV(8989.3,1,"INTRO",L,0)=" --------      -----------       -----------         --------------------"
 S L=L+1
 S ^XTV(8989.3,1,"INTRO",L,0)=" PROVIDER,UNK  SYNPROV123        SYNPROV123!!        123456"
 S L=L+1
 S ^XTV(8989.3,1,"INTRO",L,0)=" PHARMACIST,U  SYNPHARM123       SYNPHARM123!!       123456"
 ;
 S $P(^XTV(8989.3,1,"INTRO",0),U,3,4)=L_U_L
 ;
 QUIT
 ;
INSTALLRO(URL) ; [Private] Download and Install RO files
 ; Get current directory (GT.M may need it to write routines later)
 N PWD S PWD=$$PWD()
 ;
 ; Change to temporary directory (a bit complex for Windows)
 D CDTMPDIR
 ;
 ; Get temp dir
 N TMPDIR S TMPDIR=$$PWD()
 ;
 ; Download the files from Github into temp directory
 D DOWNLOAD(URL)
 ;
 ; Go back to the old directory
 D CD(PWD)
 ;
 ; Silently install RSA -- fur GT.M pass the GTM directory in case we need it.
 new filename set filename=$p(URL,"/",$l(URL,"/"))
 I $$CACHE DO RICACHE(TMPDIR_filename)
 I $$GTM DO RIGTM(TMPDIR_filename,,PWD)
 QUIT
 ;
PWD() ; $$ - Get current directory
 Q:$$CACHE $ZU(168)
 Q:$$GTM $ZD
 S $EC=",U-NOT-IMPLEMENTED,"
 QUIT
 ;
CDTMPDIR ; Proc - Change to temporary directory
 I $$GTM S $ZD="/tmp/" QUIT  ; GT.M
 I $$CACHE S %=$ZU(168,^%SYS("TempDir")) QUIT  ; Cache
 S $EC=",U-NOT-IMPLEMENTED,"
 QUIT
 ;
CD(DIR) ; Proc - Change to the old directory
 I $$CACHE N % S %=$ZU(168,DIR) QUIT
 I $$GTM S $ZD=DIR QUIT
 QUIT
 ;
CACHEMAP(G) ; Map Globals and Routines away from %SYS in Cache
 ; ZEXCEPT: AddGlobalMapping,Class,Config,Configuration,Create,Get,GetErrorText,GetGlobalMapping,MapRoutines,MapGlobals,Namespaces,Status,class - these are all part of Cache class names
 ; Get current namespace
 I $$GTM QUIT
 ;
 S G=G_"*"
 N NMSP
 I $P($P($ZV,") ",2),"(")<2012 S NMSP=$ZU(5)
 I $P($P($ZV,") ",2),"(")>2011 S NMSP=$NAMESPACE
 ;
 N $ET S $ET="ZN NMSP D ^%ZTER S $EC="""""
 ;
 ZN "%SYS" ; Go to SYS
 ;
 ; Props
 N PROP
 N % S %=##Class(Config.Namespaces).Get(NMSP,.PROP) ; Get all namespace properties
 I '% W !,"Error="_$SYSTEM.Status.GetErrorText(%) S $EC=",U-CONFIG-FAIL," QUIT
 ;
 N DBG S DBG=PROP("Globals")  ; get the database globals location
 N DBR S DBR=PROP("Routines") ; get the database routines location
 ;
 ; the following is needed for the call to MapGlobals.Create below, is not set in above call
 S PROP("Database")=NMSP
 ;
 ; Map %ut globals away from %SYS
 N %
 S %=##class(Config.Configuration).GetGlobalMapping(NMSP,G,"",DBG,DBG)
 I '% S %=##class(Config.Configuration).AddGlobalMapping(NMSP,G,"",DBG,DBG)
 I '% W !,"Error="_$SYSTEM.Status.GetErrorText(%) S $EC=",U-CONFIG-FAIL," QUIT
 ;
 ; Map %ut routines away from %SYS
 N PROPRTN S PROPRTN("Database")=DBR
 N % S %=##Class(Config.MapRoutines).Get(NMSP,G,.PROPRTN)
 S PROPRTN("Database")=DBR  ; Cache seems to like deleting this
 I '% S %=##Class(Config.MapRoutines).Create(NMSP,G,.PROPRTN)
 I '% W !,"Error="_$SYSTEM.Status.GetErrorText(%) S $EC=",U-CONFIG-FAIL," QUIT
 ZN NMSP ; Go back
 QUIT
 ;
CACHETLS ; Create a client SSL/TLS config on Cache
 I $$GTM QUIT
 ;
 ; Create the configuration
 N $NAMESPACE S $NAMESPACE="%SYS"
 n config,status
 n % s %=##class(Security.SSLConfigs).Exists("encrypt_only",.config,.status) ; check if config exists
 i '% d
 . n prop s prop("Name")="encrypt_only"
 . s %=##class(Security.SSLConfigs).Create("encrypt_only",.prop) ; create a default ssl config
 . i '% w $SYSTEM.Status.GetErrorText(%) s $ec=",u-cache-error,"
 . s %=##class(Security.SSLConfigs).Exists("encrypt_only",.config,.status) ; get config
 e  s %=config.Activate()
 ;
 ; Test it by connecting to encrypted.google.com
 n rtn
 d config.TestConnection("encrypted.google.com",443,.rtn)
 i rtn w "TLS/SSL client configured on Cache as config name 'encrypt_only'",!
 e  w "Cannot configure TLS/SSL on Cache",! s $ec=",u-cache-error,"
 QUIT
 ;
DOWNLOAD(URL) ; Download the files from Github
 D:$$CACHE DOWNCACH(URL)
 D:$$GTM DOWNGTM(URL)
 QUIT
 ;
DOWNCACH(URL) ; Download for Cache
 ; Download and save
 set httprequest=##class(%Net.HttpRequest).%New()
 if $e(URL,1,5)="https" do
 . set httprequest.Https=1
 . set httprequest.SSLConfiguration="encrypt_only"
 new server set server=$p(URL,"://",2),server=$p(server,"/")
 new port set port=$p(server,":",2)
 new filepath set filepath=$p(URL,"://",2),filepath=$p(filepath,"/",2,99)
 new filename set filename=$p(filepath,"/",$l(filepath,"/"))
 set httprequest.Server=server
 if port set httprequest.Port=port
 set httprequest.Timeout=5
 new status set status=httprequest.Get(filepath)
 new response set response=httprequest.HttpResponse.Data
 new sysfile set sysfile=##class(%Stream.FileBinary).%New()
 set status=sysfile.FilenameSet(filename)
 set status=sysfile.CopyFromAndSave(response)
 set status=sysfile.%Close()
 QUIT
 ;
DOWNGTM(URL) ; Download for GT.M
 N CMD S CMD="curl -s -L -O "_URL
 O "pipe":(shell="/bin/sh":command=CMD)::"pipe"
 U "pipe" C "pipe"
 QUIT
 ;
RIGTM(ROPATH,FF,GTMDIR) ; Silent Routine Input for GT.M
 ; ROPATH = full path to routine archive
 ; FF = Form Feed 1 = Yes 0 = No. Optional.
 ; GTMDIR = GTM directory in case gtmroutines is relative to current dir
 ;
 ; Check inputs
 I $ZPARSE(ROPATH)="" S $EC=",U-NO-SUCH-FILE,"
 S FF=$G(FF,0)
 ;
 ; Convert line endings from that other Mumps
 O "pipe":(shell="/bin/sh":command="perl -pi -e 's/\r\n?/\n/g' "_ROPATH:parse)::"pipe"
 U "pipe" C "pipe"
 ;
 ; Set end of routine
 N EOR
 I FF S EOR=$C(13,12)
 E  S EOR=""
 ;
 ; Get output directory
 N D D PARSEZRO(.D,$ZROUTINES)
 N OUTDIR S OUTDIR=$$ZRO1ST(.D)
 ;
 ; If output directory is relative, append GTM directory to it.
 I $E(OUTDIR)'="/" S OUTDIR=GTMDIR_OUTDIR
 ;
 ; Open use RO/RSA
 O ROPATH:(readonly:block=2048:record=2044:rewind):0 E  S $EC=",U-ERR-OPEN-FILE,"
 U ROPATH
 ;
 ; Discard first two lines
 N X,Y R X:0,Y:0
 ;
 F  D  Q:$ZEOF
 . ; Read routine info line
 . N RTNINFO R RTNINFO:0
 . Q:$ZEOF
 . ;
 . ; Routine Name is 1st piece
 . N RTNNAME S RTNNAME=$P(RTNINFO,"^")
 . ;
 . ; Check routine name
 . I RTNNAME="" QUIT
 . I RTNNAME'?1(1"%",1A).99AN S $EC=",U-INVALID-ROUTINE-NAME,"
 . ;
 . ; Path to save routine, and save
 . N SAVEPATH S SAVEPATH=OUTDIR_$TR(RTNNAME,"%","_")_".m"
 . O SAVEPATH:(newversion:noreadonly:blocksize=2048:recordsize=2044)
 . F  U ROPATH R Y:0 Q:Y=EOR  Q:$ZEOF  U SAVEPATH W $S(Y="":" ",1:Y),!
 . C SAVEPATH
 . ZL $TR(RTNNAME,"%","_"):"-nowarning"
 ;
 C ROPATH
 ;
 QUIT  ; Done
 ;
PARSEZRO(DIRS,ZRO) ; Parse $zroutines properly into an array
 ; Eat spaces
 F  Q:($E(ZRO)'=" ")  S ZRO=$E(ZRO,2,999)
 ;
 N PIECE
 N I
 F I=1:1:$L(ZRO," ") S PIECE(I)=$P(ZRO," ",I)
 N CNT S CNT=1
 F I=0:0 S I=$O(PIECE(I)) Q:'I  D
 . S DIRS(CNT)=$G(DIRS(CNT))_PIECE(I)
 . I DIRS(CNT)["("&(DIRS(CNT)[")") S CNT=CNT+1 QUIT
 . I DIRS(CNT)'["("&(DIRS(CNT)'[")") S CNT=CNT+1 QUIT
 . S DIRS(CNT)=DIRS(CNT)_" " ; prep for next piece
 QUIT
 ;
ZRO1ST(DIRS) ; $$ Get first routine directory
 ; TODO: Deal with .so.
 N OUT ; $$ return
 N %1 S %1=DIRS(1) ; 1st directory
 ; Parse with (...)
 I %1["(" DO
 . S OUT=$P(%1,"(",2)
 . I OUT[" " S OUT=$P(OUT," ")
 . E  S OUT=$P(OUT,")")
 ; no parens
 E  S OUT=%1
 ;
 ; Add trailing slash
 I $E(OUT,$L(OUT))'="/" S OUT=OUT_"/"
 QUIT OUT
 ;
RICACHE(ROPATH) ; Silent Routine Input for Cache
 D $SYSTEM.Process.SetZEOF(1) ; Cache stuff!!
 I $ZSEARCH(ROPATH)="" S $EC=",U-NO-SUCH-FILE,"
 N EOR S EOR=""
 ;
 ; Open using Stream Format (TERMs are CR/LF/FF)
 O ROPATH:("RS"):0 E  S $EC=",U-ERR-OPEN-FILE,"
 U ROPATH
 ;
 ; Discard first two lines
 N X,Y R X:2,Y:2
 ;
 F  D  Q:$ZEOF
 . ; Read routine info line
 . N RTNINFO R RTNINFO:2
 . Q:$ZEOF
 . ;
 . ; Routine Name is 1st piece
 . N RTNNAME S RTNNAME=$P(RTNINFO,"^")
 . ;
 . ; Check routine name
 . I RTNNAME="" QUIT
 . I RTNNAME'?1(1"%",1A).99AN S $EC=",U-INVALID-ROUTINE-NAME,"
 . ;
 . N RTNCODE,L S L=1
 . F  R Y:2 Q:Y=EOR  Q:$ZEOF  S RTNCODE(L)=Y,L=L+1
 . S RTNCODE(0)=L-1 ; required for Cache
 . D ROUTINE^%R(RTNNAME_".INT",.RTNCODE,.ERR,"CS",0)
 ;
 C ROPATH
 ;
 QUIT  ; Done
