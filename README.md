# VistA FHIR Data Loader Project
This project lets you load data from Synthea (https://synthetichealth.github.io/synthea/) 
into VistA to produce high quality synthetic patient data for development and testing.
Other FHIR data sources are supportable; but are not supported at this time.

# Pre-installation Requirements
The Installer DUZ must have the key XUMGR in order to be able to add users to the
systems.
Disk Space Requirements: We never actually measured how much disk space the
package and each patient takes. However, from experience, loading about 400
full patient histories takes up 100 GB.

Here's a full list of the software you will need. We do not describe how to
install this pre-requisites here.

* Java (JDK only) 1.8 or above to run Synthea
* Git to clone the Synthea Repository
* Google Chrome or Mozilla Firefox to visualize Synthea Patients
* Intersystems Cache with the VistA database loaded. This does not have to be
on your own laptop; you can copy the generated Synthea Patients into the
machine that hosts your VistA instance.

# Outline of all steps neeeded for New Windows Machine (as of Aug 2019):

 * Download and Install Intersystems Cache
 * Download and configure FOIA VistA on Cache
 * Download and configure latest CPRS
 * Enable Telnet (Windows 10 only; already enabled in Windows 7)
 * Install Java (JDK, not JRE)
 * Install Latest Git
 * Install Google Chrome
 * Install PCE_STANDARDIZATION_1_0_T5.KID
 * Install VISTA_FHIR_DATA_LOADER_VA_VERSION_0P2.KID
 * Clone Synthea Repo
 * Run Synthea to Create Patients
 * Import Patients in VistA
 * View Imported patients using CPRS

Below is some automation to speed up set-up of a new Windows Machine:

```
@"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"
dism /online /Enable-Feature /FeatureName:TelnetClient
choco install googlechrome
choco install git
choco install adoptopenjdk8
```

# Installation
As of Aug 20th 2018, the official way to install this project is to use the latest
KIDS build in [releases](https://github.com/OSEHRA/VistA-FHIR-Data-Loader/releases/latest).

As of v0.2 (unlike v0.1), PCE STANDARDIZATION 1.0 is now required. In order to
install this, you need these patches:
 
 * https://foia-vista.osehra.org/Patches_By_Application/XU-KERNEL/XU-8_SEQ-546_PAT-672.kids (if not installed)
 * https://code.osehra.org/journal/download?items=1173,%201 (zip file, unzip and load PCE_STANDARDIZATION_1_0_T5.KID)
 * https://github.com/OSEHRA/VistA-FHIR-Data-Loader/releases/download/0.2va/VISTA_FHIR_DATA_LOADER_VA_VERSION_0P2.KID.zip (zip file, unzip and load VISTA_FHIR_DATA_LOADER_VA_VERSION_0P2.KID)

As of the time of this writing, PCE STANDARIDZATION has not been officially
released by the VA. That's why you need to obtain it from the Tech Journal. 

The KIDS build needs to be unzipped first and then installed. The installer
must have the key XUMGR in order to be able to add users to the systems.

## Sample Install Transcript
```
FOIA1907>D ^XPDIL,^XPDI

Enter a Host File: /opt/cachesys/foia1907/VISTA_FHIR_DATA_LOADER_VA_VERSION_0P2.KID

KIDS Distribution saved on Aug 07, 2019@21:07:48
Comment: T5 - FHIR4 Allergies issue; ETS dep; menus; labs don't print

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

Select INSTALL NAME: VISTA FHIR DATA LOADER VA VERSION 0.2       Loaded from Dis
tribution    8/8/19@13:19:29
     => T5 - FHIR4 Allergies issue; ETS dep; menus; labs don't print  ;Created

This Distribution was loaded on Aug 08, 2019@13:19:29 with header of 
   T5 - FHIR4 Allergies issue; ETS dep; menus; labs don't print  ;Created on Aug
 07, 2019@21:07:48
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

DEVICE: HOME// ;P-OTHER;  Virtual Terminal

 
 Install Started for VISTA FHIR DATA LOADER VA VERSION 0.2 : 
               Aug 08, 2019@13:19:43
 
Build Distribution Date: Aug 07, 2019
 
 Installing Routines:.
               Aug 08, 2019@13:19:43
 
 Install Started for ISI_DATA_LOADER 2.6 : 
               Aug 08, 2019@13:19:43
 
Build Distribution Date: Aug 07, 2019
 
 Installing Routines:..........................................................
               Aug 08, 2019@13:19:43
 
 Installing Data Dictionaries: ..
               Aug 08, 2019@13:19:43
 
 Installing Data: 
               Aug 08, 2019@13:19:43
 
 Installing PACKAGE COMPONENTS: 
 
 Installing REMOTE PROCEDURE........................
 
 Installing OPTION..
               Aug 08, 2019@13:19:43
 
 Updating Routine file......
 
 Updating KIDS files.....
 
 ISI_DATA_LOADER 2.6 Installed. 
               Aug 08, 2019@13:19:43
 
 No link to PACKAGE file
 
 NO Install Message sent 
 
 Install Started for VISTA SYN DATA LOADER 0.2 : 
               Aug 08, 2019@13:19:43
 
Build Distribution Date: Aug 07, 2019
 
 Installing Routines:............................................
               Aug 08, 2019@13:19:43
 
 Running Pre-Install Routine: PRE^SYNKIDS.
 
 Installing Data Dictionaries: ..
               Aug 08, 2019@13:19:43
 
 Installing PACKAGE COMPONENTS: 
 
 Installing OPTION.....
               Aug 08, 2019@13:19:43
 
 Running Post-Install Routine: POST^SYNKIDS.
Merging ^SYN global in. This takes time...

Syn Patients Importer Init
Provider 68
Pharmacist 69
Hospital Location 3
Fixing AMIE thingy
Fixing IB ACTION TYPE file
Setting up Outpatient Pharmacy 3
 
 Updating Routine file......
 
 Updating KIDS files.....
 
 VISTA SYN DATA LOADER 0.2 Installed. 
               Aug 08, 2019@13:19:45
 
 No link to PACKAGE file
 
 NO Install Message sent 
 
 Updating Routine file.....
 
 Updating KIDS files.......
 
 VISTA FHIR DATA LOADER VA VERSION 0.2 Installed. 
               Aug 08, 2019@13:19:45
 
 Not a production UCI
 
 NO Install Message sent 
```

# Usage
To create new synthetic patients from Synthea, and load them into VistA, you
need to perform the following steps: Create Synthetic Patients Using Synthea,
(optionally) copy the files to where your VistA instance can reach them on the
file system, and then load them into VistA using the menu options from the
top level menu SYNMENU (which is installed as part of the KIDS build).

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
PS C:\Users\User\synthea> cd .\synthea\output\fhir\
PS C:\Users\User\synthea\output\fhir> $folder=$PWD.Path
PS C:\Users\User\synthea\output\fhir> del $folder/*.html
PS C:\Users\User\synthea\output\fhir> $files = Get-ChildItem $folder -Filter *_*.json
PS C:\Users\User\synthea\output\fhir> foreach ($f in $files) {
>>   echo $f.FullName
>>   Invoke-RestMethod -Uri https://code.osehra.org/synthea/synthea_upload.php -Method Post -InFile $f.FullName > ($f.FullName + ".html")
>> }
C:\Users\User\synthea\output\fhir\Andrea7_Gaylord332_64cf76b3-02e6-4587-a45d-a53d8228507e.json
C:\Users\User\synthea\output\fhir\Clifford177_Frami345_fb59c2ec-f2c2-4898-b9a3-bd9c8268c06a.json
C:\Users\User\synthea\output\fhir\Eleanor470_Windler79_9183bf97-98e2-46b1-b15a-8a6080519c75.json
C:\Users\User\synthea\output\fhir\Elfrieda676_Weber641_f690bc22-3181-40ca-b3d0-580e572245f4.json
C:\Users\User\synthea\output\fhir\Evangelina20_Buckridge80_45c61fae-adc2-4464-af01-ad8e4b7e40e1.json
C:\Users\User\synthea\output\fhir\Glynda607_Oberbrunner298_9ad260a4-6e51-4295-a45f-5e45d6f1f4d3.json
C:\Users\User\synthea\output\fhir\Jordan900_Dickens475_0a1add8e-8468-4656-ac9d-c39f46cc2df5.json
C:\Users\User\synthea\output\fhir\Sharie942_Littel644_e164e7bc-872d-4942-9321-c8943f3c91df.json
C:\Users\User\synthea\output\fhir\Tobias236_Hackett68_0e059736-0da2-4840-a748-5d259a9864dd.json
C:\Users\User\synthea\output\fhir\Wiley422_Witting912_da9c7598-8bf9-4cf7-acff-689eba310230.json
```

## Importing
Once you are ready to import the patients, you need to nagivate to the 
[SYNMENU].

```
FOIA>D ^XUP

Setting up programmer environment
This is a TEST account.

Access Code: ******
Terminal Type set to: C-VT220

You have 11384 new messages.
Select OPTION NAME: SYNMENU       Synthetic Patients Importer Menu

   1      Load Patients from Filesystem [SYN LOAD FILES]
   2      View Ingested Patients' FHIR JSON [SYN FHIR JSON]
   3      Load Log [SYN LOAD LOG]

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
Loading Andrea7_Gaylord332_64cf76b3-02e6-4587-a45d-a53d8228507e.json...
Ingesting Andrea7_Gaylord332_64cf76b3-02e6-4587-a45d-a53d8228507e.json...
Loaded with following data:
DFN: 1              ICN: 2242333820V488716        Graph Store IEN: 1
--------------------------------------------------------------------------
Type                          Loaded?                       Error
ADR/Allergy                   0                             0
Appointments
Care Plans                    53                            42
Problems                      1                             4
Encounters                    46                            42
Immunization                  17                            2
Labs                                                        22
Meds                          49                            42
Procedures                    53                            42
Vitals                        31                            42

Loading Clifford177_Frami345_fb59c2ec-f2c2-4898-b9a3-bd9c8268c06a.json...
Ingesting Clifford177_Frami345_fb59c2ec-f2c2-4898-b9a3-bd9c8268c06a.json...

CALL IRM AND HAVE USERS ASSIGNED TO THE GMRA MARK CHART MAIL GROUP
Type <Enter> to continue or '^' to exit: Loaded with following data:
DFN: 2              ICN: 2399595930V839003        Graph Store IEN: 2
--------------------------------------------------------------------------
Type                          Loaded?                       Error
ADR/Allergy                   1                             0
Appointments
Care Plans                    63                            42
Problems                      1                             1
Encounters                    49                            42
Immunization                  13                            3
Labs                                                        22
Meds                          52                            42
Procedures                    61                            42
Vitals                        31                            42

Loading Eleanor470_Windler79_9183bf97-98e2-46b1-b15a-8a6080519c75.json...
Ingesting Eleanor470_Windler79_9183bf97-98e2-46b1-b15a-8a6080519c75.json...
Loaded with following data:
DFN: 3              ICN: 2552504473V187158        Graph Store IEN: 3
--------------------------------------------------------------------------
Type                          Loaded?                       Error
ADR/Allergy                   0                             0
Appointments
Care Plans                    110                           186
Problems                      8                             3
Encounters                    74                            185
Immunization                  12
Labs                                                        162
Meds                          84                            185
Procedures                    108                           185
Vitals                        33                            183

Loading Elfrieda676_Weber641_f690bc22-3181-40ca-b3d0-580e572245f4.json...
Ingesting Elfrieda676_Weber641_f690bc22-3181-40ca-b3d0-580e572245f4.json...
Loaded with following data:
DFN: 4              ICN: 6697937228V099180        Graph Store IEN: 4
--------------------------------------------------------------------------
Type                          Loaded?                       Error
ADR/Allergy                   0                             0
Appointments
Care Plans                    49                            82
Problems                      9                             2
Encounters                    35                            74
Immunization                  5
Labs                                                        66
Meds                          40                            74
Procedures                    47                            82
Vitals                        15                            74

Loading Evangelina20_Buckridge80_45c61fae-adc2-4464-af01-ad8e4b7e40e1.json...
Ingesting Evangelina20_Buckridge80_45c61fae-adc2-4464-af01-ad8e4b7e40e1.json...
Loaded with following data:
DFN: 5              ICN: 1088722406V945920        Graph Store IEN: 5
--------------------------------------------------------------------------
Type                          Loaded?                       Error
ADR/Allergy                   0                             0
Appointments
Care Plans                    325                           1296
Problems                      6                             4
Encounters                    286                           1295
Immunization                  5                             8
Labs                                                        1057
Meds                          288                           1295
Procedures                    324                           1295
Vitals                        207                           1195

Loading Glynda607_Oberbrunner298_9ad260a4-6e51-4295-a45f-5e45d6f1f4d3.json...
Ingesting Glynda607_Oberbrunner298_9ad260a4-6e51-4295-a45f-5e45d6f1f4d3.json...
Loaded with following data:
DFN: 6              ICN: 1041846255V974887        Graph Store IEN: 6
--------------------------------------------------------------------------
Type                          Loaded?                       Error
ADR/Allergy                   0                             0
Appointments
Care Plans                    45                            43
Problems                      6                             3
Encounters                    35                            43
Immunization                  9
Labs                                                        30
Meds                          38                            43
Procedures                    42                            43
Vitals                        20                            42

Loading Jordan900_Dickens475_0a1add8e-8468-4656-ac9d-c39f46cc2df5.json...
Ingesting Jordan900_Dickens475_0a1add8e-8468-4656-ac9d-c39f46cc2df5.json...
Loaded with following data:
DFN: 7              ICN: 5795359238V603597        Graph Store IEN: 7
--------------------------------------------------------------------------
Type                          Loaded?                       Error
ADR/Allergy                   0                             0
Appointments
Care Plans                    17                            29
Problems                      1
Encounters                    13                            29
Immunization                  6
Labs                                                        22
Meds                          14                            29
Procedures                    16                            29
Vitals                        9                             28

Loading Sharie942_Littel644_e164e7bc-872d-4942-9321-c8943f3c91df.json...
Ingesting Sharie942_Littel644_e164e7bc-872d-4942-9321-c8943f3c91df.json...
Loaded with following data:
DFN: 8              ICN: 1410982341V141809        Graph Store IEN: 8
--------------------------------------------------------------------------
Type                          Loaded?                       Error
ADR/Allergy                   0                             0
Appointments
Care Plans                    83                            167
Problems                      4                             1
Encounters                    62                            39
Immunization                  11
Labs                                                        22
Meds                          64                            39
Procedures                    79                            167
Vitals                        21                            36

Loading Tobias236_Hackett68_0e059736-0da2-4840-a748-5d259a9864dd.json...
Ingesting Tobias236_Hackett68_0e059736-0da2-4840-a748-5d259a9864dd.json...
Loaded with following data:
DFN: 9              ICN: 1232805599V215201        Graph Store IEN: 9
--------------------------------------------------------------------------
Type                          Loaded?                       Error
ADR/Allergy                   0                             0
Appointments
Care Plans                    38                            48
Problems                      3                             2
Encounters                    29                            48
Immunization                  9
Labs                                                        34
Meds                          31                            48
Procedures                    36                            48
Vitals                        19                            46

Loading Wiley422_Witting912_da9c7598-8bf9-4cf7-acff-689eba310230.json...
Ingesting Wiley422_Witting912_da9c7598-8bf9-4cf7-acff-689eba310230.json...
Loaded with following data:
DFN: 10             ICN: 1804856752V148652        Graph Store IEN: 10
--------------------------------------------------------------------------
Type                          Loaded?                       Error
ADR/Allergy                   0                             0
Appointments
Care Plans                    16                            22
Problems                      3
Encounters                    14                            22
Immunization                  4
Labs                                                        15
Meds                          14                            22
Procedures                    16                            22
Vitals                        10                            21
```

## Examining the Status of Load
As you can see, the project is far from perfect in its ability to load data
from Synthea generated FHIR. The menu options `View Ingested Patients' FHIR JSON [SYN FHIR JSON]`
and `Load Log [SYN LOAD LOG]` help you diagnose failed loading issues.

For example, 8 immunizations failed to load for DFN 5. Let's find out why.
Most of the time, we can just look at the load log to figure out what happened.

```
Select Synthetic Patients Importer Menu <TEST ACCOUNT> Option: 3  Load Log
Select PATIENT NAME: `5  BUCKRIDGE80,EVANGELINA20        9-24-63    999828695
  NO     NON-VETERAN (OTHER)

1 all        6 labs          11 procedure
2 patient    7 meds
3 allergy    8 immunizations
4 conditions 9 encounters
5 vitals     10 careplan
Please select clinical category to view:

Enter response: 1// 8

                            PATIENT 5 immunizations
^SYNGRAPH(2002.801,2,5,"load","immunizations")
|--155
|  |--log
|  |  |--1 code is: 140
|  |  |--2 code system is: http://hl7.org/fhir/sid/cvx
|  |  |--3 effectiveDateTime is:
|  |  |--4 fileman dateTime is:
|  |  |--5 hl7 dateTime is:
|  |  |--6 reference encounter ID is : f5c65e78-7d0f-439b-8201-8c33771abccf
|  |  |--7 visit ien is: -1
|  |  |--8 HL7 DateTime is:
|  |  |--9 Provider NPI for outpatient is: 9990000348
|  |  |--10 Location for outpatient is: #3 GENERAL MEDICINE
|  |  |--11 Calling IMMUNUPD^ZZDHP61 to add immunization
|  |  |--12 Return from data loader was: -1^Visit not found
|  |--parms
|  |  |--DHPLOC 3
|  |  |--DHPPAT 1088722406V945920
|  |  |--EVENTDT
|  |  |--IMMPROV 9990000348
|  |  |--IMMUNIZ 140
|  |  |--VISIT -1
Col>   1 |Press <PF1>H for help| Line>      22 of 425  Screen>       1 of 20
```

Now you can use Up/Down and Page Up/Page Down to browse the log. Alternately,
you can use F1-F1-P to print the log to a file using the HFS device.

You can also get the original FHIR from Synthea that got imported for
reference: 

```
Select Synthetic Patients Importer Menu <TEST ACCOUNT> Option: 2  View Ingested Patients' FHIR JSON
Select PATIENT NAME: `5  BUCKRIDGE80,EVANGELINA20        9-24-63    999828695
  NO     NON-VETERAN (OTHER)

1 all         7 MedicationRequest 13 ExplanationOfBenefit
2 Patient     8 Immunization      14 ImagingStudy
3 Allergy     9 Encounter         15 Practitioner
4 Condition   10 CarePlan         16 Organization
5 Observation 11 Procedure
6 Claim       12 DiagnosticReport
Please select clinical category to view:

Enter response: 1// 8

                            PATIENT 5 Immunization
^TMP("SYNFHIR",1036)
|--Immunization
|  |--entry
|  |  |--155
|  |  |  |--fullUrl urn:uuid:0f235683-bd85-4936-8fdc-0466cecc8ab5
|  |  |  |--request
|  |  |  |  |--method POST
|  |  |  |  |--url Immunization
|  |  |  |--resource
|  |  |  |  |--encounter
|  |  |  |  |  |--reference urn:uuid:f5c65e78-7d0f-439b-8201-8c33771abccf
|  |  |  |  |--id 0f235683-bd85-4936-8fdc-0466cecc8ab5
|  |  |  |  |--occurrenceDateTime 2010-03-30T13:50:14-07:00
|  |  |  |  |--patient
|  |  |  |  |  |--reference urn:uuid:bdb144ae-e4f8-49ab-b7c5-6304cb3a76c9
|  |  |  |  |--primarySource true
|  |  |  |  |--resourceType Immunization
|  |  |  |  |--status completed
|  |  |  |  |--vaccineCode
|  |  |  |  |  |--coding
|  |  |  |  |  |  |--1
|  |  |  |  |  |  |  |--code 140
Col>   1 |Press <PF1>H for help| Line>      22 of 302  Screen>       1 of 14
```

As before, you can use F1-F1-P to print the document from the browser.

## Getting the Virtual Patient Record on a patient
Future work: To be put on the menu: ``D VPR^SYNVPR``

# How to contribute
You can join the developers by sending a message to this mailing list: https://www.osehra.org/groups/synthetic-patient-data-project-group 

# License
All source code produced is under Apache 2.0.
