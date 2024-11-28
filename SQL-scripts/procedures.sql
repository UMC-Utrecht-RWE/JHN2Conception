CREATE OR REPLACE VIEW JHN_Conception.Conception.vw_PROCEDURES AS

/*
 * We need to do a distinct here because the old 'Mondriaan' data allows for dupplicates, these are wrong, we have to leave just one
 */

SELECT DISTINCT
	Patient_id_umc AS person_id
	-- According to meta either billing date or actual procedure date
	, strftime(Factuur_datum, '%Y%m%d') AS procedure_date
	, COALESCE(Vektis_code, Nhg_code) AS procedure_code
	, CASE	WHEN Vektis_code IS NOT NULL THEN 'Vektis COD322-NZA, code-element 008' -- Meta doesn't say what vektis table, but it looks like that one
			WHEN Nhg_code IS NOT NULL THEN 'NHG15'
			END AS procedure_code_vocabulary	
	, 'GP_procedure' AS meaning_of_procedure
	, 'verrichting' AS origin_of_procedure
	, CAST(import_id AS INT) || ':' || CAST(Contact_id AS INT) AS visit_occurrence_id
FROM JHN_Conception.import.verrichting

/*
WHERE
	-- Filter on date > 01/01/2019
	YEAR(Factuur_datum) >= 2019
	
	-- not after 01/07/2024
	AND Factuur_datum < '2024/07/01'
*/	
