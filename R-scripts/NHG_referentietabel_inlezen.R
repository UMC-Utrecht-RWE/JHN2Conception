###########################################################
#### Hier lezen we de NHG vocabulary in naar de duckdb ####
###########################################################

########################
#### Load libraries ####
########################

library(readxl)
library(DBI)
library(duckdb)
library(here) # Working directory

##################################################################################
#### Functie om een Excel-bestand in te lezen en weg te schrijven naar DuckDB ####
##################################################################################

write_excel_to_duckdb <- function(excel_file, db_file) {

  # Maak verbinding met de DuckDB-database
  con <- dbConnect(duckdb::duckdb(), db_file)
  
  # Creëer het NHG-schema als het nog niet bestaat
  dbExecute(con, "CREATE SCHEMA IF NOT EXISTS NHG")
  
  # Krijg de namen van alle sheets in het Excel-bestand
  sheets <- excel_sheets(excel_file)
  
  # Lees elke sheet in en schrijf deze weg naar de DuckDB-database
  for (sheet in sheets) {
    # Lees de huidige sheet in
    data <- read_excel(excel_file, sheet = sheet)
    
    # Even wat output
    cat('NHG referentietabel ', sheet, ' inlezen en wegschrijven.\n')
    
    # Schrijf de data weg naar DuckDB in het NHG-schema
    dbWriteTable(con, SQL(paste0("NHG.", sheet)), data, overwrite = TRUE)
  }
  
  # Sluit de databaseverbinding
  dbDisconnect(con, shutdown = TRUE)
}

# Specificaties van het Excel-bestand en de DuckDB-database
excel_file <- "./OtherSources/NHG.xlsx"
db_file <- "./Duck_Database/JHN_Conception.duckdb"

#############################
#### Voer de functie uit ####
#############################

write_excel_to_duckdb(excel_file, db_file)
