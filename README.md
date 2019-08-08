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

* Java 1.8 or above to run Synthea
* Git to clone the Synthea Repository
* Intersystems Cache with the VistA database loaded. This does not have to be
on your own laptop; you can copy the generated Synthea Patients into the
machine that hosts your VistA instance.

# Installation
As of Aug 20th 2018, the official way to install this project is to use the latest
KIDS build in [releases](https://github.com/OSEHRA/VistA-FHIR-Data-Loader/releases/latest).

As of v0.2 (unlike v0.1), PCE STANDARDIZATION 1.0 is now required. In order to
install this, you need these patches:
 
 * https://foia-vista.osehra.org/Patches_By_Application/XU-KERNEL/XU-8_SEQ-546_PAT-672.kids (if not installed)
 * https://code.osehra.org/journal/download?items=1173,%201 (zip file, unzip and load PCE_STANDARDIZATION_1_0_T5.KID)
 * https://github.com/OSEHRA/VistA-FHIR-Data-Loader/releases/download/0.2va/VISTA_FHIR_DATA_LOADER_VA_VERSION_0P2.KID.zip (zip file, unzip and load VISTA_FHIR_DATA_LOADER_VA_VERSION_0P2.KID.zip)

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
installed.

```
git clone https://github.com/synthetichealth/synthea.git
cd synthea
./run_synthea # or ./run_synthea.bat on Windows
```

Here's the output for reference:

```
saichiko:synthea sam$ ./run_synthea

> Task :run
Loading /Users/sam/workspace/repo/synthea/build/resources/main/modules/dementia.json
Loading /Users/sam/workspace/repo/synthea/build/resources/main/modules/colorectal_cancer.json
Loading /Users/sam/workspace/repo/synthea/build/resources/main/modules/self_harm.json
Loading /Users/sam/workspace/repo/synthea/build/resources/main/modules/osteoporosis.json
Loading /Users/sam/workspace/repo/synthea/build/resources/main/modules/epilepsy.json
Loading /Users/sam/workspace/repo/synthea/build/resources/main/modules/primary_atrophic_hypothyroidism.json
Loading /Users/sam/workspace/repo/synthea/build/resources/main/modules/attention_deficit_disorder.json
Loading /Users/sam/workspace/repo/synthea/build/resources/main/modules/medications/ear_infection_antibiotic.json
Loading /Users/sam/workspace/repo/synthea/build/resources/main/modules/medications/moderate_opioid_pain_reliever.json
Loading /Users/sam/workspace/repo/synthea/build/resources/main/modules/medications/strong_opioid_pain_reliever.json
Loading /Users/sam/workspace/repo/synthea/build/resources/main/modules/medications/otc_pain_reliever.json
Loading /Users/sam/workspace/repo/synthea/build/resources/main/modules/medications/otc_antihistamine.json
Loading /Users/sam/workspace/repo/synthea/build/resources/main/modules/sore_throat.json
Loading /Users/sam/workspace/repo/synthea/build/resources/main/modules/homelessness.json
Loading /Users/sam/workspace/repo/synthea/build/resources/main/modules/total_joint_replacement/functional_status_assessments.json
Loading /Users/sam/workspace/repo/synthea/build/resources/main/modules/lung_cancer.json
Loading /Users/sam/workspace/repo/synthea/build/resources/main/modules/contraceptives.json
Loading /Users/sam/workspace/repo/synthea/build/resources/main/modules/sexual_activity.json
Loading /Users/sam/workspace/repo/synthea/build/resources/main/modules/appendicitis.json
Loading /Users/sam/workspace/repo/synthea/build/resources/main/modules/opioid_addiction.json
Loading /Users/sam/workspace/repo/synthea/build/resources/main/modules/osteoarthritis.json
Loading /Users/sam/workspace/repo/synthea/build/resources/main/modules/pregnancy.json
Loading /Users/sam/workspace/repo/synthea/build/resources/main/modules/contraceptives/female_sterilization.json
Loading /Users/sam/workspace/repo/synthea/build/resources/main/modules/contraceptives/patch_contraceptive.json
Loading /Users/sam/workspace/repo/synthea/build/resources/main/modules/contraceptives/oral_contraceptive.json
Loading /Users/sam/workspace/repo/synthea/build/resources/main/modules/contraceptives/injectable_contraceptive.json
Loading /Users/sam/workspace/repo/synthea/build/resources/main/modules/contraceptives/implant_contraceptive.json
Loading /Users/sam/workspace/repo/synthea/build/resources/main/modules/contraceptives/ring_contraceptive.json
Loading /Users/sam/workspace/repo/synthea/build/resources/main/modules/contraceptives/male_sterilization.json
Loading /Users/sam/workspace/repo/synthea/build/resources/main/modules/contraceptives/clear_contraceptive.json
Loading /Users/sam/workspace/repo/synthea/build/resources/main/modules/contraceptives/intrauterine_device.json
Loading /Users/sam/workspace/repo/synthea/build/resources/main/modules/contraceptive_maintenance.json
Loading /Users/sam/workspace/repo/synthea/build/resources/main/modules/fibromyalgia.json
Loading /Users/sam/workspace/repo/synthea/build/resources/main/modules/lupus.json
Loading /Users/sam/workspace/repo/synthea/build/resources/main/modules/cystic_fibrosis.json
Loading /Users/sam/workspace/repo/synthea/build/resources/main/modules/rheumatoid_arthritis.json
Loading /Users/sam/workspace/repo/synthea/build/resources/main/modules/urinary_tract_infections.json
Loading /Users/sam/workspace/repo/synthea/build/resources/main/modules/metabolic_syndrome_care.json
Loading /Users/sam/workspace/repo/synthea/build/resources/main/modules/bronchitis.json
Loading /Users/sam/workspace/repo/synthea/build/resources/main/modules/asthma.json
Loading /Users/sam/workspace/repo/synthea/build/resources/main/modules/sinusitis.json
Loading /Users/sam/workspace/repo/synthea/build/resources/main/modules/copd.json
Loading /Users/sam/workspace/repo/synthea/build/resources/main/modules/gout.json
Loading /Users/sam/workspace/repo/synthea/build/resources/main/modules/injuries.json
Loading /Users/sam/workspace/repo/synthea/build/resources/main/modules/allergies.json
Loading /Users/sam/workspace/repo/synthea/build/resources/main/modules/wellness_encounters.json
Loading /Users/sam/workspace/repo/synthea/build/resources/main/modules/dermatitis.json
Loading /Users/sam/workspace/repo/synthea/build/resources/main/modules/lung_cancer/lung_cancer_probabilities.json
Loading /Users/sam/workspace/repo/synthea/build/resources/main/modules/food_allergies.json
Loading /Users/sam/workspace/repo/synthea/build/resources/main/modules/atopy.json
Loading /Users/sam/workspace/repo/synthea/build/resources/main/modules/allergies/outgrow_env_allergies.json
Loading /Users/sam/workspace/repo/synthea/build/resources/main/modules/allergies/allergy_panel.json
Loading /Users/sam/workspace/repo/synthea/build/resources/main/modules/allergies/outgrow_food_allergies.json
Loading /Users/sam/workspace/repo/synthea/build/resources/main/modules/allergies/severe_allergic_reaction.json
Loading /Users/sam/workspace/repo/synthea/build/resources/main/modules/allergies/allergy_incidence.json
Loading /Users/sam/workspace/repo/synthea/build/resources/main/modules/allergies/immunotherapy.json
Loading /Users/sam/workspace/repo/synthea/build/resources/main/modules/allergic_rhinitis.json
Loading /Users/sam/workspace/repo/synthea/build/resources/main/modules/female_reproduction.json
Loading /Users/sam/workspace/repo/synthea/build/resources/main/modules/dermatitis/early_severe_eczema_obs.json
Loading /Users/sam/workspace/repo/synthea/build/resources/main/modules/dermatitis/moderate_cd_obs.json
Loading /Users/sam/workspace/repo/synthea/build/resources/main/modules/dermatitis/severe_cd_obs.json
Loading /Users/sam/workspace/repo/synthea/build/resources/main/modules/dermatitis/early_moderate_eczema_obs.json
Loading /Users/sam/workspace/repo/synthea/build/resources/main/modules/dermatitis/mid_moderate_eczema_obs.json
Loading /Users/sam/workspace/repo/synthea/build/resources/main/modules/dermatitis/mid_severe_eczema_obs.json
Loading /Users/sam/workspace/repo/synthea/build/resources/main/modules/med_rec.json
Loading /Users/sam/workspace/repo/synthea/build/resources/main/modules/metabolic_syndrome_disease.json
Loading /Users/sam/workspace/repo/synthea/build/resources/main/modules/ear_infections.json
Loading /Users/sam/workspace/repo/synthea/build/resources/main/modules/total_joint_replacement.json
Loaded 72 modules.
Running with options:
Population: 1
Seed: 1534183758504
Location: Massachusetts
Min Age: 0
Max Age: 140
1 -- King743 Eichmann909 (8 y/o M) Marblehead, Massachusetts
{alive=1, dead=0}

BUILD SUCCESSFUL in 6s
4 actionable tasks: 2 executed, 2 up-to-date
saichiko:synthea sam$ find output/
output/
output//fhir
output//fhir/hospitalInformation1534183758506.json
output//fhir/King743_Eichmann909_c7f8935d-1099-4ce3-81da-3256f02a2956.json
saichiko:synthea sam$ find output -name '*.json*'
output/fhir/hospitalInformation1534183758506.json
output/fhir/King743_Eichmann909_c7f8935d-1099-4ce3-81da-3256f02a2956.json
saichiko:synthea sam$ curl localhost:9080/addpatient -d @output/fhir/King743_Eichmann909_c7f8935d-1099-4ce3-81da-3256f02a2956.json
{"allergyStatus":{"errors":0,"loaded":0,"status":""},"apptStatus":{"errors":"","loaded":"","status":""},"careplanStatus":{"errors":2,"loaded":1,"status":"ok"},"dfn":22,"encountersStatus":{"errors":3,"loaded":16,"status":"ok"},"icn":"2741032865V461309","id":"","ien":22,"immunizationsStatus":{"errors":"","loaded":13,"status":"ok"},"labsStatus":{"errors":21,"loaded":114,"status":"ok"},"loadStatus":"loaded","medsStatus":{"errors":"","loaded":5,"status":"ok"},"problemStatus":{"errors":"","loaded":8,"status":"ok"},"proceduresStatus":{"errors":"","loaded":20,"status":"ok"},"status":"ok","vitalsStatus":{"errors":20,"loaded":31,"status":"ok"}}
```

## Updating an existing patient
The call is similar, expect use updatepatient?icn={icn from previous call}
```
curl localhost:9080/updatepatient?icn=1563654899V859470 -d @output/fhir/King743_Eichmann909_c7f8935d-1099-4ce3-81da-3256f02a2956.json
```

The update call doesn't work too well right now... it adds data again. But worth
coming back to in future versions.

## Examining the Status of Load
This is useful to see the errors. Pipe to `less` to page through it or view in
a browser. You can either ask for it using this URL: `/loadstatus?latest=1` for
the last one; or `/loadstatus?ien={ien}`; the ien which is obtained from
addpatient/updatepatient call.

On GT.M/YottaDB, you can do a more targeted analysis using a ZWRITE command
sent to stdout, like this

```
mumps -r %XCMD 'zwrite ^%wd(17.040801,1,{ien},"load",:,:,"status",*)'
```

Note that the second subscript 1 may be different on development systems. You
can find it by typing in the command line `w $$setroot^%wd("fhir-intake")`.

This will narrow it down to just load statuses, which you can filter down using
grep/ack/rg etc.

## Getting the Virtual Patient Record on a patient
The url is /vpr/{dfn}.

```
curl localhost:9080/vpr/1
```



# How to contribute
You can join the developers by sending a message to this mailing list: https://www.osehra.org/groups/synthetic-patient-data-project-group 

# License
All source code produced is under Apache 2.0.
