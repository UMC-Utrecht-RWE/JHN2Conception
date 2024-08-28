CREATE OR REPLACE VIEW JHN_Conception.Conception.vw_PERSONS AS

WITH LASTP AS	(
					-- I want to have the last row per patient 
					SELECT 
						Patient_id_umc
						, MAX(Import_id) AS MaxImport_id
					FROM JHN_Conception.import.patient
					
					GROUP BY
						Patient_id_umc
				)
				
SELECT
	P.Patient_id_umc AS person_id
	, NULL AS day_of_birth
	, strftime('%m', P.Geboorte_maand_jaar) AS month_of_birth
	, strftime('%Y', P.Geboorte_maand_jaar) AS year_of_birth
	, CASE WHEN P.Uitschrijfreden = 'O' THEN strftime('%d', P.Uitschrijfdatum) END AS day_of_death
	, CASE WHEN P.Uitschrijfreden = 'O' THEN strftime('%m', P.Uitschrijfdatum) END AS month_of_death
	, CASE WHEN P.Uitschrijfreden = 'O' THEN strftime('%Y', P.Uitschrijfdatum) END AS year_of_death
	, CASE	WHEN P.Geslacht IN ('M', 'O') THEN P.Geslacht 
			WHEN P.Geslacht = 'V' THEN 'F'
			ELSE 'U'
			END AS sex_at_instance_creation
	, NULL AS race
	, NULL AS country_of_birth
	, NULL AS quality
FROM JHN_Conception.import.patient P

INNER JOIN LASTP LP
	-- So only keep the most recent row (with the highest import_id)
	ON LP.Patient_id_umc = P.Patient_id_umc
	AND LP.MaxImport_id = P.Import_id
	
	
