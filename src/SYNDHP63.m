SYNDHP63 ;DHP/ART -  Write Lab Tests to VistA ;2019-11-18  3:35 PM
 ;;0.3;VISTA SYNTHETIC DATA LOADER;;Jul 01, 2019;Build 12
 ;
 ; Original routine authored by Andrew Thompson & Ferdinand Frankson of DXC Technology 2017-2018
 ;
 ; Copyright (c) 2017-2018 DXC Technology (now Perspecta)
 ; Copyright (c) 2024-2025 DocMe360 LLC
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
 ;
 QUIT
 ;
 ; -------- Create lab test for a patient
 ;
LABADD(RETSTA,DHPPAT,DHPLOC,DHPTEST,DHPRSLT,DHPRSDT,DHPLOINC,DHPCSAMP) ;Create lab test
 ; This is a wrapper to setup a call to the ISI Lab Import processing
 ;
 ; Input:
 ;   DHPPAT  - Patient ICN (required)
 ;   DHPLOC  - Location Name (required)
 ;   DHPTEST - Test name (required if no valid LOINC code passed)
 ;   DHPRSLT - Test result value (required)
 ;   DHPRSDT - Test result date (required, HL7 format)
 ;   DHPLOINC - LOINC code
 ;   DHPCSAMP - Collection Sample
 ;
 ; Output:   RETSTA
 ;  1 - success
 ; -1 - failure -1^message
 ;
 N PATDFN,PATSSN,LABARRAY,RC,DHPRC,LOINCIEN,TESTIEN,LABTEST,SAVEIO
 ;
 S RETSTA("LABINPUT","DHPPAT")=DHPPAT
 S RETSTA("LABINPUT","DHPLOC")=DHPLOC
 S RETSTA("LABINPUT","DHPTEST")=DHPTEST
 S RETSTA("LABINPUT","DHPRSLT")=DHPRSLT
 S RETSTA("LABINPUT","DHPRSDT")=DHPRSDT
 S RETSTA("LABINPUT","DHPLOINC")=DHPLOINC
 S RETSTA("LABINPUT","DHPCSAMP")=DHPCSAMP
 ;
 I $G(DHPPAT)="" S RETSTA="-1^Missing patient identifier." QUIT
 I $G(DHPLOC)="" S RETSTA="-1^Missing location." QUIT
 I $G(DHPLOINC)="",$G(DHPTEST)="" S RETSTA="-1^Missing lab test name." QUIT
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
 S LABDTTM=+LABDTTM ;drop any trailing 0's in time
 ;
 ;Get lab test name for LOINC code
 I $G(DHPLOINC)'="" D
 . S LOINCIEN=$O(^LAM("AH",$P(DHPLOINC,"-",1),""),-1)
 . QUIT:LOINCIEN=""
 . S LABTEST=$$GET1^DIQ(64,LOINCIEN_",",25.5,"E")
 ;I $G(LABTEST)="" S LABTEST=$$UP^XLFSTR(DHPTEST)
 I $G(LABTEST)="" S LABTEST=DHPTEST
 I $G(LABTEST)="" S RETSTA="-1^Cannot determine lab test name." QUIT
 ;
 S LABARRAY("PAT_SSN")=PATSSN
 S LABARRAY("LAB_TEST")=LABTEST
 S LABARRAY("RESULT_DT")=LABDTTM
 S LABARRAY("RESULT_VAL")=DHPRSLT
 S LABARRAY("LOCATION")=DHPLOC
 S LABARRAY("LOINC")=DHPLOINC
 S LABARRAY("COLLECTION_SAMPLE")=DHPCSAMP
 M RETSTA("LABDATA")=LABARRAY
 ;
 I $G(DEBUG)=1 D
 . W "ICN:      ",DHPPAT,!
 . W "SSN:      ",LABARRAY("PAT_SSN"),!
 . W "LOCATION: ",LABARRAY("LOCATION"),!
 . W "LOINC:    ",DHPLOINC,!
 . W "TEST:     ",LABARRAY("LAB_TEST"),!
 . W "RESULT:   ",LABARRAY("RESULT_VAL"),!
 . W "DATE:     ",LABARRAY("RESULT_DT"),!
 . W "CSAMP     ",LABARRAY("COLLECTION_SAMPLE"),!
 ;
 ;call ISI Labs Ingest
 S DHPRC=$$LAB^ISIIMP12(.RC,.LABARRAY)
 I +DHPRC=-1 S RETSTA=DHPRC QUIT
 ;
 S RETSTA=1
 ;
 QUIT
 ;
T1 ; test one
 ;
 M PARMS=^XTMP("SYNGRAPH",1,1267,"load","labs",13,"parms")
 S N=""
 F  S N=$O(PARMS(N)) Q:N=""  S @N=PARMS(N)
 D LABADD(.ZXC,DHPPAT,DHPLOC,DHPLAB,DHPOBS,DHPDTM,DHPLOINC)
 Q
