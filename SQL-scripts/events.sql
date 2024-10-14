/***************************
 * Temp table STATUS	****
 **************************/

CREATE OR REPLACE TABLE tussentabellen.STATUS AS 

-- First we need to make sure we don't have historic records that were imported from old GPs
SELECT 
	Patient_id_umc
	, Stabiel_Episode_Id
	, Episode_id
	, Icpc
	, Icpc_omschrijving
	, Begindatum
	, Einddatum
	, Wijzigings_datumtijd
	, Omschrijving
	, Import_id
	, CASE	WHEN Episode_status LIKE 'A%' OR Episode_status LIKE 'a%' THEN 'Actief'
			WHEN Episode_status IS NULL AND Attentie = 1 THEN 'Actief'
			WHEN Episode_status IS NULL AND Attentie = 0 AND Einddatum IS NULL THEN 'Actief'
			WHEN Episode_status LIKE 'I%' OR Episode_status LIKE 'i%' THEN 'Inactief'
			WHEN Episode_status LIKE 'N%' OR Episode_status LIKE 'n%' THEN 'Inactief'
			WHEN Episode_status IS NULL AND (Attentie = 0 OR Attentie IS NULL) AND Einddatum IS NOT NULL THEN 'Inactief'
			WHEN Episode_status LIKE 'Historisch (N)%' THEN 'Inactief'
			WHEN Episode_status LIKE 'V%' OR Episode_status LIKE 'v%' THEN 'Historisch'
			WHEN Episode_status LIKE 'S%' OR Episode_status LIKE 's%' THEN 'Historisch'
			WHEN Episode_status LIKE 'H%' OR Episode_status LIKE 'h%' THEN 'Historisch'							
			END AS Episode_status_afgeleid				
FROM JHN_Conception.import.episode
					
WHERE 	
	CASE	WHEN Episode_status LIKE 'A%' OR Episode_status LIKE 'a%' THEN 'Actief'
			WHEN Episode_status IS NULL AND Attentie = 1 THEN 'Actief'
			WHEN Episode_status IS NULL AND Attentie = 0 AND Einddatum IS NULL THEN 'Actief'
			WHEN Episode_status LIKE 'I%' OR Episode_status LIKE 'i%' THEN 'Inactief'
			WHEN Episode_status LIKE 'N%' OR Episode_status LIKE 'n%' THEN 'Inactief'
			WHEN Episode_status IS NULL AND (Attentie = 0 OR Attentie IS NULL) AND Einddatum IS NOT NULL THEN 'Inactief'
			WHEN Episode_status LIKE 'Historisch (N)%' THEN 'Inactief'
			WHEN Episode_status LIKE 'V%' OR Episode_status LIKE 'v%' THEN 'Historisch'
			WHEN Episode_status LIKE 'S%' OR Episode_status LIKE 's%' THEN 'Historisch'
			WHEN Episode_status LIKE 'H%' OR Episode_status LIKE 'h%' THEN 'Historisch'							
			END IN ('Actief', 'Inactief');

/***************************
 * Temp table WIJZIGING	****
 **************************/		
		
CREATE OR REPLACE TABLE tussentabellen.WIJZIGING AS		
			
SELECT 
	*						
	--, LAG(Episode_status_afgeleid) OVER(PARTITION BY Patient_id_umc, Stabiel_Episode_Id ORDER BY Import_id) AS Vorige_Episode_status_afgeleid
	, CASE WHEN COALESCE(LAG(Episode_status_afgeleid) OVER(PARTITION BY Patient_id_umc, Stabiel_Episode_Id ORDER BY Import_id), '') != Episode_status_afgeleid THEN 1 END AS StatusWijziging
FROM tussentabellen.STATUS S;
	
/***************************
 * Temp table BEGEIND	****
 **************************/

CREATE OR REPLACE TABLE tussentabellen.BEGEIND AS					
		
SELECT
	Patient_id_umc
	, COALESCE(Stabiel_Episode_Id, Episode_id) AS Stabiel_Episode_Id
	, Icpc
	, Icpc_omschrijving
--	 Begindatum
--	, Einddatum
	, CASE	WHEN ROW_NUMBER() OVER(PARTITION BY Patient_id_umc, COALESCE(Stabiel_Episode_Id, Episode_id) ORDER BY Import_id) = 1 THEN Begindatum
			ELSE CAST(Wijzigings_datumtijd AS DATE) 
			END AS Begindatum
	, COALESCE(CAST(LEAD(Wijzigings_datumtijd) OVER(PARTITION BY Patient_id_umc, COALESCE(Stabiel_Episode_Id, Episode_id) ORDER BY Import_id) AS DATE), Einddatum) AS Einddatum
	, Episode_status_afgeleid	
	, Omschrijving
--	, Wijzigings_datumtijd
	, Import_id	
	, StatusWijziging
FROM tussentabellen.WIJZIGING
						
WHERE
	-- Ik wil alleen rijen met een status wijziging
	StatusWijziging = 1;	

/***************************
 * The actual query		****
 **************************/

CREATE OR REPLACE VIEW Conception.vw_EVENTS AS 

SELECT 
	Patient_id_umc AS person_id
	, strftime(Begindatum, '%Y%m%d') AS start_date_record
	, strftime(Einddatum, '%Y%m%d') AS end_date_record
	, Icpc AS event_code
	, CASE	WHEN Icpc IS NOT NULL THEN 'Icpc'
			WHEN Omschrijving IS NOT NULL THEN 'free_text' 
			END AS event_record_vocabulary
	, Icpc_omschrijving AS text_linked_to_event_code
	, CASE WHEN Icpc IS NULL THEN Omschrijving END AS event_free_text
	, NULL AS present_on_admission -- We're not talking admissions here
	, NULL AS laterality_of_event -- Not in the data
	, 'primary_care_event' AS meaning_of_event
	, 'episode' AS origin_of_event
	, NULL AS visit_occurrence_id -- These episodes are not linked to a contact
FROM tussentabellen.BEGEIND

WHERE 
	-- Ik wil alleen de actieve perioden
	Episode_status_afgeleid = 'Actief'
	
	-- Event_code of event_free_text moet zijn gevuld (of beiden)
	AND (Icpc IS NOT NULL OR Omschrijving IS NOT NULL)
/*	
	-- Filter on date > 01/01/2019
	AND YEAR(Begindatum) >= 2019
	
	-- not after 01/07/2024
	AND Begindatum < '2024/07/01'
*/	
	-- Einddatum mag nooit voor begindatum zijn
	AND end_date_record >= start_date_record

UNION ALL

SELECT 
	JR.Patient_id_umc  AS person_id
	, strftime(JR.Journaal_Datumtijd, '%Y%m%d') AS start_date_record
	, NULL AS end_date_record -- No end date
	, JR.Icpc AS event_code	
	, CASE	WHEN JR.Icpc IS NOT NULL THEN 'Icpc'
			WHEN JR.Tekst IS NOT NULL THEN 'free_text' 
			END AS event_record_vocabulary
	, JR.Soepcode AS text_linked_to_event_code
	, CASE WHEN	JR.Icpc IS NULL THEN JR.Tekst END AS event_free_text 
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
