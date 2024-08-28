CREATE OR REPLACE VIEW JHN_Conception.Conception.vw_MEDICINES AS

SELECT
    Patient_id_umc AS person_id    
    , NULL AS medicinal_product_id -- We don't use the product table here 
    , Atc_code AS medicinal_product_atc_code
    , Afleverdatum AS date_dispensing
    , strftime(Voorschrijfdatum , '%Y%m%d') AS date_prescription
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
    , 'NHG12' AS prescriber_speciality_vocabulary
    , Contact_id AS visit_occurrence_id
FROM
    JHN_Conception.import.medicatie
	
WHERE    
    -- ATC-code should not start with J07 otherwise it's a vaccination (which should go into the vaccination table)
	SUBSTRING(Atc_code, 1, 3) != 'J07'
/*	
	-- Filter on date > 01/01/2019
	AND YEAR(Voorschrijfdatum) >= 2019	
	
	-- not after 01/07/2024
	AND Voorschrijfdatum < '2024/07/01'
*/	

