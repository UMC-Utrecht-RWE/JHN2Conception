########################################################
#### Here we write all reference tables to database ####
########################################################

########################
#### Load libraries ####
########################

suppressMessages(library(readxl)) # To read the xlsx files
suppressMessages(library(DBI))    # To connect to the DuckDB
suppressMessages(library(duckdb)) # To connect to the DuckDB
suppressMessages(library(here))   # Working directory
suppressMessages(library(dplyr))  # Magic
suppressMessages(library(readr))  # To read the z-index tables

################################################################################
#### Function to read all sheets from a excel-file and write them to duckdb ####
################################################################################

write_excel_to_duckdb <- function(excel_file, db_file) {

  # Connect to database
  con <- dbConnect(duckdb::duckdb(), db_file)
  
  # Create the ReferenceTables-schema if it doesn't exist
  dbExecute(con, "CREATE SCHEMA IF NOT EXISTS ReferenceTables")
  
  # What is the name of the sheet?
  sheets <- excel_sheets(excel_file)
  
  # Read the sheet
  for (sheet in sheets) {
    # Lees de huidige sheet in
    data <- read_excel(excel_file, sheet = sheet) %>%
      # Fix some dumb hardcoded NULL values that shoukd be NA
      mutate(across(where(is.character), ~na_if(., "NULL")))
    
    # Some verbosity
    cat('Reading NHG reference table ', sheet, ' and writing it to the database.\n')
    
    # And write the sheet to the database
    dbWriteTable(con, SQL(paste0("ReferenceTables.", sheet)), data, overwrite = TRUE)
  }
  
  # Sluit de databaseverbinding
  dbDisconnect(con, shutdown = TRUE)
}

# Where is the sheet and the database?
excel_file <- "./OtherSources/NHG.xlsx"
db_file <- "./Duck_Database/JHN_Conception.duckdb"

##########################
#### Run the function ####
##########################

write_excel_to_duckdb(excel_file, db_file)

###################################################################
#### Also read the COD322-NZA code-element 008 reference table ####
###################################################################

cat('Write Vektis COD322-NZA code-element 008 to the database\n')

# Since this is a single sheet file I won't do this using a function
cod322 <- read_excel("./OtherSources/Vektis COD322-NZA code-element 008.xlsx", skip = 15) %>%
  # Assign some better names (why would you create a column name with a space in it?)
  rename(Toelichting1 = "Toelichting 1"
         , Toelichting2 = "Toelichting 2"  
         , AardMutatie = "Aard mutatie"   
         , RedenMutatie = "Reden mutatie")

# Connect to database
con <- dbConnect(duckdb::duckdb(), "./Duck_Database/JHN_Conception.duckdb")

# And write it to DuckDB in the ReferenceTables-schema
dbWriteTable(con, SQL("ReferenceTables.cod322NZA"), cod322, overwrite = TRUE)

# Close the connection
dbDisconnect(con, shutdown = TRUE)

#################################################
#### Now we'll read the needed Z-index files ####
#################################################

# Since the Z-index will not be included in github because of licencing limitations I'll check if the folder and files exist
if(!dir.exists("./OtherSources/Z-index")) {
  stop("Z-index folder (./OtherSources/Z-index) does not exist. Create it first and add the Z-index files (BST004T, BST070T, BST711T and BST801T).")
}

# We need the following tables: 004, 070, 711 and 801
# The column with the name EMPTY did not have a column name, but since R will assign an even uglier name (like X24) I'll call it EMPTY

#################
#### BST004T ####
#################

# See http://z-index.nl/documentatie/bestandsbeschrijvingen/bestand?bestandsnaam=BST004T

if(!file.exists("./OtherSources/Z-index/BST004T")) {
  stop("BST004T does not exist. Add it to the to the Z-index folder first (./OtherSources/Z-index).")
}

cat('Write Z-index BST004T to the database\n')

BST004T <- read_fwf("./OtherSources/Z-index/BST004T",
                    fwf_positions(start = c(1, 5, 6, 14, 22, 29, 37, 42, 45, 48, 53, 56, 59, 67, 68, 76, 77, 78, 79, 80, 81, 86, 87, 92, 100, 110, 122, 127, 132, 137
                                            , 140, 143, 151, 159, 167, 168, 169, 170, 171, 183, 191, 199, 207, 215, 223, 231, 242, 254, 262, 282, 290, 302, 308, 310, 316),
                                  end = c(4, 5, 13, 21, 28, 36, 41, 44, 47, 52, 55, 58, 66, 67, 75, 76, 77, 78, 79, 80, 85, 86, 91, 99, 109, 121, 126, 131, 136, 139
                                          , 142, 150, 158, 166, 167, 168, 169, 170, 182, 190, 198, 206, 214, 222, 230, 241, 253, 261, 281, 289, 301, 307, 309, 315, 320),
                                  col_names = c('BSTNUM', 'MUTKOD', 'ATKODE', 'HPKODE', 'ATNMNR', 'VPINHV', 'VPHFAA', 'THHFOM', 'VPHFOM', 'VPDLAA', 'THDLOM', 'VPDLOM'
                                                , 'VPDLHV', 'VPKUNV', 'XPKUND', 'VPKWGM', 'VPKKLK', 'VPKKVP', 'VPKBWR', 'VPKEAS', 'RVRVG1', 'RVRVG2', 'RVRVG3', 'XVINSD'
                                                , 'MNVDDD', 'VPFBVN', 'XVREGH', 'XVIMP', 'VPKLEV', 'THLND', 'XALND', 'XPIHDD', 'XPUHDD', 'PKKODE', 'WTGKOD', 'PGBTWK'
                                                , 'INKKAN', 'REFKOD', 'PGVKPE', 'VEGPRS', 'REFPRS', 'XPINDD', 'XPDODD', 'XNB4DD', 'XNUIDD', 'GVSKOD', 'GVSVGL', 'PGIKPR'
                                                , 'EUNUM', 'VPPERC', 'VPMAXP', 'RVREGNR1', 'RVREGNR2', 'RVREGNR3', 'EMPTY'))
                    , show_col_types = FALSE) %>%
  # There's an empty final line that we need to skip
  filter(!is.na(MUTKOD))

