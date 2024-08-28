##############################################################
#### Here we're going to import all csv files into duckDB ####
##############################################################

# Laad de packages
library(duckdb) # For the database
library(dplyr) # Magic
library(here) # Working directory
library(haven) # To read the SAS7BDAT files

##########################################################################################################
#### Read each file into a dataframe.                                                                 ####
#### I'm doing this one by one for now so that I can fix errors as I go.                              ####
##########################################################################################################

cat('SAS bestanden inlezen....\n')

cat(paste0(Sys.time(), " allergie\n"))
allergie <- read_sas("/mnt/data/inbox/transfer-2024-07-03-09-38-am/allergie.sas7bdat", encoding = "latin1") %>% mutate_if(is.character, ~ na_if(., ''))

cat(paste0(Sys.time(), " bepaling\n"))
bepaling <- read_sas("/mnt/data/inbox/transfer-2024-07-03-09-38-am/bepaling.sas7bdat", encoding = "latin1") %>% mutate_if(is.character, ~ na_if(., ''))

cat(paste0(Sys.time(), " contact\n"))
contact <- read_sas("/mnt/data/inbox/transfer-2024-07-03-09-38-am/contact.sas7bdat", encoding = "latin1") %>% mutate_if(is.character, ~ na_if(., ''))

cat(paste0(Sys.time(), " contraindicatie\n"))
contraindicatie <- read_sas("/mnt/data/inbox/transfer-2024-07-03-09-38-am/contraindicatie.sas7bdat", encoding = "latin1") %>% mutate_if(is.character, ~ na_if(., ''))

cat(paste0(Sys.time(), " episode\n"))
episode <- read_sas("/mnt/data/inbox/transfer-2024-07-03-09-38-am/episode.sas7bdat", encoding = "latin1") %>% mutate_if(is.character, ~ na_if(., ''))

cat(paste0(Sys.time(), " journaal\n"))
journaal <- read_sas("/mnt/data/inbox/transfer-2024-07-03-09-38-am/journaal.sas7bdat", encoding = "latin1") %>% mutate_if(is.character, ~ na_if(., ''))

cat(paste0(Sys.time(), " journaalregel\n"))
journaalregel <- read_sas("/mnt/data/inbox/transfer-2024-07-08-01-18-pm/journaalregel_tekst.sas7bdat", encoding = "latin1") %>% mutate_if(is.character, ~ na_if(., '')) # Please note the alternative location to this file

cat(paste0(Sys.time(), " medicatie\n"))
medicatie <- read_sas("/mnt/data/inbox/transfer-2024-07-03-09-38-am/medicatie.sas7bdat", encoding = "latin1") %>% mutate_if(is.character, ~ na_if(., ''))

cat(paste0(Sys.time(), " patient\n"))
patient <- read_sas("/mnt/data/inbox/transfer-2024-07-03-09-38-am/patient.sas7bdat", encoding = "latin1") %>% mutate_if(is.character, ~ na_if(., ''))

cat(paste0(Sys.time(), " patient_in_uit\n"))
patient_in_uit <- read_sas("/mnt/data/inbox/transfer-2024-07-03-09-38-am/patient_in_uit.sas7bdat", encoding = "latin1") %>% mutate_if(is.character, ~ na_if(., ''))

cat(paste0(Sys.time(), " ruiter\n"))
ruiter <- read_sas("/mnt/data/inbox/transfer-2024-07-03-09-38-am/ruiter.sas7bdat") %>% mutate_if(is.character, ~ na_if(., ''))

cat(paste0(Sys.time(), " verrichting\n"))
verrichting <- read_sas("/mnt/data/inbox/transfer-2024-07-03-09-38-am/verrichting.sas7bdat", encoding = "latin1") %>% mutate_if(is.character, ~ na_if(., ''))

cat(paste0(Sys.time(), " verwijzing\n"))
verwijzing <- read_sas("/mnt/data/inbox/transfer-2024-07-03-09-38-am/verwijzing.sas7bdat", encoding = "latin1") %>% mutate_if(is.character, ~ na_if(., ''))

################################
#### And import into duckDB ####
################################

# Even alle dataframe namen lezen
dataframes <- Filter(function(x) is.data.frame(get(x)), ls())

# Maak verbinding met DuckDB
con <- dbConnect(duckdb::duckdb(), './Duck_Database/JHN_Conception.duckdb')

# Import schema aanmaken
dbExecute(con, "CREATE SCHEMA IF NOT EXISTS import")

# Loopje voor alle dataframes
for (tabel in dataframes) {
  
  # We maken een dataframe df met de inhoud van de tabel
  df <- get(tabel)

  # Even wat output zodat we weten wat we aan het doen zijn
  cat(paste0('En wegschrijven naar duckDB: ', Sys.time(), ", ", tabel, "\n"))
  
  # En wegschrijven naar duckdb
  dbWriteTable(con, Id(schema = "import", table = tabel), df, overwrite = TRUE)
  } 

# Sluit de verbinding
dbDisconnect(con)
