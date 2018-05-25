SYNINIT ;OSEHRA/SMH - Initilization Code for Synthetic Data Loader;May 23 2018
 ;;1.0;Synthetic Data Loader;
; 
; NUMBER: 10                              HTTP VERB: POST                         URI: addcondition
; EXECUTION ENDPOINT: wsIntakeConditions^SYNFCON
 ;
LOADHAND ; [Public] Load URL handlers
 W !!,"LOADING URL HANDLERS",!
 N I,IEN F I=1:1 N LN S LN=$P($T(LH+I),";;",2,99) Q:LN=""  D  ; Read inline
 . N NREF S NREF=$P(LN,"=") ; variable name reference
 . I $E(NREF)="^" S NREF=$NA(@NREF) ; convert IEN to actual value
 . N TESTNODE S TESTNODE="" ; for $DATA testing
 . I $QS(NREF,2)="B" S TESTNODE=$NA(@NREF,5) ; Get all subs b4 IEN
 . I $L(TESTNODE),$D(@TESTNODE) DO  QUIT  ; If node exists in B index
 . . WRITE TESTNODE_" ALREADY INSTALLED",!  ; say so
 . . KILL ^%W(17.6001,IEN) ; and delete the stuff we entered
 . S @LN  ; okay to set.
 QUIT
LH ;; START
 ;;IEN=$O(^%W(17.6001," "),-1)+1
 ;;^%W(17.6001,IEN,0)="POST"
 ;;^%W(17.6001,IEN,1)="addpatient/*"
 ;;^%W(17.6001,IEN,2)="wsPostFHIR^SYNFHIR"
 ;;^%W(17.6001,"B","POST","addpatient/*","wsPostFHIR^SYNFHIR",IEN)=""
 ;;IEN=IEN+1
 ;;^%W(17.6001,IEN,0)="GET"
 ;;^%W(17.6001,IEN,1)="showfhir/*"
 ;;^%W(17.6001,IEN,2)="wsShow^SYNFHIR"
 ;;^%W(17.6001,"B","GET","showfhir/*","wsShow^SYNFHIR",IEN)=""
 ;;IEN=IEN+1
 ;;^%W(17.6001,IEN,0)="GET"
 ;;^%W(17.6001,IEN,1)="vpr/*"
 ;;^%W(17.6001,IEN,2)="wsVPR^SYNVPR"
 ;;^%W(17.6001,"B","GET","vpr/*","wsVPR^SYNVPR",IEN)=""
 ;;IEN=IEN+1
 ;;^%W(17.6001,IEN,0)="GET"
 ;;^%W(17.6001,IEN,1)="global/{root}"
 ;;^%W(17.6001,IEN,2)="wsGLOBAL^SYNVPR"
 ;;^%W(17.6001,"B","GET","global/{root}","wsGLOBAL^SYNVPR",IEN)=""
 ;;IEN=IEN+1
 ;;^%W(17.6001,IEN,0)="POST"
 ;;^%W(17.6001,IEN,1)="addvitals/*"
 ;;^%W(17.6001,IEN,2)="wsIntakeVitals^SYNFVIT"
 ;;^%W(17.6001,"B","POST","addvitals/*","wsIntakeVitals^SYNFVIT",IEN)=""
 ;;IEN=IEN+1
 ;;^%W(17.6001,IEN,0)="POST"
 ;;^%W(17.6001,IEN,1)="addencounter"
 ;;^%W(17.6001,IEN,2)="wsIntakeEncounters^SYNFENC"
 ;;^%W(17.6001,"B","POST","addencounter","wsIntakeEncounters^SYNFENC",IEN)=""
 ;;IEN=IEN+1
 ;;^%W(17.6001,IEN,0)="POST"
 ;;^%W(17.6001,IEN,1)="addcondition"
 ;;^%W(17.6001,IEN,2)="wsIntakeConditions^SYNFCON"
 ;;^%W(17.6001,"B","POST","addcondition","wsIntakeConditions^SYNFCON",IEN)=""
 ;;^%W(17.6001,0)="WEB SERVICE URL HANDLER^17.6001S^"_IEN_"^"_IEN
 ;;
 ;
