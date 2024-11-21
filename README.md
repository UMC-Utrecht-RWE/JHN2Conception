# JHN2Conception
Mapping JHN to Conception

## Background
We mapped the JHN (Julius Huisartsen Netwerk) to the conception CDM. This is a very brief readme on how to use the code. More background can be read in the ETL specification file (which can be found in the '/Documentation' folder).

## Table mapping
Tables from JHN are mapped to Conception CDM as follows:

| JHN table          | Conception table      | Conception table |
| ------------------ | --------------------- | -----------------|
| Bepaling           | MEDICAL_OBSERVATIONS  |                  |
| Contact	         | VISIT_OCCURENCE       |                  |
| Journaal           | EVENTS                |                  |
| Journaalregel      | EVENTS                |                  |
| Medicatie          | MEDICINES             | VACCINES         |
| Patient            | PERSONS               |                  |
| Patient_in_uit     | OBSERVATION_PERIODS   |                  |
| Verrichting        | PROCEDURES            |                  |

JHN tables not mentioned are not used, Conception tables not mentioned are not filled.

## Prerequisites

- R and RStudio
- JHN source files in SAS (sas7bdat) format
- R libraries: DBI, dplyr, duckdb, haven, here, readxl
- The following Z-index files / tables: BST004T, BST070T, BST711T and BST801T

**IMPORTANT:** Because of licencing limitations the Z-index files are not included in this repo!

## Running the code

To run the code:
- Create the ./OtherSources/Z-index folder and add the Z-index files (at least BST004T, BST070T, BST711T and BST801T) to it
- Open the project (JHN_to_Conception.Rproj)
- Adjust the location of the source files in the Read_sas7bdat_into_DuckDB_one_by_one.R scipt
- Open and run the script 'Script_to_do_everything.R' (in the folder 'R-scripts')

The output is saved in CSV files in the /Output folder.

## Important note: The use of the episode table for EVENTS was removed
Originally the episode table was used in the creation of the EVENTS table. After talks with JHN this mapping was removed. All relevant information on the recent events is in the journaal and journaalregel table. The episode table is normally only used when we want to determine comorbidity, but this is now done by taking the Episode_icpc from the journaal table. This makes the episode table redundant, which is good since this is a very complex table with a high risk of errors

## Known issues

### Issue 1: Free text in MEDICINES table
Conception wants the medication in presc_quantity_per_day and presc_duration_days. JHN has this information in the ‘gebruiksvoorschift’ (instructions for use) field, which is free text. This field can be quite structed (2d1t, meaning twice a day one tablet), but is often just a text string (‘During the first week two tablets with dinner, thereafter 1 tablet when necessary’). I tried a small proof of concept trying to extract the presc_quantity_per_day and presc_duration_days fields using LLMs, but this had very limited success. This does not mean it cannot be done, but then it needs to be a project on its own with experts in the AI field. The presc_quantity_per_day and presc_duration_days fields in the MEDICINES table can therefore not be used now.

### Issue 2: Semantic harmonization
There is no semantic harmonization. To do this we need to map the NHG table 12, 15 and 45 and Vektis COD322-NZA, code-element 008 to other coding systems. 
- NHG table 12 has 142 rows of medical specialism codes
- NHG table 15 has 269  rows of PROCEDURES codes
- NHG table 45 has 4029 rows of MEDICAL_OBSERVATION codes.
- Vektis COD322-NZA, code-element 008 has 614 rows of MEDICAL_OBSERVATION codes

### Issue 3: Unmapped columns
Not all columns with important information from JHN could be mapped to Conception, for example all kind of free text fields have no place in Conception.

### Issue 4: Unmapped tables
Not all JHN tables were mapped (Allergie, Contraindicatie, Episode, Ruite and Verwijzing). There were a few reasons for this:
- Low data quality, issues that I encountered could not be explained
- Some tables are hardly ever used, so there is very limited knowledge on how these tables should be interpreted
- Tables were not relevant for conception
If we do want to use these tables we need to have a better understanding of the contents and limitations of these tables.



