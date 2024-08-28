-- jhn_conception.main.CDM_SOURCE definition

CREATE OR REPLACE TABLE Conception.CDM_SOURCE(data_access_provider_code VARCHAR,
	data_access_provider_name VARCHAR,
	data_source_name VARCHAR,
	data_dictionary_link VARCHAR,
	etl_link VARCHAR,
	cdm_vocabulary_version VARCHAR,
	cdm_version VARCHAR,
	instance_number INTEGER,
	date_creation VARCHAR,
	recommended_end_date VARCHAR);


-- jhn_conception.main.EUROCAT definition

CREATE OR REPLACE TABLE Conception.EUROCAT(centre VARCHAR,
	numloc VARCHAR,
	birthdate VARCHAR,
	sex VARCHAR,
	nbrbaby VARCHAR,
	sp_twin VARCHAR,
	nbrmalf VARCHAR,
	"type" VARCHAR,
	civreg VARCHAR,
	weight DECIMAL(18,3),
	gestlength DECIMAL(18,3),
	survival VARCHAR,
	death_date VARCHAR,
	datemo VARCHAR,
	agemo DECIMAL(18,3),
	bmi DECIMAL(18,3),
	residmo VARCHAR,
	totpreg VARCHAR,
	whendisc VARCHAR,
	condisc VARCHAR,
	agedisc DECIMAL(18,3),
	firstpre VARCHAR,
	sp_firstpre VARCHAR,
	karyo VARCHAR,
	sp_karyo VARCHAR,
	gentest VARCHAR,
	sp_gentest VARCHAR,
	pm VARCHAR,
	surgery VARCHAR,
	syndrome VARCHAR,
	"sp-syndrome" VARCHAR,
	malfo1 VARCHAR,
	sp_malfo1 VARCHAR,
	malfo2 VARCHAR,
	sp_malfo2 VARCHAR,
	malfo3 VARCHAR,
	sp_malfo3 VARCHAR,
	malfo4 VARCHAR,
	sp_malfo4 VARCHAR,
	malfo5 VARCHAR,
	sp_malfo5 VARCHAR,
	malfo6 VARCHAR,
	sp_malfo6 VARCHAR,
	malfo7 VARCHAR,
	sp_malfo7 VARCHAR,
	malfo8 VARCHAR,
	sp_malfo8 VARCHAR,
	presyn VARCHAR,
	premal1 VARCHAR,
	premal2 VARCHAR,
	premal3 VARCHAR,
	premal4 VARCHAR,
	premal5 VARCHAR,
	premal6 VARCHAR,
	premal7 VARCHAR,
	premal8 VARCHAR,
	omim VARCHAR,
	orpha VARCHAR,
	assconcept VARCHAR,
	occupmo VARCHAR,
	illbef1 VARCHAR,
	illbef2 VARCHAR,
	matdiab VARCHAR,
	hba1c DECIMAL(18,3),
	illdur1 VARCHAR,
	illdur2 VARCHAR,
	folic_g14 VARCHAR,
	firsttri VARCHAR,
	drugs1 VARCHAR,
	spdrugs1 VARCHAR,
	drugs2 VARCHAR,
	spdrugs2 VARCHAR,
	drugs3 VARCHAR,
	spdrugs3 VARCHAR,
	drugs4 VARCHAR,
	spdrugs4 VARCHAR,
	drugs5 VARCHAR,
	spdrugs5 VARCHAR,
	"extra-drugs" VARCHAR,
	consang VARCHAR,
	sp_consang VARCHAR,
	sibanom VARCHAR,
	sp_sibanom VARCHAR,
	prevsib VARCHAR,
	sib1 VARCHAR,
	sib2 VARCHAR,
	sib3 VARCHAR,
	moanom VARCHAR,
	sp_moanom VARCHAR,
	faanom VARCHAR,
	sp_faanom VARCHAR,
	matedu VARCHAR,
	socm VARCHAR,
	socf VARCHAR,
	migrant VARCHAR,
	genrem VARCHAR,
	person_id_child VARCHAR,
	person_id_mother VARCHAR,
	survey_id VARCHAR);


