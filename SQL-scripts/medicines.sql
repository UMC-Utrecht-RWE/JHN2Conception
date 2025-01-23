CREATE OR REPLACE VIEW JHN_Conception.Conception.vw_MEDICINES AS

/*
 * We need to deduplicate the medication because sometimes the prescription comes back from the pharmacy into the GP system. We then have one version
 * from the GP and one from the pharmacy. They often compliment each other, so it's best to do the max of the rows so as to eliminate the NULL rows 
 * 
 */

WITH DEDUP AS 	(	
					SELECT 
						Patient_id_umc
						, praktijk_id
						, Atc_code
						, Omschrijving
						, Voorschrijfdatum	
						
						, MAX(Id) AS Id
						, MAX(Contact_id) AS Contact_id
						, MAX(Journaal_id) AS Journaal_id
						, MAX(Episode_id) AS Episode_id
						, MAX(HIS_episode_id) AS HIS_episode_id
						, MAX(Episode_icpc) AS Episode_icpc
						, MAX(Recept_id) AS Recept_id
						, MAX(Afgeleverd) AS Afgeleverd
						, MAX(Afleverdatum) AS Afleverdatum
						, MAX(Atc_omschrijving) AS Atc_omschrijving
						, MAX(Zindex_nummer) AS Zindex_nummer
						, MAX(Prk) AS Prk
						, MAX(Gpk) AS Gpk
						, MAX(Hpk) AS Hpk
						, MAX(Hoeveelheid) AS Hoeveelheid
						, MAX(Aflever_eenheid) AS Aflever_eenheid
						, MAX(Product_sterkte) AS Product_sterkte
						, MAX(Gebruiksvoorschrift) AS Gebruiksvoorschrift
						, MAX(Einddatum) AS Einddatum
						, MAX(Gebruik_X) AS Gebruik_X
						, MAX(Gebruik_t) AS Gebruik_t
						, MAX(Gebruik_Y) AS Gebruik_Y
						, MAX(Gebruik_a) AS Gebruik_a
						, MAX(Gebruik_b) AS Gebruik_b
						, MAX(Vrije_tekst) AS Vrije_tekst
						, MAX(Chronisch) AS Chronisch
						, MAX(Iteraties) AS Iteraties
						, MAX(Volgnummer_herhaling) AS Volgnummer_herhaling
						, MAX(Toedieningsweg) AS Toedieningsweg
						, MAX(Specialisme) AS Specialisme
						, MAX(Actueel) AS Actueel
						, MAX(Originele_medewerker_id_umc) AS Originele_medewerker_id_umc
						, MAX(Laatste_medewerker_id_umc) AS Laatste_medewerker_id_umc
						, MAX(Creatie_datumtijd) AS Creatie_datumtijd
						, MAX(Wijzigings_datumtijd) AS Wijzigings_datumtijd
						, MAX(Selectie_datumtijd) AS Selectie_datumtijd
						, MAX(icpc_omschrijving) AS icpc_omschrijving
						, MAX(code_stopzetting) AS code_stopzetting
						, MAX(reden_stopzetting) AS reden_stopzetting
						, MAX(stopzetting_medewerker_id_umc) AS stopzetting_medewerker_id_umc
						, MAX(Import_id) AS Import_id
					FROM JHN_Conception.import.medicatie
					
					GROUP BY
						Patient_id_umc
						, praktijk_id
						, Atc_code
						, Omschrijving
						, Voorschrijfdatum
				)
				
SELECT
    Patient_id_umc AS person_id    

