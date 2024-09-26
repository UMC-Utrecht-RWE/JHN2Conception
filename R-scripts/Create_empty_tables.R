#################################################################################################################################################################
#### Here we're going to create the empty Conception tables                                                                                                  ####
#### We need these tables for the metadata table because it has all tables and columns (we don't create all tables for JHN, but they need to be in the meta) ####
#################################################################################################################################################################

# Load libraries
suppressMessages(llibrary(here))    # Set our working folder
suppressMessages(llibrary(DBI))     # For the database operations
suppressMessages(llibrary(duckdb))  # To communicatie with duckdb

##########################################################
#### Read the function that will load the SQL scripts ####
##########################################################

source("./R-functions/getSQL.R")

#####################################
#### And create the empty tables ####
#####################################

cat('Creating the empty Conception tables')

# Connect to the database
con <- dbConnect(duckdb::duckdb(), './Duck_Database/JHN_Conception.duckdb')

# Create the Conception schema if it doesn't exist
dbExecute(con, "CREATE SCHEMA IF NOT EXISTS Conception")

# Read the SQL script
SQLQuery <- getSQL('./Conception_Schema/Conception_2.2_schema_SQL.sql')
  
# Run it against the database
dbExecute(con, SQLQuery)

# And close the connection
dbDisconnect(con)
