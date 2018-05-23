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

To load synthetic patients, run D LOADALL^KBAIFPUL. This will load 1000 patients into VistA.

# How to contribute
You can join the developers by sending a message to this mailing list: https://www.osehra.org/groups/synthetic-patient-data-project-group 

# License
All source code produced is under Apache 2.0.