-- jhn_conception.main.EVENTS definition

CREATE OR REPLACE TABLE Conception.EVENTS(person_id VARCHAR,
	start_date_record VARCHAR,
	end_date_record VARCHAR,
	event_code VARCHAR,
	event_record_vocabulary VARCHAR,
	text_linked_to_event_code VARCHAR,
	event_free_text VARCHAR,
	present_on_admission VARCHAR,
	laterality_of_event VARCHAR,
	meaning_of_event VARCHAR,
	origin_of_event VARCHAR,
	visit_occurrence_id VARCHAR);


-- jhn_conception.main.INSTANCE definition

CREATE OR REPLACE TABLE Conception.INSTANCE(source_table_name VARCHAR,
	source_column_name VARCHAR,
	included_in_instance VARCHAR,
	date_when_data_last_updated VARCHAR,
	since_when_data_complete VARCHAR,
	up_to_when_data_complete VARCHAR,
	restriction_in_values VARCHAR,
	list_of_values VARCHAR,
	restriction_condition VARCHAR);


-- jhn_conception.main.MEDICAL_OBSERVATIONS definition

CREATE OR REPLACE TABLE Conception.MEDICAL_OBSERVATIONS(person_id VARCHAR,
	mo_date VARCHAR,
	mo_code VARCHAR,
	mo_record_vocabulary VARCHAR,
	mo_source_table VARCHAR,
	mo_source_column VARCHAR,
	mo_source_value VARCHAR,
	mo_unit VARCHAR,
	mo_meaning VARCHAR,
	mo_origin VARCHAR,
	visit_occurrence_id VARCHAR);


-- jhn_conception.main.MEDICINES definition

CREATE OR REPLACE TABLE Conception.MEDICINES(person_id VARCHAR,
	medicinal_product_id VARCHAR,
	medicinal_product_atc_code VARCHAR,
	date_dispensing VARCHAR,
	date_prescription VARCHAR,
	disp_number_medicinal_product DECIMAL(18,3),
	presc_quantity_per_day DECIMAL(18,3),
	presc_quantity_unit VARCHAR,
	presc_duration_days DECIMAL(18,3),
	product_lot_number VARCHAR,
	indication_code VARCHAR,
	indication_code_vocabulary VARCHAR,
	meaning_of_drug_record VARCHAR,
	origin_of_drug_record VARCHAR,
	prescriber_speciality VARCHAR,
	prescriber_speciality_vocabulary VARCHAR,
	visit_occurrence_id VARCHAR);


-- jhn_conception.main.METADATA definition

CREATE OR REPLACE TABLE Conception.METADATA(type_of_metadata VARCHAR,
	tablename VARCHAR,
	columnname VARCHAR,
	other VARCHAR,
	"value" VARCHAR);


-- jhn_conception.main.OBSERVATION_PERIODS definition

CREATE OR REPLACE TABLE Conception.OBSERVATION_PERIODS(person_id VARCHAR,
	op_start_date VARCHAR,
	op_end_date VARCHAR,
	op_meaning VARCHAR,
	op_origin VARCHAR);


-- jhn_conception.main.PERSON_RELATIONSHIPS definition

CREATE OR REPLACE TABLE Conception.PERSON_RELATIONSHIPS(person_id VARCHAR,
	related_id VARCHAR,
	meaning_of_relationship VARCHAR,
	origin_of_relationship VARCHAR,
	method_of_linkage VARCHAR);


-- jhn_conception.main.PERSONS definition

