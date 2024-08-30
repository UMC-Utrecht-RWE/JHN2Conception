CREATE OR REPLACE VIEW JHN_Conception.Conception.vw_VISIT_OCCURRENCE AS

SELECT 
	Patient_id_umc AS person_id
	, Contact_id AS visit_occurrence_id
	, strftime(Datum, '%Y%m%d') AS visit_start_date
	-- Same because a GP visit cannot take mutiple days
	, strftime(Datum, '%Y%m%d') AS visit_end_date
	, 'HAG' AS speciality_of_visit
	, 'NHG12' AS speciality_of_visit_vocabulary
	-- There is no status at discharge in JHN
	, NULL AS status_at_discharge
	, NULL AS status_at_discharge_vocabulary
	, COALESCE(REGEXP_REPLACE(Contactsoort_Omschr, '[^a-zA-Z0-9]', ' ', 'g'), 'contact') AS meaning_of_visit
	, 'contact' AS origin_of_visit
FROM JHN_Conception.import.contact

/*
WHERE
	-- Filter on date > 01/01/2019
	YEAR(Datum) >= 2019
	
	-- not after 01/07/2024
	AND Datum < '2024/07/01'
*/	



