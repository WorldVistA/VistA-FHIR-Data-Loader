SYNFMED ;OSE/SMH - Add Medications to Patient Record;May 23, 2018
 ;;1.0;SYNTHETIC PATIENTS LOADER;
 ; (C) 2016 Sam Habiel
 ;
RXN2MED(RXN) ; [Public] Get or Create a drug for a specific RxNorm code
 N VUIDS S VUIDS=$$RXN2VUI(RXN)
 I VUIDS="" S $EC=",U-INVESTIGATE-PLEASE,"
 N MEDS S MEDS=$$MATCHVM(VUIDS)
 ;
 I MEDS="" N NEWMED S NEWMED="" D  QUIT NEWMED
 . N OKVUIDS
 . N I,VUID F I=1:1:$L(VUIDS) S VUID=$P(VUIDS,U,I) Q:VUID=""  D
 .. N C0XVUID ; For Searching Compound Index
 .. S C0XVUID(1)=VUID
 .. S C0XVUID(2)=1
 .. N F5068IEN S F5068IEN=$$FIND1^DIC(50.68,"","XQ",.C0XVUID,"AMASTERVUID")
 .. I 'F5068IEN QUIT  ; Try next one if this one isn't master
 .. N NAME S NAME=$P(^PSNDF(50.68,F5068IEN,0),U)
 .. S OKVUIDS(VUID)=NAME[",UD"
 . ;
 . N C S C=0
 . N V S V=""
 . F  S V=$O(OKVUIDS(V)) Q:'V  S C=C+1
 . ;
 . N VUID2USE
 . I C=1 S VUID2USE=$O(OKVUIDS("")) S NEWMED=$$ADDDRUG2(RXN,VUID2USE) QUIT
 . E  N DONE S DONE=0,V="" F  S V=$O(OKVUIDS(V)) Q:'V  D  Q:DONE
 .. I OKVUIDS(V)=1 QUIT
 .. E  S NEWMED=$$ADDDRUG2(RXN,V),DONE=1
 . ;
 . I NEWMED QUIT
 . ;
 . S VUID2USE=$O(OKVUIDS(""))
 . S NEWMED=$$ADDDRUG2(RXN,VUID2USE)
 ;
 I $L(MEDS,U)=1 QUIT MEDS ;
 ;
 ; $L(MEDS,U)>1 ...
 N MED2USE S MED2USE=""
 N I F I=1:1:$L(MEDS,U) D  Q:MED2USE
 . N MED S MED=$P(MEDS,U,I)
 . N NAME S NAME=$P(^PSDRUG(MED,0),U)
 . N INACTIVE S INACTIVE=+$G(^PSDRUG(MED,"I"))
 . I INACTIVE QUIT
 . I NAME["UD" QUIT
 . S MED2USE=MED
 ;
 I MED2USE Q MED2USE
 ;
 S MED2USE=$P(MEDS,U) Q MED2USE
 ;
 QUIT
 ;
RXN2MEDS(RXN) ; [Public] Get Drugs that are associated with an RxNorm
 Q $$MATCHVM($$RXN2VUI(RXN))
 ;
RXN2VUI(RXN) ; [Public] Get ^ delimited VUIDs for an RxNorm
 N VUIDS S VUIDS=""
 n file
 I $T(^ETSRXN)]"" d  quit VUIDS
 . n fileVUIDs s fileVUIDs=$$ETSRXN2VUID(RXN)
 . n i f i=1:1:$l(fileVUIDs,U) do
 .. s file=$p(fileVUIDs,"~")
 .. i file'=50.68 quit
 .. n vuid s vuid=$p(fileVUIDs,"~",2)
 .. s VUIDS=VUIDS_vuid_U
 . i $e(VUIDS,$l(VUIDS))=U S $E(VUIDS,$L(VUIDS))=""
 ;
 ; TODO: Rest is not implemented yet.
 N URL S URL="https://rxnav.nlm.nih.gov/REST/rxcui/{RXN}/property.json?propName=VUID"
 N % S %("{RXN}")=RXN
 S URL=$$REPLACE^XLFSTR(URL,.%)
 N C0CRETURN
 D GET(.C0CRETURN,URL)
 N C0COUT
 D DECODE^XLFJSON($NA(C0CRETURN),$NA(C0COUT))
 N J F J=0:0 S J=$O(C0COUT("propConceptGroup","propConcept",J)) Q:'J  D
 . S VUIDS=VUIDS_C0COUT("propConceptGroup","propConcept",J,"propValue")_U
 S $E(VUIDS,$L(VUIDS))="" ; rm trailing ^
 QUIT VUIDS
 ;
ETSRXN2VUID(RXN) ; [Public] Return delimited list of file~VUID^file~VUID based on ETS
 ; Input: RxNorm Number for IN or CD TTY
 ; Output: file~VUID^file~VUID..., where file is 50.6 or 50.68.
 ;         or -1^vuid-not-found
 ; 
 ; Translate RXN to VUID
 new numVUID set numVUID=+$$RXN2OUT^ETSRXN(RXN)
 if 'numVUID quit:$quit "-1^vuid-not-found" quit
 ;
 ; loop through VUIDs, and grab a good one (CD or IN)
 ; ^TMP("ETSOUT",69531,831533,"VUID",1,0)="296833^831533^VANDF^AB^4031994^N"
 ; ^TMP("ETSOUT",69531,831533,"VUID",1,1)="ERRIN 0.35MG TAB,28"
 new done s done=0
 new out
 new vuid,name
 new type,file
 new i for i=0:0 set i=$o(^TMP("ETSOUT",$J,RXN,"VUID",i)) quit:'i  do  quit:done
 . new node0 set node0=^TMP("ETSOUT",$J,RXN,"VUID",i,0)
 . new node1 set node1=^TMP("ETSOUT",$J,RXN,"VUID",i,1)
 . set type=$p(node0,U,4)
 . if "^CD^IN^"'[(U_type_U) quit
 . ;
 . set vuid=$p(node0,U,5)
 . set file=$s(type="CD":50.68,type="IN":50.6,1:1/0) ; any other type is invalid!
 . set name=node1
 . set out=file_"~"_vuid_"~"_name_U
 if $extract(out,$length(out))=U set $extract(out,$length(out))=""
 quit out
 ;
MATCHVM(VUIDS) ; [Public] Match delimited list of VUIDs to delimited set of drugs (not one to one)
 N MATCHES S MATCHES=""
 N I,VUID
 F I=1:1 S VUID=$P(VUIDS,U,I) Q:VUID=""  D
 . N MATCH S MATCH=$$MATCHV1(VUID)
 . I MATCH S MATCHES=MATCHES_MATCH_U
 S $E(MATCHES,$L(MATCHES))="" ; rm trailing ^
 QUIT MATCHES
 ;
 ;
MATCHV1(VUID) ; [Public] Match a single VUID to a set of drugs.
 N VAP S VAP=$$VUI2VAP(VUID) ; says it's supposed to be plural, but that's not possible??
 I 'VAP S $EC=",U-VUID-SHOULD-NOT-BE-MISSING,"
 N MEDS S MEDS=$$VAP2MED(VAP)
 QUIT MEDS
 ;
VUI2VAP(VUID) ; $$ Public - Get VA Product IEN(s) from VUID
 ; Input VUID by Value
 ; Output: Extrinsic
 D FIND^DIC(50.68,,"@","QP",VUID,,"AVUID") ; Find all in VUID index
 N O S O="" ; Output
 N I F I=0:0 S I=$O(^TMP("DILIST",$J,I)) Q:'I  S O=O_^(I,0)_U ; Concat results together
 S O=$E(O,1,$L(O)-1) ; remove trailing ^
 Q O
 ;
VAP2MED(VAPROD) ; $$ Public - Get Drug(s) using VA Product IEN
 ; Un-Unit-testable: Drug files differ between sites.
 ; Input: VA Product IEN By Value
 ; OUtput: Caret delimited extrinsic
 ; This code inspired from PSNAPIs
 ; WHY THE HELL WOULD I USE A TEXT INDEX?
 ; It's my only option. Creating new xrefs on the drug file doesn't help
 ; as they are not filled out when adding a drug (IX[ALL]^DIK isn't called).
 N MEDS S MEDS="" ; result
 N PN,PN1 ; Product Name, abbreviated product name.
 S PN=$P(^PSNDF(50.68,VAPROD,0),"^"),PN1=$E(PN,1,30)
 N P50 S P50=0 ; looper through VAPN index which is DRUG file entry
 F  S P50=$O(^PSDRUG("VAPN",PN1,P50)) Q:'P50  D  ; for each text match
 . I $P(^PSDRUG(P50,"ND"),"^",3)=VAPROD S MEDS=$G(MEDS)_P50_U  ; check that the VA PRODUCT pointer is the same as ours.
 S:MEDS MEDS=$E(MEDS,1,$L(MEDS)-1) ; remove trailing ^
 Q MEDS
 ;
ADDDRUG(RXN,NDC,BARCODE) ; [Public] Add Drug to Drug File
 ; Input: RXN - RxNorm Semantic Clinical Drug CUI by Value. Required.
 ; Input: NDC - Drug NDC by Value. Optional. Pass in 11 digit format without dashes.
 ; Input: BARCODE - Wand Barcode. Optional. Pass exactly as wand reads minus control characters.
 ; Output: Internal Entry Number
 ;
 ; Prelim Checks
 I '$G(RXN) S $EC=",U1," ; Required
 I $L($G(NDC)),$L(NDC)'=11 S $EC=",U1,"
 ;
 ; Get first VUID for this RxNorm drug
 N VUID S VUID=+$$RXN2VUI(RXN)
 Q:'VUID
 G NEXT
ADDDRUG2(RXN,VUID) ;
 ; ZEXCEPT: NDC,BARCODE
NEXT ;
 N PSSZ S PSSZ=1    ; Needed for the drug file to let me in!
 ;
 W "(debug) VUID for RxNorm CUI "_RXN_" is "_VUID,!
 ;
 ; IEN in 50.68
 N C0XVUID ; For Searching Compound Index
 S C0XVUID(1)=VUID
 S C0XVUID(2)=1
 N F5068IEN S F5068IEN=$$FIND1^DIC(50.68,"","XQ",.C0XVUID,"AMASTERVUID")
 Q:'F5068IEN
 W "F 50.68 IEN (debug): "_F5068IEN,!
 ;
 ; Guard against adding the drug back in again.
 N EXISTING S EXISTING=$$VAP2MED(F5068IEN)
 I EXISTING Q EXISTING
 ;
 ; FDA Array
 N C0XFDA
 ;
 ; Name, shortened
 S C0XFDA(50,"+1,",.01)=$E($$GET1^DIQ(50.68,F5068IEN,.01),1,40)
 ;
 ; File BarCode as a Synonym for BCMA
 I $L($G(BARCODE)) D
 . S C0XFDA(50.1,"+2,+1,",.01)=BARCODE
 . S C0XFDA(50.1,"+2,+1,",1)="Q"
 ;
 ; Brand Names & NDCs
 ; N NDCS
 ; N URL S URL="https://rxnav.nlm.nih.gov/REST/rxcui/{RXN}/ndcs.json"
 ; N % S %("{RXN}")=RXN
 ; S URL=$$REPLACE^XLFSTR(URL,.%)
 ; N C0CRETURN
 ; D GET(.C0CRETURN,URL)
 ; N C0COUT
 ; D DECODE^XLFJSON($NA(C0CRETURN),$NA(C0COUT))
 ; ZWRITE C0COUT
 ; QUIT
 ; ;
 ; N BNS S BNS="" ; S BNS=$$RXN2BNS^C0CRXNLK(RXN) ; Brands
 ; I $L(BNS) N I F I=1:1:$L(BNS,U) D
 ; . N IENS S IENS=I+2
 ; . S C0XFDA(50.1,"+"_IENS_",+1,",.01)=$$UP^XLFSTR($E($P(BNS,U,I),1,40))
 ; . S C0XFDA(50.1,"+"_IENS_",+1,",1)="T"
 ;
 ; NDC (string)
 I $G(NDC) S C0XFDA(50,"+1,",31)=$E(NDC,1,5)_"-"_$E(NDC,6,9)_"-"_$E(NDC,10,11)
 ;
 ; Dispense Unit (string)
 S C0XFDA(50,"+1,",14.5)=$$GET1^DIQ(50.68,F5068IEN,"VA DISPENSE UNIT")
 ;
 ; National Drug File Entry (pointer to 50.6)
 S C0XFDA(50,"+1,",20)="`"_$$GET1^DIQ(50.68,F5068IEN,"VA GENERIC NAME","I")
 ;
 ; VA Product Name (string)
 S C0XFDA(50,"+1,",21)=$E($$GET1^DIQ(50.68,F5068IEN,.01),1,70)
 ;
 ; PSNDF VA PRODUCT NAME ENTRY (pointer to 50.68)
 S C0XFDA(50,"+1,",22)="`"_F5068IEN
 ;
 ; DEA, SPECIAL HDLG (string)
 D  ; From ^PSNMRG ; ZEXCEPT: n
 . N CS S CS=$$GET1^DIQ(50.68,F5068IEN,"CS FEDERAL SCHEDULE","I")
 . S CS=$S(CS?1(1"2n",1"3n"):+CS_"C",+CS=2!(+CS=3)&(CS'["C"):+CS_"A",1:CS)
 . S C0XFDA(50,"+1,",3)=CS
 ;
 ; NATIONAL DRUG CLASS (pointer to 50.605) (triggers VA Classification field)
 S C0XFDA(50,"+1,",25)="`"_$$GET1^DIQ(50.68,F5068IEN,"PRIMARY VA DRUG CLASS","I")
 ;
 ; Right Now, I don't file the following which ^PSNMRG does (cuz I don't need them)
 ; - Package Size (derived from NDC/UPN file)
 ; - Package Type (ditto)
 ; - CMOP ID (from $$PROD2^PSNAPIS)
 ; - National Formulary Indicator (from 50.68)
 ;
 ; Next Step is to kill Old OI if Dosage Form doesn't match
 ; Won't do that here as it's assumed any drugs that's added is new.
 ; This happens at ^PSNPSS
 ;
 ; Now add drug to drug file, as we need the IEN for the dosages call.
 N C0XERR,C0XIEN
 D UPDATE^DIE("E","C0XFDA","C0XIEN","C0XERR")
 S:$D(C0XERR) $EC=",U1,"
 ;
 ; Next Step: Kill off old doses and add new ones.
 D EN2^PSSUTIL(C0XIEN(1))
 ;
 ; Mark uses for the Drug; use the undocumented Silent call in PSSGIU
 N PSIUDA,PSIUX ; Expected Input variables
 S PSIUDA=C0XIEN(1),PSIUX="O^Outpatient Pharmacy" D ENS^PSSGIU
 S PSIUDA=C0XIEN(1),PSIUX="U^Unit Dose" D ENS^PSSGIU
 S PSIUDA=C0XIEN(1),PSIUX="X^Non-VA Med" D ENS^PSSGIU
 ;
 ; Get VA Generic text and VA Product pointer for Orderable Item creation plus dosage form information
 N VAGENP S VAGENP=$P(^PSDRUG(C0XIEN(1),"ND"),U) ; VA Generic Pointer
 N VAGEN S VAGEN=$$VAGN^PSNAPIS(VAGENP) ; VA Generic Full name
 N VAPRODP S VAPRODP=$P(^PSDRUG(C0XIEN(1),"ND"),U,3) ; VA Product Pointer
 N DOSAGE S DOSAGE=$$PSJDF^PSNAPIS(0,VAPRODP) ; IEN of dose form in 50.606 ^ Text
 N DOSEPTR S DOSEPTR=$P(DOSAGE,U) ; ditto
 N DOSEFORM S DOSEFORM=$P(DOSAGE,U,2) ;ditto
 ;
 ; Get the (possibly new) Orderable Item Text
 N VAG40 S VAG40=$E(VAGEN,1,40) ; Max length of .01 field
 ;
 ; See if there is an existing orderable item already. If so, populate the Pharmacy Orderable item on drug file.
 N OI S OI=$O(^PS(50.7,"ADF",VAG40,DOSEPTR,""))
 ;
 ; Otherwise, add a new one. (See MCHAN+12^PSSPOIMN)
 N FLAGNEWOI S FLAGNEWOI=0
 I 'OI D
 . N C0XFDA,C0XERR
 . S C0XFDA(50.7,"+1,",.01)=VAG40
 . S C0XFDA(50.7,"+1,",.02)=DOSEPTR
 . D UPDATE^DIE("",$NA(C0XFDA),$NA(OI),$NA(C0XERR))
 . I $D(C0XERR) S $EC=",U1,"
 . S OI=OI(1) ; For ease of use...
 . S FLAGNEWOI=1
 ;
 ; Add the orderable Item to the drug file.
 N C0XFDA,C0XERR S C0XFDA(50,C0XIEN(1)_",",2.1)=OI ; Orderable Item
 D FILE^DIE("",$NA(C0XFDA),$NA(C0XERR))
 S:$D(C0XERR) $EC=",U1,"
 ;
 ; Previously, we did the CPRS message here; but we don't need to anymore.
 ;
EX QUIT C0XIEN(1)
 ;
GET(RETURN,URL) ; [Public] Get a URL
 ;
 ; Timeout
 N TO S TO=5
 N HEADERS
 ; Action
 I $T(^%WC)]"" D %^%WC(.RETURN,"GET",URL,,,TO,.HEADERS) I 1
 E  N STATUS S STATUS=$$GETURL^XTHC10(URL,TO,$NA(RETURN)),HEADERS("STATUS")=STATUS
 ;
 ; ZWRITE HEADERS
 ; ZWRITE RETURN
 ;
 ; Check status code to be 200.
 I "^200^302^"'[HEADERS("STATUS") S %XOBWERR=HEADERS("STATUS"),$EC=",UXOBWHTTP,"
 QUIT
 ;
WRITERXRXN(PSODFN,RXNCDCUI,RXDATE) ; [Public] Create a new prescription for a patient using RxNorm SCD CUI
 N DRUG S DRUG=$$ADDDRUG(RXNCDCUI)
 D WRITERXPS(PSODFN,DRUG,RXDATE)
 QUIT
 ; 
WRITERXPS(PSODFN,DRUG,RXDATE) ; [Public] Create a new prescription for a patient using drug IEN
 ; Little by little we will work this out!
 ; Assumptions right now:
 ; XXX: Site in 59 is created
 ;
 ; Drug Array we will pass by reference
 N PSONEW
 ; 
 ; Call to get drug demographics
 N PSOY
 S PSOY=DRUG
 S PSOY(0)=^PSDRUG(DRUG,0)
 N PSODRUG
 D SET^PSODRG
 M PSONEW=PSODRUG
 ;
 ; Days and refills
 S PSONEW("ISSUE DATE")=RXDATE
 S PSONEW("FILL DATE")=RXDATE
 S PSONEW("DAYS SUPPLY")=30
 S PSONEW("# OF REFILLS")=1
 ;
 ; Pharmacist here!
 S PSONEW("VERIFY")=1
 S PSONEW("PHARMACIST")=$$PHARM^SYNINIT()
 S PSONEW("CLERK CODE")=PSONEW("PHARMACIST") ; Needed for CPRS for "Entered By" field.
 ;
 ; Provider
 S PSONEW("PROVIDER")=$$PROV^SYNINIT()
 ;
 ; Clinic
 S PSONEW("CLINIC")=$$HL^SYNINIT()
 ;
 ; Get Prescription Number
 N PSOSITE S PSOSITE=$O(^PS(59,0))
 I PSOSITE="" S PSOSITE=1 ; XXX I am not sure if that's a good idea! Maybe create the outpatient site?
 D AUTO^PSONRXN
 ;
 ; Dosage
 S PSONEW("ENT")=1
 S PSONEW("DOSE",PSONEW("ENT"))="ONE TABLET DAILY"
 ;
 ; Copay
 N PSOSCP S PSOSCP=""
 ;
 ; Quantity
 S PSONEW("QTY")=30 ; Non-sense number
 ;
 ; Counseling
 N PSOCOU,PSOCOUU
 S PSOCOU=1,PSOCOUU=1
 ;
 ;
 ; Nature of order
 N PSONOOR S PSONOOR="W"
 ;
 ; File in 52
 D EN^PSON52(.PSONEW)
 ;
 ; HL7 to OE/RR to update the Order File
 D EOJ^PSONEW
 QUIT
 ;
TEST D EN^%ut($T(+0),3) QUIT
 ;
T0 ; @TEST Test $$ETSRXN2VUID^SYNFMED API
 D CHKEQ^%ut($$ETSRXN2VUID^SYNFMED(831533),"50.68~4031994~ERRIN 0.35MG TAB,28")
 D CHKEQ^%ut($$ETSRXN2VUID^SYNFMED(70618),"50.6~4019880~PENICILLIN")
 D CHKEQ^%ut($$ETSRXN2VUID^SYNFMED(198211),"50.68~4016607~SIMVASTATIN 40MG TAB,UD")
 D CHKEQ^%ut($$ETSRXN2VUID^SYNFMED(313195),"50.68~4004891~TAMOXIFEN CITRATE 20MG TAB")
 D CHKEQ^%ut($$ETSRXN2VUID^SYNFMED(1009219),"50.6~4030995~ALISKIREN/AMLODIPINE")
 D CHKEQ^%ut($$ETSRXN2VUID^SYNFMED(309110),"50.68~4007024~CEPHALEXIN 125MG/5ML SUSP")
 D CHKEQ^%ut($$ETSRXN2VUID^SYNFMED(2231),"50.6~4018891~CEPHALEXIN")
 D CHKEQ^%ut($$ETSRXN2VUID^SYNFMED(10582),"50.6~4022126~LEVOTHYROXINE")
 QUIT
 ;
T1 ; @TEST Test get VUIDs
 D CHKEQ^%ut($$RXN2VUI(1014675),4033356)
 D CHKEQ^%ut($$RXN2VUI(197379),4014051)
 QUIT
 ;
T2 ; @TEST Get Local Matches for VUID (no accurate tests as drug file is local)
 W " "
 W $$MATCHV1(4004876)," "
 W $$MATCHV1(4033365)," "
 W $$MATCHV1(4014051)," "
 D SUCCEED^%ut
 QUIT
 ;
T3 ; @TEST Get Local Matches for RxNorm (no accurate tests as drug file is local)
 W $$RXN2MEDS(1014675)," " ; Ceterizine capsule
 W $$RXN2MEDS(197379)," "  ; Atenolol 100
 W $$RXN2MEDS(1085640)," " ;  Triamcinolone Acetonide 0.005 MG/MG Topical Ointment
 D SUCCEED^%ut
 QUIT
 ;
T4 ; @TEST Write Rx Using Drug IEN
 ; DELETE ALL RX FOR PATIENT ONE
 N DA,DIK
 N DFN S DFN=1
 N PSOI F PSOI=0:0 S PSOI=$O(^PS(55,DFN,"P",PSOI)) Q:'PSOI  D
 . N RXIEN S RXIEN=^PS(55,DFN,"P",PSOI,0)
 . I $D(^PSRX(RXIEN,"OR1")) N ORNUM S ORNUM=$P(^("OR1"),U,2) S DA=ORNUM,DIK="^OR(100," D ^DIK
 . S DIK="^PSRX(",DA=RXIEN D ^DIK
 S DA=DFN,DIK="^PS(55," D ^DIK
 D WRITERXPS(1,10,DT)
 N RX0 S RX0=^PSRX(1,0)
 N PAT S PAT=$P(RX0,U,2)
 N DRG S DRG=$P(RX0,U,6)
 D CHKEQ^%ut(PAT,1)
 D CHKEQ^%ut(DRG,10)
 QUIT
 ;
T5 ; @TEST Write Rx Using Drug RxNorm SCD
 ; DELETE ALL RX FOR PATIENT ONE
 N DA,DIK
 N DFN S DFN=1
 N PSOI F PSOI=0:0 S PSOI=$O(^PS(55,DFN,"P",PSOI)) Q:'PSOI  D
 . N RXIEN S RXIEN=^PS(55,DFN,"P",PSOI,0)
 . I $D(^PSRX(RXIEN,"OR1")) N ORNUM S ORNUM=$P(^("OR1"),U,2) S DA=ORNUM,DIK="^OR(100," D ^DIK
 . S DIK="^PSRX(",DA=RXIEN D ^DIK
 S DA=DFN,DIK="^PS(55," D ^DIK
 D WRITERXRXN(1,313195,DT) ; Tamoxifen Citrate 20mg tab
 N RX0 S RX0=^PSRX(1,0)
 N PAT S PAT=$P(RX0,U,2)
 N DRG S DRG=$P(RX0,U,6)
 N DRGNM S DRGNM=$P(^PSDRUG(DRG,0),U)
 D CHKEQ^%ut(PAT,1)
 D CHKTF^%ut(DRGNM["TAMOXIFEN")
 QUIT
 ;
VUI2VAPT ; @TEST Get VA Product IEN from VUID
 N L F L=1:1 N LN S LN=$T(VUI2VAPD+L) Q:LN["<<END>>"  Q:LN=""  D
 . N VUID S VUID=$P(LN,";",3)
 . N VAP S VAP=$P(LN,";",4)
 . D CHKEQ^%ut($$VUI2VAP(VUID),VAP,"Translation from VUID to VA PRODUCT failed")
 QUIT
 ;
VUI2VAPD ; @DATA - Data for above test
 ;;4006455;5932
 ;;4002369;1784
 ;;4000874;252
 ;;4003335;2756
 ;;4002469;1884
 ;;4009488;9046^10090
 ;;<<END>>
