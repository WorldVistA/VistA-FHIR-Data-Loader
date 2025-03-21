SYNQLDM ; GPL/GPL - QRDA loader entry routines ;2018-08-17  3:25 PM
 ;;0.7;VISTA SYN DATA LOADER;;Mar 18, 2025
 ;
 ; Copyright (c) 2016-2018 George P. Lilly
 ; Copyright (c) 2025 DocMe360 LLC
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
 Q
 ;
INITMAPS        ; initialize maps
 N G
 S G=$NA(^XTMP("SYNQLD","MAPS"))
 K @G
 N MAP
 ; SOP (payment?)
 S MAP="SOP"
 S @G@(MAP,"CODE","394","OTHER")=""
 ; race
 S MAP="race"
 S @G@(MAP,"CODE","1002-5","AMERICAN INDIAN OR ALASKA NATI")=""
 S @G@(MAP,"CODE","2028-9","ASIAN")=""
 S @G@(MAP,"CODE","2054-5","BLACK OR AFRICAN AMERICAN")=""
 S @G@(MAP,"CODE","2076-8","NATIVE HAWAIIAN OR OTHER PACIFIC ISLANDER")=""
 S @G@(MAP,"CODE","2106-3","WHITE")=""
 S @G@(MAP,"CODE","213101","DECLINED TO SPECIFY")=""
 S @G@(MAP,"CODE","9999-4","UNKNOWN BY PATIENT")=""
 ; ethnicity
 S MAP="ethnicity"
 S @G@(MAP,"CODE","21350-2","HISPANIC OR LATINO")=""
 S @G@(MAP,"CODE","2186-5","NOT HISPANIC OR LATINO")=""
 S @G@(MAP,"CODE","213101","DECLINED TO ANSWER")=""
 ; Health Factors - SNOMED
 S MAP="HF"
 S @G@(MAP,"CODE","4525004","ED [ARRIVAL-DEPARTURE] TIME")=""
 S @G@(MAP,"CODE","1748006","VTE COMFIRMED")=""
 S @G@(MAP,"CODE","10378005","TIME DECISION TO ADMIT MADE")=""
 S @G@(MAP,"CODE","225337009","SUICIDE RISK ASSESSMENT")=""
 S @G@(MAP,"CODE","428191000124101","DOCUMENTATION OF CURRENT MEDS")=""
 S @G@(MAP,"CODE","371530004","CLINICAL CONSULTATION REPORT")=""
 S @G@(MAP,"CODE","428171000124102","ADOLESCENT DEPRESSION SCREEN NEGATIVE")=""
 S @G@(MAP,"CODE","428231000124106","MATERNAL POSTPARTUM DEPRESSION CARE")=""
 S @G@(MAP,"CODE","428341000124108","MACULAR EDEMA ABSENT")=""
 S @G@(MAP,"CODE","193350004","MACULAR EDEMA PRESENT")=""
 S @G@(MAP,"CODE","417886001","TREATMENT ADJUSTED PER PROTOCOL")=""
 S @G@(MAP,"CODE","105480006","WRITTEN INFORMATION NOT GIVEN")=""
 S @G@(MAP,"CODE","413318004","WRITTEN INFORMATION GIVEN")=""
 S @G@(MAP,"CODE","226789007","BREAST MILK ADMINISTERED")=""
 S @G@(MAP,"CODE","105480006","PATIENT REFUSED TREATMENT")=""
 S @G@(MAP,"CODE","428171000124102","ADULT DEPRESSION SCREEN")=""
 S @G@(MAP,"CODE","183932001","PROCEDURE CONTRAINDICATED")=""
 ; Health Factors - LOINC
 S @G@(MAP,"CODE","38208-5","STANDARD PAIN ASSMNT TOOL")=""
 S @G@(MAP,"CODE","44249-1","PHQ-9 RESULT")=""
 S @G@(MAP,"CODE","71955-9","PROMIS-29: ")=""
 S @G@(MAP,"CODE","71938-5","MLHFQ")=""
 S @G@(MAP,"CODE","71955-9","PROMIS-29")=""
 S @G@(MAP,"CODE","58151-2","BIMS SCORE")=""
 S @G@(MAP,"CODE","73830-2","FALL RISK ASSESSMENT")=""
 S @G@(MAP,"CODE","73831-0","ADOLESCENT DEPRESSION SCREEN")=""
 S @G@(MAP,"CODE","73832-8","ADULT DEPRESSION SCREEN")=""
 S @G@(MAP,"CODE","69981-9","ASTHMA ACTION PLAN")=""
 ; Encounters - SNOMED
 S MAP="encounters"
 ;S @G@(MAP,"CODE","183452005","IP")=""
 S @G@(MAP,"CODE","185349003","OP")=""
 ;S @G@(MAP,"CODE","4525004","ER")=""
 ;S @G@(MAP,"CODE","10197000","PS")=""
 ;S @G@(MAP,"CODE","10378005","IP")=""
 S @G@(MAP,"CODE","108313002","OP")=""
 ;S @G@(MAP,"CODE","171047005","IO")=""
 ;S @G@(MAP,"CODE","32485007","IP")=""
 ;S @G@(MAP,"CODE","305351004","ICU")=""
 ;S @G@(MAP,"CODE","112689000","IP")=""
 ;S @G@(MAP,"CODE","8715000","IP")=""
 ; Encounters - CPT
 S @G@(MAP,"CODE","92002","OP")=""
 ;S @G@(MAP,"CODE","96150","PS")=""
 S @G@(MAP,"CODE","99201","OP")=""
 ;S @G@(MAP,"CODE","99285","ER")=""
 ;S @G@(MAP,"CODE","90791","PS")=""
 S @G@(MAP,"CODE","99202","OP")=""
 ;S @G@(MAP,"CODE","99285","ER")=""
 S @G@(MAP,"CODE","99381","OP")=""
 ; location
 S MAP="location"
 ;S @G@(MAP,"CODE","OP","CLINIC A")=""
 ;S @G@(MAP,"CODE","OP","VISTA HEALTH CARE")=""
 S @G@(MAP,"CODE","OP","GENERAL MEDICINE")=""
 S @G@(MAP,"CODE","ER","EMERGENCY DEPT")=""
 S @G@(MAP,"CODE","IP","CERT MED SURG")=""
 S @G@(MAP,"CODE","ICU","CERT ICU")=""
 S @G@(MAP,"CODE","PS","CLINIC A")=""
 ; roombed
 S MAP="roombed"
 S @G@(MAP,"CODE","IP","M1-A")=""
 S @G@(MAP,"CODE","ICU","1-A")=""
 S @G@(MAP,"CODE","PS","CLINIC PSYCHIATRY")=""
 ; provider
 S MAP="provider"
 ;S @G@(MAP,"CODE","OP","CQM,HISTORICAL MD")=""
 ;S @G@(MAP,"CODE","OP","USER,THREE")=""
 S @G@(MAP,"CODE","OP","9990000348")=""
 S @G@(MAP,"CODE","ER","CQM,HISTORICAL MD")=""
 S @G@(MAP,"CODE","IP","CQM,HISTORICAL MD")=""
 S @G@(MAP,"CODE","ICU","CQM,HISTORICAL MD")=""
 S @G@(MAP,"CODE","PS","CQM,HISTORICAL MD")=""
 ; admitting regulation
 S MAP="regs"
 S @G@(MAP,"CODE","IP","OBSERVATION (AND) EXAMINATION")=""
 S @G@(MAP,"CODE","ICU","OBSERVATION (AND) EXAMINATION")=""
 ; facility treating speciality
 S MAP="facilityTreatingSpeciality"
 S @G@(MAP,"CODE","IP","MEDICAL OBSERVATION")=""
 S @G@(MAP,"CODE","ICU","MEDICAL OBSERVATION")=""
 ; discharge type
 S MAP="dischargeType"
 S @G@(MAP,"CODE","10161009","DISCHARGE TO HOME OR POLICE CU")=""
 ; vitals
 S MAP="vitals"
 S @G@(MAP,"CODE","8462-4","BLOOD PRESSURE")=""
 S @G@(MAP,"CODE","8480-6","BLOOD PRESSURE")=""
 S @G@(MAP,"CODE","39156-5","BMI")=""
 ; VPatientEd
 S MAP="vPatientEd"
 S @G@(MAP,"CODE","11816003","DIET EDUCATION")=""
 S @G@(MAP,"CODE","171047005","DRUGS OF ADDICTION EDUCATION")=""
 ; consults
 S MAP="consults"
 S @G@(MAP,"CODE","103697008","DENTAL")=""
 S @G@(MAP,"CODE","171047005","PHYSICAL REHAB")=""
 ; rad orders - LOINC
 S MAP="rad"
 S @G@(MAP,"CODE","24533-2","ABDOMINAL VESSELS MRI ANGIOGRAM W/CON  IV")=""
 S @G@(MAP,"CODE","24604-1","BREAST MAMMOGRAM DIAGNOSTIC LIMITED")=""
 S @G@(MAP,"CODE","25031-6","BONE SCAN")=""
 S @G@(MAP,"CODE","24665-2","SACRUM AND COCCYX X-RAY")=""
 ; rad orders - SNOMED
 S @G@(MAP,"CODE","113094008","DIAGNOSTIC RADIOGRAPHY OF CHEST, LATERAL")=""
 S @G@(MAP,"CODE","168731009","CHEST XRAY")=""
 S @G@(MAP,"CODE","1748006","VTE Confirmed.")=""
 ; immunizations - CVX
 S MAP="immunizations"
 S @G@(MAP,"CODE","3","MEASLES,MUMPS,RUBELLA (MMR)")=""
 S @G@(MAP,"CODE","8","HEPATITIS B")=""
 S @G@(MAP,"CODE","10","POLIOMYELITIS")=""
 S @G@(MAP,"CODE","20","DIP-TET-a/PERT")=""
 S @G@(MAP,"CODE","21","VARICELLA")=""
 S @G@(MAP,"CODE","33","PNEUMOCOCCAL CONJUGATE PCV23")=""
 S @G@(MAP,"CODE","48","HIB,PRP-T")=""
 S @G@(MAP,"CODE","83","HEPA,PED/ADOL-2")=""
 S @G@(MAP,"CODE","104","HEPA/HEPB ADULT")=""
 S @G@(MAP,"CODE","111","FLU,NASAL")=""
 S @G@(MAP,"CODE","116","ROTOVIRUS,ORAL")=""
 S @G@(MAP,"CODE","140","INFLUENZA")=""
 ; immunizations - SNOMED
 S @G@(MAP,"CODE","442333005","INFLUENZA")=""
 ; VExam LOINC
 S MAP="vExam"
 S @G@(MAP,"CODE","24604-1","MAMMOGRAM")=""
 S @G@(MAP,"CODE","32451-7","MACULAR EXAM")=""
 S @G@(MAP,"CODE","44249-1","PHQ-9 RESULT")=""
 S @G@(MAP,"CODE","54108-6","NEONATAL HEARING EXAM")=""
 S @G@(MAP,"CODE","54109-4","NEONATAL HEARING EXAM")=""
 S @G@(MAP,"CODE","57254-5","FALL RISK ASSESSMENT")=""
 S @G@(MAP,"CODE","58151-2","BIMS SCORE")=""
 S @G@(MAP,"CODE","65853-4","CARDIOVASCULAR RISK")=""
 S @G@(MAP,"CODE","71484-0","CUP TO DISK RATIO EXAM")=""
 S @G@(MAP,"CODE","71486-5","OPTIC DISK EXAM")=""
 S @G@(MAP,"CODE","71938-5","MLHFQ")=""
 S @G@(MAP,"CODE","71955-9","PROMIS-29:")=""
 S @G@(MAP,"CODE","73831-0","ADOLESCENT DEPRESSION SCREEN NEGATIVE")=""
 ; VExam - SNOMED
 S @G@(MAP,"CODE","225337009","SUICIDE RISK ASSESSMENT")=""
 S @G@(MAP,"CODE","91161007","PULSE FOOT EXAM")=""
 S @G@(MAP,"CODE","134388005","DIABETIC FOOT EXAM")=""
 S @G@(MAP,"CODE","252779009","DILATED EYE EXAM")=""
 S @G@(MAP,"CODE","401191002","DIABETIC FOOT CHECK")=""
 S @G@(MAP,"CODE","419775003","VISION EXAM")=""
 S @G@(MAP,"CODE","412726003","LENGTH OF GESTATION AT BIRTH")=""
 S @G@(MAP,"CODE","44413500","ESTIMATED FETAL GESTATIONAL AGE")=""
 S @G@(MAP,"CODE","417491009","NEONATAL HEARING EXAM")=""
 ; VCPT - CPT
 S MAP="vCPT"
 S @G@(MAP,"CODE","99201","OP")=""
 S @G@(MAP,"CODE","90791","PS")=""
 S @G@(MAP,"CODE","99202","OP")=""
 S @G@(MAP,"CODE","99381","OP")=""
 ; VCPT - SNOMED
 ; Commented out by OSE/SMH
 ; Use OS5 instead
 ;S MAP="sct2cpt"
 ;S @G@(MAP,"CODE","394701000","99241")=""
 ;S @G@(MAP,"CODE","170258001","99382")=""
 ;S @G@(MAP,"CODE","371883000","99201")=""
 ;S @G@(MAP,"CODE","185347001","99201")=""
 ;S @G@(MAP,"COD,E""183478001","99381")=""
 ;S @G@(MAP,"CODE","308646001","99238")=""
 ;S @G@(MAP,"CODE","424441002","59426")=""
 ;S @G@(MAP,"CODE","183460006","99218")=""
 ;S @G@(MAP,"CODE","698314001","99241")=""
 ;S @G@(MAP,"CODE","424619006","59425")=""
 ;S @G@(MAP,"CODE","50849002","99281")=""
 ;S @G@(MAP,"CODE","185345009","99213")=""
 ;S @G@(MAP,"CODE","170258001","99383")=""
 ;S @G@(MAP,"CODE","10492003","55810")=""
 ;S @G@(MAP,"CODE","84755001","77427")=""
 ;S @G@(MAP,"CODE","234723000","D1206")=""
 ;S @G@(MAP,"CODE","10745001","59400")=""
 ;S @G@(MAP,"CODE","10178000","66840")=""
 ;S @G@(MAP,"CODE","105355005","99408")=""
 ;S @G@(MAP,"CODE","12350003","44388")=""
 ;S @G@(MAP,"CODE","15163009","27130")=""
 ;S @G@(MAP,"CODE","177184002","59409")=""
 ;S @G@(MAP,"CODE","179344006","27447")=""
 ;S @G@(MAP,"CODE","13767004","65235")=""
 ;S @G@(MAP,"CODE","108241001","90937")=""
 ;S @G@(MAP,"CODE","185349003","99202")=""
 ;S @G@(MAP,"CODE","442333005","90653")=""
 ;S @G@(MAP,"CODE","444783004","45378")=""
 ;S @G@(MAP,"CODE","4525004","99285")=""
 ;S @G@(MAP,"CODE","185349003","99381")=""
 ; labs
 S MAP="labs"
 S @G@(MAP,"CODE","32776-7","URINE BLOOD")=""
 S @G@(MAP,"CODE","5794-3","URINE BLOOD")=""
 S @G@(MAP,"CODE","5902-2","PROTIME")=""
 S @G@(MAP,"CODE","6301-6","INR")=""
 S @G@(MAP,"CODE","10839-9","TROPONIN")=""
 S @G@(MAP,"CODE","89579-7","TROPONIN")=""
 S @G@(MAP,"CODE","2502-3","IRON SATURATION")=""
 S @G@(MAP,"CODE","2500-7","TIBC")=""
 S @G@(MAP,"CODE","2498-4","IRON")=""
 S @G@(MAP,"CODE","2085-9","HDL")=""
 S @G@(MAP,"CODE","34714-6","PT/INR")=""
 S @G@(MAP,"CODE","2093-3","CHOLESTEROL")=""
 S @G@(MAP,"CODE","12773-8","LDL CHOLESTEROL")=""
 S @G@(MAP,"CODE","13457-7","LDL CHOLESTEROL")=""
 S @G@(MAP,"CODE","13056-7","PLATELET COUNT")=""
 S @G@(MAP,"CODE","10524-7","PAP TEST")=""
 S @G@(MAP,"CODE","17856-6","HEMOGLOBIN A1C")=""
 S @G@(MAP,"CODE","17855-8","HEMOGLOBIN A1C")=""
 S @G@(MAP,"CODE","10508-0","PSA")=""
 S @G@(MAP,"CODE","10351-5","HIV 1 RNA")=""
 S @G@(MAP,"CODE","35266-6","GLEASON SCORE")=""
 S @G@(MAP,"CODE","24467-3","CD4 COUNT")=""
 S @G@(MAP,"CODE","20447-9","HIV 1 RNA")=""
 S @G@(MAP,"CODE","19080-1","PREGNANCY TEST")=""
 S @G@(MAP,"CODE","10674-0","HEPATITIS B SURFACE ANTIGEN")=""
 S @G@(MAP,"CODE","2093-3","CHOLESTEROL")=""
 S @G@(MAP,"CODE","12951-0","TRIGLYCERIDES")=""
 S @G@(MAP,"CODE","11268-0","STREPTOZYME")=""
 S @G@(MAP,"CODE","13217-5","CHLAMYDIA CULTURE")=""
 S @G@(MAP,"CODE","14463-4","CHLAMYDIA CULTURE")=""
 S @G@(MAP,"CODE","1742-6","ALT")=""
 S @G@(MAP,"CODE","1751-7","ALBUMIN")=""
 S @G@(MAP,"CODE","17861-6","CALCIUM")=""
 S @G@(MAP,"CODE","18262-6","LDL CHOLESTEROL")=""
 S @G@(MAP,"CODE","1920-8","SGOT")=""
 S @G@(MAP,"CODE","1975-2","TOT. BIL")=""
 S @G@(MAP,"CODE","2028-9","CO2")=""
 S @G@(MAP,"CODE","20454-5","URINE PROTEIN")=""
 S @G@(MAP,"CODE","20505-4","URINE BILIRUBIN")=""
 S @G@(MAP,"CODE","20565-8","CO2")=""
 S @G@(MAP,"CODE","2069-3","CHLORIDE")=""
 S @G@(MAP,"CODE","2075-0","CHLORIDE")=""
 S @G@(MAP,"CODE","21000-5","RDW")=""
 S @G@(MAP,"CODE","2160-0","CREATININE")=""
 S @G@(MAP,"CODE","2339-0","GLUCOSE")=""
 S @G@(MAP,"CODE","2345-7","GLUCOSE")=""
 S @G@(MAP,"CODE","2514-8","URINE KETONES")=""
 S @G@(MAP,"CODE","25428-4","URINE GLUCOSE")=""
 S @G@(MAP,"CODE","2571-8","TRIGLYCERIDE")=""
 S @G@(MAP,"CODE","2823-3","POTASSIUM")=""
 S @G@(MAP,"CODE","2885-2","TOT PROT")=""
 S @G@(MAP,"CODE","2947-0","SODIUM")=""
 S @G@(MAP,"CODE","2951-2","SODIUM")=""
 S @G@(MAP,"CODE","3094-0","UREA NITROGEN")=""
 ;S @G@(MAP,"CODE","32167-9","N/A")=""
 ;S @G@(MAP,"CODE","32207-3","N/A")=""
 S @G@(MAP,"CODE","32623-1","MPV")=""
 ;S @G@(MAP,"CODE","33914-3","SKIP - CALCULATED")=""
 ;S @G@(MAP,"CODE","34533-0","N/A")=""
 S @G@(MAP,"CODE","38483-4","CREATININE")=""
 ;S @G@(MAP,"CODE","44261-6","SKIP - NOT A LAB TEST")=""
 S @G@(MAP,"CODE","4544-3","HCT")=""
 S @G@(MAP,"CODE","49765-1","CALCIUM")=""
 S @G@(MAP,"CODE","5767-9","APPEARANCE")=""
 S @G@(MAP,"CODE","5770-3","URINE BILIRUBIN")=""
 S @G@(MAP,"CODE","5778-6","URINE COLOR")=""
 S @G@(MAP,"CODE","5792-7","URINE GLUCOSE")=""
 S @G@(MAP,"CODE","5797-6","URINE KETONES")=""
 S @G@(MAP,"CODE","5799-2","LEUCOCYTE ESTERASE, URINE")=""
 S @G@(MAP,"CODE","5802-4","NITRITE, URINE")=""
 S @G@(MAP,"CODE","5821-4","URINE WBC/HPF")=""
 S @G@(MAP,"CODE","13945-1","URINE RBC/HPF")=""
 S @G@(MAP,"CODE","5787-7","EPITH CELLS")=""
 S @G@(MAP,"CODE","24124-0","URINE CASTS")=""
 S @G@(MAP,"CODE","8247-9","URINE MUCUS")=""
 S @G@(MAP,"CODE","5769-5","URINE BACTERIA")=""
 S @G@(MAP,"CODE","5803-2","URINE PH")=""
 S @G@(MAP,"CODE","5804-0","URINE PROTEIN")=""
 S @G@(MAP,"CODE","5811-5","SPECIFIC GRAVITY")=""
 ;S @G@(MAP,"CODE","59460-6","SKIP - NOT A LAB TEST")=""
 ;S @G@(MAP,"CODE","59461-4","SKIP - NOT A LAB TEST")=""
 S @G@(MAP,"CODE","6298-4","POTASSIUM")=""
 S @G@(MAP,"CODE","6299-2","UREA NITROGEN")=""
 S @G@(MAP,"CODE","6690-2","WBC")=""
 S @G@(MAP,"CODE","6768-6","ALK PHOS")=""
 S @G@(MAP,"CODE","718-7","HGB")=""
 S @G@(MAP,"CODE","777-3","PLATELET COUNT")=""
 S @G@(MAP,"CODE","785-6","MCH")=""
 S @G@(MAP,"CODE","786-4","MCHC")=""
 S @G@(MAP,"CODE","787-2","MCV")=""
 S @G@(MAP,"CODE","789-8","RBC")=""
 S @G@(MAP,"CODE","20570-8","HCT")=""
 S @G@(MAP,"CODE","19123-9","MAGNESIUM")=""
 S @G@(MAP,"CODE","788-0","RDW-CV")=""
 S @G@(MAP,"CODE","33914-3","COMPUTED CREATININE CLEARANCE")=""
 S @G@(MAP,"CODE","3173-2","PTT")=""
 S @G@(MAP,"CODE","2276-4","FERRITIN")=""
 S @G@(MAP,"CODE","2746-6","PH ")="" ; not a typo, it really has a space
 ; "Leukocytes [#/volume] in Blood","26464-8",11.39 -> WBC (part of CBC)
 S @G@(MAP,"CODE","26464-8","WBC")=""
 ; "Erythrocytes [#/volume] in Blood","26453-1",5.6994 -> RBC (part of CBC)
 S @G@(MAP,"CODE","26453-1","RBC")=""
 ; "Hemoglobin","718-7",14.748 -> HGB (part of CBC)
 ;S @G@(MAP,"CODE","718-7","HGB")="" ; duplicate
 ; "Hematocrit","20570-8",43.417 -> HCT (part of CBC)
 ;S @G@(MAP,"CODE","20570-8","HCT")="" ; duplicate
 ; "MCV","30428-7",89.107 -> MCV (part of CBC)
 S @G@(MAP,"CODE","30428-7","MCV")=""
 ; "RBC Distribution Width","30385-9",13.191 -> RDW (part of CBC)
 S @G@(MAP,"CODE","30385-9","RDW")=""
 ; "Platelet Count","26515-7",183.25 -> PLATELET COUNT (part of CBC)
 S @G@(MAP,"CODE","26515-7","PLATELET COUNT")=""
 ; "Neutrophils/100 leukocytes in Blood by Automated count","770-8",31.284 -> NEUTROPHILS % (not part of panel)
 S @G@(MAP,"CODE","770-8","NEUTROPHILS %")=""
 ; "Lymphocytes/100 leukocytes in Blood by Automated count","736-9",6.5796 -> LYMPHS % (part)
 S @G@(MAP,"CODE","736-9","LYMPHS %")=""
 ; "Monocytes/100 leukocytes in Blood by Automated count","5905-5",10.47 -> MONOS (part)
 S @G@(MAP,"CODE","5905-5","MONOS")=""
 ; "Eosinophils/100 leukocytes in Blood by Automated count","713-8",4.1706 -> EOSINO (part)
 S @G@(MAP,"CODE","713-8","EOSINO")=""
 ; "Basophils/100 leukocytes in Blood by Automated count","706-2",3.5937 -> BASO (part)
 S @G@(MAP,"CODE","706-2","BASO")=""
 ; "Neutrophils [#/volume] in Blood by Automated count","751-8",3.2589 -> NEUTROPHILS ABSOLUTE (not)
 S @G@(MAP,"CODE","751-8","NEUTROPHILS ABSOLUTE")=""
 ; "Lymphocytes [#/volume] in Blood by Automated count","731-0",1.0566 -> LYMPH ABS. (not)
 S @G@(MAP,"CODE","731-0","LYMPH ABS.")=""
 ; "Monocytes [#/volume] in Blood by Automated count","742-7",1.153 -> MONO ABS. (not)
 S @G@(MAP,"CODE","742-7","MONO ABS.")=""
 ; "Eosinophils [#/volume] in Blood by Automated count","711-2",0.22372 -> EOSINO, ABSOLUTE (not)
 S @G@(MAP,"CODE","711-2","EOSINO, ABSOLUTE")=""
 ; "Basophils [#/volume] in Blood by Automated count","704-7",0.22279 -> BASOPHILS, ABSOLUTE (not)
 S @G@(MAP,"CODE","704-7","BASOPHILS, ABSOLUTE")=""
 ; "pH of Arterial blood","2744-1",6.9599 "PH " (WITH A SPACE)
 S @G@(MAP,"CODE","2744-1","PH ")=""
 ; "Carbon dioxide [Partial pressure] in Arterial blood","2019-8",36.523 (PCO2)
 S @G@(MAP,"CODE","2019-8","PCO2")=""
 ; "Oxygen [Partial pressure] in Arterial blood","2703-7",83.922 (PO2)
 S @G@(MAP,"CODE","2703-7","PO2")=""
 ; "Bicarbonate [Moles/volume] in Arterial blood","1960-4",26.323 (HCO3)
 S @G@(MAP,"CODE","1960-4","HCO3")=""
 ; "pH of Venous blood","2746-6",7.4284 "PH " (WITH A SPACE) --- duplicate
 ; "Carbon dioxide [Partial pressure] in Venous blood","2021-4",47.903 (PCO2)
 S @G@(MAP,"CODE","2021-4","PCO2")=""
 ; "Oxygen [Partial pressure] in Venous blood","2705-2",46.124 (PO2)
 S @G@(MAP,"CODE","2705-2","PO2")=""
 ; "Bicarbonate [Moles/volume] in Venous blood","14627-4",22.593 (BICARBONATE (SBC)) (PROBABLY NOT AN EXACT MATCH)
 S @G@(MAP,"CODE","14627-4","BICARBONATE (SBC)")=""
 ; "Carbon dioxide, total [Moles/volume] in Venous blood","2027-1",1.3999 (CO2CT. (TCO2))
 S @G@(MAP,"CODE","2027-1","CO2CT. (TCO2)")=""
 ;
 ; gmr allergies snomed to vuid
 S MAP="gmr-allergies"
 S @G@(MAP,"CODE",419474003,4636980)=""
 S @G@(MAP,"CODE",232347008,4637420)=""
 S @G@(MAP,"CODE",419263009,4636804)=""
 S @G@(MAP,"CODE",418689008,4637448)=""
 ;S @G@(MAP,"CODE",232350006) ; MITE POLEN
 S @G@(MAP,"CODE",300913006,4636953)=""
 S @G@(MAP,"CODE",424213003,4637407)=""
 S @G@(MAP,"CODE",91935009,4636971)=""
 S @G@(MAP,"CODE",91934008,4636976)=""
 S @G@(MAP,"CODE",417532002,4637301)=""
 S @G@(MAP,"CODE",300916003,4538971)=""
 S @G@(MAP,"CODE",91930004,4637287)=""
 S @G@(MAP,"CODE",420174000,4637435)=""
 S @G@(MAP,"CODE",425525006,4636665)=""
 S @G@(MAP,"CODE",714035009,4636951)=""
 ; rxnorm to vuid
 S MAP="rxnorm"
 S @G@(MAP,"CODE",1000097,4002480)=""
 S @G@(MAP,"CODE",313585,4012182)=""
 S @G@(MAP,"CODE",314153,4013783)=""
 S @G@(MAP,"CODE",692876,4025906)=""
 S @G@(MAP,"CODE",577154,4025018)=""
 S @G@(MAP,"CODE",860215,4003764)=""
 S @G@(MAP,"CODE",860221,4003765)=""
 S @G@(MAP,"CODE",151226,4024528)=""
 S @G@(MAP,"CODE",198029,4010104)=""
 S @G@(MAP,"CODE",198030,4010106)=""
 S @G@(MAP,"CODE",198031,4010105)=""
 S @G@(MAP,"CODE",198045,4001216)=""
 S @G@(MAP,"CODE",198046,4001218)=""
 S @G@(MAP,"CODE",198047,4001215)=""
 S @G@(MAP,"CODE",199888,4013030)=""
 S @G@(MAP,"CODE",199889,4013031)=""
 S @G@(MAP,"CODE",199890,4013032)=""
 S @G@(MAP,"CODE",205315,4013343)=""
 S @G@(MAP,"CODE",205316,4013342)=""
 S @G@(MAP,"CODE",250983,4013568)=""
 S @G@(MAP,"CODE",311975,4005637)=""
 S @G@(MAP,"CODE",312036,4001214)=""
 S @G@(MAP,"CODE",314119,4005636)=""
 S @G@(MAP,"CODE",317136,4001217)=""
 S @G@(MAP,"CODE",359817,4016739)=""
 S @G@(MAP,"CODE",359818,4016738)=""
 S @G@(MAP,"CODE",636671,4025534)=""
 S @G@(MAP,"CODE",636676,4025535)=""
 S @G@(MAP,"CODE",749289,4025532)=""
 S @G@(MAP,"CODE",749788,4025533)=""
 S @G@(MAP,"CODE",896100,4010112)=""
 S @G@(MAP,"CODE",966531,4017048)=""
 S @G@(MAP,"CODE",993503,4016940)=""
 S @G@(MAP,"CODE",993518,4017073)=""
 S @G@(MAP,"CODE",993536,4024749)=""
 S @G@(MAP,"CODE",993541,4026567)=""
 S @G@(MAP,"CODE",993550,4029871)=""
 S @G@(MAP,"CODE",993557,4026568)=""
 S @G@(MAP,"CODE",993567,4029870)=""
 S @G@(MAP,"CODE",993681,4029872)=""
 S @G@(MAP,"CODE",998671,4002473)=""
 S @G@(MAP,"CODE",998675,4002474)=""
 S @G@(MAP,"CODE",998679,4002475)=""
 D INITMAPS^SYNFPAN(G)
 N ZI
 S ZI=""
 F  S ZI=$O(@G@(ZI)) Q:ZI=""  D  ;
 . N ZJ S ZJ=""
 . F  S ZJ=$O(@G@(ZI,"CODE",ZJ)) Q:ZJ=""  D  ;
 . . N VAL
 . . S VAL=$O(@G@(ZI,"CODE",ZJ,""))
 . . S @G@(ZI,"VALUE",VAL,ZJ)=""
 . . S @G@("CODE",ZJ,VAL,ZI)=""
 . . S @G@("VALUE",VAL,ZJ,ZI)=""
 Q
 ;