#################
#### BST070T ####
#################

# See http://z-index.nl/documentatie/bestandsbeschrijvingen/bestand?bestandsnaam=BST070T

if(!file.exists("./OtherSources/Z-index/BST070T")) {
  stop("BST070T does not exist. Add it to the to the Z-index folder first (./OtherSources/Z-index).")
}

cat('Write Z-index BST070T to the database\n')

BST070T <- read_fwf("./OtherSources/Z-index/BST070T",
                    fwf_positions(start = c(1, 5, 6, 14, 22, 30, 38, 46, 54),
                                  end = c(4, 5, 13, 21, 29, 37, 45, 53, 64),
                                  col_names = c('BSTNUM', 'MUTKOD', 'HPKODE', 'PRKODE', 'HPANPR', 'GPKODE', 'PRANGP', 'HPANGP', 'EMPTY'))
                    , show_col_types = FALSE) %>%
  # There's an empty final line that we need to skip
  filter(!is.na(MUTKOD))

#################
#### BST711T ####
#################

# See http://z-index.nl/documentatie/bestandsbeschrijvingen/bestand?bestandsnaam=BST711T

if(!file.exists("./OtherSources/Z-index/BST711T")) {
  stop("BST711T does not exist. Add it to the to the Z-index folder first (./OtherSources/Z-index).")
}

cat('Write Z-index BST711T to the database\n')

BST711T <- read_fwf("./OtherSources/Z-index/BST711T",
                    fwf_positions(start = c(1, 5, 6, 14, 22, 25, 28, 31, 34, 41, 48, 73, 76, 84, 87, 95, 99, 105, 113, 116, 119, 127, 130, 133),
                                  end = c(4, 5, 13, 21, 24, 27, 30, 33, 40, 47, 72, 75, 83, 86, 94, 98, 104, 112, 115, 118, 126, 129, 132, 160),
                                  col_names = c('BSTNUM', 'MUTKOD', 'GPKODE', 'GSKODE', 'THKTVR', 'GPKTVR', 'THKTWG', 'GPKTWG', 'GPNMNR', 'GPSTNR', 'GPINST', 'GPMLCI'
                                                , 'GPMLCT', 'GPADVP', 'GPTCVP', 'THKHVS', 'GPKHVS', 'SPKODE', 'THSTWG', 'SSKTWG', 'ATCODE', 'THEHHV', 'XPEHHV', 'EMPTY'))
                    , show_col_types = FALSE) %>%
  # There's an empty final line that we need to skip
  filter(!is.na(MUTKOD))

#################
#### BST801T ####
#################

# See http://z-index.nl/documentatie/bestandsbeschrijvingen/bestand?bestandsnaam=BST711T

if(!file.exists("./OtherSources/Z-index/BST801T")) {
  stop("BST801T does not exist. Add it to the to the Z-index folder first (./OtherSources/Z-index).")
}

cat('Write Z-index BST801T to the database\n')

BST711T <- read_fwf("./OtherSources/Z-index/BST801T",
                    fwf_positions(start = c(1, 5, 6, 14, 94, 174, 175),
                                  end = c(4, 5, 13, 93, 173, 174, 192),
                                  col_names = c('BSTNUM', 'MUTKOD', 'ATCODE', 'ATOMS', 'ATOMSE', 'ATKIND', 'EMPTY'))
                    , show_col_types = FALSE) %>%
  # There's an empty final line that we need to skip
  filter(!is.na(MUTKOD))

# Connect to the DuckDB-database
con <- dbConnect(duckdb::duckdb(), "./Duck_Database/JHN_Conception.duckdb")

# And write these tables to the ReferenceTables-schema
dbWriteTable(con, SQL("ReferenceTables.BST004T"), BST004T, overwrite = TRUE)
dbWriteTable(con, SQL("ReferenceTables.BST070T"), BST070T, overwrite = TRUE)
dbWriteTable(con, SQL("ReferenceTables.BST711T"), BST711T, overwrite = TRUE)
dbWriteTable(con, SQL("ReferenceTables.BST801T"), BST711T, overwrite = TRUE)

# Close the connection
dbDisconnect(con, shutdown = TRUE)


