CREATE OR REPLACE VIEW JHN_Conception.Conception.vw_METADATA AS

WITH META AS	(
					SELECT 'presence_of_table' AS type_of_metadata UNION
					SELECT 'presence_of_column' AS type_of_metadata
				)


SELECT DISTINCT 
	M.type_of_metadata
	, IC.table_name AS tablename
	, CASE WHEN M.type_of_metadata != 'presence_of_table' THEN IC.column_name END AS columnname
	, NULL AS other	
	, CASE 	WHEN LOWER(IC.table_name) IN ('eurocat', 'person_relationships', 'survey_id', 'survey_observations') THEN 'No'
			WHEN LOWER(IC.table_name) NOT IN ('eurocat', 'person_relationships', 'products', 'survey_id', 'survey_observations') AND M.type_of_metadata = 'precense_of_column' THEN 'Yes'
			WHEN LOWER(IC.table_name) = 'cdm_source' AND IC.column_name IN ('data_dictionary_link', 'etl_link') THEN 'No'
			WHEN LOWER(IC.table_name) = 'events' AND IC.column_name IN ('present_on_admission', 'laterality_of_event') THEN 'No'
			WHEN LOWER(IC.table_name) = 'instance' AND IC.column_name IN ('restriction_in_values', 'list_of_values', 'restriction_condition') THEN 'No'
			--WHEN LOWER(IC.table_name) = 'medical_observations' AND IC.column_name IN ('', '', '', '', '', '', '', '', '', '', '') THEN 'No'
			WHEN LOWER(IC.table_name) = 'medicines' AND IC.column_name IN ('medicinal_product_id', 'date_dispensing', 'disp_number_medicinal_product', 'product_lot_number', 'indication_code', 'indication_code_vocabulary', 'presc_duration_days') THEN 'No'
			--WHEN LOWER(IC.table_name) = 'metadata' AND IC.column_name IN ('other') THEN 'No'
			--WHEN LOWER(IC.table_name) = 'observation_periods' AND IC.column_name IN ('', '', '', '', '', '', '', '', '', '', '') THEN 'No'
			WHEN LOWER(IC.table_name) = 'persons' AND IC.column_name IN ('day_of_birth', 'race', 'country_of_birth', 'quality') THEN 'No'
			--WHEN LOWER(IC.table_name) = 'procedures' AND IC.column_name IN ('', '', '', '', '', '', '', '', '', '', '') THEN 'No'
			WHEN LOWER(IC.table_name) = 'vaccines' AND IC.column_name IN ('vx_type', 'medicinal_product_id', 'vx_manufacturer') THEN 'No'
			WHEN LOWER(IC.table_name) = 'visit_occurrence' AND IC.column_name IN ('status_at_discharge', 'status_at_discharge_vocabulary') THEN 'No'
			WHEN LOWER(IC.table_name) = 'products' AND IC.column_name IN ('unit_of_presentation_type', 'unit_of_presentation_num', 'administration_dose_form'
				, 'administration_route', 'medicinal_product_atc_code', 'subst2_atc_code', 'subst3_atc_code', 'subst1_amount_per_form', 'subst2_amount_per_form'
				, 'subst3_amount_per_form', 'subst1_amount_unit', 'subst2_amount_unit', 'subst3_amount_unit', 'subst1_concentration', 'subst2_concentration'
				, 'subst3_concentration', 'subst1_concentration_unit', 'subst2_concentration_unit', 'subst3_concentration_unit', 'concentration_total_content'
				, 'concentration_total_content_unit', 'medicinal_product_manufacturer') THEN 'No'			
			ELSE 'Yes'
			END AS values
FROM information_schema.columns IC

INNER JOIN META M
	ON 1 = 1 

WHERE 
	-- Alleen de lege tabellen (daar staan alle tabellen en kolommen in)
	SUBSTRING(table_name, 1, 3) != 'vw_'
	
	-- In schema Conception
	AND table_schema = 'Conception'
	
	-- De metadata mag zelf niet mee
	AND IC.table_name != 'METADATA'
	
	-- No empty columns
	AND CASE WHEN M.type_of_metadata != 'presence_of_table' THEN IC.column_name END IS NOT NULL

UNION ALL

