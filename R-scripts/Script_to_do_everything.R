###################################################################################################################################################
#### In dit script zorgen we ervoor dat alle stappen voor het genereren van de JHN Conception CSV files worden doorlopen in de juiste volgorde ####
###################################################################################################################################################

# Waar werken we vanuit?
library(here)

#############################################################################
#### Stap 1: Het inlezen van de sa7bdat files zoals die aangeleverd zijn ####
#############################################################################

source("./R-scripts/Read_sas7bdat_into_DuckDB_one_by_one.R", local = TRUE)

###############################################
#### Stap 2: De refenretietabellen inlezen ####
###############################################

source("./R-scripts/Referentietabellen_inlezen.R", local = TRUE)

###############################################################################################
#### Stap 3: Ook de lege Conception tabellen aanmaken (dit is nodig voor de metadata tabel) ###
###############################################################################################

source("./R-scripts/Create_empty_tables.R", local = TRUE)

#####################################
#### Stap 4: Alle views aanmaken ####
#####################################

source("./R-scripts/Create_views.R", local = TRUE)

###########################################################
#### Stap 5: De views inlezen en wegschrijven naar csv ####
###########################################################

source("./R-scripts/Write_CSV_output.R", local = TRUE)