MAP(CDE,MAP)    ; extrinsic returns the Value for the Code in map MAP, which is optional
 N RTN
 N GN S GN=$NA(^XTMP("SYNQLD","MAPS"))
 I '$D(@GN) D INITMAPS
 I $G(CDE)="" Q ""
 I $G(MAP)="" D  Q RTN
 . S RTN=$O(@GN@("CODE",CDE,""))
 I '$D(@GN@(MAP)) S RTN="" Q RTN  ;
 S RTN=$O(@GN@(MAP,"CODE",CDE,""))
 I $O(@GN@(MAP,"CODE",CDE,RTN))'="" S RTN=-1 ; more than one match
 Q RTN
 ;
UNMAP(VAL,MAP)  ; extrinsic returns the Value for the Code in map MAP, which is optional
 N RTN
 N GN S GN=$NA(^XTMP("SYNQLD","MAPS"))
 I '$D(MAP) D  Q RTN
 . S RTN=$O(@GN@("VALUE",VAL,""))
 I '$D(@GN@(MAP)) S RTN="" Q  ;
 S RTN=$O(@GN@(MAP,"VALUE",VAL,""))
 I $O(@GN@(MAP,"VALUE",VAL,RTN))'="" S RTN=-1 ; more than one match
 Q RTN
 ;