-- Add list_of_values rows

-- PERSONS
SELECT 'list_of_values' AS type_of_metadata, 'PERSONS' AS tablename, 'sex_at_instance_creation' AS columnname, '' AS other, STRING_AGG(DISTINCT sex_at_instance_creation, ' ') AS VALUES FROM JHN_Conception.Conception.vw_PERSONS
UNION ALL

--CDM_SOURCE
SELECT 'list_of_values' AS type_of_metadata, 'CDM_SOURCE' AS tablename, 'data_access_provider_code' AS columnname, '' AS other, STRING_AGG(DISTINCT data_access_provider_code, ' ') AS values FROM JHN_Conception.Conception.vw_CDM_SOURCE
UNION ALL
SELECT 'list_of_values' AS type_of_metadata, 'CDM_SOURCE' AS tablename, 'data_access_provider_name' AS columnname, '' AS other, STRING_AGG(DISTINCT data_access_provider_name, ' ') AS values FROM JHN_Conception.Conception.vw_CDM_SOURCE
UNION ALL
SELECT 'list_of_values' AS type_of_metadata, 'CDM_SOURCE' AS tablename, 'data_source_name' AS columnname, '' AS other, STRING_AGG(DISTINCT data_source_name, ' ') AS values FROM JHN_Conception.Conception.vw_CDM_SOURCE
UNION ALL
SELECT 'list_of_values' AS type_of_metadata, 'CDM_SOURCE' AS tablename, 'cdm_vocabulary_version' AS columnname, '' AS other, STRING_AGG(DISTINCT cdm_vocabulary_version, ' ') AS values FROM JHN_Conception.Conception.vw_CDM_SOURCE
UNION ALL
SELECT 'list_of_values' AS type_of_metadata, 'CDM_SOURCE' AS tablename, 'cdm_version' AS columnname, '' AS other, STRING_AGG(DISTINCT cdm_version, ' ') AS values FROM JHN_Conception.Conception.vw_CDM_SOURCE
UNION ALL

-- EVENTS
SELECT 'list_of_values' AS type_of_metadata, 'EVENTS' AS tablename, 'event_record_vocabulary' AS columnname, '' AS other, STRING_AGG(DISTINCT event_record_vocabulary, ' ') AS values FROM JHN_Conception.Conception.vw_EVENTS
UNION ALL
SELECT 'list_of_values' AS type_of_metadata, 'EVENTS' AS tablename, 'meaning_of_event' AS columnname, '' AS other, STRING_AGG(DISTINCT meaning_of_event, ' ') AS values FROM JHN_Conception.Conception.vw_EVENTS
UNION ALL

--INSTANCE
SELECT 'list_of_values' AS type_of_metadata, 'INSTANCE' AS tablename, 'included_in_instance' AS columnname, '' AS other, STRING_AGG(DISTINCT included_in_instance, ' ') AS values FROM JHN_Conception.Conception.vw_INSTANCE
UNION ALL
SELECT 'list_of_values' AS type_of_metadata, 'INSTANCE' AS tablename, 'restriction_in_values' AS columnname, '' AS other, STRING_AGG(DISTINCT restriction_in_values, ' ') AS values FROM JHN_Conception.Conception.vw_INSTANCE
UNION ALL
SELECT 'list_of_values' AS type_of_metadata, 'INSTANCE' AS tablename, 'source_table_name' AS columnname, '' AS other, STRING_AGG(DISTINCT source_table_name, ' ') AS values FROM JHN_Conception.Conception.vw_INSTANCE
UNION ALL