CREATE OR REPLACE TABLE Conception.PERSONS(person_id VARCHAR,
	day_of_birth VARCHAR,
	month_of_birth VARCHAR,
	year_of_birth VARCHAR,
	day_of_death VARCHAR,
	month_of_death VARCHAR,
	year_of_death VARCHAR,
	sex_at_instance_creation VARCHAR,
	race VARCHAR,
	country_of_birth VARCHAR,
	quality VARCHAR);


-- jhn_conception.main.PROCEDURES definition

CREATE OR REPLACE TABLE Conception.PROCEDURES(person_id VARCHAR,
	procedure_date VARCHAR,
	procedure_code VARCHAR,
	procedure_code_vocabulary VARCHAR,
	meaning_of_procedure VARCHAR,
	origin_of_procedure VARCHAR,
	visit_occurrence_id VARCHAR);


-- jhn_conception.main.PRODUCTS definition

CREATE OR REPLACE TABLE Conception.PRODUCTS(medicinal_product_id VARCHAR,
	medicinal_product_name VARCHAR,
	unit_of_presentation_type VARCHAR,
	unit_of_presentation_num DECIMAL(18,3),
	administration_dose_form VARCHAR,
	administration_route VARCHAR,
	medicinal_product_atc_code VARCHAR,
	subst1_atc_code VARCHAR,
	subst2_atc_code VARCHAR,
	subst3_atc_code VARCHAR,
	subst1_amount_per_form DECIMAL(18,3),
	subst2_amount_per_form DECIMAL(18,3),
	subst3_amount_per_form DECIMAL(18,3),
	subst1_amount_unit VARCHAR,
	subst2_amount_unit VARCHAR,
	subst3_amount_unit VARCHAR,
	subst1_concentration DECIMAL(18,3),
	subst2_concentration DECIMAL(18,3),
	subst3_concentration DECIMAL(18,3),
	subst1_concentration_unit VARCHAR,
	subst2_concentration_unit VARCHAR,
	subst3_concentration_unit VARCHAR,
	concentration_total_content DECIMAL(18,3),
	concentration_total_content_unit VARCHAR,
	medicinal_product_manufacturer VARCHAR);


-- jhn_conception.main.SURVEY_ID definition

CREATE OR REPLACE TABLE Conception.SURVEY_ID(person_id VARCHAR,
	survey_id VARCHAR,
	survey_date VARCHAR,
	survey_meaning VARCHAR,
	survey_origin VARCHAR);


-- jhn_conception.main.SURVEY_OBSERVATIONS definition

CREATE OR REPLACE TABLE Conception.SURVEY_OBSERVATIONS(person_id VARCHAR,
	so_date VARCHAR,
	so_source_table VARCHAR,
	so_source_column VARCHAR,
	so_source_value VARCHAR,
	so_unit VARCHAR,
	so_meaning VARCHAR,
	so_origin VARCHAR,
	survey_id VARCHAR);


-- jhn_conception.main.VACCINES definition

CREATE OR REPLACE TABLE Conception.VACCINES(person_id VARCHAR,
	vx_record_date VARCHAR,
	vx_admin_date VARCHAR,
	vx_atc VARCHAR,
	vx_type VARCHAR,
	vx_text VARCHAR,
	medicinal_product_id VARCHAR,
	vx_dose VARCHAR,
	vx_manufacturer VARCHAR,
	vx_lot_num VARCHAR,
	meaning_of_vx_record VARCHAR,
	origin_of_vx_record VARCHAR,
	visit_occurrence_id VARCHAR);


-- jhn_conception.main.VISIT_OCCURRENCE definition

CREATE OR REPLACE TABLE Conception.VISIT_OCCURRENCE(person_id VARCHAR,
	visit_occurrence_id VARCHAR,
	visit_start_date VARCHAR,
	visit_end_date VARCHAR,
	speciality_of_visit VARCHAR,
	speciality_of_visit_vocabulary VARCHAR,
	status_at_discharge VARCHAR,
	status_at_discharge_vocabulary VARCHAR,
	meaning_of_visit VARCHAR,
	origin_of_visit VARCHAR);
	