PROV() ;[Public] Create Generic Provider for Synthetic Patients
 ; ASSUMPTION: DUZ MUST HAVE XUMGR OTHERWISE FILEMAN WILL BLOCK YOU!
 N NAME S NAME="PROVIDER,UNKNOWN SYNTHEA" ; Constant
 Q:$O(^VA(200,"B",NAME,0)) $O(^(0)) ; Quit if the entry exists with entry
 ;
 N C0XFDA,C0XIEN,C0XERR,DIERR
 S C0XFDA(200,"?+1,",.01)=NAME
 S C0XFDA(200,"?+1,",1)="USP" ; Initials
 S C0XFDA(200,"?+1,",28)=100 ; Mail Code
 S C0XFDA(200,"?+1,",53.1)=1 ; Authorized to write meds
 S C0XFDA(200.05,"?+2,?+1,",.01)="`144" ; Person Class - Allopathic docs.
 S C0XFDA(200.05,"?+2,?+1,",2)=2700101 ; Date active
 ;
 ; Security keys
 S C0XFDA(200.051,"?+3,?+1,",.01)="PROVIDER"
 S C0XFDA(200.051,"?+4,?+1,",.01)="ORES"
 ;
 ; Access and Verify Codes so we can log in as the provider if we want to
 ; We must pre-hash them as that's not in the IT
 S C0XFDA(200,"?+1,",2)=$$EN^XUSHSH("SYNPROV123") ; ac
 S C0XFDA(200,"?+1,",11)=$$EN^XUSHSH("SYNPROV123!!") ; vc
 S C0XFDA(200,"?+1,",7.2)=1 ; verify code never expires
 ;
 ; Electronic Signature
 ; Input transform hashes this guy
 S C0XFDA(200,"?+1,",20.4)="123456"
 ;
 ; Primary Menu
 S C0XFDA(200,"?+1,",201)="`"_$$FIND1^DIC(19,,"QX","XUCORE","B")
 ;
 ; Secondary Menu (CPRS, etc)
 S C0XFDA(200.03,"?+5,?+1,",.01)="`"_$$FIND1^DIC(19,,"QX","OR CPRS GUI CHART","B")
 ;
 ; Restrict Patient Selection
 S C0XFDA(200,"?+1,",101.01)="NO"
 ;
 ; CPRS Tabs
 S C0XFDA(200.010113,"?+6,?+1,",.01)="COR"
 S C0XFDA(200.010113,"?+6,?+1,",.02)="T-1"
 ;
 ; Service/Section
 S C0XFDA(200,"?+1,",29)="`1"
 ;
 ; NPI - Ferdi made this one up.
 S C0XFDA(200,"?+1,",41.99)="9990000348"
 ;
 N DIC S DIC(0)="" ; An XREF in File 200 requires this.
 D UPDATE^DIE("E",$NA(C0XFDA),$NA(C0XIEN),$NA(C0XERR)) ; Typical UPDATE
 I $D(DIERR) S $EC=",U1,"
 ;
 ; Fix verify code change date to the far future
 N FDA 
 S FDA(200,C0XIEN(1)_",",11.2)=$$FMTH^XLFDT($$FMADD^XLFDT(DT,3000))
 ;
 ; Signature block. Do this as internal values to prevent name check in 20.2.
 S FDA(200,C0XIEN(1)_",",20.2)="SYNTHETIC PROVIDER, MD"
 S FDA(200,C0XIEN(1)_",",20.3)="Staff Physician"
 ;
 D FILE^DIE(,$NA(FDA))
 I $D(DIERR) S $EC=",U1,"
 ;
 Q C0XIEN(1) ;Provider IEN
 ;