--MEDICAL_OBSERVATIONS
SELECT 'list_of_values' AS type_of_metadata, 'MEDICAL_OBSERVATIONS' AS tablename, 'mo_meaning' AS columnname, '' AS other, STRING_AGG(DISTINCT mo_meaning, ' ') AS values FROM JHN_Conception.Conception.vw_MEDICAL_OBSERVATIONS
UNION ALL
SELECT 'list_of_values' AS type_of_metadata, 'MEDICAL_OBSERVATIONS' AS tablename, 'mo_record_vocabulary' AS columnname, '' AS other, STRING_AGG(DISTINCT mo_record_vocabulary, ' ') AS values FROM JHN_Conception.Conception.vw_MEDICAL_OBSERVATIONS
UNION ALL
SELECT 'list_of_values' AS type_of_metadata, 'MEDICAL_OBSERVATIONS' AS tablename, 'mo_source_table' AS columnname, '' AS other, STRING_AGG(DISTINCT mo_source_table, ' ') AS values FROM JHN_Conception.Conception.vw_MEDICAL_OBSERVATIONS
UNION ALL
SELECT 'list_of_values' AS type_of_metadata, 'MEDICAL_OBSERVATIONS' AS tablename, 'mo_unit' AS columnname, '' AS other, STRING_AGG(DISTINCT mo_unit, ' ') AS values FROM JHN_Conception.Conception.vw_MEDICAL_OBSERVATIONS
UNION ALL

--MEDICINES
SELECT 'list_of_values' AS type_of_metadata, 'MEDICINES' AS tablename, 'meaning_of_drug_record' AS columnname, '' AS other, STRING_AGG(DISTINCT meaning_of_drug_record, ' ') AS values FROM JHN_Conception.Conception.vw_MEDICINES
UNION ALL
SELECT 'list_of_values' AS type_of_metadata, 'MEDICINES' AS tablename, 'presc_quantity_unit' AS columnname, '' AS other, STRING_AGG(DISTINCT presc_quantity_unit, ' ') AS values FROM JHN_Conception.Conception.vw_MEDICINES
UNION ALL
SELECT 'list_of_values' AS type_of_metadata, 'MEDICINES' AS tablename, 'prescriber_speciality_vocabulary' AS columnname, '' AS other, STRING_AGG(DISTINCT prescriber_speciality_vocabulary, ' ') AS values FROM JHN_Conception.Conception.vw_MEDICINES
UNION ALL

--OBSERVATION_PERIODS
SELECT 'list_of_values' AS type_of_metadata, 'OBSERVATION_PERIODS' AS tablename, 'op_meaning' AS columnname, '' AS other, STRING_AGG(DISTINCT op_meaning, ' ') AS values FROM JHN_Conception.Conception.vw_OBSERVATION_PERIODS
UNION ALL

--PROCEDURES
SELECT 'list_of_values' AS type_of_metadata, 'PROCEDURES' AS tablename, 'meaning_of_procedure' AS columnname, '' AS other, STRING_AGG(DISTINCT meaning_of_procedure, ' ') AS values FROM JHN_Conception.Conception.vw_PROCEDURES
UNION ALL
SELECT 'list_of_values' AS type_of_metadata, 'PROCEDURES' AS tablename, 'procedure_code_vocabulary' AS columnname, '' AS other, STRING_AGG(DISTINCT procedure_code_vocabulary, ' ') AS values FROM JHN_Conception.Conception.vw_PROCEDURES
UNION ALL

--VACCINES
SELECT 'list_of_values' AS type_of_metadata, 'VACCINES' AS tablename, 'meaning_of_vx_record' AS columnname, '' AS other, STRING_AGG(DISTINCT meaning_of_vx_record, ' ') AS values FROM JHN_Conception.Conception.vw_VACCINES
UNION ALL
SELECT 'list_of_values' AS type_of_metadata, 'VACCINES' AS tablename, 'vx_dose' AS columnname, '' AS other, STRING_AGG(DISTINCT vx_dose, ' ') AS values FROM JHN_Conception.Conception.vw_VACCINES
UNION ALL

--VISIT_OCCURRENCE
SELECT 'list_of_values' AS type_of_metadata, 'VISIT_OCCURRENCE' AS tablename, 'meaning_of_visit' AS columnname, '' AS other, STRING_AGG(DISTINCT meaning_of_visit, ' ') AS values FROM JHN_Conception.Conception.vw_VISIT_OCCURRENCE
UNION ALL
SELECT 'list_of_values' AS type_of_metadata, 'VISIT_OCCURRENCE' AS tablename, 'speciality_of_visit_vocabulary' AS columnname, '' AS other, STRING_AGG(DISTINCT speciality_of_visit_vocabulary, ' ') AS values FROM JHN_Conception.Conception.vw_VISIT_OCCURRENCE


ORDER BY
	1, 2, 3
	
	