GETMAP(RTN,MAP) ; returns an array of the MAP. if MAP is not specified, it returns an
 ; array of the names of all the maps
 N GN S GN=$NA(^XTMP("SYNQLD","MAPS"))
 I '$D(MAP) D  Q  ;
 . N ZI S ZI=""
 . F  S ZI=$O(@GN@(ZI)) Q:ZI=""  D  ;
 . . Q:ZI="CODE"
 . . Q:ZI="VALUE"
 . . S @RTN@(ZI)=""
 I $D(@GN@(MAP)) M @RTN=@GN@(MAP)
 Q
 ;
MAPERR(CDE,MAP,CMT) ; add the map error to the mapping-errors graph
 n meroot s meroot=$$setroot^SYNWD("mapping-errors")
 q:meroot=""
 n meien
 s meien=$o(@meroot@("errors","B",CDE,""))
 i meien="" d  ;
 . s meien=$o(@meroot@("errors"," "),-1)+1
 . s @meroot@("errors",meien,"code")=CDE
 . s @meroot@("errors","B",CDE,meien)=""
 s @meroot@("errors",meien,"map")=$g(MAP)
 i $g(CMT)'="" s @meroot@("errors",meien,"comment")=CMT
 s @meroot@("errors",meien,"count")=$g(@meroot@("errors",meien,"count"))+1
 q
 ;