PHARM() ;[Public] Create Generic Provider for Synthetic Patients
 ; ASSUMPTION: DUZ MUST HAVE XUMGR OTHERWISE FILEMAN WILL BLOCK YOU!
 N NAME S NAME="PHARMACIST,UNKNOWN SYNTHEA" ; Constant
 Q:$O(^VA(200,"B",NAME,0)) $O(^(0)) ; Quit if the entry exists with entry
 ;
 N C0XFDA,C0XIEN,C0XERR,DIERR
 S C0XFDA(200,"?+1,",.01)=NAME
 S C0XFDA(200,"?+1,",1)="UST" ; Initials
 S C0XFDA(200,"?+1,",28)=111 ; Mail Code
 S C0XFDA(200.05,"?+2,?+1,",.01)="`246" ; Person Class - Pharmacist
 S C0XFDA(200.05,"?+2,?+1,",2)=2700101 ; Date active
 ;
 ; Security keys
 S C0XFDA(200.051,"?+3,?+1,",.01)="PSORPH"
 S C0XFDA(200.051,"?+4,?+1,",.01)="ORELSE"
 ;
 ; Access and Verify Codes so we can log in as the provider if we want to
 ; We must pre-hash them as that's not in the IT
 S C0XFDA(200,"?+1,",2)=$$EN^XUSHSH("SYNPHARM123") ; ac
 S C0XFDA(200,"?+1,",11)=$$EN^XUSHSH("SYNPHARM123!!") ; vc
 S C0XFDA(200,"?+1,",7.2)=1 ; verify code never expires
 ;
 ; Electronic Signature
 ; Input transform hashes this guy
 S C0XFDA(200,"?+1,",20.4)="123456"
 ;
 ; Primary Menu
 S C0XFDA(200,"?+1,",201)="`"_$$FIND1^DIC(19,,"QX","XUCORE","B")
 ;
 ; Secondary Menu (CPRS, etc)
 S C0XFDA(200.03,"?+5,?+1,",.01)="`"_$$FIND1^DIC(19,,"QX","OR CPRS GUI CHART","B")
 ;
 ; Restrict Patient Selection
 S C0XFDA(200,"?+1,",101.01)="NO"
 ;
 ; CPRS Tabs
 S C0XFDA(200.010113,"?+6,?+1,",.01)="COR"
 S C0XFDA(200.010113,"?+6,?+1,",.02)="T-1"
 ;
 ; Service/Section
 S C0XFDA(200,"?+1,",29)="`1"
 ;
 N DIC S DIC(0)="" ; An XREF in File 200 requires this.
 D UPDATE^DIE("E",$NA(C0XFDA),$NA(C0XIEN),$NA(C0XERR)) ; Typical UPDATE
 I $D(DIERR) S $EC=",U1,"
 ;
 ; Fix verify code change date to the far future
 N FDA 
 S FDA(200,C0XIEN(1)_",",11.2)=$$FMTH^XLFDT($$FMADD^XLFDT(DT,3000))
 ;
 ; Signature block. Do this as internal values to prevent name check in 20.2.
 S FDA(200,C0XIEN(1)_",",20.2)="SYNTHETIC PHARMACIST, RPH"
 S FDA(200,C0XIEN(1)_",",20.3)="Staff Pharmacist"
 ;
 D FILE^DIE(,$NA(FDA))
 I $D(DIERR) S $EC=",U1,"
 ;
 Q C0XIEN(1) ;Provider IEN
 ;
HL() ; [Public] Generic Hospital Location Entry
 N NAME S NAME="GENERAL MEDICINE" ; Constant
 Q:$O(^SC("B",NAME,0)) $O(^(0)) ; Quit if the entry exists with the entry
 ;
 N C0XFDA,C0XIEN,C0XERR,DIERR
 S C0XFDA(44,"?+1,",.01)=NAME
 S C0XFDA(44,"?+1,",2)="C" ; Type - Clinic
 S C0XFDA(44,"?+1,",2.1)=1 ; Type Extension - Clinic
 S C0XFDA(44,"?+1,",3)=+$$SITE^VASITE() ; Institution - Default institution
 S C0XFDA(44,"?+1,",8)=295 ; STOP CODE NUMBER - Primary Care
 S C0XFDA(44,"?+1,",9)="M" ; SERVICE
 S C0XFDA(44,"?+1,",2502)="Y" ; NON-COUNT CLINIC
 D UPDATE^DIE("",$NA(C0XFDA),$NA(C0XIEN),$NA(C0XERR))
 I $D(DIERR) S $EC=",U1,"
 Q C0XIEN(1) ; HL IEN
 ;
