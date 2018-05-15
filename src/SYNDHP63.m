SYNDHP63 ;DHP/ART -  Write Lab Tests to VistA ;05/15/2018
 ;;1.0;DHP;**1**;Jan 17, 2017;
 ;;Original routine authored by Andrew Thompson & Ferdinand Frankson of DXC Technology 2017-2018
 ;
 QUIT
 ;
 ; -------- Create lab test for a patient
 ;
LABADD(RETSTA,DHPPAT,DHPLOC,DHPTEST,DHPRSLT,DHPRSDT) ;Create lab test
 ;
 ; Input:
 ;   DHPPAT  - Patient ICN (required)
 ;   DHPLOC  - Location Name (required)
 ;   DHPTEST - Test name (required)
 ;   DHPRSLT - Test result value (required)
 ;   DHPRSDT - Test result date (required, HL7 format)
 ;
 ; Output:   RETSTA
 ;  1 - success
 ; -1 - failure -1^message
 ;
 N PATDFN,PATSSN,LABARRAY,RC,DHPRC
 ;
 I $G(DHPPAT)="" S RETSTA="-1^Missing patient identifier." QUIT
 I $G(DHPLOC)="" S RETSTA="-1^Missing location." QUIT
 I $G(DHPTEST)="" S RETSTA="-1^Missing lab test name." QUIT
 I $G(DHPRSLT)="" S RETSTA="-1^Missing lab test result value." QUIT
 I $G(DHPRSDT)="" S RETSTA="-1^Missing lab test result date/time." QUIT
 ;
 I '$D(^DPT("AFICN",DHPPAT)) S RETSTA="-1^Patient not recognised." QUIT
 S PATDFN=$O(^DPT("AFICN",DHPPAT,""))
 S PATSSN=$$GET1^DIQ(2,PATDFN_",",.09,"I") ;patient SSN
 I PATSSN="" S RETSTA="-1^Patient does not have an SSN." QUIT
 ;
 ; -- Check lab test date/time --
 S LABDTTM=$$HL7TFM^XLFDT(DHPRSDT)
 I $P(LABDTTM,".",2)="" S RETSTA="-1^Missing time for result date/time." QUIT
 ;chop off seconds
 S LABTM=$E($P(LABDTTM,".",2),1,4)
 S $P(LABDTTM,".",2)=LABTM
 S LABDTTM=$$HL7TFM^XLFDT($$FMTHL7^XLFDT(LABDTTM))
 ;
 S LABARRAY("PAT_SSN")=PATSSN
 S LABARRAY("LAB_TEST")=DHPTEST
 S LABARRAY("RESULT_DT")=LABDTTM
 S LABARRAY("RESULT_VAL")=DHPRSLT
 S LABARRAY("LOCATION")=DHPLOC
 ;
 W "SSN:      ",LABARRAY("PAT_SSN"),!
 W "LOCATION: ",LABARRAY("LOCATION"),!
 W "TEST:     ",LABARRAY("LAB_TEST"),!
 W "RESULT:   ",LABARRAY("RESULT_VAL"),!
 W "DATE:     ",LABARRAY("RESULT_DT"),!
 ;
 S DHPRC=$$LAB^ISIIMP12(.RC,.LABARRAY)
 I +DHPRC=-1 S RETSTA=DHPRC QUIT
 ;
 S RETSTA=1
 ;
 QUIT
