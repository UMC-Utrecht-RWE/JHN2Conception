CREATE OR REPLACE VIEW JHN_Conception.Conception.vw_INSTANCE AS

SELECT 
	table_name AS source_table_name
	, column_name AS source_column_name
	, CASE	WHEN table_name = 'patient' AND column_name IN ('Patient_id_umc', 'Geboorte_maand_jaar', 'Geboorte_maand_jaar', 'Uitschrijfreden', 'Geslacht', 'Import_id') THEN 'yes'
			WHEN table_name = 'contact' AND column_name IN ('Patient_id_umc', 'Id', 'Datum', 'Contactsoort_Omschr') THEN 'yes'
			WHEN table_name = 'episode' AND column_name IN ('Episode_status', 'Patient_id_umc', 'Stabiel_Episode_Id', 'Import_id', 'Begindatum', 'Einddatum', 'Icpc', 'Icpc_omschrijving', 'Omschrijving') THEN 'yes'
			WHEN table_name = 'journaalregel' AND column_name IN ('Patient_id_umc', 'Journaal_Datumtijd', 'Icpc', 'Soepcode', 'Tekst', 'Contact_id') THEN 'yes'
			WHEN table_name = 'bepaling' AND column_name IN ('Patient_id_umc', 'Datum', 'NHGnummer', 'Uitslag', 'Uitslag_tekst', 'Contact_id') THEN 'yes'
			WHEN table_name = 'patient_in_uit' AND column_name IN ('Patient_id_umc', 'Inschrijfdatum', 'Uitschrijfdatum', 'Uitschrijfreden') THEN 'yes'
			WHEN table_name = 'verrichting' AND column_name IN ('Patient_id_umc', 'Factuur_datum', 'Vektis_code', 'Nhg_code', 'Omschrijving', 'Contact_id') THEN 'yes'
			WHEN table_name = 'medicatie' AND column_name IN ('Patient_id_umc', 'Voorschrijfdatum', 'Afleverdatum', 'Atc_code', 'Omschrijving', 'Product_sterkte', 'Gebruiksvoorschrift', 'Contact_id', 'Hoeveelheid', 'Aflever_eenheid', 'Specialisme') THEN 'yes'
			ELSE 'no'
			END AS included_in_instance
	, '20240411' AS date_when_data_last_updated
	, '20190101' AS since_when_data_complete
	, '20240101' AS up_to_when_data_complete
	, CASE WHEN	CASE	WHEN table_name = 'patient' AND column_name IN ('Patient_id_umc', 'Geboorte_maand_jaar', 'Geboorte_maand_jaar', 'Uitschrijfreden', 'Geslacht', 'Import_id') THEN 'yes'
						WHEN table_name = 'contact' AND column_name IN ('Patient_id_umc', 'Id', 'Datum', 'Contactsoort_Omschr') THEN 'yes'
						WHEN table_name = 'episode' AND column_name IN ('Episode_status', 'Patient_id_umc', 'Stabiel_Episode_Id', 'Import_id', 'Begindatum', 'Einddatum', 'Icpc', 'Icpc_omschrijving', 'Omschrijving') THEN 'yes'
						WHEN table_name = 'journaalregel' AND column_name IN ('Patient_id_umc', 'Journaal_Datumtijd', 'Icpc', 'Soepcode', 'Tekst', 'Contact_id') THEN 'yes'
						WHEN table_name = 'bepaling' AND column_name IN ('Patient_id_umc', 'Datum', 'NHGnummer', 'Uitslag', 'Uitslag_tekst', 'Contact_id') THEN 'yes'
						WHEN table_name = 'patient_in_uit' AND column_name IN ('Patient_id_umc', 'Inschrijfdatum', 'Uitschrijfdatum', 'Uitschrijfreden') THEN 'yes'
						WHEN table_name = 'verrichting' AND column_name IN ('Patient_id_umc', 'Factuur_datum', 'Vektis_code', 'Nhg_code', 'Omschrijving', 'Contact_id') THEN 'yes'
						WHEN table_name = 'medicatie' AND column_name IN ('Patient_id_umc', 'Voorschrijfdatum', 'Afleverdatum', 'Atc_code', 'Omschrijving', 'Product_sterkte', 'Gebruiksvoorschrift', 'Contact_id', 'Hoeveelheid', 'Aflever_eenheid', 'Specialisme') THEN 'yes'
						ELSE 'no'
						END = 'yes' THEN 'no'
				END AS restriction_in_values
	, NULL AS list_of_values
	, NULL AS restriction_condition
FROM information_schema.columns

WHERE
	-- Alleen van het import schema
	table_schema = 'import'

ORDER BY
	table_name
	, ordinal_position
