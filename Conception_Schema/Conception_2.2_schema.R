
################################################################################################
#### We're going to create the schema of Conception so we can fill existing tables from JHN ####
################################################################################################

########################
#### Load libraries ####
########################

library(tibble)

######################################
#### And create the empty tables  ####
######################################

# VISIT_OCCURRENCE
VISIT_OCCURRENCE <- tibble(
  person_id = character(),
  visit_occurrence_id = character(),
  visit_start_date = character(),
  visit_end_date = character(),
  speciality_of_visit = character(),
  speciality_of_visit_vocabulary = character(),
  status_at_discharge = character(),
  status_at_discharge_vocabulary = character(),
  meaning_of_visit = character(),
  origin_of_visit = character())

# EVENTS
EVENTS <- tibble(
  person_id = character(),
  start_date_record = character(),
  end_date_record = character(),
  event_code = character(),
  event_record_vocabulary = character(),
  text_linked_to_event_code = character(),
  event_free_text = character(),
  present_on_admission = character(),
  laterality_of_event = character(),
  meaning_of_event = character(),
  origin_of_event = character(),
  visit_occurrence_id = character())

# MEDICINES
MEDICINES <- tibble(
  person_id	= character(),
  medicinal_product_id = character(),
  medicinal_product_atc_code = character(),
  date_dispensing	= character(),
  date_prescription = character(),
  disp_number_medicinal_product = numeric(),
  presc_quantity_per_day = numeric(),
  presc_quantity_unit = character(),
  presc_duration_days = numeric(),
  product_lot_number = character(),
  indication_code = character(),
  indication_code_vocabulary = character(),
  meaning_of_drug_record = character(),
  origin_of_drug_record = character(),
  prescriber_speciality = character(),
  prescriber_speciality_vocabulary = character(),
  visit_occurrence_id = character())

# PROCEDURES
PROCEDURES <- tibble(
  person_id = character(),
  procedure_date = character(),
  procedure_code = character(),
  procedure_code_vocabulary = character(),
  meaning_of_procedure = character(),
  origin_of_procedure = character(),
  visit_occurrence_id = character())

# VACCINES
VACCINES <- tibble(
  person_id = character(),
  vx_record_date = character(),
  vx_admin_date = character(),
  vx_atc = character(),
  vx_type = character(),
  vx_text = character(),
  medicinal_product_id = character(),
  vx_dose = character(),
  vx_manufacturer = character(),
  vx_lot_num = character(),
  meaning_of_vx_record = character(),
  origin_of_vx_record = character(),
  visit_occurrence_id = character())

# MEDICAL_OBSERVATIONS
MEDICAL_OBSERVATIONS <- tibble(
  person_id = character(),
  mo_date = character(),
  mo_code = character(),
  mo_record_vocabulary = character(),
  mo_source_table = character(),
  mo_source_column = character(),
  mo_source_value = character(),
  mo_unit = character(),
  mo_meaning = character(),
  mo_origin = character(),
  visit_occurrence_id = character())

# EUROCAT
EUROCAT <- tibble(
  centre = character(),
  numloc = character(),
  birthdate = character(),
  sex = character(),
  nbrbaby = character(),
  sp_twin = character(),
  nbrmalf = character(),
  type = character(),
  civreg = character(),
  weight = numeric(),
  gestlength = numeric(),
  survival = character(),
  death_date = character(),
  datemo = character(),
  agemo = numeric(),
  bmi = numeric(),
  residmo = character(),
  totpreg = character(),
  whendisc = character(),
  condisc = character(),
  agedisc = numeric(),
  firstpre = character(),
  sp_firstpre = character(),
  karyo = character(),
  sp_karyo = character(),
  gentest = character(),
  sp_gentest = character(),
  pm = character(),
  surgery = character(),
  syndrome = character(),
  `sp-syndrome` = character(),
  malfo1 = character(),
  sp_malfo1 = character(),
  malfo2 = character(),
  sp_malfo2 = character(),
  malfo3 = character(),
  sp_malfo3 = character(),
  malfo4 = character(),
  sp_malfo4 = character(),
  malfo5 = character(),
  sp_malfo5 = character(),
  malfo6 = character(),
  sp_malfo6 = character(),
  malfo7 = character(),
  sp_malfo7 = character(),
  malfo8 = character(),
  sp_malfo8 = character(),
  presyn = character(),
  premal1 = character(),
  premal2 = character(),
  premal3 = character(),
  premal4 = character(),
  premal5 = character(),
  premal6 = character(),
  premal7 = character(),
  premal8 = character(),
  omim = character(),
  orpha = character(),
  assconcept = character(),
  occupmo = character(),
  illbef1 = character(),
  illbef2 = character(),
  matdiab = character(),
  hba1c = numeric(),
  illdur1 = character(),
  illdur2 = character(),
  folic_g14 = character(),
  firsttri = character(),
  drugs1 = character(),
  spdrugs1 = character(),
  drugs2 = character(),
  spdrugs2 = character(),
  drugs3 = character(),
  spdrugs3 = character(),
  drugs4 = character(),
  spdrugs4 = character(),
  drugs5 = character(),
  spdrugs5 = character(),
  `extra-drugs` = character(),
  consang = character(),
  sp_consang = character(),
  sibanom = character(),
  sp_sibanom = character(),
  prevsib = character(),
  sib1 = character(),
  sib2 = character(),
  sib3 = character(),
  moanom = character(),
  sp_moanom = character(),
  faanom = character(),
  sp_faanom = character(),
  matedu = character(),
  socm = character(),
  socf = character(),
  migrant = character(),
  genrem = character(),
  person_id_child = character(),
  person_id_mother = character(),
  survey_id = character())

