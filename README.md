# VistA FHIR Data Loader Project
This project lets you load data from Synthea
(https://synthetichealth.github.io/synthea/) into VistA to produce high quality
synthetic patient data for development and testing.  Other FHIR data sources
are supportable; but are not supported at this time.

DO NOT USE THIS SOFTWARE ON PRODUCTION SYSTEMS. This software is only used to
create patients on test VistA systems.

# Pre-installation Requirements
The Installer DUZ must have the key XUMGR in order to be able to add users to
the systems. You will be blocked from installing if you don't have that
security key.

Disk Space Requirements: We never actually measured how much disk space the
package and each patient takes. However, from experience, loading about 400
full patient histories takes up 100 GB.

Here's a full list of the software you will need. We do not describe how to
install this pre-requisites here.

* Java (JDK only) 11 or newer LTS versions to run Synthea
* Google Chrome or Mozilla Firefox to visualize Synthea Patients
* InterSystems IRIS with the VistA database loaded. This does not have to be
on your own laptop; you can copy the generated Synthea Patients into the
machine that hosts your VistA instance.

# Installation
As of Aug 20th 2018, the official way to install this project is to use the
latest KIDS build in
[releases](https://github.com/WorldVistA/VistA-FHIR-Data-Loader/releases/latest).

The current version is 0.6.

The installer must have the key XUMGR in order to be able to add users to the
systems.

You need to install two KIDS builds: The Dataloader, and the FHIR Importer. See
the [releases](https://github.com/WorldVistA/VistA-FHIR-Data-Loader/releases/latest)
for a link to the KIDS builds.

# Pre-Install Warnings on VEHU
This code exercises so much of the VistA system, that it requires a fully
configured VistA system. The Post-install does a lot of configuration
(Providers, Hospital Locations, Services) but there are some items we cannot
fix that have to do with the configuration of institutions:

- If you see error `<UNDEFINED>VISN+4^SDTMPHLB` during the install, this is
  because your INSTITUTION entry does not have an ASSOCIATION of type "VISN".
  You should add such an association and choose a VISN. E.g.:
```
>>D P^DI


VA FileMan 22.2


Select OPTION: INQUIRE TO FILE ENTRIES



Output from what File: INSTITUTION// 4  INSTITUTION  (5053 entries)
Select INSTITUTION NAME: `500  CAMP MASTER  NY  VAMC  500
Another one:
Standard Captioned Output? Yes//   (Yes)
Include COMPUTED fields:  (N/Y/R/B): NO//  - No record number (IEN), no Computed Fields

NAME: CAMP MASTER                       STATE: NEW YORK                         DISTRICT: 2                             SHORT NAME: CAMP
  VA TYPE CODE: HOSP                    REGION: 1                               STATUS: National
  STREET ADDR. 1: VA MEDICAL CENTER     STREET ADDR. 2: 1 3RD sT.               CITY: ALBANY                            ZIP: 12180-0097
  FACILITY TYPE: VAMC                   DOMAIN: GOLD.VAINNOVATION.US
>>>ASSOCIATIONS: VISN                      PARENT OF ASSOCIATION: VISN 2
  LOCATION TIMEZONE: EASTERN            COUNTRY: USA                            STATION NUMBER: 500
  OFFICIAL VA NAME: ALBANY VA MEDICAL CENTER                                    AGENCY CODE: VA                         REPORTING STATION: CAMP MASTER
  POINTER TO AGENCY: VA
EFFECTIVE DATE: JUL 1,2000              REALIGNED TO: ALBANY, NY (VAMC)
EFFECTIVE DATE: APR 3,2002              NAME (CHANGED FROM): ALBANY
CODING SYSTEM: VASTANUM                 ID: 500
  FACILITY DEA NUMBER: FS3232321        MULTI-DIVISION FACILITY: YES            CURRENT LOCATION: YES
```

- If you see error `<UNDEFINED>SITE+12^VASITE` during the import, this is
  because `STATION NUMBER (TIME SENSITIVE)` entry `7` points to an invalid
  `MEDICAL CENTER DIVISION`. Edit entry `7` with Fileman and pick any valid
  `MEDICAL CENTER DIVISION`.

## Sample Install Transcript
```
VEHU>S DUZ=1

VEHU>D ^XUP

Setting up programmer environment
This is a TEST account.

Terminal Type set to: C-VT100

Select OPTION NAME:
VEHU>D ^XPDIL,^XPDI
Enter a Host File: /github/VistA-DataLoader/VistA/VISTA_DATALOADER_3P1.KID

KIDS Distribution saved on Dec 23, 2024@22:50:58
Comment: VISTA DATALOADER 3.1 v3

This Distribution contains Transport Globals for the following Package(s):
   VISTA DATALOADER 3.1
Distribution OK!

Want to Continue with Load? YES//
Loading Distribution...

   VISTA DATALOADER 3.1
Use INSTALL NAME: VISTA DATALOADER 3.1 to install this Distribution.

Select INSTALL NAME:    VISTA DATALOADER 3.1    12/26/24@20:33:49
     => VISTA DATALOADER 3.1 v3  ;Created on Dec 23, 2024@22:50:58

This Distribution was loaded on Dec 26, 2024@20:33:49 with header of
   VISTA DATALOADER 3.1 v3  ;Created on Dec 23, 2024@22:50:58
   It consisted of the following Install(s):
VISTA DATALOADER 3.1
Checking Install for Package VISTA DATALOADER 3.1

Install Questions for VISTA DATALOADER 3.1

Incoming Files:


   9001      ISI PT IMPORT TEMPLATE  (including data)
Note:  You already have the 'ISI PT IMPORT TEMPLATE' File.
I will OVERWRITE your data with mine.

Want KIDS to Rebuild Menu Trees Upon Completion of Install? NO//


Want KIDS to INHIBIT LOGONs during the install? NO//
Want to DISABLE Scheduled Options, Menu Options, and Protocols? NO//

Enter the Device you want to print the Install messages.
You can queue the install by enter a 'Q' at the device prompt.
Enter a '^' to abort the install.

DEVICE: HOME// ;P-OTHER;  VMS


 Install Started for VISTA DATALOADER 3.1 :
               Dec 26, 2024@20:33:55

Build Distribution Date: Dec 23, 2024

 Installing Routines:..............................................................
               Dec 26, 2024@20:33:55

 Installing Data Dictionaries: ..
               Dec 26, 2024@20:33:55

 Installing Data:
               Dec 26, 2024@20:33:55

 Installing PACKAGE COMPONENTS:

 Installing REMOTE PROCEDURE...........................

 Installing OPTION..
               Dec 26, 2024@20:33:55

 Updating Routine file......

 Updating KIDS files.......

 VISTA DATALOADER 3.1 Installed.
               Dec 26, 2024@20:33:55

 NO Install Message sent
VEHU>D ^XPDIL,^XPDI

Enter a Host File: /github/VistA-FHIR-Data-Loader/kids/VISTA_SYN_DATA_LOADER_0P6.KID

KIDS Distribution saved on Dec 26, 2024@20:10:20
Comment: VISTA SYN DATA LOADER 0.6 v4

This Distribution contains Transport Globals for the following Package(s):
   VISTA SYN DATA LOADER 0.6
Distribution OK!

Want to Continue with Load? YES//
Loading Distribution...

   VISTA SYN DATA LOADER 0.6
Use INSTALL NAME: VISTA SYN DATA LOADER 0.6 to install this Distribution.

Select INSTALL NAME:    VISTA SYN DATA LOADER 0.6    12/26/24@20:34:01
     => VISTA SYN DATA LOADER 0.6 v4  ;Created on Dec 26, 2024@20:10:20

This Distribution was loaded on Dec 26, 2024@20:34:01 with header of
   VISTA SYN DATA LOADER 0.6 v4  ;Created on Dec 26, 2024@20:10:20
   It consisted of the following Install(s):
VISTA SYN DATA LOADER 0.6
Checking Install for Package VISTA SYN DATA LOADER 0.6

Install Questions for VISTA SYN DATA LOADER 0.6

Incoming Files:


   2002.801  GRAPH

Want KIDS to Rebuild Menu Trees Upon Completion of Install? NO//


Want KIDS to INHIBIT LOGONs during the install? NO//
Want to DISABLE Scheduled Options, Menu Options, and Protocols? NO//

Enter the Device you want to print the Install messages.
You can queue the install by enter a 'Q' at the device prompt.
Enter a '^' to abort the install.

DEVICE: HOME// ;p-other;  VMS


 Install Started for VISTA SYN DATA LOADER 0.6 :
               Dec 26, 2024@20:34:41

Build Distribution Date: Dec 26, 2024

 Installing Routines:............................................
               Dec 26, 2024@20:34:41

 Running Pre-Install Routine: PRE^SYNKIDS.

 Installing Data Dictionaries: ..
               Dec 26, 2024@20:34:41

 Installing PACKAGE COMPONENTS:

 Installing OPTION......
               Dec 26, 2024@20:34:41

 Running Post-Install Routine: POST^SYNKIDS.
Merging ^SYN global in. This takes time...


Syn Patients Importer Init
Provider 520824660
Pharmacist 520824661
Hospital Location 23
Fixing AMIE thingy
Fixing IB ACTION TYPE file
Setting up Outpatient Pharmacy 1048
Disabling Allergy Bulletins

 Updating Routine file......

 Updating KIDS files.....

 VISTA SYN DATA LOADER 0.6 Installed.
               Dec 26, 2024@20:34:43

 No link to PACKAGE file

 NO Install Message sent
```

# Usage
To create new synthetic patients from Synthea, and load them into VistA, you
need to perform the following steps (as described below): Create Synthetic
Patients Using Synthea, (optionally) copy the files to where your VistA
instance can reach them on the file system, and then load them into VistA using
the menu options from the top level menu SYNMENU (which is installed as part of
the KIDS build).

## Creating Synthetic Patients
Open up your terminal/command line, and check that java is installed.  Running
`java -version` will verify that it is installed. `-p 10` means produce 10
patients.

```
wget https://github.com/synthetichealth/synthea/releases/download/master-branch-latest/synthea-with-dependencies.jar
java -jar synthea-with-dependencies.jar -p 10
```

Here's the output for reference:

```
> Task :run
Scanned 61 modules and 36 submodules.
Loading submodule C:\Users\User\synthea\build\resources\main\modules\breast_cancer\tnm_diagnosis.json
Loading submodule C:\Users\User\synthea\build\resources\main\modules\allergies\allergy_incidence.json
Loading submodule C:\Users\User\synthea\build\resources\main\modules\dermatitis\moderate_cd_obs.json
Loading submodule C:\Users\User\synthea\build\resources\main\modules\dermatitis\severe_cd_obs.json
Loading submodule C:\Users\User\synthea\build\resources\main\modules\contraceptives\female_sterilization.json
Loading submodule C:\Users\User\synthea\build\resources\main\modules\allergies\outgrow_env_allergies.json
Loading submodule C:\Users\User\synthea\build\resources\main\modules\lung_cancer\lung_cancer_probabilities.json
Loading submodule C:\Users\User\synthea\build\resources\main\modules\contraceptives\patch_contraceptive.json
Loading submodule C:\Users\User\synthea\build\resources\main\modules\allergies\allergy_panel.json
Loading submodule C:\Users\User\synthea\build\resources\main\modules\breast_cancer\surgery_therapy_breast.json
Loading submodule C:\Users\User\synthea\build\resources\main\modules\allergies\severe_allergic_reaction.json
Loading submodule C:\Users\User\synthea\build\resources\main\modules\dermatitis\early_severe_eczema_obs.json
Loading submodule C:\Users\User\synthea\build\resources\main\modules\total_joint_replacement\functional_status_assessments.json
Loading submodule C:\Users\User\synthea\build\resources\main\modules\contraceptives\ring_contraceptive.json
Loading submodule C:\Users\User\synthea\build\resources\main\modules\anemia\anemia_sub.json
Loading submodule C:\Users\User\synthea\build\resources\main\modules\medications\otc_pain_reliever.json
Loading submodule C:\Users\User\synthea\build\resources\main\modules\breast_cancer\hormone_diagnosis.json
Loading submodule C:\Users\User\synthea\build\resources\main\modules\medications\ear_infection_antibiotic.json
Loading submodule C:\Users\User\synthea\build\resources\main\modules\medications\strong_opioid_pain_reliever.json
Loading submodule C:\Users\User\synthea\build\resources\main\modules\allergies\immunotherapy.json
Loading submodule C:\Users\User\synthea\build\resources\main\modules\dermatitis\mid_moderate_eczema_obs.json
Loading submodule C:\Users\User\synthea\build\resources\main\modules\contraceptives\clear_contraceptive.json
Loading submodule C:\Users\User\synthea\build\resources\main\modules\surgery\general_anesthesia.json
Loading submodule C:\Users\User\synthea\build\resources\main\modules\veterans\veteran_suicide_probabilities.json
Loading submodule C:\Users\User\synthea\build\resources\main\modules\contraceptives\oral_contraceptive.json
Loading submodule C:\Users\User\synthea\build\resources\main\modules\medications\moderate_opioid_pain_reliever.json
Loading submodule C:\Users\User\synthea\build\resources\main\modules\medications\otc_antihistamine.json
Loading submodule C:\Users\User\synthea\build\resources\main\modules\dermatitis\mid_severe_eczema_obs.json
Loading submodule C:\Users\User\synthea\build\resources\main\modules\dermatitis\early_moderate_eczema_obs.json
Loading submodule C:\Users\User\synthea\build\resources\main\modules\contraceptives\intrauterine_device.json
Loading submodule C:\Users\User\synthea\build\resources\main\modules\contraceptives\male_sterilization.json
Loading submodule C:\Users\User\synthea\build\resources\main\modules\contraceptives\implant_contraceptive.json
Loading submodule C:\Users\User\synthea\build\resources\main\modules\breast_cancer\hormonetherapy_breast.json
Loading submodule C:\Users\User\synthea\build\resources\main\modules\contraceptives\injectable_contraceptive.json
Loading submodule C:\Users\User\synthea\build\resources\main\modules\allergies\outgrow_food_allergies.json
Loading submodule C:\Users\User\synthea\build\resources\main\modules\breast_cancer\chemotherapy_breast.json
Loading module C:\Users\User\synthea\build\resources\main\modules\opioid_addiction.json
Loading module C:\Users\User\synthea\build\resources\main\modules\dialysis.json
Loading module C:\Users\User\synthea\build\resources\main\modules\allergic_rhinitis.json
Loading module C:\Users\User\synthea\build\resources\main\modules\pregnancy.json
Loading module C:\Users\User\synthea\build\resources\main\modules\atopy.json
Loading module C:\Users\User\synthea\build\resources\main\modules\self_harm.json
Loading module C:\Users\User\synthea\build\resources\main\modules\asthma.json
Loading module C:\Users\User\synthea\build\resources\main\modules\ear_infections.json
Loading module C:\Users\User\synthea\build\resources\main\modules\sinusitis.json
Loading module C:\Users\User\synthea\build\resources\main\modules\dementia.json
Loading module C:\Users\User\synthea\build\resources\main\modules\veteran_hyperlipidemia.json
Loading module C:\Users\User\synthea\build\resources\main\modules\mTBI.json
Loading module C:\Users\User\synthea\build\resources\main\modules\veteran_prostate_cancer.json
Loading module C:\Users\User\synthea\build\resources\main\modules\anemia___unknown_etiology.json
Loading module C:\Users\User\synthea\build\resources\main\modules\urinary_tract_infections.json
Loading module C:\Users\User\synthea\build\resources\main\modules\hypothyroidism.json
Loading module C:\Users\User\synthea\build\resources\main\modules\osteoarthritis.json
Loading module C:\Users\User\synthea\build\resources\main\modules\appendicitis.json
Loading module C:\Users\User\synthea\build\resources\main\modules\copd.json
Loading module C:\Users\User\synthea\build\resources\main\modules\contraceptive_maintenance.json
Loading module C:\Users\User\synthea\build\resources\main\modules\fibromyalgia.json
Loading module C:\Users\User\synthea\build\resources\main\modules\veteran_substance_abuse_treatment.json
Loading module C:\Users\User\synthea\build\resources\main\modules\veteran_lung_cancer.json
Loading module C:\Users\User\synthea\build\resources\main\modules\total_joint_replacement.json
Loading module C:\Users\User\synthea\build\resources\main\modules\rheumatoid_arthritis.json
Loading module C:\Users\User\synthea\build\resources\main\modules\sore_throat.json
Loading module C:\Users\User\synthea\build\resources\main\modules\gallstones.json
Loading module C:\Users\User\synthea\build\resources\main\modules\bronchitis.json
Loading module C:\Users\User\synthea\build\resources\main\modules\sexual_activity.json
Loading module C:\Users\User\synthea\build\resources\main\modules\homelessness.json
Loading module C:\Users\User\synthea\build\resources\main\modules\epilepsy.json
Loading module C:\Users\User\synthea\build\resources\main\modules\wellness_encounters.json
Loading module C:\Users\User\synthea\build\resources\main\modules\injuries.json
Loading module C:\Users\User\synthea\build\resources\main\modules\colorectal_cancer.json
Loading module C:\Users\User\synthea\build\resources\main\modules\med_rec.json
Loading module C:\Users\User\synthea\build\resources\main\modules\congestive_heart_failure.json
Loading module C:\Users\User\synthea\build\resources\main\modules\veteran_self_harm.json
Loading module C:\Users\User\synthea\build\resources\main\modules\veteran_mdd.json
Loading module C:\Users\User\synthea\build\resources\main\modules\lung_cancer.json
Loading module C:\Users\User\synthea\build\resources\main\modules\contraceptives.json
Loading module C:\Users\User\synthea\build\resources\main\modules\osteoporosis.json
Loading module C:\Users\User\synthea\build\resources\main\modules\breast_cancer.json
Loading module C:\Users\User\synthea\build\resources\main\modules\female_reproduction.json
Loading module C:\Users\User\synthea\build\resources\main\modules\veteran.json
Loading module C:\Users\User\synthea\build\resources\main\modules\gout.json
Loading module C:\Users\User\synthea\build\resources\main\modules\metabolic_syndrome_disease.json
Loading module C:\Users\User\synthea\build\resources\main\modules\allergies.json
Loading module C:\Users\User\synthea\build\resources\main\modules\metabolic_syndrome_care.json
Loading module C:\Users\User\synthea\build\resources\main\modules\lupus.json
Loading module C:\Users\User\synthea\build\resources\main\modules\attention_deficit_disorder.json
Loading module C:\Users\User\synthea\build\resources\main\modules\cystic_fibrosis.json
Loading module C:\Users\User\synthea\build\resources\main\modules\dermatitis.json
Loading module C:\Users\User\synthea\build\resources\main\modules\food_allergies.json
Loading module C:\Users\User\synthea\build\resources\main\modules\veteran_ptsd.json
Loading module C:\Users\User\synthea\build\resources\main\modules\veteran_substance_abuse_conditions.json
Loading module C:\Users\User\synthea\build\resources\main\modules\hypertension.json
Running with options:
Population: 10
Seed: 1565618444324
Provider Seed:1565618444324
Location: Massachusetts
Min Age: 0
Max Age: 140
5 -- Sharie942 Littel644 (23 y/o F) Waltham, Massachusetts
1 -- Clifford177 Frami345 (16 y/o M) Boston, Massachusetts
8 -- Wiley422 Witting912 (34 y/o M) Waltham, Massachusetts
3 -- Jordan900 Dickens475 (30 y/o M) Wakefield, Massachusetts
6 -- Tobias236 Hackett68 (46 y/o M) Brockton, Massachusetts
7 -- Glynda607 Oberbrunner298 (52 y/o F) Wrentham, Massachusetts
2 -- Eleanor470 Windler79 (57 y/o F) Needham, Massachusetts
4 -- Evangelina20 Buckridge80 (55 y/o F) Lynn, Massachusetts
9 -- Andrea7 Gaylord332 (12 y/o F) Norwood, Massachusetts
10 -- Elfrieda676 Weber641 (41 y/o F) Somerville, Massachusetts
{alive=10, dead=0}

BUILD SUCCESSFUL in 15s
4 actionable tasks: 2 executed, 2 up-to-date
```

## Visualizing Created Patients
You can visualize created patients in order to be able to view their records
in an easy to understand way. Instructions for doing that can be found in
the [SyntheaPatientViz](https://github.com/logicahealth/SyntheaPatientViz) 
Repository. 

## Importing
Before starting importing, if you are using a copy of the VEHU database,
look at [VEHU Lab Package Config](docs/vehu-lab-package-config.md) to improve
the results of the lab import.

The software creates a `SYNMENU` option that contains all the user facing
interface to load Synthetic Patients from Synthea.

Login as a user who holds the `LRLAB` and `LRVERIFY` keys. Nagivate to SYNMENU.

```
FOIA>KILL  D ^XUP

Setting up programmer environment
This is a TEST account.

Access Code: **********
Select TERMINAL TYPE NAME: C-VT320
     1   C-VT320                Digital Equipment Corporation VT-320 video
     2   C-VT320 PC             Digital Equipment Corporation VT-320 video
     3   C-VT320/132            Digital Equipment Corporation VT-320 video
     4   C-VT320/34             Digital Equipment Corporation VT-320 video
CHOOSE 1-4: 1  C-VT320          Digital Equipment Corporation VT-320 video
Terminal Type set to: C-VT320

Select OPTION NAME: SYNMENU       Synthetic Patients Importer Menu

   1      Load Patients from Filesystem [SYN LOAD FILES]
   2      Load Log [SYN LOAD LOG]
   3      View Ingested Patients' FHIR JSON [SYN FHIR JSON]
   4      View a Patient's VPR [SYN VPR]

Select Synthetic Patients Importer Menu <TEST ACCOUNT> Option:
```

The first menu option is for you to load patients; the second and third menus
are to help you debug the load. Here's how to use it. Note that starting with v0.6
the default mode is one patient at a time, as shown below. You can still choose to
load all patients in a specific directory by typing "M".

```
Select Synthetic Patients Importer Menu <TEST ACCOUNT> Option: 1  Load Patients
from Filesystem
Enter directory from which to load Synthea Patients (FHIR DSTU3 or R4): C:\Users
\User\synthea\output\fhir

Do you want to import a [S]ingle or [M]ultiple patients? S// ingle

1. Agatha2_Konopelski743_29085255-8836-8d3a-bfb2-c53a523025cf.json
2. Bea654_Alejandrina481_Zemlak964_f2bd762c-0466-7ebc-4647-a7cf53458be8.json
3. Carmen818_Renner328_357f85a6-652f-68df-4d5e-9335a6bf67a4.json
4. Carson894_Huels583_3d86dfcb-0147-ab7d-3f74-78a36e1f2dc6.json
5. Charles364_Sipes176_9aa9f581-6788-5397-3da9-4b60c47bc58c.json
6. Refugio197_Adams676_7047cf31-18d8-55b9-96ef-3181fc1e6ce6.json
7. Thelma273_Manda751_Stiedemann542_aae8b213-233f-2afd-fb9b-43cca5a58f57.json

Enter a list or range of numbers (1-7): 1// 

Loading Agatha2_Konopelski743_29085255-8836-8d3a-bfb2-c53a523025cf.json...
Ingesting Agatha2_Konopelski743_29085255-8836-8d3a-bfb2-c53a523025cf.json...
Loaded with following data:
File: Agatha2_Konopelski743_29085255-8836-8d3a-bfb2-c53a523025cf.json
DFN: 101084         ICN: 2168542776V639758        Graph Store IEN: 2
--------------------------------------------------------------------------
Type                          Loaded?                       Error
ADR/Allergy                   0                             0
Appointments
Care Plans
Problems                      1                             3
Encounters                    14
Immunization                  23                            4
Labs                          10                            1
Lab Panels                    1                             0
Meds                          2
Procedures                                                  3
Vitals                        78                            47
```

## Examining the Status of Load
As you can see, the project is far from perfect in its ability to load data
from Synthea generated FHIR. The menu options `View Ingested Patients' FHIR JSON [SYN FHIR JSON]`
and `Load Log [SYN LOAD LOG]` help you diagnose failed loading issues.

For example, 3 problems failed to load for DFN 101084. Let's find out why.
Most of the time, we can just look at the load log to figure out what happened.

```
Select Synthetic Patients Importer Menu <TEST ACCOUNT> Option: 2  Load Log
Select PATIENT NAME:    KONOPELSKI743,AGATHA2        6-27-20    999512521     NO
     NON-VETERAN (OTHER)

1 all        6 labs          11 procedure
2 patient    7 meds          12 labPanels
3 allergy    8 immunizations
4 conditions 9 encounters
5 vitals     10 careplan
Please select clinical category to view:

Enter response: 1// 4

```
                           PATIENT 101084 conditions
^SYNGRAPH(2002.801,2,2,"load","conditions")
|--3
|  |--log
|  |  |--1 reference encounter ID is : cac21819-560d-9fe0-ddd4-ee76d9454545
|  |  |--2 visit ien is: 15103
|  |  |--3 visit date is: 3200627.0458
|  |  |--4 code is: 314529007
|  |  |--5 icd code type is: icd10
|  |  |--6 icd mapping is: 1^Z76.89
|  |  |--7 onsetDateTime is: 2020-06-27T04:58:36-04:00
|  |  |--8 fileman onsetDateTime is: 3200627.045836
|  |  |--9 hl7 onsetDateTime is: 20200627045836-0400
|  |  |--10 abatementDateTime is: 2020-08-01T04:58:36-04:00
|  |  |--11 fileman abatementDateTime is: 3200801.045836
|  |  |--12 hl7 abatementDateTime is: 20200801045836-0400
|  |  |--13 reference encounter ID is : cac21819-560d-9fe0-ddd4-ee76d9454545
|  |  |--14 visit ien is: 15103
|  |  |--15 Provider NPI for outpatient is: 9990000348
|  |  |--16 Calling PRBUPDT^SYNDHP62 to add snomed condition
|  |  |--17 Return from data loader was: 1^15103
|  |--parms
|  |  |--DHPCLNST I
Col>   1 |Press <PF1>H for help| Line>      22 of 204  Screen>       1 of 10
```

Now you can use Up/Down and Page Up/Page Down to browse the log. Alternately,
you can use F1-F1-P to print the log to a file using the HFS device.

You can also get the original FHIR from Synthea that got imported for
reference: 

```
Select Synthetic Patients Importer Menu <TEST ACCOUNT> Option: 3  View Ingested
Patients' FHIR JSON
Select PATIENT NAME:    KONOPELSKI743,AGATHA2        6-27-20    999512521     NO
     NON-VETERAN (OTHER)

1 all         7 MedicationRequest 13 ExplanationOfBenefit
2 Patient     8 Immunization      14 ImagingStudy
3 Allergy     9 Encounter         15 Practitioner
4 Condition   10 CarePlan         16 Organization
5 Observation 11 Procedure
6 Claim       12 DiagnosticReport
Please select clinical category to view:

Enter response: 1// 4
^TMP("SYNFHIR",254)
|--Condition
|  |--entry
|  |  |--3
|  |  |  |--fullUrl urn:uuid:f1acc549-fa8f-ff23-2881-4dcd1df7fcb2
|  |  |  |--request
|  |  |  |  |--method POST
|  |  |  |  |--url Condition
|  |  |  |--resource
|  |  |  |  |--abatementDateTime 2020-08-01T04:58:36-04:00
|  |  |  |  |--category
|  |  |  |  |  |--1
|  |  |  |  |  |  |--coding
|  |  |  |  |  |  |  |--1
|  |  |  |  |  |  |  |  |--code encounter-diagnosis
|  |  |  |  |  |  |  |  |--display Encounter Diagnosis
|  |  |  |  |  |  |  |  |--system http://terminology.hl7.org/CodeSystem/conditio
|  |  |  |  |--clinicalStatus
|  |  |  |  |  |--coding
|  |  |  |  |  |  |--1
|  |  |  |  |  |  |  |--code resolved
|  |  |  |  |  |  |  |--system http://terminology.hl7.org/CodeSystem/condition-c
Col>   1 |Press <PF1>H for help| Line>      22 of 175  Screen>       1 of 8
```

As before, you can use F1-F1-P to print the document from the browser.

## Getting the Virtual Patient Record on a patient
Use this menu option to view a patient's VPR. This works for all patients, not
just patients imported using this importer.

```
   4      View a Patient's VPR [SYN VPR]
```

Here's an example:

```
Select PATIENT NAME:    KONOPELSKI743,AGATHA2        6-27-20    999512521     NO
     NON-VETERAN (OTHER)

1 all          6 labs          11 appointments 16 factors
2 demographics 7 meds          12 documents    17 skinTests
3 reactions    8 immunizations 13 procedures   18 exams
4 problems     9 observation   14 consults     19 education
5 vitals       10 visits       15 flags        20 insurance
Please select clinical category to view:

Enter response: 1// 4
                            PATIENT 101084 problems
|--results
|--  : timeZone^-0500
|--  : version^1.13
|  |--problems
|  |--  : total^1
|  |  |--problem
|  |  |  |--codingSystem
|  |  |  |--  : value^10D
|  |  |  |--entered
|  |  |  |--  : value^3250218
|  |  |  |--facility
|  |  |  |--  : code^500
|  |  |  |--  : name^CAMP MASTER
|  |  |  |--icd
|  |  |  |--  : value^Z76.89
|  |  |  |--icdd
|  |  |  |--  : value^Persons encountering health services in other specified ci
|  |  |  |--id
|  |  |  |--  : value^2004
|  |  |  |--location
|  |  |  |--  : value^GENERAL MEDICINE
|  |  |  |--name
Col>   1 |Press <PF1>H for help| Line>      22 of 39   Screen>       1 of 2
```

# License
All source code produced is under Apache 2.0.