TEST D EN^%ut($T(+0),3) QUIT
 ;
TESTPROV ; @TEST Test adding a provider
 N NAME S NAME="PROVIDER,UNKNOWN SYNTHEA" ; Constant
 N PROV S PROV=$$FIND1^DIC(200,,"QX",NAME,"B")
 I PROV N DA,DIK S DA=PROV,DIK="^VA(200," D ^DIK
 S PROV=$$PROV()
 D CHKTF^%ut(PROV>0)
 QUIT
 ;
TESTPHARM ; @TEST Test adding a pharmacist
 N NAME S NAME="PHARMACIST,UNKNOWN SYNTHEA" ; Constant
 N PHARM S PHARM=$$FIND1^DIC(200,,"QX",NAME,"B")
 I PHARM N DA,DIK S DA=PHARM,DIK="^VA(200," D ^DIK
 S PHARM=$$PHARM()
 D CHKTF^%ut(PHARM>0)
 QUIT
 ;
TESTHL ; @TEST Test adding a clinic
 N NAME S NAME="GENERAL MEDICINE" ; Constant
 N HL S HL=$$FIND1^DIC(44,,"QX",NAME,"B")
 I HL N DA,DIK S DA=HL,DIK="^SC(" D ^DIK
 S HL=$$HL()
 D CHKTF^%ut(HL>0)
 QUIT
 ;
TESTLH ; @Test Load Handlers
 ; SO MANY NAKED PEOPLE!
 N IEN
 S IEN=$O(^%W(17.6001,"B","POST","addpatient/*","wsPostFHIR^SYNFHIR",""))
 K ^(IEN),^%W(17.6001,IEN)
 S IEN=$O(^%W(17.6001,"B","GET","showfhir/*","wsShow^SYNFHIR",""))
 K ^(IEN),^%W(17.6001,IEN)
 S IEN=$O(^%W(17.6001,"B","GET","vpr/*","wsVPR^SYNVPR",""))
 K ^(IEN),^%W(17.6001,IEN)
 S IEN=$O(^%W(17.6001,"B","GET","global/{root}","wsGLOBAL^SYNVPR",""))
 K ^(IEN),^%W(17.6001,IEN)
 S IEN=$O(^%W(17.6001,"B","POST","addvitals/*","wsIntakeVitals^SYNFVIT",""))
 K ^(IEN),^%W(17.6001,IEN)
 S IEN=$O(^%W(17.6001,"B","POST","addencounter","wsIntakeEncounters^SYNFENC",""))
 K ^(IEN),^%W(17.6001,IEN)
 S IEN=$O(^%W(17.6001,"B","POST","addcondition","wsIntakeConditions^SYNFCON",""))
 K ^(IEN),^%W(17.6001,IEN)
 D LOADHAND
 K IEN
 S IEN=$O(^%W(17.6001,"B","POST","addpatient/*","wsPostFHIR^SYNFHIR",""))
 D CHKTF^%ut(IEN)
 K IEN
 S IEN=$O(^%W(17.6001,"B","GET","showfhir/*","wsShow^SYNFHIR",""))
 D CHKTF^%ut(IEN)
 K IEN
 S IEN=$O(^%W(17.6001,"B","GET","vpr/*","wsVPR^SYNVPR",""))
 D CHKTF^%ut(IEN)
 K IEN
 S IEN=$O(^%W(17.6001,"B","GET","global/{root}","wsGLOBAL^SYNVPR",""))
 D CHKTF^%ut(IEN)
 K IEN
 S IEN=$O(^%W(17.6001,"B","POST","addvitals/*","wsIntakeVitals^SYNFVIT",""))
 D CHKTF^%ut(IEN)
 K IEN
 S IEN=$O(^%W(17.6001,"B","POST","addencounter","wsIntakeEncounters^SYNFENC",""))
 D CHKTF^%ut(IEN)
 K IEN
 S IEN=$O(^%W(17.6001,"B","POST","addcondition","wsIntakeConditions^SYNFCON",""))
 D CHKTF^%ut(IEN)
 K IEN
 QUIT
