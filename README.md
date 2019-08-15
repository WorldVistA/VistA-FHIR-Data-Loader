# VistA FHIR Data Loader Project
This project lets you load data from Synthea (https://synthetichealth.github.io/synthea/) 
into VistA to produce high quality synthetic patient data for development and testing.
Other FHIR data sources are supportable; but are not supported at this time.

# Pre-installation Requirements
The Installer DUZ must have the key XUMGR in order to be able to add users to
the systems.
Disk Space Requirements: We never actually measured how much disk space the
package and each patient takes. However, from experience, loading about 400
full patient histories takes up 100 GB.

Here's a full list of the software you will need. We do not describe how to
install this pre-requisites here.

* Java (JDK only) 1.8 or above to run Synthea
* Git to clone the Synthea Repository
* Google Chrome or Mozilla Firefox to visualize Synthea Patients
* InterSystems Caché with the VistA database loaded. This does not have to be
on your own laptop; you can copy the generated Synthea Patients into the
machine that hosts your VistA instance.

# Outline of all steps needed for New Windows Machine (as of Aug 2019):

 * Enable Telnet (Windows 10 only; already enabled in Windows 7)
 * Install Java (JDK, not JRE)
 * Install Latest Git
 * Install Google Chrome
 * Download and Install InterSystems Caché
 * Download and configure FOIA VistA on Caché
 * Download and configure latest CPRS
 * Install PCE_STANDARDIZATION_1_0_T5.KID
 * Install VISTA_FHIR_DATA_LOADER_VA_VERSION_0P2.KID
 * Clone Synthea Repo
 * Run Synthea to Create Patients
 * Import Patients in VistA
 * View Imported patients using CPRS

# Installation
As of Aug 20th 2018, the official way to install this project is to use the latest
KIDS build in [releases](https://github.com/OSEHRA/VistA-FHIR-Data-Loader/releases/latest).

As of v0.2 (unlike v0.1), PCE STANDARDIZATION 1.0 is now required. In order to
install this, you need these patches:
 
 * https://code.osehra.org/journal/download?items=1173,%201 (zip file, unzip and load PCE_STANDARDIZATION_1_0_T5.KID)
 * https://github.com/OSEHRA/VistA-FHIR-Data-Loader/releases/download/0.2va/VISTA_FHIR_DATA_LOADER_VA_VERSION_0P2.KID.zip (zip file, unzip and load VISTA_FHIR_DATA_LOADER_VA_VERSION_0P2.KID)

As of the time of this writing, PCE STANDARDIZATION has not been officially
released by the VA. That's why you need to obtain it from the Tech Journal. 

The KIDS build needs to be unzipped first and then installed. The installer
must have the key XUMGR in order to be able to add users to the systems.

## Sample Install Transcript
```
FOIA1907>d ^XPDIL,^XPDI

Enter a Host File: /tmp/VISTA_FHIR_DATA_LOADER_VA_VERSION_0P2.KID

KIDS Distribution saved on Aug 15, 2019@16:39:40
Comment: T6 - Counters fix, missing log fix, all bull fix

This Distribution contains Transport Globals for the following Package(s):
   VISTA FHIR DATA LOADER VA VERSION 0.2
   ISI_DATA_LOADER 2.6
   VISTA SYN DATA LOADER 0.2
Distribution OK!

Want to Continue with Load? YES//
Loading Distribution...

   VISTA FHIR DATA LOADER VA VERSION 0.2
   ISI_DATA_LOADER 2.6
   VISTA SYN DATA LOADER 0.2
Use INSTALL NAME: VISTA FHIR DATA LOADER VA VERSION 0.2 to install this Distribu
tion.

Select INSTALL NAME: vista FHIR DATA LOADER VA VERSION 0.2       Loaded from Dis
tribution    8/15/19@17:07:54
     => T6 - Counters fix, missing log fix, all bull fix  ;Created on Aug 15,

This Distribution was loaded on Aug 15, 2019@17:07:54 with header of
   T6 - Counters fix, missing log fix, all bull fix  ;Created on Aug 15, 2019@16
:39:40
   It consisted of the following Install(s):
VISTA FHIR DATA LOADER VA VERSION 0.2ISI_DATA_LOADER 2.6VISTA SYN DATA LOADER 0.
2
Checking Install for Package VISTA FHIR DATA LOADER VA VERSION 0.2

Install Questions for VISTA FHIR DATA LOADER VA VERSION 0.2


Checking Install for Package ISI_DATA_LOADER 2.6

Install Questions for ISI_DATA_LOADER 2.6

Incoming Files:


   9001      ISI PT IMPORT TEMPLATE  (including data)

Want KIDS to Rebuild Menu Trees Upon Completion of Install? NO//

Checking Install for Package VISTA SYN DATA LOADER 0.2

Install Questions for VISTA SYN DATA LOADER 0.2

Incoming Files:


   2002.801  GRAPH

Want KIDS to Rebuild Menu Trees Upon Completion of Install? NO//


Want KIDS to INHIBIT LOGONs during the install? NO//
Want to DISABLE Scheduled Options, Menu Options, and Protocols? NO//

Enter the Device you want to print the Install messages.
You can queue the install by enter a 'Q' at the device prompt.
Enter a '^' to abort the install.

DEVICE: HOME// ;p-other;  Virtual Terminal


 Install Started for VISTA FHIR DATA LOADER VA VERSION 0.2 :
               Aug 15, 2019@17:08:02

Build Distribution Date: Aug 15, 2019

 Installing Routines:.
               Aug 15, 2019@17:08:02

 Install Started for ISI_DATA_LOADER 2.6 :
               Aug 15, 2019@17:08:02

Build Distribution Date: Aug 15, 2019

 Installing Routines:..........................................................
               Aug 15, 2019@17:08:03

 Installing Data Dictionaries: ..
               Aug 15, 2019@17:08:03

 Installing Data:
               Aug 15, 2019@17:08:03

 Installing PACKAGE COMPONENTS:

 Installing REMOTE PROCEDURE........................

 Installing OPTION..
               Aug 15, 2019@17:08:03

 Updating Routine file......

 Updating KIDS files.....

 ISI_DATA_LOADER 2.6 Installed.
               Aug 15, 2019@17:08:03

 No link to PACKAGE file

 NO Install Message sent

 Install Started for VISTA SYN DATA LOADER 0.2 :
               Aug 15, 2019@17:08:03

Build Distribution Date: Aug 15, 2019

 Installing Routines:............................................
               Aug 15, 2019@17:08:03

 Running Pre-Install Routine: PRE^SYNKIDS.

 Installing Data Dictionaries: ..
               Aug 15, 2019@17:08:03

 Installing PACKAGE COMPONENTS:

 Installing OPTION......
               Aug 15, 2019@17:08:03

 Running Post-Install Routine: POST^SYNKIDS.
Merging ^SYN global in. This takes time...

Syn Patients Importer Init
Provider 68
Pharmacist 69
Hospital Location 3
Fixing AMIE thingy
Fixing IB ACTION TYPE file
Setting up Outpatient Pharmacy 3
Disabling Allergy Bulletins

 Updating Routine file......

 Updating KIDS files.....

 VISTA SYN DATA LOADER 0.2 Installed.
               Aug 15, 2019@17:08:05

 No link to PACKAGE file

 NO Install Message sent

 Updating Routine file.....

 Updating KIDS files.......

 VISTA FHIR DATA LOADER VA VERSION 0.2 Installed.
               Aug 15, 2019@17:08:05

 Not a production UCI

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
Open up your terminal/command line, and check that java and git are installed.
Running `git --version` and `java -version` will verify that the commands are
installed. `-p 10` means produce 10 patients.

```
git clone https://github.com/synthetichealth/synthea.git
cd synthea
./run_synthea -p 10 # or ./run_synthea.bat -p 10 on Windows CMD
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
the [SyntheaPatientViz](https://github.com/OSEHRA-Sandbox/SyntheaPatientViz) 
Repository. Here's an example on Windows/Powershell:

```
 cd .\synthea\output\fhir\
 $folder=$PWD.Path
 del $folder/*.html
 $files = Get-ChildItem $folder -Filter *_*.json
 foreach ($f in $files) {
  echo $f.FullName
  Invoke-RestMethod -Uri https://code.osehra.org/synthea/synthea_upload.php -Method Post -InFile $f.FullName > ($f.FullName + ".html")
}
```

## Importing
Kill your symbol table, and login as a user who holds the `LRLAB` and `LRVERIFY`
keys. The installer creates a provider with the access code `SYNPROV123` and
the verify code `SYNPROV123!!` that has the correct keys. You can use that
to log-in.  Nagivate to SYNMENU.

```
FOIA>D ^XUP

Setting up programmer environment
This is a TEST account.

Access Code: *******
FOIA>D ^XUP

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
are to help you debug the load. Let's start by loading the patients we just
created:

```
Select Synthetic Patients Importer Menu <TEST ACCOUNT> Option: 1  Load Patients
from Filesystem
Enter directory from which to load Synthea Patients (FHIR DSTU3 or R4): C:\Users
\User\synthea\output\fhir
Loading Alden634_Ortiz186_f1bf603b-add2-4fd3-8328-87d42678d106.json...
Ingesting Alden634_Ortiz186_f1bf603b-add2-4fd3-8328-87d42678d106.json...
Loaded with following data:
DFN: 1              ICN: 1050779984V938828        Graph Store IEN: 1
--------------------------------------------------------------------------
Type                          Loaded?                       Error
ADR/Allergy                   0                             0
Appointments
Care Plans                    3
Problems                      4                             1
Encounters                    9                             3
Immunization                  10
Labs                          28                            4
Meds                          4
Procedures                    2
Vitals                        21                            12

Loading Alicia629_Gálvez271_4ddaea7e-530f-42c4-b9bf-c8ddcb4f89c8.json...
Ingesting Alicia629_Gálvez271_4ddaea7e-530f-42c4-b9bf-c8ddcb4f89c8.json...
Loaded with following data:
DFN: 2              ICN: 1801934432V959527        Graph Store IEN: 2
--------------------------------------------------------------------------
Type                          Loaded?                       Error
ADR/Allergy                   0                             0
Appointments
Care Plans                    7
Problems                      7                             2
Encounters                    34                            2
Immunization                  6
Labs                          27                            7
Meds                          8
Procedures                    10                            68
Vitals                        9                             6

Loading Bo157_Balistreri607_3baf7f93-5a9c-440c-ab00-f2e9705a6d26.json...
Ingesting Bo157_Balistreri607_3baf7f93-5a9c-440c-ab00-f2e9705a6d26.json...
Loaded with following data:
DFN: 3              ICN: 2260908635V993173        Graph Store IEN: 3
--------------------------------------------------------------------------
Type                          Loaded?                       Error
ADR/Allergy                   0                             0
Appointments
Care Plans                                                  1
Problems                      1                             3
Encounters                    13                            1
Immunization                  13
Labs                          24                            10
Meds
Procedures                    6
Vitals                        32                            20

Loading Catharine355_Luettgen772_ae49675c-d363-45f8-bf7f-c1e3d8ea6a86.json...
Ingesting Catharine355_Luettgen772_ae49675c-d363-45f8-bf7f-c1e3d8ea6a86.json...

No refills allowed on this narcotic drug.
 Loaded with following data:
DFN: 4              ICN: 9712588764V722272        Graph Store IEN: 4
--------------------------------------------------------------------------
Type                          Loaded?                       Error
ADR/Allergy                   0                             0
Appointments
Care Plans                    1                             1
Problems                      5                             3
Encounters                    14                            4
Immunization                  13
Labs                          24                            10
Meds                          4
Procedures                    7                             1
Vitals                        31                            20

Loading Dolores502_Blanda868_6d0a63ac-2485-42c8-aced-4c1f43533519.json...
Ingesting Dolores502_Blanda868_6d0a63ac-2485-42c8-aced-4c1f43533519.json...
Loaded with following data:
DFN: 5              ICN: 1707938753V493604        Graph Store IEN: 5
--------------------------------------------------------------------------
Type                          Loaded?                       Error
ADR/Allergy                   0                             0
Appointments
Care Plans                    6
Problems                      12                            3
Encounters                    55                            5
Immunization                  5
Labs                          32                            13
Meds                          5
Procedures                    15                            183
Vitals                        13                            8

Loading Ewa95_Douglas31_990d6019-ec49-4f41-a136-b590ab1ca0bd.json...
Ingesting Ewa95_Douglas31_990d6019-ec49-4f41-a136-b590ab1ca0bd.json...
Loaded with following data:
DFN: 6              ICN: 2074153525V922746        Graph Store IEN: 6
--------------------------------------------------------------------------
Type                          Loaded?                       Error
ADR/Allergy                   0                             0
Appointments
Care Plans
Problems
Encounters                    3
Immunization                  7
Labs                          9                             2
Meds
Procedures
Vitals                        9                             3

Loading Josh874_McCullough561_8d2d408d-3633-4fe0-96ec-7cdbda27d824.json...
Ingesting Josh874_McCullough561_8d2d408d-3633-4fe0-96ec-7cdbda27d824.json...
Loaded with following data:
DFN: 7              ICN: 2176211877V820918        Graph Store IEN: 7
--------------------------------------------------------------------------
Type                          Loaded?                       Error
ADR/Allergy                   0                             0
Appointments
Care Plans                    4                             1
Problems                      12                            2
Encounters                    18                            11
Immunization                  11                            1
Labs                          212                           122
Meds                          12
Procedures                    24                            6
Vitals                        30                            18

Loading Lakeshia836_O'Hara248_29aea4fc-a14d-4767-9b04-e3ad0cb9bfdc.json...
Ingesting Lakeshia836_O'Hara248_29aea4fc-a14d-4767-9b04-e3ad0cb9bfdc.json...

No refills allowed on this narcotic drug.
 Loaded with following data:
DFN: 8              ICN: 1151359466V320852        Graph Store IEN: 8
--------------------------------------------------------------------------
Type                          Loaded?                       Error
ADR/Allergy                   0                             0
Appointments
Care Plans                    2
Problems                      2                             1
Encounters                    24                            1
Immunization                  10
Labs                          18                            4
Meds                          8
Procedures                    5                             44
Vitals                        18                            12

Loading Marcell728_Heathcote539_2031beeb-1dc8-4dbe-a88f-4129b9a7b10b.json...
Ingesting Marcell728_Heathcote539_2031beeb-1dc8-4dbe-a88f-4129b9a7b10b.json...
Loaded with following data:
DFN: 9              ICN: 9111518904V096652        Graph Store IEN: 9
--------------------------------------------------------------------------
Type                          Loaded?                       Error
ADR/Allergy                   0                             0
Appointments
Care Plans                    2
Problems                      5                             1
Encounters                    11                            3
Immunization                  10
Labs                          87                            10
Meds                          1
Procedures                    12
Vitals                        21                            14

Loading Rafael239_Casárez469_c381dbf2-3d29-4b11-8ddf-7ab6284ab25b.json...
Ingesting Rafael239_Casárez469_c381dbf2-3d29-4b11-8ddf-7ab6284ab25b.json...
Loaded with following data:
DFN: 10             ICN: 3033904878V810223        Graph Store IEN: 10
--------------------------------------------------------------------------
Type                          Loaded?                       Error
ADR/Allergy                   0                             0
Appointments
Care Plans                    2
Problems                      4                             1
Encounters                    41                            3
Immunization                  13
Labs                          15                            9
Meds                          2
Procedures                    9
Vitals                        30                            22

Loading Samira471_Roberts511_4194a71b-6b63-4ce2-9688-4044b2bdb97b.json...
Ingesting Samira471_Roberts511_4194a71b-6b63-4ce2-9688-4044b2bdb97b.json...
Loaded with following data:
DFN: 11             ICN: 1537507155V261598        Graph Store IEN: 11
--------------------------------------------------------------------------
Type                          Loaded?                       Error
ADR/Allergy                   0                             0
Appointments
Care Plans                    4                             1
Problems                      6                             3
Encounters                    27                            4
Immunization                  11
Labs                          24                            10
Meds                          7
Procedures                    8                             42
Vitals                        24                            16
```

## Examining the Status of Load
As you can see, the project is far from perfect in its ability to load data
from Synthea generated FHIR. The menu options `View Ingested Patients' FHIR JSON [SYN FHIR JSON]`
and `Load Log [SYN LOAD LOG]` help you diagnose failed loading issues.

For example, 3 problems failed to load for DFN 11. Let's find out why.
Most of the time, we can just look at the load log to figure out what happened.

```
Select Synthetic Patients Importer Menu <TEST ACCOUNT> Option: 2  Load Log
Select PATIENT NAME: `11  ROBERTS511,SAMIRA471        7-27-63    999129657     N
O     NON-VETERAN (OTHER)      

1 all        6 labs          11 procedure
2 patient    7 meds          
3 allergy    8 immunizations
4 conditions 9 encounters
5 vitals     10 careplan
Please select clinical category to view: 

Enter response: 1// 4

                             PATIENT 11 conditions
^SYNGRAPH(2002.801,2,11,"load","conditions")
|--5
|  |--log
|  |  |--1 reference encounter ID is : b4f323c6-4bae-4e06-b401-404904b52a25
|  |  |--2 visit ien is: -1
|  |  |--3 visit date is:
|  |  |--4 code is: 59621000
|  |  |--5 icd code type is: icd9
|  |  |--6 icd mapping is: 1^401.9
|  |  |--7 onsetDateTime is: 1981-09-19T11:47:57-04:00
|  |  |--8 fileman onsetDateTime is: 2810919.114757
|  |  |--9 hl7 onsetDateTime is: 19810919114757-0400
|  |  |--10 no abatementDateTime
|  |  |--11 reference encounter ID is : b4f323c6-4bae-4e06-b401-404904b52a25
|  |  |--12 visit ien is: -1
|  |  |--13 Provider NPI for outpatient is: 9990000348
|  |  |--14 Calling PRBUPDT^SYNDHP62 to add snomed condition
|  |  |--15 Return from data loader was: -1^Visit not found
|  |--parms
|  |  |--DHPCLNST I
|  |  |--DHPONS 19810919114757-0400
|  |  |--DHPPAT 1537507155V261598
Col>   1 |Press <PF1>H for help| Line>      22 of 486  Screen>       1 of 23
```

Now you can use Up/Down and Page Up/Page Down to browse the log. Alternately,
you can use F1-F1-P to print the log to a file using the HFS device.

You can also get the original FHIR from Synthea that got imported for
reference: 

```
Select Synthetic Patients Importer Menu <TEST ACCOUNT> Option: 3  View Ingested Patients' FHIR JSON
Select PATIENT NAME:    ROBERTS511,SAMIRA471        7-27-63    999129657     NO 
    NON-VETERAN (OTHER)      

1 all         7 MedicationRequest 13 ExplanationOfBenefit
2 Patient     8 Immunization      14 ImagingStudy
3 Allergy     9 Encounter         15 Practitioner
4 Condition   10 CarePlan         16 Organization
5 Observation 11 Procedure
6 Claim       12 DiagnosticReport
Please select clinical category to view: 

Enter response: 1//4

                             PATIENT 11 Condition
^TMP("SYNFHIR",315)
|--Condition
|  |--entry
|  |  |--5
|  |  |  |--fullUrl urn:uuid:77e2f26c-a99d-4e10-a4c9-2ef462fae82f
|  |  |  |--request
|  |  |  |  |--method POST
|  |  |  |  |--url Condition
|  |  |  |--resource
|  |  |  |  |--clinicalStatus
|  |  |  |  |  |--coding
|  |  |  |  |  |  |--1
|  |  |  |  |  |  |  |--code active
|  |  |  |  |  |  |  |--system http://terminology.hl7.org/CodeSystem/condition-c
|  |  |  |  |--code
|  |  |  |  |  |--coding
|  |  |  |  |  |  |--1
|  |  |  |  |  |  |  |--code 59621000
|  |  |  |  |  |  |  |  |--\s
|  |  |  |  |  |  |  |--display Hypertension
|  |  |  |  |  |  |  |--system http://snomed.info/sct
|  |  |  |  |  |--text Hypertension
Col>   1 |Press <PF1>H for help| Line>      22 of 296  Screen>       1 of 14
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
Select PATIENT NAME:    ROBERTS511,SAMIRA471        7-27-63    999129657     NO
    NON-VETERAN (OTHER)

1 all          6 labs          11 appointments 16 factors
2 demographics 7 meds          12 documents    17 skinTests
3 reactions    8 immunizations 13 procedures   18 exams
4 problems     9 observation   14 consults     19 education
5 vitals       10 visits       15 flags        20 insurance
Please select clinical category to view:

Enter response: 1// 4
                              PATIENT 11 problems
|--results
|--  : timeZone^-0400
|--  : version^1.13
|  |--problems
|  |--  : total^6
|  |  |--problem
|  |  |  |--codingSystem
|  |  |  |--  : value^10D
|  |  |  |--entered
|  |  |  |--  : value^3190815.170926
|  |  |  |--facility
|  |  |  |--  : code^050
|  |  |  |--  : name^PLATINUM
|  |  |  |--icd
|  |  |  |--  : value^R69.
|  |  |  |--icdd
|  |  |  |--  : value^Illness, unspecified
|  |  |  |--id
|  |  |  |--  : value^53
|  |  |  |--name
|  |  |  |--  : value^Miscarriage in first trimester (SCT 19169002)
|  |  |  |--onset
Col>   1 |Press <PF1>H for help| Line>      22 of 201  Screen>       1 of 10
```

# How to contribute
You can join the developers by sending a message to this mailing list:
https://www.osehra.org/groups/synthetic-patient-data-project-group 

# License
All source code produced is under Apache 2.0.
