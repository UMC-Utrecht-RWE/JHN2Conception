CREATE OR REPLACE VIEW JHN_Conception.Conception.vw_METADATA AS

WITH META AS	(
					SELECT 'presence_of_table' AS type_of_metadata UNION
					SELECT 'presence_of_column' AS type_of_metadata UNION
					SELECT 'list_of_values' AS type_of_metadata
					
				)


SELECT DISTINCT 
	M.type_of_metadata
	, IC.table_name AS tablename
	, CASE WHEN M.type_of_metadata != 'presence_of_table' THEN IC.column_name END AS columnname
	, NULL AS other	
	, CASE 	WHEN LOWER(IC.table_name) IN ('eurocat', 'person_relationships', 'products', 'survey_id', 'survey_observations') THEN 'No'
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

ORDER BY
	M.type_of_metadata
	, IC.table_name
	, IC.column_name
	
