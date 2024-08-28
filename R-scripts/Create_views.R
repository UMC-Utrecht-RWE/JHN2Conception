#################################################################################################
#### Here we're going to execute the SQL scripts that create the views we can export lateron ####
#################################################################################################

# Load libraries
library(here) # Set our working folder
library(DBI) # For the database operations
library(duckdb) # To communicatie with duckdb

#################################################
#### Even ons mooie SQL inleesscript inlezen ####
#################################################

source("./R-functions/getSQL.R")

######################
#### En uitvoeren ####
######################

# List all the scipts
SQLScripts <- list.files("./SQL-scripts", pattern = "\\.sql$", full.names = TRUE)

# Connect to the database
con <- dbConnect(duckdb::duckdb(), './Duck_Database/JHN_Conception.duckdb')

# Conception en tussentabellen schema aanmaken
dbExecute(con, "CREATE SCHEMA IF NOT EXISTS Conception")
dbExecute(con, "CREATE SCHEMA IF NOT EXISTS tussentabellen")

# Loopje voor alle scripts
for (script in SQLScripts) {

  # Even wat output zodat we weten wat we aan het doen zijn
  cat(paste0(Sys.time(), ", ", script, "\n"))
    
  # Het sql-script inlezen
  SQLQuery <- getSQL(script)
  
  # Uitvoeren
  dbExecute(con, SQLQuery)
}

# Sluit de verbinding
dbDisconnect(con)
