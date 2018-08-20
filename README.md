# VistA FHIR Data Loader Project
This project lets you load data from Synthea (https://synthetichealth.github.io/synthea/) 
into VistA to produce high quality synthetic patient data for development and testing.
Other FHIR data sources are supportable; but are not supported at this time.

# Installation
As of Aug 20th 2018, the official way to install this project is to use the latest
KIDS build in [releases](https://github.com/OSEHRA/VistA-FHIR-Data-Loader/releases/latest).

The KIDS build needs to be unzipped first and then installed. The installer must have the key
XUMGR in order to be able to add users to the systems.

Here's a sample install transcript:

```
[root@c3e7f9a9d95d vista]# mumps -dir

FOIA>S DUZ=1

FOIA>D ^XUP

Setting up programmer environment
This is a TEST account.

Terminal Type set to: C-VT220

Select OPTION NAME:
FOIA>D ^XPDIL,^XPDI

Enter a Host File: /opt/vista/VISTA_SYNTHETIC_DATA_LOADER_BUNDLE_0P1T3.KID

KIDS Distribution saved on Aug 17, 2018@17:06:42
Comment: T3

This Distribution contains Transport Globals for the following Package(s):
   ISI_DATA_LOADER 2.5
   VISTA SYNTHETIC DATA LOADER 0.1
Distribution OK!

Want to Continue with Load? YES//
Loading Distribution...

   ISI_DATA_LOADER 2.5
Build VISTA SYNTHETIC DATA LOADER 0.1 has an Environmental Check Routine
Want to RUN the Environment Check Routine? YES//

   VISTA SYNTHETIC DATA LOADER 0.1
Will first run the Environment Check Routine, SYNKIDS
Use INSTALL NAME: ISI_DATA_LOADER 2.5 to install this Distribution.

Select INSTALL NAME: ISI_DATA_LOADER 2.5       Loaded from Distribution    8/20/
18@13:51:20
     => T3   ;Created on Aug 17, 2018@17:06:42

This Distribution was loaded on Aug 20, 2018@13:51:20 with header of
   T3   ;Created on Aug 17, 2018@17:06:42
   It consisted of the following Install(s):
ISI_DATA_LOADER 2.5VISTA SYNTHETIC DATA LOADER 0.1
Checking Install for Package ISI_DATA_LOADER 2.5

Install Questions for ISI_DATA_LOADER 2.5

Incoming Files:


   9001      ISI PT IMPORT TEMPLATE  (including data)

Want KIDS to Rebuild Menu Trees Upon Completion of Install? NO//

Checking Install for Package VISTA SYNTHETIC DATA LOADER 0.1

Install Questions for VISTA SYNTHETIC DATA LOADER 0.1

Incoming Files:


   17.040801 graph


Want KIDS to INHIBIT LOGONs during the install? NO//
Want to DISABLE Scheduled Options, Menu Options, and Protocols? NO//

Enter the Device you want to print the Install messages.
You can queue the install by enter a 'Q' at the device prompt.
Enter a '^' to abort the install.

DEVICE: HOME// ;P-OTHER;  TELNET


 Install Started for ISI_DATA_LOADER 2.5 :
               Aug 20, 2018@13:51:40

Build Distribution Date: Aug 17, 2018

 Installing Routines:..........................................................
               Aug 20, 2018@13:51:41

 Installing Data Dictionaries: ..
               Aug 20, 2018@13:51:41

 Installing Data:
               Aug 20, 2018@13:51:41

 Installing PACKAGE COMPONENTS:

 Installing REMOTE PROCEDURE........................

 Installing OPTION..
               Aug 20, 2018@13:51:41

 Updating Routine file......

 Updating KIDS files.....

 ISI_DATA_LOADER 2.5 Installed.
               Aug 20, 2018@13:51:41

 No link to PACKAGE file

 NO Install Message sent

 Install Started for VISTA SYNTHETIC DATA LOADER 0.1 :
               Aug 20, 2018@13:51:41

Build Distribution Date: Aug 17, 2018

 Installing Routines:
               Aug 20, 2018@13:51:41

 Running Pre-Install Routine: PRE^SYNKIDS.

 Installing Data Dictionaries: ..
               Aug 20, 2018@13:51:41

 Running Post-Install Routine: POST^SYNKIDS.
Downloading MASH...
Downloading MWS...
This version (#0.2) of '%WINIT' was created on 22-NOV-2013
         (at Vista-Office EHR, by VA FILEMAN 22.0)

I AM GOING TO SET UP THE FOLLOWING FILES:

   17.6001   WEB SERVICE URL HANDLER


...SORRY, I'M WORKING AS FAST AS I CAN........
OK, I'M DONE.
NOTE THAT FILE SECURITY-CODE PROTECTION HAS BEEN MADE

Mumps Web Services is now listening to port 9080
Visit http://localhost:9080/ to see the home page.
Also, try the sample web services...
 - http://localhost:9080/xml
 - http://localhost:9080/ping

LOADING URL HANDLERS


Syn Patients Importer Init
Provider 66
Pharmacist 67
Hospital Location 12
Fixing AMIE thingy
Fixing IB ACTION TYPE file
Setting up Outpatient Pharmacy 3

 Updating Routine file......

 Updating KIDS files.......

 VISTA SYNTHETIC DATA LOADER 0.1 Installed.
               Aug 20, 2018@13:51:45

 Not a VA primary domain

 NO Install Message sent
```

# Loading Synthetic Patients
To pull EXISTING (previously created) synthetic patients, run: `D LOADALL^SYNFPUL`. This will load 1000 patients into VistA.

To create new synthetic patients from Synthea, and load them into VistA, do the following:

```
git clone https://github.com/synthetichealth/synthea.git
cd synthea
./gradlew clean build
./run_synthea
find output -name '*.json' # note which patients show up here; you need to pick one
curl -H "Content-Type: application/json" localhost:9080/addpatient --data @{file_name}
```

Here's the output of the last three steps for reference:

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
saichiko:synthea sam$ curl -H "Content-Type: application/json" localhost:9080/addpatient --data @output/fhir/King743_Eichmann909_c7f8935d-1099-4ce3-81da-3256f02a2956.json
{"conditionsStatus":{"errors":"","loaded":"","status":""},"dfn":14,"encountersStatus":{"errors":24,"loaded":"","status":"ok"},"icn":"1563654899V859470","id":"","ien":12,"immunizationsStatus":{"errors":"","loaded":35,"status":"ok"},"loadStatus":"loaded","status":"ok","vitalsStatus":{"errors":8,"loaded":53,"status":"ok"}}saichiko:synthea sam$
```

# How to contribute
You can join the developers by sending a message to this mailing list: https://www.osehra.org/groups/synthetic-patient-data-project-group 

# License
All source code produced is under Apache 2.0.