--    , CASE	WHEN NULLIF(Zindex_nummer, 0) IS NOT NULL THEN CAST(CAST(Zindex_nummer AS INT) AS VARCHAR)
--			WHEN COALESCE(BST711T.ATCODE, Atc_code) IS NOT NULL THEN COALESCE(BST711T.ATCODE, Atc_code)
--			END AS medicinal_product_id
    
      , CASE	WHEN COALESCE(BST711T.ATCODE, Atc_code) IS NOT NULL THEN COALESCE(BST711T.ATCODE, Atc_code)
	      		WHEN NULLIF(Zindex_nummer, 0) IS NOT NULL THEN CAST(CAST(Zindex_nummer AS INT) AS VARCHAR)
				END AS medicinal_product_id
			
    , COALESCE(BST711T.ATCODE, Atc_code) AS medicinal_product_atc_code
    , strftime(Afleverdatum, '%Y%m%d') AS date_dispensing
    , strftime(Voorschrijfdatum, '%Y%m%d') AS date_prescription
    , NULL AS disp_number_medicinal_product -- We don't have dispensing information in JHN    
    
    -- The following two columns (prescribed quantity per day and prescribed duration days) are not coded as such in JHN.
    -- they can be derived from the folling columns in JHN though after textmining:
    	-- Hoeveelheid: Total prescribed quantity (not per day)
    	-- Gebruiksvoorschrift: How to take these drugs (twice a day one tablet)
    	-- So a Hoeveelheid of 90 and a Gebruiksvoorschrift of 2D1T (twice dayly one tablet) will result in
    		-- presc_quantity_per_day: 2
    		-- presc_duration_days: 45 
    -- Because I don't have the correct values I'm going to use 
    	-- Hoeveelheid AS presc_quantity_per_day
    	-- Gebruiksvoorschrift AS presc_duration_days
    -- ... even though this is not correct.
    
    , Hoeveelheid AS presc_quantity_per_day -- So, NOT correct, see above
    , Aflever_eenheid AS presc_quantity_unit
    -- Remove any special characters otherwise these brittle levelchecks will fail
    -- Actually making it NULL since this column should be numeric
    , NULL AS presc_duration_days
    --, REGEXP_REPLACE(Gebruiksvoorschrift, '[^a-zA-Z0-9]', ' ', 'g') AS presc_duration_days -- So, NOT correct, see above
    
    , NULL AS product_lot_number -- We don't have dispensing information in JHN
    , NULL AS indication_code -- There is no indication in the JHN
    , NULL AS indication_code_vocabulary -- There is no indication in the JHN
    , 'Prescription_in_general_practition' AS meaning_of_drug_record
    , 'medicatie' AS origin_of_drug_record
    , Specialisme AS prescriber_speciality
    , CASE WHEN Specialisme IS NOT NULL THEN 'NHG12' END AS prescriber_speciality_vocabulary
    , CASE WHEN Contact_id IS NOT NULL THEN CONCAT(CAST(Contact_id AS INT), ':',  CAST(Import_id AS INT), ':', CAST(Patient_id_umc AS INT)) END AS visit_occurrence_id
FROM DEDUP M

LEFT JOIN JHN_Conception.ReferenceTables.BST004T
	-- Join to BST004T to get to the HPKODE from the Z-index
	ON M.Zindex_nummer = BST004T.ATKODE
	
LEFT JOIN JHN_Conception.ReferenceTables.BST070T
	-- Join to BST070T to get to the GPKODE from the Z-index
	-- Take either the HPKODE from BST004T or from medicatie
	ON COALESCE(BST004T.HPKODE, LPAD(CAST(CAST(Hpk AS INT) AS VARCHAR), 7, '0')) = BST070T.HPKODE
	
LEFT JOIN JHN_Conception.ReferenceTables.BST711T
	-- Join to BST711T to get to the ATCODE (ATC-code) from the Z-index
	-- Take either the GPKODE from BST070T or from medicatie	
	ON COALESCE(BST711T.GPKODE, LPAD(CAST(CAST(Gpk AS INT) AS VARCHAR), 8, '0')) = BST070T.GPKODE  
    
WHERE    
    -- ATC-code should not start with J07 otherwise it's a vaccination (which should go into the vaccination table)
	SUBSTRING(COALESCE(COALESCE(BST711T.ATCODE, Atc_code), ''), 1, 3) != 'J07'
	
/*	
	-- Filter on date > 01/01/2019
	AND YEAR(Voorschrijfdatum) >= 2019	
	
	-- not after 01/07/2024
	AND Voorschrijfdatum < '2024/07/01'
*/	


