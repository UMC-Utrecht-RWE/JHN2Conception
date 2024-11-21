CREATE OR REPLACE VIEW JHN_Conception.Conception.vw_EVENTS AS

SELECT 
	JR.Patient_id_umc  AS person_id
	, strftime(JR.Journaal_Datumtijd, '%Y%m%d') AS start_date_record
	, NULL AS end_date_record -- No end date
	--If there is no Icpc on the journaalregel we'll take the journaal ICPC
	, COALESCE(JR.Icpc, J.Icpc) AS event_code	
	, CASE	WHEN COALESCE(JR.Icpc, J.Icpc) IS NOT NULL THEN 'Icpc'
			WHEN JR.Tekst IS NOT NULL THEN 'free_text' 
			END AS event_record_vocabulary
	-- If nothing then E
	, COALESCE(JR.Soepcode, 'E') AS text_linked_to_event_code
	, CASE WHEN	COALESCE(JR.Icpc, J.Icpc) IS NULL THEN JR.Tekst END AS event_free_text 
	, NULL AS present_on_admission -- Not applicable
	, NULL AS laterality_of_event  -- Not applicable
	, 'Journaalregel' AS meaning_of_event
	, 'journaalregel' AS origin_of_event
	, CAST(J.import_id AS INT) || ':' || CAST(J.Contact_id AS INT) AS visit_occurrence_id
FROM JHN_Conception.import.journaalregel JR

INNER JOIN JHN_Conception.import.journaal J
	-- To get the visit_occurrence_id
	ON J.Journaal_id = JR.Journaal_id
	AND J.Import_id = JR.Import_id
	
WHERE 	
	-- Event_code of event_free_text moet zijn gevuld (of beiden)
	(JR.Icpc IS NOT NULL OR JR.Tekst IS NOT NULL)
/*	
	-- Filter on date > 01/01/2019
	AND YEAR(JR.Journaal_Datumtijd) >= 2019
	
	-- not after 01/07/2024
	AND JR.Journaal_Datumtijd < '2024/07/01'
*/
	
UNION ALL

/* 
 * Here we add the Journaal lines otherwise we might miss the Icpc codes of the episode
 */

SELECT 
	J.Patient_id_umc AS person_id
	, strftime(J.Journaal_datumtijd, '%Y%m%d')  AS start_date_record
	, NULL AS end_date_record
	, J.Episode_icpc AS event_code
	, 'Icpc' AS event_record_vocabulary
	, 'E' AS text_linked_to_event_code
	, NULL AS event_free_text
	, NULL AS present_on_admission
	, NULL AS laterality_of_event
	, 'Journaal' AS meaning_of_event
	, 'Journaal' AS origin_of_event
	, CAST(J.import_id AS INT) || ':' || CAST(J.Contact_id AS INT) AS visit_occurrence_id
FROM JHN_Conception.import.journaal J

WHERE 	
	-- We need to have an ICPC code on the journaal to be a relevant line
	J.Episode_icpc IS NOT NULL
/*	
	-- Filter on date > 01/01/2019
	AND YEAR(J.Journaal_Datumtijd) >= 2019
	
	-- not after 01/07/2024
	AND J.Journaal_Datumtijd < '2024/07/01'
*/