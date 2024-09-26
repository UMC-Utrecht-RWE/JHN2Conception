##########################################################################
#### Here we read the data from the views and write them to CSV files ####
##########################################################################

# Load libraries
suppressMessages(library(here))    # Set our working folder
suppressMessages(library(DBI))     # For the database operations
suppressMessages(library(duckdb))  # To communicatie with duckdb
suppressMessages(library(dplyr))   # Dplyr obviously

##########################
#### The actual scipt ####
##########################

# We'll create an output folder with todays date
OutputFolder <- paste0("./Output/", Sys.Date())

# Create the main output folder if it doesn't exist
if(!dir.exists('./Output/')) {
  dir.create('./Output/')
}

# Create todays folder if it does not exist
if(!dir.exists(OutputFolder)) {
  dir.create(OutputFolder)
}

# Connect to the database
con <- dbConnect(duckdb::duckdb(), './Duck_Database/JHN_Conception.duckdb')

# Read the names of all the views (starting with vw_)
views <- dbListTables(con) %>%
  grep('vw_', ., value = TRUE)

# Read all the views and output them to CSV files using a for loop
for (view in views) {
  
  # The output file should not have the vw_ prefix
  CSVNaam <- sub('vw_', '', view)
  
  # Some verbosity
  cat(paste0(Sys.time(), ", ", CSVNaam, "\n"))
  
  # Read the view
  data <- tbl(con, paste0('Conception.', view)) %>%
    collect()
  
  # Write to disk
  write.csv(data, paste0(OutputFolder, '/', CSVNaam, '.csv'), row.names = FALSE, na = '')
}

# Close the connection
dbDisconnect(con)