# SURVEY_ID  
SURVEY_ID <- tibble(
  person_id = character(),
  survey_id = character(),
  survey_date = character(),
  survey_meaning = character(),
  survey_origin = character()
)

# SURVEY_OBSERVATIONS
SURVEY_OBSERVATIONS <- tibble(
  person_id = character(),
  so_date = character(),
  so_source_table = character(),
  so_source_column = character(),
  so_source_value = character(),
  so_unit = character(),
  so_meaning = character(),
  so_origin = character(),
  survey_id = character())

# PERSONS
PERSONS <- tibble(
  person_id = character(),
  day_of_birth = character(),
  month_of_birth = character(),
  year_of_birth = character(),
  day_of_death = character(),
  month_of_death = character(),
  year_of_death = character(),
  sex_at_instance_creation = character(),
  race = character(),
  country_of_birth = character(),
  quality = character())

# OBSERVATION_PERIODS
OBSERVATION_PERIODS <- tibble(
  person_id = character(),
  op_start_date = character(),
  op_end_date = character(),
  op_meaning = character(),
  op_origin = character())

# PERSON_RELATIONSHIPS
PERSON_RELATIONSHIPS <- tibble(
  person_id = character(),
  related_id = character(),
  meaning_of_relationship = character(),
  origin_of_relationship = character(),
  method_of_linkage = character())

# PRODUCTS
PRODUCTS <- tibble(
  medicinal_product_id = character(),
  medicinal_product_name = character(),
  unit_of_presentation_type = character(),
  unit_of_presentation_num = numeric(),
  administration_dose_form = character(),
  administration_route = character(),
  medicinal_product_atc_code = character(),
  subst1_atc_code = character(),
  subst2_atc_code = character(),
  subst3_atc_code = character(),
  subst1_amount_per_form = numeric(),
  subst2_amount_per_form = numeric(),
  subst3_amount_per_form = numeric(),
  subst1_amount_unit = character(),
  subst2_amount_unit = character(),
  subst3_amount_unit = character(),
  subst1_concentration = numeric(),
  subst2_concentration = numeric(),
  subst3_concentration = numeric(),
  subst1_concentration_unit = character(),
  subst2_concentration_unit = character(),
  subst3_concentration_unit = character(),
  concentration_total_content = numeric(),
  concentration_total_content_unit = character(),
  medicinal_product_manufacturer = character())

# METADATA
METADATA <- tibble(
  type_of_metadata = character(),
  tablename = character(),
  columnname = character(),
  other = character(),
  values = character())

# CDM_SOURCE
CDM_SOURCE <- tibble(
  data_access_provider_code = character(),
  data_access_provider_name = character(),
  data_source_name = character(),
  data_dictionary_link = character(),
  etl_link = character(),
  cdm_vocabulary_version = character(),
  cdm_version = character(),
  instance_number = integer(),
  date_creation = character(),
  recommended_end_date = character())

INSTANCE <- tibble(
  source_table_name = character(),
  source_column_name = character(),
  included_in_instance = character(),
  date_when_data_last_updated = character(),
  since_when_data_complete = character(),
  up_to_when_data_complete = character(),
  restriction_in_values = character(),
  list_of_values = character(),
  restriction_condition = character())

