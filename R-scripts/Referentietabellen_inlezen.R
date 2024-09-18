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
library(dplyr)

##################################################################################
#### Functie om een Excel-bestand in te lezen en weg te schrijven naar DuckDB ####
##################################################################################

write_excel_to_duckdb <- function(excel_file, db_file) {

  # Maak verbinding met de DuckDB-database
  con <- dbConnect(duckdb::duckdb(), db_file)
  
  # Creëer het ReferenceTables-schema als het nog niet bestaat
  dbExecute(con, "CREATE SCHEMA IF NOT EXISTS ReferenceTables")
  
  # Krijg de namen van alle sheets in het Excel-bestand
  sheets <- excel_sheets(excel_file)
  
  # Lees elke sheet in en schrijf deze weg naar de DuckDB-database
  for (sheet in sheets) {
    # Lees de huidige sheet in
    data <- read_excel(excel_file, sheet = sheet) %>%
      # Fix some dumd hardcoded NULL values that shoukd be NA
      mutate(across(where(is.character), ~na_if(., "NULL")))
    
    # Even wat output
    cat('NHG referentietabel ', sheet, ' inlezen en wegschrijven.\n')
    
    # Schrijf de data weg naar DuckDB in het ReferenceTables-schema
    dbWriteTable(con, SQL(paste0("ReferenceTables.", sheet)), data, overwrite = TRUE)
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

####################################################################
#### Ook de COD322-NZA code-element 008 inlezen en wegschrijven ####
####################################################################

# Dit is een bestand met slechts een sheet, dus dit doen we niet via een functie
cod322 <- read_excel("./OtherSources/Vektis COD322-NZA code-element 008.xlsx", skip = 15) %>%
  # Even wat mooiere namen geven aan de kolommen (wie haalt het in z'n hoofd om spaties in kolomnamen te zetten?)
  rename(Toelichting1 = "Toelichting 1"
         , Toelichting2 = "Toelichting 2"  
         , AardMutatie = "Aard mutatie"   
         , RedenMutatie = "Reden mutatie")

# Maak verbinding met de DuckDB-database
con <- dbConnect(duckdb::duckdb(), "./Duck_Database/JHN_Conception.duckdb")

# En wegschrijven naar DuckDB in het ReferenceTables-schema
dbWriteTable(con, SQL("ReferenceTables.cod322NZA"), cod322, overwrite = TRUE)

# Sluit de databaseverbinding
dbDisconnect(con, shutdown = TRUE)
