CREATE OR REPLACE VIEW JHN_Conception.Conception.vw_VACCINES AS

SELECT 
	Patient_id_umc AS person_id
	, strftime(Voorschrijfdatum, '%Y%m%d') AS vx_record_date
	, strftime(Afleverdatum, '%Y%m%d') AS vx_admin_date
	, Atc_code AS vx_atc
	, NULL AS vx_type
	, Omschrijving AS vx_text
	, NULL AS medicinal_product_id -- Same as the medicines table, we might fill this one in later when we fillt eh products table
	, Product_sterkte AS vx_dose
	, NULL AS vx_manufacturer -- We can extract this from the omschrijving or ATC-code if we like
	-- The next line seems to catch the lot, but depends on that very specific notiation
	, NULLIF(SPLIT_PART(Gebruiksvoorschrift, 'Batchnummer: ', 2), '') AS vx_lot_num
	, 'Vaccination_as_administerd_or_reported_back_to_the_GP' AS meaning_of_vx_record
	, 'medicatie' AS origin_of_vx_record	
	, CAST(import_id AS INT) || ':' || CAST(Contact_id AS INT) AS visit_occurrence_id
FROM JHN_Conception.import.medicatie

WHERE 
	-- ATC-code should not start with J07 otherwise it's a vaccination (which should go into the vaccination table)
	SUBSTRING(Atc_code, 1, 3) = 'J07'
/*	
	-- Filter on date > 01/01/2019
	AND YEAR(COALESCE(Voorschrijfdatum, Afleverdatum)) >= 2019
	
	-- not after 01/07/2024
	AND COALESCE(Voorschrijfdatum, Afleverdatum) < '2024/07/01'
*/	
