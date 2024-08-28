CREATE OR REPLACE VIEW JHN_Conception.Conception.vw_CDM_SOURCE AS

SELECT 
	'JHN' AS data_access_provider_code
	, 'Julius Huisartsen Netwerk' AS data_access_provider_name
	, 'Julius Huisartsen Netwerk data since 2016' AS data_source_name
	, NULL AS data_dictionary_link
	, NULL AS etl_link
	, 'v2.2' AS cdm_vocabulary_version
	, 'v2.2' AS cdm_version
	, 1 AS instance_number
	, '20240701' AS date_creation
	, '20240701' AS recommended_end_date
