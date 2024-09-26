#################################################################################################
#### Here we're going to execute the SQL scripts that create the views we can export lateron ####
#################################################################################################

# Load libraries
suppressMessages(llibrary(here))    # Set our working folder
suppressMessages(llibrary(DBI))     # For the database operations
suppressMessages(llibrary(duckdb))  # To communicatie with duckdb

##########################################################
#### Read the function that will read the SQL scripts ####
##########################################################

source("./R-functions/getSQL.R")

##########################################
#### And create the schema and views  ####
##########################################

cat('Creating the Conception views in the database. This may take a while.')

# List all the scipts
SQLScripts <- list.files("./SQL-scripts", pattern = "\\.sql$", full.names = TRUE)

# Connect to the database
con <- dbConnect(duckdb::duckdb(), './Duck_Database/JHN_Conception.duckdb')

# Create the Conception and tussentabellen schema
dbExecute(con, "CREATE SCHEMA IF NOT EXISTS Conception")
dbExecute(con, "CREATE SCHEMA IF NOT EXISTS tussentabellen")

# Loop all the scripts
for (script in SQLScripts) {

  # Create some output
  cat(paste0(Sys.time(), ", ", script, "\n"))
    
  # Read the SQL script we're in the loop for now
  SQLQuery <- getSQL(script)
  
  # Run it
  dbExecute(con, SQLQuery)
}

# Close the connection
dbDisconnect(con)
