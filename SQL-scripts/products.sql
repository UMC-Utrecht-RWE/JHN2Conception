CREATE OR REPLACE VIEW JHN_Conception.Conception.vw_PRODUCTS AS

/*
 * Since the JHN only has the ATC-code for 90% of rows I also only fill this table only with the ATC-codes. That
 * renders most of these columns also useless (because we need more specific produc info for that), so NULL.
 */ 

SELECT 
	CAST(ATKODE AS INT) AS medicinal_product_id
	, BST801T.ATOMSE AS medicinal_product_name
	, NULL AS unit_of_presentation_type
	, NULL AS unit_of_presentation_num
	, NULL AS administration_dose_form
	, NULL AS administration_route
	, NULL AS medicinal_product_atc_code
	, BST711T.ATCODE AS subst1_atc_code
	, NULL AS subst2_atc_code
	, NULL AS subst3_atc_code
	, NULL AS subst1_amount_per_form
	, NULL AS subst2_amount_per_form
	, NULL AS subst3_amount_per_form
	, NULL AS subst1_amount_unit
	, NULL AS subst2_amount_unit
	, NULL AS subst3_amount_unit
	, NULL AS subst1_concentration
	, NULL AS subst2_concentration
	, NULL AS subst3_concentration
	, NULL AS subst1_concentration_unit
	, NULL AS subst2_concentration_unit
	, NULL AS subst3_concentration_unit
	, NULL AS concentration_total_content
	, NULL AS concentration_total_content_unit
	, NULL AS medicinal_product_manufacturer
FROM JHN_Conception.ReferenceTables.BST004T
	
LEFT JOIN JHN_Conception.ReferenceTables.BST070T
	-- Join to BST070T to get to the GPKODE from the Z-index
	-- Take either the HPKODE from BST004T or from medicatie
	ON BST004T.HPKODE = BST070T.HPKODE
	
LEFT JOIN JHN_Conception.ReferenceTables.BST711T
	-- Join to BST711T to get to the ATCODE (ATC-code) from the Z-index
	-- Take either the GPKODE from BST070T or from medicatie	
	ON BST711T.GPKODE = BST070T.GPKODE  
	
LEFT JOIN JHN_Conception.ReferenceTables.BST801T
	-- Join to BST801T to get the name of the ATC-code from the Z-index
	ON BST801T.ATCODE = BST711T.ATCODE
	
UNION ALL

SELECT 
	ATCODE AS medicinal_product_id
	, ATOMSE AS medicinal_product_name
	, NULL AS unit_of_presentation_type
	, NULL AS unit_of_presentation_num
	, NULL AS administration_dose_form
	, NULL AS administration_route
	, NULL AS medicinal_product_atc_code
	, ATCODE AS subst1_atc_code
	, NULL AS subst2_atc_code
	, NULL AS subst3_atc_code
	, NULL AS subst1_amount_per_form
	, NULL AS subst2_amount_per_form
	, NULL AS subst3_amount_per_form
	, NULL AS subst1_amount_unit
	, NULL AS subst2_amount_unit
	, NULL AS subst3_amount_unit
	, NULL AS subst1_concentration
	, NULL AS subst2_concentration
	, NULL AS subst3_concentration
	, NULL AS subst1_concentration_unit
	, NULL AS subst2_concentration_unit
	, NULL AS subst3_concentration_unit
	, NULL AS concentration_total_content
	, NULL AS concentration_total_content_unit
	, NULL AS medicinal_product_manufacturer
FROM JHN_Conception.ReferenceTables.BST801T




