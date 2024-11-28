CREATE OR REPLACE VIEW JHN_Conception.Conception.vw_VISIT_OCCURRENCE AS

WITH DEDOUBLE AS (
					SELECT 
						C.Patient_id_umc AS person_id
						, CONCAT(CAST(Contact_id AS INT), ':', CAST(import_id AS INT), ':', CAST(Patient_id_umc AS INT)) AS visit_occurrence_id
						, strftime(C.Datum, '%Y%m%d') AS visit_start_date
						-- Same because a GP visit cannot take mutiple days
						, strftime(C.Datum, '%Y%m%d') AS visit_end_date
						, 'HAG' AS speciality_of_visit
						, 'NHG12' AS speciality_of_visit_vocabulary
						-- There is no status at discharge in JHN
						, NULL AS status_at_discharge
						, NULL AS status_at_discharge_vocabulary
						, 'GP_visit_or_contact' AS meaning_of_visit
						, 'contact' AS origin_of_visit	
						
						/* There are duplicate combinations of import_id and Contact_id in the older data. We cannot have this in Conception
						* so we add a rownumber and keep only the most recently edited line
						*/
						, ROW_NUMBER() OVER (PARTITION BY CONCAT(CAST(Contact_id AS INT), ':', CAST(import_id AS INT), ':', C.Patient_id_umc)  ORDER BY Wijzigings_datumtijd DESC) AS DubbelVolgnummer
					FROM JHN_Conception.import.contact C
				)
				
SELECT 
	person_id
	, visit_occurrence_id
	, visit_start_date
	, visit_end_date
	, speciality_of_visit
	, speciality_of_visit_vocabulary
	, status_at_discharge
	, status_at_discharge_vocabulary
	, meaning_of_visit
	, origin_of_visit
FROM DEDOUBLE

WHERE
	-- So we only keep the most recent row
	DubbelVolgnummer = 1 
	
/*  -- Filter on date > 01/01/2019
	AND YEAR(Datum) >= 2019
	
	-- not after 01/07/2024
	AND Datum < '2024/07/01'
*/	

