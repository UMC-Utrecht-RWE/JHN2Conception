##############################################################
#### Here we're going to import all csv files into duckDB ####
##############################################################

# Laad de packages
suppressMessages(library(duckdb)) # For the database
suppressMessages(library(dplyr))  # Magic
suppressMessages(library(here))   # Working directory
suppressMessages(library(haven))  # To read the SAS7BDAT files

##########################################################################################################
#### Read each file into a dataframe.                                                                 ####
#### I'm doing this one by one for now so that I can fix errors as I go.                              ####
##########################################################################################################

cat('Reading the SAS files, this may take a while....\n')

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

# Get all the dataframes in the environment
dataframes <- Filter(function(x) is.data.frame(get(x)), ls())

# Create the database folder if it doesn't exist
if(!dir.exists("./Duck_Database")) {
  dir.create("./Duck_Database")
}

# Create the connection to DuckDB
con <- dbConnect(duckdb::duckdb(), './Duck_Database/JHN_Conception.duckdb')

# Create the import schema if it doesn't exist
dbExecute(con, "CREATE SCHEMA IF NOT EXISTS import")

# Loop through all the dataframes
for (tabel in dataframes) {
  
  # Create a dataframe with the content of the dataframe we're looping for now
  df <- get(tabel)

  # Create some verbosity
  cat(paste0('En wegschrijven naar duckDB: ', Sys.time(), ", ", tabel, "\n"))
  
  # And write to duckdb
  dbWriteTable(con, Id(schema = "import", table = tabel), df, overwrite = TRUE)
  } 

# And close the connection
dbDisconnect(con)
