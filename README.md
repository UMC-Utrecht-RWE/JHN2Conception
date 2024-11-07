# JHN2Conception
Mapping JHN to Conception

## Background
We mapped the JHN (Julius Huisartsen Netwerk) to the conception CDM. 
This is a very brief readme on how to use the code. More background can be read in the ETL specification file (which can be found in the '/Documentation' folder).


## Table mapping
Tables from JHN are mapped to Conception CDM as follows:

| JHN table          | Conception table      | Conception table |
| ------------------ | --------------------- | -----------------|
| Bepaling           | MEDICAL_OBSERVATIONS  |                  |
| Contact	         | VISIT_OCCURENCE       |                  |
| Episode            | EVENTS                |                  |
| Journaal           | EVENTS                |                  |
| Journaalregel      | EVENTS                |                  |
| Medicatie          | MEDICINES             | VACCINES         |
| Patient            | PERSONS               |                  |
| Patient_in_uit     | OBSERVATION_PERIODS   |                  |
| Verrichting        | PROCEDURES            |                  |

JHN tables not mentioned are not used, Conception tables not mentioned are not filled.

## Prerequisites

- R
- JHN source files in SAS (sas7bdat) format
- R libraries: DBI, dplyr, duckdb, haven, here, readxl


## Running the code

To run the code:
- Open the project (JHN_to_Conception.Rproj)
- Adjust the location of the source files in the Read_sas7bdat_into_DuckDB_one_by_one.R scipt
- Open and run the script 'Script_to_do_everything.R' (in the folder 'R-scripts')

The output is saved in CSV files in the /Output folder.

## About
This is an open source repository mantained by the RWE department. 

For the forked version used by Health Data Space Utrecht, access here:

https://github.com/HDSU-Health-Data-Space-Utrecht/JHN2Conception
