#################################################################################################################################################################
#### Here we're going to crate the empty Conception tables                                                                                                   ####
#### We need these tables for the metadata table because it has all tables and columns (we don't create all tables for JHN, but they need to be in the meta) ####
#################################################################################################################################################################

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

# Connect to the database
con <- dbConnect(duckdb::duckdb(), './Duck_Database/JHN_Conception.duckdb')

# Conception schema aanmaken als hij nog niet bestaat (doet hij wel uiteraard)
dbExecute(con, "CREATE SCHEMA IF NOT EXISTS Conception")

# Het sql-script inlezen
SQLQuery <- getSQL('./Conception_Schema/Conception_2.2_schema_SQL.sql')
  
# Uitvoeren
dbExecute(con, SQLQuery)

# Sluit de verbinding
dbDisconnect(con)
