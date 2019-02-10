# VistA FHIR Data Loader Project
This project lets you load data from Synthea (https://synthetichealth.github.io/synthea/) 
into VistA to produce high quality synthetic patient data for development and testing.
Other FHIR data sources are supportable; but are not supported at this time.

# Installation
As of Aug 20th 2018, the official way to install this project is to use the latest
KIDS build in [releases](https://github.com/OSEHRA/VistA-FHIR-Data-Loader/releases/latest).

As of v0.2 (unlike v0.1), PCE STANDARDIZATION 1.0 is now required. In order to
install this, you need these patches:
 
 * https://foia-vista.osehra.org/Patches_By_Application/XU-KERNEL/XU-8_SEQ-546_PAT-672.kids
 * https://code.osehra.org/journal/download?items=1097,%208 (zip file, unzip and load PCE_STANDARDIZATION_1_0_T4.KID)
 * https://github.com/OSEHRA/VistA-FHIR-Data-Loader/releases/download/0.2/SYN_BUNDLE_0P2.KIDS.zip (zip file, unzip and load SYN_BUNDLE_0P2.KIDS)

As of the time of this writing, PCE STANDARIDZATION has not been officially
released by the VA. That's why you need to obtain it from the Tech Journal. 

The KIDS build needs to be unzipped first and then installed. The installer
must have the key XUMGR in order to be able to add users to the systems.

## Sample Install Transcript on GT.M/YottaDB:

```
OSEHRA>D ^XPDIL,^XPDI

Enter a Host File: SYN_BUNDLE_0P2.KIDS

KIDS Distribution saved on Feb 07, 2019@15:56:08
Comment: T13

This Distribution contains Transport Globals for the following Package(s):
   ISI_DATA_LOADER 2.6
   VISTA SYN DATA LOADER 0.2
Distribution OK!

Want to Continue with Load? YES//
Loading Distribution...

   ISI_DATA_LOADER 2.6
Build VISTA SYN DATA LOADER 0.2 has an Environmental Check Routine
Want to RUN the Environment Check Routine? YES//
   VISTA SYN DATA LOADER 0.2
Will first run the Environment Check Routine, SYNKIDS

Use INSTALL NAME: ISI_DATA_LOADER 2.6 to install this Distribution.

Select INSTALL NAME: isi_DATA_LOADER 2.6       Loaded from Distribution    2/8/1
9@14:24:18
     => T13  ;Created on Feb 07, 2019@15:56:08

This Distribution was loaded on Feb 08, 2019@14:24:18 with header of
   T13  ;Created on Feb 07, 2019@15:56:08
   It consisted of the following Install(s):
ISI_DATA_LOADER 2.6VISTA SYN DATA LOADER 0.2
Checking Install for Package ISI_DATA_LOADER 2.6

Install Questions for ISI_DATA_LOADER 2.6

Incoming Files:


   9001      ISI PT IMPORT TEMPLATE  (including data)

Want KIDS to Rebuild Menu Trees Upon Completion of Install? NO//

Checking Install for Package VISTA SYN DATA LOADER 0.2
Will first run the Environment Check Routine, SYNKIDS


Install Questions for VISTA SYN DATA LOADER 0.2

Incoming Files:


   17.040801 graph


Want KIDS to INHIBIT LOGONs during the install? NO//
Want to DISABLE Scheduled Options, Menu Options, and Protocols? NO//

Enter the Device you want to print the Install messages.
You can queue the install by enter a 'Q' at the device prompt.
Enter a '^' to abort the install.

DEVICE: HOME// ;p-other;  TELNET


 Install Started for ISI_DATA_LOADER 2.6 :
               Feb 08, 2019@14:24:31

Build Distribution Date: Feb 07, 2019

 Installing Routines:..........................................................
               Feb 08, 2019@14:24:32

 Installing Data Dictionaries: ..
               Feb 08, 2019@14:24:32

 Installing Data:
               Feb 08, 2019@14:24:32

 Installing PACKAGE COMPONENTS:

 Installing REMOTE PROCEDURE........................

 Installing OPTION..
               Feb 08, 2019@14:24:32

 Updating Routine file......

 Updating KIDS files.....

 ISI_DATA_LOADER 2.6 Installed.
               Feb 08, 2019@14:24:32

 No link to PACKAGE file

 NO Install Message sent

 Install Started for VISTA SYN DATA LOADER 0.2 :
               Feb 08, 2019@14:24:32

Build Distribution Date: Feb 07, 2019

 Installing Routines:.........................................
               Feb 08, 2019@14:24:32

 Running Pre-Install Routine: PRE^SYNKIDS.

 Installing Data Dictionaries: ..
               Feb 08, 2019@14:24:32

 Running Post-Install Routine: POST^SYNKIDS.
Downloading MASH...
Downloading MWS...YDB-MUMPS[1714]: %YDB-I-DBFILEXT, Database file /home/osehra/g/osehra.dat extended from 0x000A8684 blocks to 0x000A8A86 at transaction 0x00000000082FBFF0 -- generated from 0x00007F5279F9B3F4.
YDB-MUMPS[1714]: %YDB-I-DBFILEXT, Database file /home/osehra/g/osehra.dat extended from 0x000A8A86 blocks to 0x000A8E88 at transaction 0x000000000830A3FE -- generated from 0x00007F5279F9B3F4.
YDB-MUMPS[1714]: %YDB-I-DBFILEXT, Database file /home/osehra/g/osehra.dat extended from 0x000A8E88 blocks to 0x000A928A at transaction 0x00000000083190CA -- generated from 0x00007F5279F9B3F4.

This version (#1.0) of '%webINIT' was created on 22-JAN-2019
         (at DEMO.OSEHRA.ORG, by MSC FileMan 22.1061)

I AM GOING TO SET UP THE FOLLOWING FILES:

   17.6001   WEB SERVICE URL HANDLER


...SORRY, HOLD ON........
OK, I'M DONE.
NOTE THAT FILE SECURITY-CODE PROTECTION HAS BEEN MADE
Trying to open a port for the web server...
Trying 9080

Mumps Web Services is now listening to port 9080
Visit http://localhost:9080/ to see the home page.
Also, try the sample web services...
 - http://localhost:9080/xml
 - http://localhost:9080/ping
Merging ^SYN global in. This takes time...YDB-MUMPS[1714]: %YDB-I-DBFILEXT, Database file /home/osehra/g/osehra.dat extended from 0x000A928A blocks to 0x000A968C at transaction 0x0000000008326EE5 -- generated from 0x00007F5279F9B3F4.
YDB-MUMPS[1714]: %YDB-I-DBFILEXT, Database file /home/osehra/g/osehra.dat extended from 0x000A968C blocks to 0x000A9A8E at transaction 0x0000000008335DD6 -- generated from 0x00007F5279F9B3F4.
YDB-MUMPS[1714]: %YDB-I-DBFILEXT, Database file /home/osehra/g/osehra.dat extended from 0x000A9A8E blocks to 0x000A9E90 at transaction 0x0000000008344D4E -- generated from 0x00007F5279F9B3F4.
YDB-MUMPS[1714]: %YDB-I-DBFILEXT, Database file /home/osehra/g/osehra.dat extended from 0x000A9E90 blocks to 0x000AA292 at transaction 0x00000000083553F8 -- generated from 0x00007F5279F9B3F4.
YDB-MUMPS[1714]: %YDB-I-DBFILEXT, Database file /home/osehra/g/osehra.dat extended from 0x000AA292 blocks to 0x000AA694 at transaction 0x0000000008364B28 -- generated from 0x00007F5279F9B3F4.
YDB-MUMPS[1714]: %YDB-I-DBFILEXT, Database file /home/osehra/g/osehra.dat extended from 0x000AA694 blocks to 0x000AAA96 at transaction 0x000000000836E19D -- generated from 0x00007F5279F9B3F4.


Syn Patients Importer Init
Provider 67
Pharmacist 68
Hospital Location 12
Fixing AMIE thingy
Fixing IB ACTION TYPE file
Setting up Outpatient Pharmacy 3

 Updating Routine file......

 Updating KIDS files.......

 VISTA SYN DATA LOADER 0.2 Installed.
               Feb 08, 2019@14:24:36

 Not a VA primary domain

 NO Install Message sent
```

## Sample Install on Cache
```
VEHU>d ^XPDIL,^XPDI

Enter a Host File: /tmp/SYN_BUNDLE_0P2.KIDS

KIDS Distribution saved on Feb 07, 2019@15:56:08
Comment: T13

This Distribution contains Transport Globals for the following Package(s):
   ISI_DATA_LOADER 2.6
   VISTA SYN DATA LOADER 0.2
Distribution OK!

Want to Continue with Load? YES//
Loading Distribution...

   ISI_DATA_LOADER 2.6
Build VISTA SYN DATA LOADER 0.2 has an Environmental Check Routine
Want to RUN the Environment Check Routine? YES//
   VISTA SYN DATA LOADER 0.2
Will first run the Environment Check Routine, SYNKIDS

Use INSTALL NAME: ISI_DATA_LOADER 2.6 to install this Distribution.

Select INSTALL NAME: isi_DATA_LOADER 2.6       Loaded from Distribution    2/8/1
9@15:44
     => T13  ;Created on Feb 07, 2019@15:56:08

This Distribution was loaded on Feb 08, 2019@15:44 with header of
   T13  ;Created on Feb 07, 2019@15:56:08
   It consisted of the following Install(s):
ISI_DATA_LOADER 2.6VISTA SYN DATA LOADER 0.2
Checking Install for Package ISI_DATA_LOADER 2.6

Install Questions for ISI_DATA_LOADER 2.6

Incoming Files:


   9001      ISI PT IMPORT TEMPLATE  (including data)

Want KIDS to Rebuild Menu Trees Upon Completion of Install? NO//

Checking Install for Package VISTA SYN DATA LOADER 0.2
Will first run the Environment Check Routine, SYNKIDS


Install Questions for VISTA SYN DATA LOADER 0.2

Incoming Files:


   17.040801 graph


Want KIDS to INHIBIT LOGONs during the install? NO//
Want to DISABLE Scheduled Options, Menu Options, and Protocols? NO//

Enter the Device you want to print the Install messages.
You can queue the install by enter a 'Q' at the device prompt.
Enter a '^' to abort the install.

DEVICE: HOME// ;p-other;  Virtual Terminal


 Install Started for ISI_DATA_LOADER 2.6 :
               Feb 08, 2019@15:44:07

Build Distribution Date: Feb 07, 2019

 Installing Routines:..........................................................
               Feb 08, 2019@15:44:07

 Installing Data Dictionaries: ..
               Feb 08, 2019@15:44:07

 Installing Data:
               Feb 08, 2019@15:44:07

 Installing PACKAGE COMPONENTS:

 Installing REMOTE PROCEDURE........................

 Installing OPTION..
               Feb 08, 2019@15:44:07

 Updating Routine file......

 Updating KIDS files.....

 ISI_DATA_LOADER 2.6 Installed.
               Feb 08, 2019@15:44:07

 No link to PACKAGE file

 NO Install Message sent

 Install Started for VISTA SYN DATA LOADER 0.2 :
               Feb 08, 2019@15:44:07

Build Distribution Date: Feb 07, 2019

 Installing Routines:.........................................
               Feb 08, 2019@15:44:07

 Running Pre-Install Routine: PRE^SYNKIDS.TLS/SSL client configured on Cache as config name 'encrypt_only'


 Installing Data Dictionaries: ..
               Feb 08, 2019@15:44:08

 Running Post-Install Routine: POST^SYNKIDS.
Downloading MASH...
Downloading MWS...
This version (#1.0) of '%webINIT' was created on 22-JAN-2019
         (at DEMO.OSEHRA.ORG, by MSC FileMan 22.1061)

I AM GOING TO SET UP THE FOLLOWING FILES:

   17.6001   WEB SERVICE URL HANDLER


...EXCUSE ME, I'M WORKING AS FAST AS I CAN........
OK, I'M DONE.
NOTE THAT FILE SECURITY-CODE PROTECTION HAS BEEN MADE
Trying to open a port for the web server...
Trying 9080

Mumps Web Services is now listening to port 9080
Visit http://localhost:9080/ to see the home page.
Also, try the sample web services...
 - http://localhost:9080/xml
 - http://localhost:9080/ping
Merging ^SYN global in. This takes time...

Syn Patients Importer Init
Provider 63
Pharmacist 64
Hospital Location 3
Fixing AMIE thingy
Fixing IB ACTION TYPE file
Setting up Outpatient Pharmacy 3

 Updating Routine file......

 Updating KIDS files.......

 VISTA SYN DATA LOADER 0.2 Installed.
               Feb 08, 2019@15:44:10

 Not a production UCI

 NO Install Message sent
```

# Usage
## Loading Synthetic Patients
To pull EXISTING (previously created) synthetic patients, run: `D LOADALL^SYNFPUL`. This will load 1000 patients into VistA.

To create new synthetic patients from Synthea, and load them into VistA, do the following:

```
git clone https://github.com/synthetichealth/synthea.git
cd synthea
./gradlew clean build
./run_synthea
find output -name '*.json' # note which patients show up here; you need to pick one
curl localhost:9080/addpatient -d @{file_name}
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
