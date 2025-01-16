SYNDHP65 ;DHP/AFHIL -fjf - HealthConcourse - Write Procedures to VistA ;2019-11-18  5:35 PM
 ;;0.3;VISTA SYNTHETIC DATA LOADER;;Jul 01, 2019;Build 13
 ;;
 ;;Original routine authored by Andrew Thompson & Ferdinand Frankson of Perspecta 2017-2019
 ;
 ; Copyright (c) 2017-2019 DXC Technology (now Perspecta)
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
PRCADD(RETSTA,DHPPAT,DHPVST,DHPCNT,DHPSCT,DHPDTM) ;Ingest Procedures
 ;
 ; Ingest Procedures into VistA
 ;
 ; Input:
 ;   DHPPAT   - patient ICN              (mandatory)
 ;   DHPVST   - Visit Identifier         (mandatory)
 ;   DHPCNT   - No of times performed    (mandatory)
 ;   DHPSCT   - SCT Procedure code       (mandatory)
 ;   DHPDTM   - Procedure Date/Time      (mandatory) HL7 format
 ; Output:
 ;   1 - success
 ;  -1 - failure
 ;
 I '$D(^DPT("AFICN",DHPPAT)) S RETSTA="-1^Patient not recognised" Q
 ;
 I $G(DHPSCT)="" S RETSTA="-1^SNOMED CT code is required" Q
 I $G(DHPVST)="" S RETSTA="-1^Visit IEN is required" Q
 I '$D(^AUPNVSIT(DHPVST)) S RETSTA="-1^Visit not found" Q
 ;
 D INIT
 ;
 ; use SNOMED CT to OS5 mapping
 S MAPPING="sct2os5"
 ;
 S DHPOS5=$$MAP^SYNDHPMP(MAPPING,DHPSCT)
 I +DHPOS5'=1 S RETSTA="-1^Code "_DHPSCT_" not mapped" Q
 S DHPOS5=$P(DHPOS5,U,2)
 ;
 S PROCDATA("PROCEDURE",1,"PROCEDURE")=DHPOS5
 S PROCDATA("PROCEDURE",1,"QTY")=DHPCNT
 ;
 S DATFM=$$HL7TFM^XLFDT(DHPDTM)
 S PROCDATA("PROCEDURE",1,"EVENT D/T")=DATFM
 ;
 ;
 S RETSTA=1
 S RETSTA=$$DATA2PCE^PXAI("PROCDATA",PACKAGE,SOURCE,.DHPVST,USER,$G(ERRDISP),.ZZERR,$G(PPEDIT),.ZZERDESC,.ACCOUNT)
 ;I $D(ZZERR) ZWRITE ZZERR
 ;
 Q
 ;
INIT ; Initiate variables
 ;
 S PACKAGE=$$FIND1^DIC(9.4,,"","PCE")
 S SOURCE="DHP DATA INGEST"
 S USER=$$DUZ^SYNDHP69
 S ERRDISP=""
 I $G(DEBUG)=1 S ERRDISP=1
 S PPEDIT=""
 S ACCOUNT=""
 S P="|"
 ;
 S ERRDISP=1 ;for testing only, set to null otherwise  <<<<<<<<<<<<<<<<<<<<<<<
 S PPEDIT=""
 S ACCOUNT=""
 ;
 Q
 ;
T1 ;
 D PRCADD(.ZXC,"5000000352V586511",20559,1,56876005,20151002)
 Q
