CREATE OR REPLACE VIEW JHN_Conception.Conception.vw_MEDICAL_OBSERVATIONS AS

SELECT 
	B.Patient_id_umc AS person_id
	, strftime(B.Datum, '%Y%m%d') AS mo_date
	, B.NHGnummer AS mo_code
	, 'NHG45' AS mo_record_vocabulary
	, 'bepaling' AS mo_source_table
	, CASE	WHEN B.Uitslag IS NOT NULL THEN 'Uitslag'
			WHEN B.Uitslag_tekst IS NOT NULL THEN 'Uitslag_tekst'
			END AS mo_source_column
	, CASE	WHEN B.Uitslag IS NOT NULL THEN REPLACE(B.Uitslag, '.', ',')
			WHEN B.Uitslag_tekst IS NOT NULL THEN B.Uitslag_tekst
			END AS mo_source_value
	-- We can actuially get the unit by importing the NHG tables thus getting the vocabulary
	, NHG.eenheid AS mo_unit
	-- Alle niet lettes en cijfers er uit anders vallen de levelchecks om
	-- Edit 26/07/2024: Replaced the mo_meaning with a default value, otherwise the levelcheck files become huge
	, 'GP_lab_values' AS mo_meaning
	--, REGEXP_REPLACE(NHG.omschrijving, '[^a-zA-Z0-9]', ' ', 'g') AS mo_meaning 
	-- Isn't this information not already in the mo_source_table column?
	, 'bepaling' AS mo_origin
	-- Since a lot of the laboratory values are not measured directly by the GP they're often not linked to the visit directly
	, B.Contact_id AS visit_occurrence_id
FROM JHN_Conception.import.bepaling B

LEFT JOIN JHN_Conception.NHG.NHG45 NHG
	-- NHG referentietabel voor de unit
	ON NHG.bepalingsnr = B.NHGnummer
/*
WHERE
	-- Filter on date > 01/01/2019
	YEAR(B.Datum) >= 2019
	
	-- not after 01/07/2024
	AND B.Datum < '2024/07/01'
	
*/
