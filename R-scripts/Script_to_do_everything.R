########################################################################################################
#### In this script we run all scripts in the right order to create the Conception output CSV files ####
########################################################################################################

# Set the working directory to the project folder
suppressMessages(library(here))

################################################
#### Step 1: Read the sa7bdat source files  ####
################################################

source("./R-scripts/Read_sas7bdat_into_DuckDB_one_by_one.R", local = TRUE)

##########################################
#### Step 2: Read the reference files ####
##########################################

source("./R-scripts/Read_reference_files.R", local = TRUE)

#########################################################################################
#### Step 3: Create the empty Concepion tables (we need these for the metadata table) ###
#########################################################################################

source("./R-scripts/Create_empty_tables.R", local = TRUE)

##################################
#### Step 4: Create the views ####
##################################

source("./R-scripts/Create_views.R", local = TRUE)

#######################################################
#### Step 5: Read the views and output them to CSV ####
#######################################################

source("./R-scripts/Write_CSV_output.R", local = TRUE)

