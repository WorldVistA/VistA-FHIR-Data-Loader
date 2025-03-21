SYNGBLLD ; HC/ART - HealthConcourse - DHP load data in ^SYN("2002.030" global ;02/04/2019
 ;;0.7;VISTA SYN DATA LOADER;;Mar 18, 2025
 ;
 ; Original routine authored by Andrew Thompson & Ferdinand Frankson of Perspecta 2017-2019
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
 ;
 QUIT
 ;
EN ;load all
 ;
 D LOADMH
 D LOADCPT
 D LOADHF
 D LOADVIT
 D LOADPOS
 D LOADFLAG
 ;
 QUIT
 ;
LOADMH ;load ^SYN mapping table for mental health instruments
 N IDX,INSTRUMT,TESTID,TESTNAME,LOINC,SNOMED
 K ^SYN("2002.030","mh2loinc")
 K ^SYN("2002.030","mh2sct")
 ;LOINC
 S IDX=0
 F  S IDX=IDX+1,INSTRUMT=$P($T(MHLOINC+IDX),";;",2) QUIT:INSTRUMT="zzzzz"  D
 . S TESTID=$P(INSTRUMT,U,1)
 . S TESTNAME=$P(INSTRUMT,U,2)
 . S LOINC=$P(INSTRUMT,U,3)
 . S:(TESTID'="")&(LOINC'="") ^SYN("2002.030","mh2loinc","direct",TESTID,LOINC)=""
 . S:(TESTNAME'="")&(LOINC'="") ^SYN("2002.030","mh2loinc","direct",TESTNAME,LOINC)=""
 . S:(TESTID'="")&(LOINC'="") ^SYN("2002.030","mh2loinc","inverse",LOINC,TESTID)=""
 ;SNOMED
 S IDX=0
 F  S IDX=IDX+1,INSTRUMT=$P($T(MHSNOMED+IDX),";;",2) QUIT:INSTRUMT="zzzzz"  D
 . S TESTID=$P(INSTRUMT,U,1)
 . S TESTNAME=$P(INSTRUMT,U,2)
 . S SNOMED=$P(INSTRUMT,U,3)
 . S:(TESTID'="")&(SNOMED'="") ^SYN("2002.030","mh2sct","direct",TESTID,SNOMED)=""
 . S:(TESTNAME'="")&(SNOMED'="") ^SYN("2002.030","mh2sct","direct",TESTNAME,SNOMED)=""
 . S:(TESTID'="")&(SNOMED'="") ^SYN("2002.030","mh2sct","inverse",SNOMED,TESTID)=""
 ;
 QUIT
 ;
LOADCPT ;load ^SYN mapping table for SCT to CPT
 N IDX,LINE,LOINC,SCT,CPT,DESC
 K ^SYN("2002.030","sct2cpt")
 S IDX=0
 F  S IDX=IDX+1,LINE=$P($T(CPT2SCT+IDX),";;",2) QUIT:LINE="zzzzz"  D
 . S CPT=$P(LINE,U,1)
 . S SCT=$P(LINE,U,2)
 . S DESC=$P(LINE,U,3)
 . I CPT'="",SCT'="" D
 . . S ^SYN("2002.030","sct2cpt","direct",SCT,CPT)=DESC
 . . S ^SYN("2002.030","sct2cpt","inverse",CPT,SCT)=DESC
 ;
 QUIT
 ;
LOADHF ;load ^SYN mapping table for SCT to health factors
 N IDX,LINE,SCT,HFIEN,DESC
 K ^SYN("2002.030","sct2hf")
 S IDX=0
 F  S IDX=IDX+1,LINE=$P($T(SCT2HF+IDX),";;",2) QUIT:LINE="zzzzz"  D
 . S SCT=$P(LINE,U,1)
 . S HFIEN=$P(LINE,U,2)
 . S DESC=$P(LINE,U,3)
 . I SCT'="",HFIEN'="" D
 . . S ^SYN("2002.030","sct2hf","direct",SCT,HFIEN)=DESC
 . . S ^SYN("2002.030","sct2hf","inverse",HFIEN,SCT)=DESC
 ;
 QUIT
 ;
LOADVIT ;load ^SYN mapping table for SCT to health factors
 ; VistA Vital Type (file 120.51)
 N IDX,LINE,SCT,VITIEN,DESC
 K ^SYN("2002.030","sct2vit")
 S IDX=0
 F  S IDX=IDX+1,LINE=$P($T(SCT2VIT+IDX),";;",2) QUIT:LINE="zzzzz"  D
 . S SCT=$P(LINE,U,1)
 . S VITIEN=$P(LINE,U,2)
 . S DESC=$P(LINE,U,3)
 . I SCT'="",VITIEN'="" D
 . . S ^SYN("2002.030","sct2vit","direct",SCT,VITIEN)=DESC
 . . S ^SYN("2002.030","sct2vit","inverse",VITIEN,SCT)=DESC
 ;
 QUIT
 ;
LOADPOS ;load ^SYN mapping table for care team positions
 N IDX,POSITION,POSID,POSNAME,SNOMED
 K ^SYN("2002.030","ctpos2sct")
 S IDX=0
 F  S IDX=IDX+1,POSITION=$P($T(POSSCT+IDX),";;",2) QUIT:POSITION="zzzzz"  D
 . S POSID=$P(POSITION,U,1)
 . S POSNAME=$P(POSITION,U,2)
 . S SNOMED=$P(POSITION,U,3)
 . S:(POSID'="")&(SNOMED'="") ^SYN("2002.030","ctpos2sct","direct",POSID,SNOMED)=""
 . S:(POSNAME'="")&(SNOMED'="") ^SYN("2002.030","ctpos2sct","direct",POSNAME,SNOMED)=""
 . S:(POSID'="")&(SNOMED'="") ^SYN("2002.030","ctpos2sct","inverse",SNOMED,POSID)=""
 ;
 QUIT
 ;
LOADFLAG ;load ^SYN mapping table for patient flags
 N IDX,FLAGS,FLAGID,FLAGNAME,SNOMED
 K ^SYN("2002.030","flag2sct")
 S IDX=0
 F  S IDX=IDX+1,FLAGS=$P($T(FLAGSCT+IDX),";;",2) QUIT:FLAGS="zzzzz"  D
 . S FLAGID=$P(FLAGS,U,1)
 . S FLAGNAME=$P(FLAGS,U,3)
 . S SNOMED=$P(FLAGS,U,2)
 . S:(FLAGID'="")&(SNOMED'="") ^SYN("2002.030","flag2sct","direct",FLAGID,SNOMED)=FLAGNAME
 . S:(FLAGID'="")&(SNOMED'="") ^SYN("2002.030","flag2sct","inverse",SNOMED,FLAGID)=FLAGNAME
 ;
 QUIT
 ;
MHLOINC ; id^name^loinc
 ;;5^AUDC^
 ;;11^BDI2^89209-1
 ;;^CESD-R^89205-9
 ;;159^GAD-7^70274-6
 ;;89^GDS^48544-1
 ;;65^MORSE FALL SCALE^59460-6
 ;;56^PC PTSD^71754-6
 ;;71^PHQ-2^55758-7
 ;;42^PHQ9^44249-1
 ;;177^VR-12^72009-4
 ;;^VR-12 T score^72017-7
 ;;^Suicide Risk^89560-7
 ;;^PROMIS-10 score^71970-8
 ;;^PROMIS-10 T score^71969-0
 ;;^PCLC^70221-7
 ;;zzzzz
 ;
MHSNOMED ; id^name^sct^desc
 ;;71^PHQ-2^454711000124102^Depression screening using Patient Health Questionnaire Two-Item score (procedure)
 ;;42^PHQ9^715252007^Depression screening using Patient Health Questionnaire Nine Item score (procedure)
 ;;zzzzz
 ;
CPT2SCT ; cpt^sct^cpt desc
 ;;10060^428297005^Excision of Cyst
 ;;11000^19780006^Debridement of Infection of Skin
 ;;20225^56241004^Bone Marrow Biopsy
 ;;27299^28181007^Operation on hip joint
 ;;44391^73761001^Colonoscopy
 ;;47562^45595009^Laparoscopic cholecystectom
 ;;49315^80146002^Appendectomy
 ;;55250^22523008^Vasectomy
 ;;64721^10431008^Neuroplasty of median nerve at carpal tunnel
 ;;77056^71388002^Mammogram Both Breasts
 ;;99201^185347001^Office/outpatient visit new
 ;;99202^185349003^Office/outpatient visit new
 ;;99205^308335008^Office/outpatient visit new
 ;;99213^185345009^Office/outpatient visit est
 ;;99238^308646001^Hospital discharge day
 ;;99241^394701000^Office consultation
 ;;99281^50849002^Emergency dept visit
 ;;99285^4525004^Emergency dept visit
 ;;99381^183478001^INIT PM E/M NEW PAT INF
 ;;99383^170258001^PREV VISIT NEW AGE 5-11
 ;;99408^105355005^AUDIT/DAST 15-30 MIN
 ;;59426^424441002^ANTEPARTUM CARE ONLY
 ;;99218^183460006^INITIAL OBSERVATION CARE
 ;;59425^424619006^ANTEPARTUM CARE ONLY
 ;;55810^10492003^EXTENSIVE PROSTATE SURGERY
 ;;77427^84755001^RADIATION TX MANAGEMENT X5
 ;;59400^10745001^OBSTETRICAL CARE
 ;;66840^10178000^REMOVAL OF LENS MATERIAL
 ;;44388^12350003^COLONOSCOPY THRU STOMA SPX
 ;;27130^15163009^TOTAL HIP ARTHROPLASTY
 ;;59409^177184002^OBSTETRICAL CARE
 ;;27447^179344006^TOTAL KNEE ARTHROPLASTY
 ;;65235^13767004^REMOVE FOREIGN BODY FROM EYE
 ;;90937^108241001^HEMODIALYSIS REPEATED EVAL
 ;;90653^442333005^IIV ADJUVANT VACCINE IM
 ;;45378^444783004^DIAGNOSTIC COLONOSCOPY
 ;;D1206^234723000^TOPICAL FLUORIDE VARNISH
 ;;59514^11466000^Cesarean Section    CESAREAN DELIVERY ONLY
 ;;S9473^15081005^Pulmonary rehabilitation (regime/therapy)  PULMONARY REHABILITATION PROGRAM
 ;;99221^32485007^Hospital Admission                INITIAL HOSPITAL CARE
 ;;99282^50849002^Emergency Room Admission
 ;;zzzzz
 ;;10120^^Remove foreign body
 ;;99211^^Office/outpatient visit established
 ;                                                           CPT SHORT NAME
 ;;59514^11466000^Cesarean Section                           CESAREAN DELIVERY ONLY
 ;;S9473^15081005^Pulmonary rehabilitation (regime/therapy)  PULMONARY REHABILITATION PROGRAM
 ;;99221^32485007^Hospital Admission                         INITIAL HOSPITAL CARE
 ;;99222^32485007^Hospital Admission
 ;;99223^32485007^Hospital Admission
 ;;99282^50849002^Emergency Room Admission
 ;;99283^50849002^Emergency Room Admission
 ;;99284^50849002^Emergency Room Admission
 ;;99285^50849002^Emergency Room Admission
 ;
 ;CPT2SCT ; cpt^sct^cpt desc
 ;;10060^428297005^Excision of Cyst
 ;;11000^19780006^Debridement of Infection of Skin
 ;;20225^56241004^Bone Marrow Biopsy
 ;;27299^28181007^Operation on hip joint
 ;;44391^73761001^Colonoscopy
 ;;47562^45595009^Laparoscopic cholecystectomy
 ;;49315^80146002^Appendectomy
 ;;55250^22523008^Vasectomy
 ;;64721^10431008^Neuroplasty of median nerve at carpal tunnel
 ;;77056^71388002^Mammogram Both Breasts
 ;;99201^185347001^Office/outpatient visit new
 ;;99202^185349003^Office/outpatient visit new
 ;;99205^308335008^Office/outpatient visit new
 ;;99213^185345009^Office/outpatient visit est
 ;;99238^308646001^Hospital discharge day
 ;;99241^394701000^Office consultation
 ;;99281^50849002^Emergency dept visit
 ;;99285^4525004^Emergency dept visit
 ;;99381^183478001^INIT PM E/M NEW PAT INF
 ;;99383^170258001^PREV VISIT NEW AGE 5-11
 ;;99408^105355005^
 ;;59426^424441002^
 ;;99218^183460006^
 ;;59425^424619006^
 ;;55810^10492003^
 ;;77427^84755001^
 ;;59400^10745001^
 ;;66840^10178000^
 ;;44388^12350003^
 ;;27130^15163009^
 ;;59409^177184002^
 ;;27447^179344006^
 ;;65235^13767004^
 ;;90937^108241001^
 ;;90653^442333005^
 ;;45378^444783004^
 ;;D1206^234723000^
 ;;zzzzz
 ;;10120^^Remove foreign body
 ;;99211^^Office/outpatient visit established
 ;
SCT2HF ; sct^hf ien^desc
 ;;266919005^5^Never smoked tobacco
 ;;405746006^2^Current non-smoker
 ;;8517006^4^Ex-smoker
 ;;266890009^15^Family History of Alcoholism
 ;;219006^12^Current drinker of alcohol
 ;;371434005^13^History of alcohol abuse
 ;;zzzzz
 ;
SCT2VIT ; sct^vital ien^desc  (VistA Vital Type (file 120.51))
 ;;27113001^9^Body weight
 ;;50373000^8^Body height
 ;;75367002^1^Blood pressure
 ;;78564009^5^Pulse rate
 ;;386725007^2^Body Temperature
 ;;86290005^3^Respiration
 ;;48094003^10^Abdominal girth measurement
 ;;21727005^11^Audiometry
 ;;252465000^21^Pulse oximetry
 ;;22253000^22^Pain
 ;;zzzzz
 ;
POSSCT ; id^name^sct
 ;;45^ADDICTION THERAPIST^
 ;;46^ADDICTION THERAPIST (MHTC)^
 ;;13^ADMIN COORDINATOR^106331006
 ;;56^ADMINISTRATIVE ASSOCIATE^224608005
 ;;58^ADVANCE PRACTICE ASSOCIATE PROVIDER^
 ;;71^ADVANCE PRACTICE NURSE^
 ;;72^ADVANCE PRACTICE NURSE (MHTC)^
 ;;57^ANTICOAG CLINICAL PHARMACIST^
 ;;59^ASSOCIATE PROVIDER^
 ;;26^CARE MANAGER^184154008
 ;;28^CASE MANAGER^768832004^nurse case manager 445451001
 ;;43^CHAPLAIN^225725005
 ;;44^CHAPLAIN (MHTC)^225725005
 ;;60^CLINICAL ASSOCIATE^
 ;;22^CLINICAL NURSE SPECIALIST^
 ;;37^CLINICAL NURSE SPECIALIST (MHTC)^
 ;;8^CLINICAL PHARMACIST^734293001
 ;;38^CLINICAL PHARMACIST (MHTC)^734293001
 ;;30^DESIGNATED WOMEN'S HEALTH PROVIDER
 ;;61^FELLOW^
 ;;27^HEALTH TECHNICIAN^
 ;;17^INTERN (PHYSICIAN)^
 ;;73^LEAD COORDINATOR^76882100
 ;;39^LPC^
 ;;40^LPC (MHTC)^
 ;;19^MAS CLERK^
 ;;18^MEDICAL STUDENT^398130009
 ;;41^MFT^
 ;;42^MFT (MHTC)^
 ;;7^NURSE (LPN)^442251000124100
 ;;62^NURSE (LVN)^
 ;;6^NURSE (RN)^224535009
 ;;47^NURSE (RN) (MHTC)^224563006
 ;;4^NURSE PRACTITIONER^224571005
 ;;35^NURSE PRACTITIONER (MHTC)^224571005
 ;;63^NURSE PRACTITIONER ASSOCIATE PROVIDER^
 ;;48^OCCUPATIONAL THERAPIST^80546007
 ;;49^OCCUPATIONAL THERAPIST (MHTC)^80546007
 ;;15^OTHER^
 ;;21^PACT CLINICAL PHARMACIST^734293001
 ;;14^PATIENT SERVICES ASSISTANT^
 ;;64^PEER SUPPORT APPRENTICE^
 ;;65^PEER SUPPORT SPECIALIST^
 ;;74^PEER SUPPORT SPECIALIST (MHTC)^
 ;;55^PEER SUPPORT STAFF^
 ;;5^PHYSICIAN ASSISTANT^449161006
 ;;36^PHYSICIAN ASSISTANT (MHTC)^449161006
 ;;66^PHYSICIAN ASSISTANT ASSOCIATE PROVIDER^
 ;;1^PHYSICIAN-ATTENDING^405279007
 ;;2^PHYSICIAN-PRIMARY CARE^446050000
 ;;10^PHYSICIAN-PSYCHIATRIST^80584001
 ;;34^PHYSICIAN-PSYCHIATRIST (MHTC)^80584001
 ;;3^PHYSICIAN-SUBSPECIALTY^
 ;;67^PRIMARY CARE PROVIDER^453231000124104
 ;;11^PSYCHOLOGIST^59944000
 ;;31^PSYCHOLOGIST (MHTC)^59944000
 ;;53^RECREATION THERAPIST^
 ;;54^RECREATION THERAPIST (MHTC)^
 ;;20^REGISTERED DIETITIAN^309399009
 ;;12^REHAB/PSYCH TECHNICIAN^
 ;;33^REHAB/PSYCH TECHNICIAN (MHTC)^
 ;;16^RESIDENT (PHYSICIAN)^309360001
 ;;9^SOCIAL WORKER^158950001
 ;;32^SOCIAL WORKER (MHTC)^80292009
 ;;68^SURROGATE CARE MANAGER^184154008
 ;;70^SURROGATE CLINICAL ASSOCIATE^
 ;;69^SURROGATE PRIMARY CARE PROVIDER^453231000124104
 ;;25^TCM CLINICAL CASE MANAGER^
 ;;24^TCM PROGRAM MANAGER^
 ;;23^TCM TRANSITION PATIENT ADVOCATE^
 ;;29^TRAINEE^
 ;;50^VOC REHAB SPEC/COUNSELOR^
 ;;51^VOC REHAB SPEC/COUNSELOR (MHTC)^
 ;;zzzzz
 ;
FLAGSCT ;
 ;;FALL RISK^129839007^Fall Risk
 ;;WANDERER^704448006^Wanderer
 ;;BEHAVIORAL^277843001^Behavioral
 ;;HIGH RISK FOR SUICIDE^394685004^High risk for suicide
 ;;zzzzz
 ;
LOADREF(MH2LOINC,LOINC2MH,MH2SNOMED) ;load temp code arrays
 N IDX,INSTRU,LOINCODE,TESTID,TESTNAME,LOINC
 ;LOINC
 S IDX=0
 F  S IDX=IDX+1,INSTRUMT=$P($T(LOINC+IDX),";;",2) Q:INSTRUMT="zzzzz"  D
 . S TESTID=$P(INSTRUMT,U,1)
 . S TESTNAME=$P(INSTRUMT,U,2)
 . S LOINC=$P(INSTRUMT,U,3)
 . S:TESTID'="" MH2LOINC(TESTID)=LOINC
 . S:TESTNAME'="" MH2LOINC(TESTNAME)=LOINC
 . S:LOINC'="" LOINC2MH(LOINC)=TESTID_U_TESTNAME
 ;SNOMED
 S IDX=0
 F  S IDX=IDX+1,INSTRUMT=$P($T(SNOMED+IDX),";;",2) Q:INSTRUMT="zzzzz"  D
 . S TESTID=$P(INSTRUMT,U,1)
 . S TESTNAME=$P(INSTRUMT,U,2)
 . S SNOMED=$P(INSTRUMT,U,3)
 . S:TESTID'="" MH2SNOMED(TESTID)=SNOMED
 . S:TESTNAME'="" MH2SNOMED(TESTNAME)=SNOMED
 ;
 QUIT
 ;
PRCSCT ; CPT to SNOMED CT map for procedures
 K SCTA,SCTX
 S SCTA(308335008)="99205^OFFICE VISIT"
 S SCTA(428297005)="10060^Excision of Cyst"
 S SCTA(22523008)="55250^Vasectomy"
 S SCTA(73761001)="44391^Colonoscopy"
 S SCTA(56241004)="20225^Bone Marrow Biopsy"
 S SCTA(10431008)="64721^Neuroplasty of median nerve at carpal tunnel"
 S SCTA(28181007)="27299^Operation on hip joint"
 S SCTA(80146002)="49315^Appendectomy"
 S SCTA(19780006)="11000^Debridement of Infection of Skin"
 S SCTA(45595009)="47562^Laparoscopic cholecystectomy"
 ; map incoming SNOMED CT code to VistA Vital Type (file 120.51)
 S SCTX("10060")="428297005^Excision of Cyst"
 S SCTX("20225")="56241004^Bone Marrow Biopsy"
 S SCTX("27299")="28181007^Operation on hip joint"
 S SCTX("44391")="73761001^Colonoscopy"
 S SCTX("49315")="80146002^Appendectomy"
 S SCTX("55250")="22523008^Vasectomy"
 S SCTX("64721")="10431008^Neuroplasty of median nerve at carpal tunnel"
 S SCTX("11000")="19780006^Debridement of Infection of Skin"
 S SCTX("47562")="45595009^Laparoscopic cholecystectomy"
 Q
 ;
HLFSCT ; SNOMED CT MAP for health factors
 K SCTA,SCTX
 S SCTA(266919005)="5^Never smoked tobacco"
 S SCTA(405746006)="2^Current non-smoker"
 S SCTA(8517006)="4^Ex-smoker"
 S SCTA(266890009)="15^Family History of Alcoholism"
 S SCTA(219006)="12^Current drinker of alcohol"
 S SCTA(371434005)="13^History of alcohol abuse"
 ; map incoming SNOMED CT code to VistA Vital Type (file 120.51)
 S SCTX("5")="266919005^Never smoked tobacco"
 S SCTX("2")="405746006^Current non-smoker"
 S SCTX("4")="8517006^Ex-smoker"
 S SCTX("15")="266890009^Family History of Alcoholism"
 S SCTX("13")="371434005^History of Alcoholism"
 S SCTX("12")="219009^Current drinker of alcohol"
 Q
 ;
