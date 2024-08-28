####################################################################################
#### Nu gaan we de views weer inlezen uit DuckDB en wegschrijven naar CSV files ####
####################################################################################

# Load libraries
library(here) # Set our working folder
library(DBI) # For the database operations
library(duckdb) # To communicatie with duckdb
library(dplyr) # Dplyr obviously

#########################
#### En aan het werk ####
#########################

# Output folder maken (met de datum erin om te voorkomen dat we oude data gaan overschrijven die we willen houden)
OutputFolder <- paste0("./Output/", Sys.Date())

# Alleen aanmaken als hij niet bestaat uiteraard
if(!dir.exists(OutputFolder)) {
  dir.create(OutputFolder)
}

# Connect to the database
con <- dbConnect(duckdb::duckdb(), './Duck_Database/JHN_Conception.duckdb')

# Alle views bepalen, de views waar we in geinteresseerd zijn beginen met vw_
views <- dbListTables(con) %>%
  grep('vw_', ., value = TRUE)

# Nu inlezen en wegschrijven in een for-loop
for (view in views) {
  
  # Het output bestand moet niet die vw_ prefix krijgen
  CSVNaam <- sub('vw_', '', view)
  
  # Even wat output zodat we weten wat we aan het doen zijn
  cat(paste0(Sys.time(), ", ", CSVNaam, "\n"))
  
  # Inlezen
  data <- tbl(con, paste0('Conception.', view)) %>%
    collect()
  
  # En wegschrijven
  write.csv(data, paste0(OutputFolder, '/', CSVNaam, '.csv'), row.names = FALSE, na = '')
}

# Sluit de verbinding
dbDisconnect(con)
