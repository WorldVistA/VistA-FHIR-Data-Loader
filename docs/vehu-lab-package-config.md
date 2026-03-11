# VEHU Lab Config

We have found out that Synthea Panels don’t correspond exactly to VistA Panels
in many instances. Here are a few easy changes to make to ensure that you get
better panel coverage when importing from Synthea. The software WILL STILL WORK
if you don’t do this; but the labs that were parts of panels in Synthea will
show up in VistA just by themselves separated from their parent panel.

# Panel Changes
Use menu option “Edit cosmic tests [LRDIECOSMIC]”.

- Add lab tests “LEUCOCYTE ESTERASE, URINE” and “NITRITE, URINE” to “URINALYSIS” panel
- Add lab tests “CO2”, “SGOT”, and “COMPUTED CREATININE CLEARANCE” to “COMPREHENSIVE METABOLIC PANEL”
- Add lab test "COMPUTED CREATININE CLEARANCE" to "BASIC METABOLIC PANEL"
- Add lab test “INR” to “COAG PROFILE” panel
- Add lab test “RDW-CV” to “CBC” panel
- Add the following tests to "DIFFERENTIAL COUNT":
    - NEUTROPHILS %
    - NEUTROPHILS ABSOLUTE
    - LYMPH ABS.
    - MONO ABS.
    - EOSINO, ABSOLUTE
    - BASOPHILS, ABSOLUTE


# Data Name Changes
Use option “Modify an existing data name [LRWU6]”.

- “PROTHROMBIN TIME” data name (not lab, the data name) in VEHU is configured
  as a text field; whereas it’s really a numeric value. This causes an import
  problem since the numeric values can contain enough decimal places to overflow
  the limits of the text field. To fix this, use option “Modify an existing
  data name [LRWU6]” to change the definition of “PROTHROMBIN TIME” to a numeric
  field from 0 to 999 with 1 decimal place.
- PARTIAL THROMBOPLASTIN TIME has the same issue as above. Change it to have
  a range of 0-100 with 2 decimal places.
- Troponin units in Synthea are an order of magnitude larger than VistA. Need
  to change VistA units to match. Change from 0-999 with 1 decimal place to 0-1
  with 3 decimal places.
- INR Range needs to be from .8 to 20, NOT .9 to 20.

# Misc Changes
- URINE PH lab test has "PH" Synonym. Remove it using Fileman.
- A bunch of tests point to accession area ZZ GAS that is missing a numeric
  identifier. While it's best to repoint the tests to another accession area,
  for expediency, using Fileman, edit 68 (Accession) > .4 Numeric Identifier
  and put in any value.
