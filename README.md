# VistA FHIR Data Loader Project
This project lets you load data from Synthea (https://synthetichealth.github.io/synthea/) 
into VistA to produce high quality synthetic patient data for development and testing.
Other FHIR data sources are supportable; but are not supported at this time.

# Installation
As of Aug 20th 2018, the official way to install this project is to use the latest
KIDS build in [releases](https://github.com/OSEHRA/VistA-FHIR-Data-Loader/releases/latest).

As of v0.2 (unlike v0.1), PCE STANDARDIZATION 1.0 is now required. 

In order to install this, you need these patches:
 
 * https://foia-vista.osehra.org/Patches_By_Application/XU-KERNEL/XU-8_SEQ-546_PAT-672.kids (if not installed)
 * https://code.osehra.org/journal/download?items=1173,%201 (zip file, unzip and load PCE_STANDARDIZATION_1_0_T5.KID)
 * https://github.com/OSEHRA/VistA-FHIR-Data-Loader/releases/download/0.3/VISTA_FHIR_DATA_LOADER_BUNDLE_0P3.zip (zip file, unzip and load VISTA_FHIR_DATA_LOADER_BUNDLE_0P3.KID)

As of the time of this writing, PCE STANDARIDZATION has not been officially
released by the VA. That's why you need to obtain it from the Tech Journal. 

The installer must have the key XUMGR in order to be able to add users to the
systems.

## Sample Install Transcript

```
VEHU>D ^XPDIL,^XPDI

Enter a Host File: /tmp/VISTA_FHIR_DATA_LOADER_BUNDLE_0P3.KID

KIDS Distribution saved on Jul 02, 2019@17:24:06
Comment: T3 - $$HL on SYNINIT has bug with rePopulate

This Distribution contains Transport Globals for the following Package(s):
   VISTA FHIR DATA LOADER BUNDLE 0.3
   VISTA DATALOADER 3.0
   VISTA SYNTHETIC DATA LOADER 0.3
   ZZ PCE STAND T5 FIXES 0.0
Distribution OK!

Want to Continue with Load? YES//
Loading Distribution...

   VISTA FHIR DATA LOADER BUNDLE 0.3
   VISTA DATALOADER 3.0
Build VISTA SYNTHETIC DATA LOADER 0.3 has an Environmental Check Routine
Want to RUN the Environment Check Routine? YES//
   VISTA SYNTHETIC DATA LOADER 0.3
Will first run the Environment Check Routine, SYNKIDS

   ZZ PCE STAND T5 FIXES 0.0
Use INSTALL NAME: VISTA FHIR DATA LOADER BUNDLE 0.3 to install this Distribution
.

Select INSTALL NAME: vista FHIR DATA LOADER BUNDLE 0.3      7/3/19@14:34:09
     => T3 - $$HL on SYNINIT has bug with rePopulate  ;Created on Jul 02, 2019

This Distribution was loaded on Jul 03, 2019@14:34:09 with header of
   T3 - $$HL on SYNINIT has bug with rePopulate  ;Created on Jul 02, 2019@17:24:
06
   It consisted of the following Install(s):
VISTA FHIR DATA LOADER BUNDLE 0.3VISTA DATALOADER 3.0VISTA SYNTHETIC DATA LOADER
 0.3ZZ PCE STAND T5 FIXES 0.0
Checking Install for Package VISTA FHIR DATA LOADER BUNDLE 0.3

Install Questions for VISTA FHIR DATA LOADER BUNDLE 0.3


Checking Install for Package VISTA DATALOADER 3.0

Install Questions for VISTA DATALOADER 3.0

Incoming Files:


   9001      ISI PT IMPORT TEMPLATE  (including data)
Note:  You already have the 'ISI PT IMPORT TEMPLATE' File.
I will OVERWRITE your data with mine.

Want KIDS to Rebuild Menu Trees Upon Completion of Install? NO//

Checking Install for Package VISTA SYNTHETIC DATA LOADER 0.3
Will first run the Environment Check Routine, SYNKIDS


Install Questions for VISTA SYNTHETIC DATA LOADER 0.3

Incoming Files:


   17.040801 graph

Checking Install for Package ZZ PCE STAND T5 FIXES 0.0

Install Questions for ZZ PCE STAND T5 FIXES 0.0



Want KIDS to INHIBIT LOGONs during the install? NO//
Want to DISABLE Scheduled Options, Menu Options, and Protocols? NO//

Enter the Device you want to print the Install messages.
You can queue the install by enter a 'Q' at the device prompt.
Enter a '^' to abort the install.

DEVICE: HOME// ;p-other;  VMS


 Install Started for VISTA FHIR DATA LOADER BUNDLE 0.3 :
               Jul 03, 2019@14:34:28

Build Distribution Date: Jul 02, 2019

 Installing Routines:.
               Jul 03, 2019@14:34:28

 Install Started for VISTA DATALOADER 3.0 :
               Jul 03, 2019@14:34:28

Build Distribution Date: Jul 02, 2019

 Installing Routines:..............................................................
               Jul 03, 2019@14:34:28

 Installing Data Dictionaries: ..
               Jul 03, 2019@14:34:28

 Installing Data:
               Jul 03, 2019@14:34:28

 Installing PACKAGE COMPONENTS:

 Installing REMOTE PROCEDURE..........................

 Installing OPTION..
               Jul 03, 2019@14:34:28

 Updating Routine file......

 Updating KIDS files.......

 VISTA DATALOADER 3.0 Installed.
               Jul 03, 2019@14:34:29

 NO Install Message sent

 Install Started for VISTA SYNTHETIC DATA LOADER 0.3 :
               Jul 03, 2019@14:34:29

Build Distribution Date: Jul 02, 2019

 Installing Routines:........................................
               Jul 03, 2019@14:34:29

 Running Pre-Install Routine: PRE^SYNKIDS.TLS/SSL client configured on Cache as config name 'encrypt_only'


 Installing Data Dictionaries: ..
               Jul 03, 2019@14:34:29

 Running Post-Install Routine: POST^SYNKIDS.
Downloading MASH...
Downloading MWS...
This version (#1.0) of '%webINIT' was created on 22-JAN-2019
         (at DEMO.OSEHRA.ORG, by MSC FileMan 22.1061)

I AM GOING TO SET UP THE FOLLOWING FILES:

   17.6001   WEB SERVICE URL HANDLER


...SORRY, LET ME PUT YOU ON 'HOLD' FOR A SECOND........
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
Provider 520824646
Pharmacist 520824647
Hospital Location 23
Fixing AMIE thingy
Fixing IB ACTION TYPE file
Setting up Outpatient Pharmacy 1048

 Updating Routine file......

 Updating KIDS files.......

 VISTA SYNTHETIC DATA LOADER 0.3 Installed.
               Jul 03, 2019@14:34:32

 Not a VA primary domain

 NO Install Message sent

 Install Started for ZZ PCE STAND T5 FIXES 0.0 :
               Jul 03, 2019@14:34:32

Build Distribution Date: Jul 02, 2019

 Installing Routines:.......
               Jul 03, 2019@14:34:32

 Running Post-Install Routine: ^ZZPCEST5.

 Updating Routine file......

 Updating KIDS files.....

 ZZ PCE STAND T5 FIXES 0.0 Installed.
               Jul 03, 2019@14:34:32

 No link to PACKAGE file

 NO Install Message sent

 Updating Routine file.....

 Updating KIDS files.....

 VISTA FHIR DATA LOADER BUNDLE 0.3 Installed.
               Jul 03, 2019@14:34:32

 No link to PACKAGE file

 NO Install Message sent
```

# Usage
## Loading Synthetic Patients
### Using LOADALL^SYNFPUL to load old pre-existing patients from Synthetic Mass
To pull EXISTING (previously created) synthetic patients, run: `D
LOADALL^SYNFPUL`. This will load 1000 patients into VistA.

Due to incompletely tested new code in XTHC10 in OSEHRA VistA and VEHU
(provided by OSEHRA), this call fails. See issue
[#19](https://github.com/shabiel/Kernel-GTM/issues/19) and
[#20](https://github.com/shabiel/Kernel-GTM/issues/20) in the Kernel-GTM
project. To fix this, restore the old copy of XTHC10 until it's fixed:

On Cache:
```
$ wget https://raw.githubusercontent.com/shabiel/Kernel-GTM/upstream/Toolkit/Routines/XTHC10.m
$ readlink -f $PWD/XTHC10.m
/opt/cachesys/vehu/XTHC10.m
$ csession CACHE -U VEHU
Node: 3619f543b0f1, Instance: CACHE

VEHU>d $SYSTEM.Process.SetZEOF(1)

VEHU>S F="/opt/cachesys/vehu/XTHC10.m"

VEHU>ZR  ZS XTHC10

VEHU>O F U F ZL  ZS XTHC10 C F
```

On GT.M/YottaDB (replace the destination as appropriate):
```
wget https://raw.githubusercontent.com/shabiel/Kernel-GTM/upstream/Toolkit/Routines/XTHC10.m -O ~/r/XTHC10.m
```

Here's a sample of the output:
```
VEHU>D LOADALL^SYNFPUL

return is: 200^OK

title: dhp-vista-1000-1
url: http://synthea1m.vistaplex.org:9080/see/dhp-vista-1000-1?format=json
return is: 200^OK

loading patient Bartoletti882_Charles97_1
loading patient Barton351_Chloe174_21
loading patient Beatty236_Hudson688_48
loading patient Beier837_Freda866_72
...
```

### Loading brand new patients via the web service
To create new synthetic patients from Synthea, and load them into VistA via the
web service, do the following:

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
output/fhir
output/fhir/hospitalInformation1534183758506.json
output/fhir/King743_Eichmann909_c7f8935d-1099-4ce3-81da-3256f02a2956.json
saichiko:synthea sam$ find output -name '*.json*'
output/fhir/hospitalInformation1534183758506.json
output/fhir/King743_Eichmann909_c7f8935d-1099-4ce3-81da-3256f02a2956.json
saichiko:synthea sam$ curl localhost:9080/addpatient -d @output/fhir/King743_Eichmann909_c7f8935d-1099-4ce3-81da-3256f02a2956.json
{"allergyStatus":{"errors":0,"loaded":0,"status":""},"apptStatus":{"errors":"","loaded":"","status":""},"careplanStatus":{"errors":2,"loaded":1,"status":"ok"},"dfn":22,"encountersStatus":{"errors":3,"loaded":16,"status":"ok"},"icn":"2741032865V461309","id":"","ien":22,"immunizationsStatus":{"errors":"","loaded":13,"status":"ok"},"labsStatus":{"errors":21,"loaded":114,"status":"ok"},"loadStatus":"loaded","medsStatus":{"errors":"","loaded":5,"status":"ok"},"problemStatus":{"errors":"","loaded":8,"status":"ok"},"proceduresStatus":{"errors":"","loaded":20,"status":"ok"},"status":"ok","vitalsStatus":{"errors":20,"loaded":31,"status":"ok"}}
```

To updating an existing patient use updatepatient?icn={icn from previous call}
```
curl localhost:9080/updatepatient?icn=1563654899V859470 -d @output/fhir/King743_Eichmann909_c7f8935d-1099-4ce3-81da-3256f02a2956.json
```

The update call doesn't work too well right now... it adds data again. But worth
coming back to in future versions.

### Loading brand new patients from the File System
To facilitate bulk import of patients, and to help users who are not familiar
with doing web service calls, as of version 0.3 we have a new call:
`FILE^SYNFHIR`. Call with with the directory of the FHIR JSON files (look at
the example above). Typically the directory is the
`synthea_directory/output/fhir/`. A nice use case for this is sending a bunch
of patients from Synthea in a zip file and unzipping them in a directory on
a VistA server. Here's an example. Please note that we don't send output to the
null device here, so you will see VistA possibly talking back to you; this was
omitted from the below screen scrapes.

```
VEHU>D FILE^SYNFHIR("/tmp/synthea/output/fhir")
Loading Lenny728_Brekke496_268aa9e0-06a6-4509-933d-5e38b4732a04.json...
Ingesting Lenny728_Brekke496_268aa9e0-06a6-4509-933d-5e38b4732a04.json...

Loaded with following data:
DFN: 101078         ICN: 2445084033V255760        Graph Store IEN: 3
--------------------------------------------------------------------------
Type                          Loaded?                       Error
ADR/Allergy                   0                             0
Appointments
Care Plans                    11                            1
Problems                      17                            11
Encounters                    45                            52
Immunization                  3
Labs                          162                           54
Meds                          13                            4
Procedures                    18                            24
Vitals                        166                           97

Loading Luther918_Spinka232_f11579dd-869d-4d69-b28f-c7be64e817c1.json...
Ingesting Luther918_Spinka232_f11579dd-869d-4d69-b28f-c7be64e817c1.json...

Loaded with following data:
DFN: 101079         ICN: 2128062126V074799        Graph Store IEN: 4
--------------------------------------------------------------------------
Type                          Loaded?                       Error
ADR/Allergy                   0                             0
Appointments
Care Plans                    3                             1
Problems                      23                            3
Encounters                    104                           27
Immunization                  59                            1
Labs                          867                           253
Meds                          33                            1
Procedures                    51                            13
Vitals                        236                           143
```

## Examining the Status of Load
This is useful to see the errors. Pipe to `less` to page through it or view in
a browser. You can either ask for it using this URL: `/loadstatus?latest=1` for
the last one; or `/loadstatus?ien={ien}`; the ien which is obtained from
addpatient/updatepatient call.

On GT.M/YottaDB, you can do a more targeted analysis using a ZWRITE command
sent to stdout, like this

```
mumps -r %XCMD 'zwrite ^%wd(17.040801,2,{ien},"load",:,:,"status",*)'
```

Note that the second subscript 2 may be different on development systems. You
can find it by typing in the command line `w $$setroot^%wd("fhir-intake")`.

This will narrow it down to just load statuses, which you can filter down using
grep/ack/rg etc.

## Getting the Virtual Patient Record on a patient
The url is `/vpr/{dfn}`; `/vpr?icn={icn}`; or `/vpr?ien={graph store ien}`.

```
curl localhost:9080/vpr/1
```

## Displaying the Ingested FHIR data
All FHIR data ingested into VistA is saved in the graph store. You can get it
back using `/showfhir?icn={icn}`, `/showfhir?dfn={dfn}`, and `/showfhir?ien={graph store ien}`.

This can be useful if a different VistA system is to ingest data from the
current VistA system.

## Miscellaneous Web Service Calls for Debugging
### Viewing Globals
Both /global/{global_name} and /gtree/{global_name} are utilities for viewing
globals. The output of /global is the standard ZWRITE format can be used as an
input to the GT.M/YottaDB mupip load.

E.g.
```
curl 'http://localhost:9080/global/DIC(15)'
OSEHRA ZGO Export: M Web Server ZWRITE Export
03-Jul-2019 17:44:48 ZWR
^DIC(15,0)="DUPLICATE RECORD^15V"
^DIC(15,0,"AUDIT")="#"
^DIC(15,0,"DD")="@"
^DIC(15,0,"DEL")="@"
^DIC(15,0,"GL")="^VA(15,"
^DIC(15,0,"LAYGO")="@"
^DIC(15,0,"RD")="#"
^DIC(15,0,"WR")="@"
^DIC(15,"%",0)="^1.005^1^1"
^DIC(15,"%",1,0)="XU"
^DIC(15,"%","B","XU",1)=""
^DIC(15,"%D",0)="^^110^110^2970730^^"
...
```

`/gtree` gives you a view of the global as a tree. E.g.
```
curl 'http://localhost:9080/gtree/DIC(15)'
<!DOCTYPE HTML><html><head></head><body><pre>^DIC(15) DUPLICATE RECORD^15V
|--0 DUPLICATE RECORD^15V
|  |--AUDIT #
|  |--DD @
|  |--DEL @
|  |--GL ^VA(15,
|  |--LAYGO @
|  |--RD #
|  |--WR @
|--% ^1.005^1^1
|  |--0 ^1.005^1^1
|  |--1 XU
|  |  |--0 XU
|  |--B 
|  |  |--XU 
|  |  |  |--1 
|--%D ^^110^110^2970730^^
|  |--0 ^^110^110^2970730^^
```

### Viewing Graphs in the Graph Store
/graph/{graph name} will give you the data in the graph. Be careful with this
one as some graphs are very huge; and this is trying to give you all the data
all at once.

```
curl http://localhost:9080/graph/list-of-lists
```

The output is JSON. You can pretty print it using python's json.tool:

```
curl -sS http://localhost:9080/graph/loinc-lab-map | python3 -mjson.tool
{
    "0": "loinc-lab-map",
    "graph": {
        "map": [
            {
                "LOINC": "1751-7",
                "NAME": "ALBUMIN",
                "NUMBER": 185
            },

```

# How to contribute
You can join the developers by sending a message to this mailing list: https://www.osehra.org/groups/synthetic-patient-data-project-group 

# License
All source code produced is under Apache 2.0.
