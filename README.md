# VistA FHIR Data Loader Project
This project lets you load data from Synthea (https://synthetichealth.github.io/synthea/) 
into VistA to produce high quality synthetic patient data for development and testing.
Other FHIR data sources are supportable; but are not supported at this time.

# Installation
This project is at an early stage. These install instructions are mainly intended for the
developers.

 * Load all routines into Instance (on Cache, can use GFT's % routine)
 * Install ISI data loader (http://pages.jh.edu/~vista4edu/DataLoader2/VISTA_DATALOADER_2_5.KID)
 * Unzip maps/SYN_MAPS_v1.zip and load .go file into instance with %GI.
 * Load with %RI mash/mash-1-v0.ro
 * Install kids/SYN-graph.kid
 * Install Mumps Web Server (see https://github.com/shabiel/M-Web-Server/blob/master/INSTALL.md)
 * Run D ^SYNINIT to setup all the web services
 * Using D ^SDB (menu option SDBUILD), create a clinic called "GENERAL MEDICINE"

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
