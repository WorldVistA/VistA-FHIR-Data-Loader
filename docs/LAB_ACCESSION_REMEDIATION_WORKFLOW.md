# Lab Accession Remediation Workflow

This document captures the test-server workflow used to restore lab ingestion
when `SYN` logs show labs as loaded but `/vpr` and `/fhir` show zero lab output.

## Symptoms

- `wsIntakeLabs^SYNFLAB` logs repeated:
  - `<test> does not have an appropriate accession area. ORDER #... IS NOT ACCESSIONED`
- `SYN` load graph can report labs as loaded while:
  - `/vpr?dfn=<dfn>` has `labs total^0`
  - `/fhir?dfn=<dfn>` has zero laboratory `Observation` resources
- Some entries fail with:
  - `Couldn't find ien for LAB_TEST (#60)`
  - `Couldn't locate COLLECTION SAMPLE (#60.03) for LAB_TEST value.`

## Root Causes Observed

1. Missing or incomplete `LAB TEST` setup (`#60`) for chemistry tests.
2. Missing `COLLECTION SAMPLE` subentries (`#60.03`) for some tests.
3. Missing `ACCESSION AREA` subentries (`field #6`, subfile `60.11`) for tests.
4. Missing LOINC-to-lab mapping for selected codes (example: `2093-3`).
5. Duplicate source observations generate duplicate-load returns, which should not
   be treated as ingestion errors.

## Applied Remediation

### 1) LOINC mapping fix

- Add missing map row in `loinc-lab-map`:
  - `LOINC=2093-3`
  - `NAME=CHOLESTEROL`
- Reindex graph after update (`index^SYNGRAPH`).

### 2) Collection sample fix

- Ensure `LDL CHOLESTEROL DIRECT ASSAY` (`#60 IEN 901`) has
  `#60.03` collection sample data.

### 3) Accession area fix for chemistry labs

For the failing chemistry tests, add `#60 field 6` (`60.11`) rows:

- `INSTITUTION` (`.01`) = `1`
- `ACCESSION AREA` (`1`) = `11` (`CHEMISTRY`)

Tests updated in this pass:

- `HEMOGLOBIN A1C` (`97`)
- `CREATININE` (`173`)
- `UREA NITROGEN` (`174`)
- `GLUCOSE1` (`175`)
- `SODIUM` (`176`)
- `POTASSIUM` (`177`)
- `CHLORIDE` (`178`)
- `CO2` (`179`)
- `CALCIUM` (`180`)
- `CHOLESTEROL` (`183`)
- `TRIGLYCERIDE` (`205`)
- `HDL` (`244`)
- `LDL CHOLESTEROL DIRECT ASSAY` (`901`)

### 4) Duplicate handling behavior in `SYNFLAB`

`src/SYNFLAB.m` now treats this return from `LABADD^SYNDHP63`:

- `-1^Duplicate Lab Test entry for patient.`

as a success-equivalent for loader accounting:

- increments `loaded` count
- sets entry `loadstatus` to `loaded`
- writes issue text: `duplicate source observation`

This prevents duplicate source observations from being counted as load errors.

## Validation Workflow

1. Clear one patient's lab load status node (targeted graph IEN only).
2. Rerun labs intake for that patient.
3. Compare:
   - source labs (`/showfhir`)
   - loader status counts (`^%wd(...,"load","labs")`)
   - `^LR(<LRDFN>,"CH")` reverse-date count
   - `/vpr` labs total
   - `/fhir` laboratory Observation count

Expected outcome after remediation:

- accession-area error spam is gone
- `^LR(...,"CH")` is populated
- `/vpr` and `/fhir` lab counts become non-zero and track ingestable unique labs
- remaining deltas are usually duplicate-source observations

## Scheduling Note

Manual `D ^LROLOVER` may report `ROLLOVER NOT REQUIRED` if no rollover is pending.
TaskMan scheduling for lab options (`LRTASK NIGHTY`, `LRTASK ROLLOVER`, etc.)
should be configured separately using site-standard scheduling procedures.

