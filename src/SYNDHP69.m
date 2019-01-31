SYNDHP69 ;AFHIL-DHP/fjf - Commin Utility Functions;2019-01-31  10:40 AM
 ;;0.1;VISTA SYNTHETIC DATA LOADER;;Aug 17, 2018;Build 13
 Q
 ;
DUZ() ; issues/set DUZ
 I '$D(DT) S DT=$$DT^XLFDT
 N VASITE S VASITE=$$SITE^VASITE
 N SITE S SITE=$P(VASITE,"^",3)
 S DUZ=$S(+$G(DUZ)=0:$$PROV^SYNINIT,1:DUZ)
 D DUZ^XUS1A
 Q DUZ
 ;
 ;
RESID(ENT,SITE) ; resource ID
 ; some rudimenatary validatation inputs
 ;
 N S
 S S="_"
 Q ENT_S_SITE_$$FACID
 ;
 ;
FACID() ; Get facility parameter to append to site
 ;
 Q $$GET^XPAR("SYS","SYNDHPFAC",1)
 ;
 ;
GETFACID(RETSTA,X) ; Get facility parameter
 ;
 S RETSTA=$$FACID
 Q
 ;
FACPAR(RETSTA,DHPFAC) ; Setup/delete faciltity identification parameter
 ;
 ; Input:
 ;   DHPFAC - facility identifier
 ;     ER     - Emergency Room
 ;     HOSP   - Hospital
 ;     SCLIN  - Specialist Clinic
 ;     HS     - HealthShare
 ;     @      - delete
 ;
 S RETSTA=0
 I "^ER^SCLIN^HOSP^HS^@"'[DHPFAC S RETSTA=0_"^error" Q
 I $$CKPRDF=0 S RETSTA=0_"^parameter definition error" Q
 ;
 ; add the parameter if it doesn't exist, or delete for FAC="@"
 K ZZERR
 D EN^XPAR("SYS","SYNDHPFAC",,DHPFAC,.ZZERR)
 S RETSTA='ZZERR
 Q
 ;
CKPRDF() ; Check that parameter definition exists for SYNDHPFAC
 ;       and it it doesn't exist, create it
 N FN,FDA,ZZERR
 S FN=8989.51
 I +$$FIND1^DIC(FN,,"MX","SYNDHPFAC")'=0 Q 1
 S FDA(FN,"+1,",.01)="SYNDHPFAC"
 S FDA(FN,"+1,",.02)="SYNDHP Facility Parameter"
 S FDA(FN,"+1,",1.1)="F"
 K ZZERR
 D UPDATE^DIE(,"FDA",,"ZZERR")
 Q '$D(ZZERR)
 ;
TEST D EN^%ut($T(+0),1) QUIT
T1 ; @TEST HASHINFO^ORDEA previously crashed due to bad DUZ(2)
 K DUZ
 S DUZ=$$DUZ()
 N ORY
 D HASHINFO^ORDEA(.ORY,1,$$PROV^SYNINIT)
 D SUCCEED^%ut
 QUIT
 ;
