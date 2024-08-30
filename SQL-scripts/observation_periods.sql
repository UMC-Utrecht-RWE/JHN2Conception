CREATE OR REPLACE VIEW JHN_Conception.Conception.vw_OBSERVATION_PERIODS AS

SELECT 
	Patient_id_umc AS person_id
	, strftime(Inschrijfdatum, '%Y%m%d') AS op_start_date
	, strftime(Uitschrijfdatum, '%Y%m%d') AS op_end_date
	, CASE	WHEN Uitschrijfreden = 'A' THEN 'Naar andere arts'
			WHEN Uitschrijfreden = 'V' THEN 'Verhuizing'
			WHEN Uitschrijfreden = 'O' THEN 'Overleden'
			WHEN Uitschrijfreden = 'T' THEN 'Tijdelijk buiten praktijk'
			WHEN Uitschrijfreden = 'M' THEN 'Militaire dienst'
			WHEN Uitschrijfreden = 'I' THEN 'Verpleeghuis / inrichting'
			WHEN Uitschrijfreden = 'Q' THEN 'Overig'
			WHEN Uitschrijfreden = 'X' THEN 'Onbekend'
			ELSE COALESCE(Uitschrijfreden, 'Nog geldig')
			END AS op_meaning
	, 'patient_in_uit' AS op_origin
FROM JHN_Conception.import.patient_in_uit

/*
WHERE
	-- Filter on date > 01/01/2019
	YEAR(Inschrijfdatum) >= 2019
	
	-- not after 01/07/2024
	AND Inschrijfdatum < '2024/07/01'
*/	
