DELIMITER !

DROP PROCEDURE IF EXISTS INCa_export!
CREATE PROCEDURE INCa_export (echantillon_id INT)
MAIN_BLOCK:BEGIN
	DECLARE patient_id INT;
	DECLARE prelevement_id INT;
	DECLARE patient_code, prelevement_code, echantillon_code VARCHAR(25);
	
	DECLARE item1 VARCHAR(3);
	DECLARE item2 VARCHAR(25);
	DECLARE	item3 DATETIME;
	DECLARE	item4 VARCHAR(3);
	DECLARE	item5 VARCHAR(1);  
	DECLARE	item6 DATETIME; 
	DECLARE	item76 VARCHAR(1);

	DECLARE	item7 VARCHAR(25);
	DECLARE	item8 DATETIME; 
	DECLARE	item9 VARCHAR(1);
	DECLARE	item10 VARCHAR(2);
	DECLARE	item11 VARCHAR(1);
	DECLARE	item12 VARCHAR(1);

	DECLARE item13 VARCHAR(15);
	DECLARE item14 VARCHAR(15);
	DECLARE item15 DATETIME;
	DECLARE item16 VARCHAR(1);
	DECLARE item17 VARCHAR(10);
	DECLARE item18, item20 VARCHAR(5);
	DECLARE item19, item21 VARCHAR(10);
	DECLARE item22 INT(1);
	DECLARE item23 VARCHAR(1);
	DECLARE item24 VARCHAR(10);
	DECLARE item25 VARCHAR(1);
	DECLARE item26 VARCHAR(1);
	
	DECLARE isTumoral BOOL;
	DECLARE item27, item39 VARCHAR(1);
	DECLARE item28, item40 VARCHAR(25);
	DECLARE item29, item41 VARCHAR(2);
	DECLARE item30, item42 VARCHAR(1);
	DECLARE item31, item43 VARCHAR(5);
	DECLARE item32, item44 VARCHAR(1);
	DECLARE item33, item45 VARCHAR(3);
	DECLARE item34, item46 VARCHAR(25);
	DECLARE item35 VARCHAR(3);
	DECLARE item36, item37, item38, item47, item48, item49 VARCHAR(3);
	
	DECLARE item50, item51, item52, item53 VARCHAR(3);
	
	DECLARE item54, item55, item56 VARCHAR(3);
	DECLARE item57 VARCHAR(25);
	DECLARE item58 VARCHAR(3);
	DECLARE item59 VARCHAR(25);
	DECLARE item60 VARCHAR(3);
	DECLARE item61 VARCHAR(2000);
	DECLARE item62 VARCHAR(3);
	DECLARE item63 VARCHAR(3);
	DECLARE item64 VARCHAR(2000);
	
	DECLARE item66, item67, item68 VARCHAR(50);	

	SET prelevement_id = (SELECT ECHANTILLON.PRELEVEMENT_ID FROM ECHANTILLON WHERE ECHAN_ID = echantillon_id);
	SET patient_id = (SELECT CONSENTIR.PATIENT_ID FROM CONSENTIR WHERE CONSENTIR.PRELEVEMENT_ID = prelevement_id);
	
	/*Code patient OBLIGATOIRE */
	SET patient_code = (SELECT PATIENT.PATIENT_NIP FROM PATIENT WHERE PATIENT.PATIENT_ID = patient_id);
	IF patient_code = '' OR patient_code IS NULL THEN 
	SELECT 'WARNING! Code patient manquant' AS 'WARNING';
		LEAVE MAIN_BLOCK;
	END IF;
	

	/*Code prelevement OBLIGATOIRE */
	SET prelevement_code = (SELECT PRELEVEMENT.PRELEVEMENT_CODE FROM PRELEVEMENT WHERE PRELEVEMENT.PRELEVEMENT_ID = prelevement_id);
	IF prelevement_code IS NULL OR prelevement_code = '' THEN 
	SELECT 'WARNING! Code prelevement manquant' AS 'WARNING';
		LEAVE MAIN_BLOCK;
	END IF;

	/*Code echantillon OBLIGATOIRE */
	SET echantillon_code = (SELECT ECHANTILLON.ECHAN_CODE FROM ECHANTILLON WHERE ECHANTILLON.ECHAN_ID = echantillon_id);
	IF echantillon_code IS NULL OR echantillon_code = '' THEN 
	SELECT 'WARNING! Code prelevement manquant' AS 'WARNING';
		LEAVE MAIN_BLOCK;
	END IF;

	/*********************************************************************************************************/
	/*************************************** INFORMATIONS PATIENT ********************************************/
	/*********************************************************************************************************/
		
	/*Item 1 Lieu prise en charge du patient: FINESS OBLIGATOIRE*/
	#SET item1_title = 'FINESS';
	#SET item1 = (SELECT SUBSTRING_INDEX(ETABLISSEMENT.ETAB_NOM,':',1) FROM ETABLISSEMENT, SERVICE, PRELEVEMENT 
	#		WHERE PRELEVEMENT.SITE_PRELEVEUR = SERVICE.SERVICE_ID AND ETABLISSEMENT.ETAB_ID = SERVICE.ETAB_ID 
	#		AND PRELEVEMENT.PRELEVEMENT_ID = prelevement_id);
	SET item1 = (SELECT TRIM(LEFT(ETABLISSEMENT.ETAB_NOM,LOCATE(':',ETABLISSEMENT.ETAB_NOM)-1)) FROM ETABLISSEMENT, SERVICE, PRELEVEMENT 
			WHERE PRELEVEMENT.SITE_PRELEVEUR = SERVICE.SERVICE_ID AND ETABLISSEMENT.ETAB_ID = SERVICE.ETAB_ID 
			AND PRELEVEMENT.PRELEVEMENT_ID = prelevement_id);
	IF item1 = '' OR item1 IS NULL THEN 
	SELECT CONCAT('WARNING! FINESS manquant pour le patient ', patient_code) AS 'WARNING';
		LEAVE MAIN_BLOCK;
	END IF;
	
	/*Item 2 Code patient OBLIGATOIRE */
	SET item2 = patient_code;
	
	
	/*Item 3 Date de naissance du patient OBLIGATOIRE */
	SET item3 = (SELECT PATIENT.PATIENT_DATE_NAISS FROM PATIENT WHERE PATIENT.PATIENT_ID = patient_id);
	IF item3 = '0000-00-00 00:00:00' OR item3 = '' OR item3 IS NULL THEN 
		SELECT CONCAT('WARNING! Date de naissance manquante pour le patient ', patient_code) AS 'WARNING';
		LEAVE MAIN_BLOCK;
	END IF;

	/*Item 4 Sexe du patient OBLIGATOIRE */
	SET item4 = (SELECT PATIENT.PATIENT_SEXE FROM PATIENT WHERE PATIENT.PATIENT_ID = patient_id);
	IF item4 NOT REGEXP '1|2|0|M|F|I' THEN 
		SET item4 = 'I';
	END IF;

	/*Item 5 Etat du patient */
	SET item5 = (SELECT TRIM(LEFT(ITEM_ANNOTATION_THESAURUS.NOM,LOCATE(':',ITEM_ANNOTATION_THESAURUS.NOM)-1)) FROM ITEM_ANNOTATION_THESAURUS, ANNOTATION_THES, CHAMP_ANNOTATION 
			WHERE ANNOTATION_THES.OBJET_ID=patient_id AND CHAMP_ANNOTATION.NOM like '005 : Etat du patient' 
			AND ITEM_ANNOTATION_THESAURUS.ID=ANNOTATION_THES.VALEUR AND CHAMP_ANNOTATION.ID=ANNOTATION_THES.CHAMP_ANNOTATION_ID);
	IF item5 IS NULL OR item5 NOT REGEXP 'V|D|I' THEN 
		SET item5 = '';
	END IF;
	
	/*Item 6 Date de l'etat du patient */
	SET item6 = (SELECT ANNOTATION_DATE.VALEUR FROM ANNOTATION_DATE, CHAMP_ANNOTATION WHERE ANNOTATION_DATE.OBJET_ID=patient_id 
			AND CHAMP_ANNOTATION.NOM like '006 : Date de l%tat' AND CHAMP_ANNOTATION.ID=ANNOTATION_DATE.CHAMP_ANNOTATION_ID);
	#IF item6 = '0000-00-00 00:00:00' OR item6 = '' THEN 
	#	SET item6 = NULL;
	#ELSE SET item6 = DATE_FORMAT(item6,'%d/%m/%Y');
	#END IF;
	#SET item6 = DATE_FORMAT(item6,'%d/%m/%Y');

	/*Item 76 Cause de décès du patient */
	SET item76 = (SELECT TRIM(LEFT(ITEM_ANNOTATION_THESAURUS.NOM,LOCATE(':',ITEM_ANNOTATION_THESAURUS.NOM)-1)) FROM ITEM_ANNOTATION_THESAURUS, ANNOTATION_THES, CHAMP_ANNOTATION 
			WHERE ANNOTATION_THES.OBJET_ID=patient_id AND CHAMP_ANNOTATION.NOM like '076 : Cause %' AND ITEM_ANNOTATION_THESAURUS.ID=ANNOTATION_THES.VALEUR AND CHAMP_ANNOTATION.ID=ANNOTATION_THES.CHAMP_ANNOTATION_ID);
	IF item76 IS NULL OR item76 NOT REGEXP '[1-9]' THEN 
		SET item76 = '';
	END IF;

	/*********************************************************************************************************/
	/*************************************** INFORMATIONS MALADIE ********************************************/
	/*********************************************************************************************************/
	
	/*Item 7 Diagnostic principal de la tumeur initiale OBLIGATOIRE*/
	SET item7 = (SELECT TRIM(LEFT(ANNOTATION_ALPHANUM.VALEUR,LOCATE(':',ANNOTATION_ALPHANUM.VALEUR)-1)) FROM ANNOTATION_ALPHANUM, CHAMP_ANNOTATION 
			WHERE ANNOTATION_ALPHANUM.OBJET_ID=prelevement_id AND CHAMP_ANNOTATION.NOM like '007 : Diagnostic principal' AND CHAMP_ANNOTATION.ID=ANNOTATION_ALPHANUM.CHAMP_ANNOTATION_ID);
	IF item7 IS NULL THEN 
		SET item7 = '';
	END IF;

	/*Item 8 Date du diagnostic */
	SET item8 = (SELECT ANNOTATION_DATE.VALEUR FROM ANNOTATION_DATE, CHAMP_ANNOTATION WHERE ANNOTATION_DATE.OBJET_ID=prelevement_id 
			AND CHAMP_ANNOTATION.NOM like '008 : Date %' AND CHAMP_ANNOTATION.ID=ANNOTATION_DATE.CHAMP_ANNOTATION_ID);
	IF item8 > CURDATE() THEN
		SELECT CONCAT('WARNING! Date diagnostic supérieure à date du jour pour le prelevement ', prelevement_code) AS 'WARNING';
		LEAVE MAIN_BLOCK;
	END IF;

	/*Item 9 Version cTNM */
	SET item9 = (SELECT ITEM_ANNOTATION_THESAURUS.NOM FROM ITEM_ANNOTATION_THESAURUS, ANNOTATION_THES, CHAMP_ANNOTATION 
			WHERE ANNOTATION_THES.OBJET_ID=prelevement_id AND CHAMP_ANNOTATION.NOM like '009 : Version cTNM' AND ITEM_ANNOTATION_THESAURUS.ID=ANNOTATION_THES.VALEUR AND CHAMP_ANNOTATION.ID=ANNOTATION_THES.CHAMP_ANNOTATION_ID);
	IF item9 IS NULL OR item9 NOT REGEXP '[4-6]|X' THEN 
		SET item9 = '';
	END IF;

	/*Item 10 Taille de la tumeur */
	SET item10 = (SELECT ITEM_ANNOTATION_THESAURUS.NOM FROM ITEM_ANNOTATION_THESAURUS, ANNOTATION_THES, CHAMP_ANNOTATION 
			WHERE ANNOTATION_THES.OBJET_ID=prelevement_id AND CHAMP_ANNOTATION.NOM like '010 : Taille de la tumeur%' AND ITEM_ANNOTATION_THESAURUS.ID=ANNOTATION_THES.VALEUR AND CHAMP_ANNOTATION.ID=ANNOTATION_THES.CHAMP_ANNOTATION_ID);
	IF item10 IS NULL OR item10 NOT REGEXP '[0-4]|is|X' THEN 
		SET item10 = '';
	END IF;

	/*Item 11 Envahissement ganglionnaire */
	SET item11 = (SELECT ITEM_ANNOTATION_THESAURUS.NOM FROM ITEM_ANNOTATION_THESAURUS, ANNOTATION_THES, CHAMP_ANNOTATION 
			WHERE ANNOTATION_THES.OBJET_ID=prelevement_id AND CHAMP_ANNOTATION.NOM like '011 : Envahissement%' AND ITEM_ANNOTATION_THESAURUS.ID=ANNOTATION_THES.VALEUR AND CHAMP_ANNOTATION.ID=ANNOTATION_THES.CHAMP_ANNOTATION_ID);
	IF item11 IS NULL OR item11 NOT REGEXP '[0-3]|X' THEN 
		SET item11 = '';
	END IF;

	/*Item 12 Extension métastatique */
	SET item12 = (SELECT ITEM_ANNOTATION_THESAURUS.NOM FROM ITEM_ANNOTATION_THESAURUS, ANNOTATION_THES, CHAMP_ANNOTATION 
			WHERE ANNOTATION_THES.OBJET_ID=prelevement_id AND CHAMP_ANNOTATION.NOM like '012 : Extension%' AND ITEM_ANNOTATION_THESAURUS.ID=ANNOTATION_THES.VALEUR AND CHAMP_ANNOTATION.ID=ANNOTATION_THES.CHAMP_ANNOTATION_ID);
	IF item12 IS NULL OR item12 NOT REGEXP '0|1|X' THEN 
		SET item12 = '';
	END IF;
	
	/*********************************************************************************************************/
	/*************************************** INFORMATIONS PRELEVELEMENT ********************************************/
	/*********************************************************************************************************/
	
	/*Item 13 Centre se stockage OBLIGATOIRE*/
	BEGIN
		DECLARE site_stockage VARCHAR(50);
		SET site_stockage = (SELECT ETABLISSEMENT.ETAB_NOM FROM ETABLISSEMENT, SERVICE, ECHANTILLON, COLLABORATEUR 
			WHERE ECHANTILLON.ECHAN_ID=echantillon_id AND ECHANTILLON.COLLAB_STOCK=COLLABORATEUR.COLLAB_ID AND COLLABORATEUR.SERVICE_ID=SERVICE.SERVICE_ID 
			AND SERVICE.ETAB_ID=ETABLISSEMENT.ETAB_ID);
	
		IF site_stockage like '%BORDEAUX%' THEN
			IF site_stockage like '%CHU%' THEN
				SET item13 = '1TGSOCHUBDX';
			ELSEIF site_stockage like '%CLC%' THEN
				SET item13 = '2TGSOCLCBDX';
			END IF;
		ELSEIF site_stockage like '%LIMOGES%' THEN
			IF site_stockage like '%CHU%' THEN
				SET item13 = '3TGSOCHULIM';
			END IF;
		ELSEIF site_stockage like '%MONTPELLIER%' THEN
			IF site_stockage like '%CHU%' THEN
				SET item13 = '4TGSOCHUMPL';
			ELSEIF site_stockage like '%CLC%' THEN
				SET item13 = '5TGSOCLCMPL';
			END IF;
		ELSEIF site_stockage like '%NIMES%' THEN
			IF site_stockage like '%CHU%' THEN
				SET item13 = '6TGSOCHUNIM';
			END IF;
		ELSEIF site_stockage like '%TOULOUSE%' THEN
			IF site_stockage like '%CHU%' THEN
				SET item13 = '7TGSOCHUTLS';
			ELSEIF site_stockage like '%CLC%' THEN
				SET item13 = '8TGSOCLCTLS';
			END IF;	
		END IF;

		IF item13 IS NULL THEN	
			SELECT CONCAT('WARNING! Creation du code pour le centre de stockage impossible pour echantillon ', echantillon_code) AS 'WARNING';
			LEAVE MAIN_BLOCK;
		END IF;
	END;
	
	/*Item 14 Code prelevement OBLIGATOIRE */
	SET item14 = prelevement_code;
	/*Item 15 Date prelevement OBLIGATOIRE */ 
	/*Item 16 Mode de prelevement OBLIGATOIRE */
	SELECT PRELEVEMENT.PRELEV_DATE, TRIM(LEFT(PRELE_MODE.PRELE_MODE,LOCATE(':',PRELE_MODE.PRELE_MODE)-1)) 
		INTO item15, item16 FROM PRELEVEMENT, PRELE_MODE WHERE PRELEVEMENT.PRELEVEMENT_ID = prelevement_id 
		AND PRELEVEMENT.PRELE_MODE_ID=PRELE_MODE.PRELE_MODE_ID;
	IF item16 IS NULL OR item16 = ''  THEN 
		SELECT CONCAT('WARNING! Mode de prelevement manquant pour le prelevement ', prelevement_code) AS 'WARNING';
		LEAVE MAIN_BLOCK;
	END IF;
	
	/*Validation sur les dates*
	IF item5 <> '' AND item5 <> item15 THEN
		SELECT CONCAT('WARNING! La date de prélèvement diffère de la date d\'état du patient pour le ', prelevement_code) AS 'WARNING';
		LEAVE MAIN_BLOCK;
	END IF;*/
	
	IF item15 = '0000-00-00 00:00:00' OR item15 IS NULL OR item15 = ''  THEN 
		SELECT CONCAT('WARNING! Date de prelevement manquante pour le prelevement ', prelevement_code) AS 'WARNING';
		LEAVE MAIN_BLOCK;
	END IF;

	/*Item17 Classification utilisée OBLIGATOIRE*/
	BEGIN
		DECLARE description VARCHAR(250);
		SET description = (SELECT BANQUE.BANQUE_DESC FROM BANQUE, PRELEVEMENT WHERE PRELEVEMENT.PRELEVEMENT_ID=prelevement_id AND PRELEVEMENT.BANQUE_ID=BANQUE.BANQUE_ID);
		SET item17 = '';
		IF description like '%ADICAP%' THEN
			SET item17 = 'A';
		END IF;	
		IF description like '%CIMO%' THEN
			SET item17 = CONCAT(item17,'C');
		END IF;
		IF item17 = '' THEN 
			SELECT CONCAT('WARNING! Aucune classification specifiee pour la banque ', (SELECT BANQUE.BANQUE_NOM FROM BANQUE, PRELEVEMENT WHERE PRELEVEMENT.PRELEVEMENT_ID=prelevement_id AND PRELEVEMENT.BANQUE_ID=BANQUE.BANQUE_ID)) AS 'WARNING';
			LEAVE MAIN_BLOCK;
		END IF;
	END;

	/*Item18 et item20 Code organe, Item19 et item21 Type lesionnel histopathologique OBLIGATOIRE */
	/*car les champ texte ds tumo sont pas nulls*/
	SET item18 = '', item19 = '', item20 = '', item21 = ''; 
	
	IF item17 like '%C%' THEN
		SET item18 = (SELECT ORGANE_CODE FROM ORGANE, ANNO_ECHA, ECHANTILLON WHERE ANNO_ECHA.ANNO_ECHA_ID=ECHANTILLON.ANNO_ECHA_ID AND ECHANTILLON.ECHAN_ID=echantillon_id 
		AND ANNO_ECHA.ORGANE_ID=ORGANE.ORGANE_ID);
		SET item19 = (SELECT CODE_ADICAP_1 FROM ANNO_ECHA, ECHANTILLON WHERE ANNO_ECHA.ANNO_ECHA_ID=ECHANTILLON.ANNO_ECHA_ID AND ECHANTILLON.ECHAN_ID=echantillon_id);
	END IF;
	IF item17 like '%A%' THEN
		SET item20 = (SELECT ORGANE_CODE FROM ORGANE, ANNO_ECHA, ECHANTILLON WHERE ANNO_ECHA.ANNO_ECHA_ID=ECHANTILLON.ANNO_ECHA_ID AND ECHANTILLON.ECHAN_ID=echantillon_id 
		AND ANNO_ECHA.ORGANE_ID=ORGANE.ORGANE_ID);
		SET item21 = (SELECT SUBSTRING(CODE_ADICAP_1,5,3) FROM ANNO_ECHA, ECHANTILLON WHERE ANNO_ECHA.ANNO_ECHA_ID=ECHANTILLON.ANNO_ECHA_ID AND ECHANTILLON.ECHAN_ID=echantillon_id);
	END IF;
	
	IF item18 IS NULL AND item20 is NULL THEN
		SELECT CONCAT('WARNING! Aucun code organe specifie pour echantillon ', echantillon_code) AS 'WARNING';
		LEAVE MAIN_BLOCK;
	END IF;
	IF item19 = '' AND item21 = '' THEN
		SELECT CONCAT('WARNING! Aucun type lesionnel specifie pour echantillon ', echantillon_code) AS 'WARNING';
		LEAVE MAIN_BLOCK;
	END IF;

	/*Item22 Type d'evenement OBLIGATOIRE*/
	SET item22 = (SELECT TRIM(LEFT(ITEM_ANNOTATION_THESAURUS.NOM,LOCATE(':',ITEM_ANNOTATION_THESAURUS.NOM)-1)) FROM ITEM_ANNOTATION_THESAURUS, ANNOTATION_THES, CHAMP_ANNOTATION 
			WHERE ANNOTATION_THES.OBJET_ID=prelevement_id AND CHAMP_ANNOTATION.NOM like 'TYPE_EVENT' AND ITEM_ANNOTATION_THESAURUS.ID=ANNOTATION_THES.VALEUR 
			AND CHAMP_ANNOTATION.ID=ANNOTATION_THES.CHAMP_ANNOTATION_ID);
	IF item22 IS NULL THEN 
		SELECT CONCAT('WARNING! Aucun type évenement specifie pour le prelevement ', prelevement_code) AS 'WARNING';
		LEAVE MAIN_BLOCK;
	END IF;

	/*Item23 Version du pTNM*/
	SET item23 = (SELECT ITEM_ANNOTATION_THESAURUS.NOM FROM ITEM_ANNOTATION_THESAURUS, ANNOTATION_THES, CHAMP_ANNOTATION 
			WHERE ANNOTATION_THES.OBJET_ID=prelevement_id AND CHAMP_ANNOTATION.NOM like '023 : Version pTNM%' AND ITEM_ANNOTATION_THESAURUS.ID=ANNOTATION_THES.VALEUR AND CHAMP_ANNOTATION.ID=ANNOTATION_THES.CHAMP_ANNOTATION_ID);
	IF item23 IS NULL OR item12 NOT REGEXP '[4-6]|X' THEN 
		SET item23 = '';
	END IF;
	
	/*Item24 pT*/
	SET item24 = (SELECT ITEM_ANNOTATION_THESAURUS.NOM FROM ITEM_ANNOTATION_THESAURUS, ANNOTATION_THES, CHAMP_ANNOTATION 
			WHERE ANNOTATION_THES.OBJET_ID=prelevement_id AND CHAMP_ANNOTATION.NOM like '024 : Taille de la tumeur%' AND ITEM_ANNOTATION_THESAURUS.ID=ANNOTATION_THES.VALEUR AND CHAMP_ANNOTATION.ID=ANNOTATION_THES.CHAMP_ANNOTATION_ID);
	IF item24 REGEXP '[0-9][a-z]*' THEN 
		SET item24 = SUBSTRING(item24,1,1);
	ELSEIF item24 REGEXP 'is(.*)' THEN 
		SET item24 = 'is';
	ELSEIF item24 IS NULL THEN
		SET item24 = '';
	END IF;

	/*Item25 Presence/absence metastases ganglionnaires pN*/
	SET item25 = (SELECT ITEM_ANNOTATION_THESAURUS.NOM FROM ITEM_ANNOTATION_THESAURUS, ANNOTATION_THES, CHAMP_ANNOTATION 
			WHERE ANNOTATION_THES.OBJET_ID=prelevement_id AND CHAMP_ANNOTATION.NOM like '025 : Envahissement ganglionnaire : pN%' AND ITEM_ANNOTATION_THESAURUS.ID=ANNOTATION_THES.VALEUR AND CHAMP_ANNOTATION.ID=ANNOTATION_THES.CHAMP_ANNOTATION_ID);
	IF item25 IS NULL THEN
		SET item25 = '';
	ELSE SET item25 = SUBSTRING(item25,1,1);
	END IF;
	
	/*Item26 Presence/absence metastases à distance pM*/
	SET item26 = (SELECT ITEM_ANNOTATION_THESAURUS.NOM FROM ITEM_ANNOTATION_THESAURUS, ANNOTATION_THES, CHAMP_ANNOTATION 
			WHERE ANNOTATION_THES.OBJET_ID=prelevement_id AND CHAMP_ANNOTATION.NOM like '026 : Extension m%tastatique : pM%' AND ITEM_ANNOTATION_THESAURUS.ID=ANNOTATION_THES.VALEUR AND CHAMP_ANNOTATION.ID=ANNOTATION_THES.CHAMP_ANNOTATION_ID);
	IF item26 IS NULL THEN
		SET item26 = '';
	END IF;
	

	/*********************************************************************************************************/
	/*************************************** INFORMATIONS ECHANTILLON ********************************************/
	/*********************************************************************************************************/
	
	/*Item27 et Item39 echantillon tumoral ou non tumoral OBLIGATOIRE */
	/*Item29 et Item41 Type d'echantillon OBLIGATOIRE*/
	BEGIN
		DECLARE type_echantillon VARCHAR(50);
		DECLARE type_lettre VARCHAR(1);
		SET type_echantillon = (SELECT ECHAN_TYPE FROM ECHAN_TYPE, ECHANTILLON WHERE ECHANTILLON.ECHAN_ID=echantillon_id AND ECHANTILLON.ECHAN_TYPE_ID=ECHAN_TYPE.ECHAN_TYPE_ID);
		IF type_echantillon IS NOT NULL THEN
			IF type_echantillon REGEXP '(T|C)T :.*' OR (type_echantillon LIKE '%TUMORAL%' AND type_echantillon NOT LIKE '% NON %') THEN
				SET item27 = 'O', item39 = 'N', isTumoral = TRUE;
			ELSE SET item27 = 'N', item39 = 'O', isTumoral = FALSE;
			END IF;
			SET type_lettre = SUBSTRING(TRIM(LEFT(type_echantillon,LOCATE(':',type_echantillon)-1)),1,1);
			IF type_lettre IS NOT NULL THEN
				IF isTumoral THEN
					SET item29 = type_lettre, item41 = '';
				ELSE
					SET item29 = '', item41 = type_lettre;
				END IF;
			END IF;
		ELSE 
			SELECT CONCAT('WARNING! Type tumoral/non tumoral non specifié pour echantillon ', echantillon_code) AS 'WARNING';
			LEAVE MAIN_BLOCK;
		END IF;
	END;

	/*Item28 et Item40 Mode de conservation */
	BEGIN
		DECLARE conteneur_temp VARCHAR(25);
		DECLARE conteneur_id INT(10);
		SET conteneur_id = (SELECT LEFT(ECHANTILLON.ECHAN_ADRP_STOCK,LOCATE('.',ECHANTILLON.ECHAN_ADRP_STOCK)-1) FROM ECHANTILLON WHERE ECHANTILLON.ECHAN_ID=echantillon_id);
		SET conteneur_temp = (SELECT CONTENEUR.CONTENEUR_TEMP FROM CONTENEUR WHERE CONTENEUR.CONTENEUR_ID=conteneur_id);
		IF conteneur_temp IS NOT NULL THEN
			IF conteneur_temp like '%-196%' THEN
				SET conteneur_temp = 'azote';
			ELSEIF conteneur_temp REGEXP '^20.*' THEN
				SET conteneur_temp = 'bloc de paraffine'; 
			END IF;
			IF isTumoral THEN
				SET item28 = conteneur_temp, item40 = '';
			ELSE SET item28 = '', item40 = conteneur_temp;
			END IF;
		ELSE 
			SET item28 = '', item40 ='';
		END IF;
	END;

	/*Item30 et item42 Mode de preparation*/
	BEGIN
		DECLARE mode VARCHAR(1);
		SET mode = (SELECT TRIM(LEFT(ITEM_ANNOTATION_THESAURUS.NOM,LOCATE(':',ITEM_ANNOTATION_THESAURUS.NOM)-1)) FROM ITEM_ANNOTATION_THESAURUS, ANNOTATION_THES, CHAMP_ANNOTATION 
			WHERE ANNOTATION_THES.OBJET_ID=echantillon_id AND CHAMP_ANNOTATION.NOM like '030 : Mode de pr%paration%' AND ITEM_ANNOTATION_THESAURUS.ID=ANNOTATION_THES.VALEUR AND CHAMP_ANNOTATION.ID=ANNOTATION_THES.CHAMP_ANNOTATION_ID);
		IF mode IS NOT NULL AND mode REGEXP '1|2|3|9' THEN
			IF isTumoral THEN
				SET item30 = mode, item42 = '';
			ELSE
				SET item30 = '', item42 = mode;
			END IF;
		ELSE SET item30 = '', item42 = '';
		END IF;
	END;

	/*Item31 et item43 Délai de congélation*/
	BEGIN
		DECLARE delai INT(5);
		SET delai = (SELECT ECHANTILLON.ECHAN_DELAI_CGL FROM ECHANTILLON WHERE ECHANTILLON.ECHAN_ID=echantillon_id);
		IF delai IS NULL OR delai < 1 THEN
			SET delai = '9';
			ELSEIF delai < 30 THEN SET delai = '1';
			ELSEIF delai >= 30 THEN SET delai = '2';
		END IF;
		IF isTumoral THEN
			SET item31 = delai, item43 = '';
		ELSE 
			SET item31 = '', item43 = delai;
		END IF;
	END;

	/*Item32 et item44 Controles sur tissu*/
	SET item32 = '';
	#SET item32 = ( ECHANTILLON WHERE ECHAN_ID=echantillon_id);
	SET item44 = item32;

	/*Item33, item34 et item45, item46 Quantite de l'échantillon et unité*/
	BEGIN 
		DECLARE quantite INT(3);
		DECLARE unite VARCHAR(25);
		SELECT ECHANTILLON.ECHAN_QUANTITE_INIT, QUANTITE_UNITE.UNITE INTO quantite, unite FROM ECHANTILLON, QUANTITE_UNITE 
			WHERE ECHANTILLON.ECHAN_ID=echantillon_id AND QUANTITE_UNITE.UNITE_ID=ECHANTILLON.UNITE_ID;
		IF quantite IS NOT NULL AND quantite > 0 THEN
			IF isTumoral THEN
				SET item33 = quantite, item45 = '';
			ELSE
				SET item33 = '', item45 = quantite;
			END IF;
		ELSE SET item33 = '', item45 = '';
		END IF;
		IF unite IS NOT NULL THEN 
			IF isTumoral THEN
				SET item34 = unite, item46 = '';
			ELSE
				SET item34 = '', item46 = unite;
			END IF;
		ELSE
			SET item34 = '', item46 = '';
		END IF;
	END;

	/*Item35 Pourcentage cellules tumorales*/
	BEGIN
		DECLARE pourcentage INT(3);
		SET pourcentage = (SELECT ANNOTATION_NUM.VALEUR FROM ANNOTATION_NUM, CHAMP_ANNOTATION WHERE ANNOTATION_NUM.OBJET_ID=echantillon_id 
			AND CHAMP_ANNOTATION.NOM like '035 : Pourcentage de cellules tumorales%' AND CHAMP_ANNOTATION.ID=ANNOTATION_NUM.CHAMP_ANNOTATION_ID);
		IF pourcentage IS NULL OR pourcentage NOT BETWEEN 0 AND 100 THEN
			SET item35 = '';
		ELSE SET item35 = pourcentage;
		END IF;
	END;

	/*Item36, item37, item38 et item47, item48, item49 respectivement ADN, ARN, proteine dérivés*/
	BEGIN
		DECLARE prod_type VARCHAR(10);
		DECLARE done INT DEFAULT 0;
		DECLARE cur CURSOR FOR SELECT DISTINCT(PROD_TYPE.PROD_TYPE) FROM PROD_DERIVE, PROD_TYPE WHERE PROD_DERIVE.ECHAN_ID=echantillon_id AND PROD_TYPE.PROD_TYPE_ID=PROD_DERIVE.PROD_TYPE_ID;
		DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1; 
		
		IF isTumoral THEN
			SET item36 = 'non', item37 = 'non', item38 = 'non', item47 = '', item48 = '', item49 = '';
		ELSE
			SET item36 = '', item37 = '', item38 = '', item47 = 'non', item48 = 'non', item49 = 'non';
		END IF;

		OPEN cur;

		type_loop : LOOP
			FETCH cur INTO prod_type;
			IF prod_type REGEXP '(ADN)|(DNA)' THEN
				IF isTumoral THEN 
					SET item36 = 'oui';
				ELSE 
					SET item47 = 'oui';
				END IF;
			ELSEIF prod_type REGEXP '(ARN)|(RNA)' THEN
				IF isTumoral THEN 
					SET item37 = 'oui';
				ELSE 
					SET item48 = 'oui';
				END IF;
			ELSEIF prod_type like 'PROTEIN%' THEN
				IF isTumoral THEN 
					SET item38 = 'oui';
				ELSE 
					SET item49 = 'oui';
				END IF;
			END IF;	
			IF done=1 THEN
				LEAVE type_loop;
			END IF;
		END LOOP;
	END;

	
	/*********************************************************************************************************/
	/*************************************** INFORMATIONS RESSOURCES BIOLOGIQUES ASSOCIEES ******************/
	/*********************************************************************************************************/
	
	/*Item50, Item51, Item52, Item53 respectivement serum, plasma, liquides, ADN*/
	BEGIN
		DECLARE consent_type_id, prele_id INT;
		DECLARE type_event, echan_type, consent_type VARCHAR(25);
		DECLARE done INT DEFAULT 0;
		DECLARE cur CURSOR FOR SELECT PRELEVEMENT.PRELEVEMENT_ID, CONSENTIR.CONSENT_TYPE_ID FROM PRELEVEMENT, CONSENTIR WHERE PRELEVEMENT.PRELEV_DATE = item15 AND CONSENTIR.PATIENT_ID=patient_id AND CONSENTIR.PRELEVEMENT_ID=PRELEVEMENT.PRELEVEMENT_ID AND PRELEVEMENT.PRELEVEMENT_ID <> prelevement_id; 
		DECLARE cur2 CURSOR FOR SELECT DISTINCT(ECHAN_TYPE.ECHAN_TYPE) FROM ECHAN_TYPE, ECHANTILLON WHERE ECHANTILLON.PRELEVEMENT_ID=prele_id AND ECHANTILLON.ECHAN_TYPE_ID=ECHAN_TYPE.ECHAN_TYPE_ID;
		DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1; 
		
		SET item50 = 'non', item51 = 'non', item52 = 'non', item53 = 'non';
		
		OPEN cur;
	
		prele_loop : LOOP
			FETCH cur INTO prele_id, consent_type_id;

			IF done=1 THEN
				LEAVE prele_loop;
			END IF;
			
			SET type_event = (SELECT TRIM(LEFT(ITEM_ANNOTATION_THESAURUS.NOM,LOCATE(':',ITEM_ANNOTATION_THESAURUS.NOM)-1)) FROM ITEM_ANNOTATION_THESAURUS, ANNOTATION_THES, CHAMP_ANNOTATION 
				WHERE ANNOTATION_THES.OBJET_ID=prele_id AND CHAMP_ANNOTATION.NOM like 'TYPE_EVENT' AND ITEM_ANNOTATION_THESAURUS.ID=ANNOTATION_THES.VALEUR 
				AND CHAMP_ANNOTATION.ID=ANNOTATION_THES.CHAMP_ANNOTATION_ID);
			
			IF type_event = item22 THEN 
				
				OPEN cur2;
	
				type_loop : LOOP
					FETCH cur2 INTO echan_type;
					
					IF echan_type like '%SERUM%' THEN
						SET item50 = 'oui'; 	
					ELSEIF echan_type like '%PLASMA%' THEN
						SET item51 = 'oui';
					ELSEIF echan_type like '%Liquid%' THEN
						SET item52 = 'oui';
					ELSEIF echan_type REGEXP '(ADN)|(DNA)' THEN
					 	IF consent_type_id IS NOT NULL and consent_type_id > 0 THEN
							SET consent_type = (SELECT CONSENT_TYPE.CONSENT_TYPE FROM CONSENT_TYPE WHERE CONSENT_TYPE.CONSENT_TYPE_ID=consent_type_id);
							IF consent_type REGEXP '.*(GÉNÉTIQUE)|(RECHERCHE).*' THEN
								SET item53 = 'oui';
							END IF;
						END IF; 
					END IF;
			
					IF done=1 THEN
						LEAVE type_loop;
					END IF;
				END LOOP;
				CLOSE cur2;	
				
				SET done = 0;	
			END IF;
			
		END LOOP;
		CLOSE cur;
	END;
	
	
	/*********************************************************************************************************/
	/*************************************** RENSEIGNEMENT COMPLEMENTAIRES *********************************/
	/*********************************************************************************************************/
	
	/*Item54 Compte rendu anapath interrogeable*/
	BEGIN
		DECLARE bool INT(1);
		SET bool = (SELECT ANNOTATION_BOOL.VALEUR FROM ANNOTATION_BOOL, CHAMP_ANNOTATION WHERE ANNOTATION_BOOL.OBJET_ID=prelevement_id 
			AND CHAMP_ANNOTATION.NOM like '054 : CR anatomopathologique%' AND CHAMP_ANNOTATION.ID=ANNOTATION_BOOL.CHAMP_ANNOTATION_ID);
		IF bool = 1 THEN
			SET item54 = 'oui';
		ELSE
			SET item54 = 'non';
		END IF;
	END;
	
	/*Item55 Donnees cliniques disponibles dans une base*/
	BEGIN
		DECLARE bool INT(1);
		SET bool = (SELECT ANNOTATION_BOOL.VALEUR FROM ANNOTATION_BOOL, CHAMP_ANNOTATION WHERE ANNOTATION_BOOL.OBJET_ID=prelevement_id 
			AND CHAMP_ANNOTATION.NOM like '055 : Donn%' AND CHAMP_ANNOTATION.ID=ANNOTATION_BOOL.CHAMP_ANNOTATION_ID);
		IF bool = 1 THEN
			SET item55 = 'oui';
		ELSE
			SET item55 = 'non';
		END IF;
	END;

	/*Item56, item57 Inclusion dans un protocole therapeutique et nom du protocole*/
	BEGIN
		DECLARE bool INT(1);
		SET item57 = '';
		SET bool = (SELECT ANNOTATION_BOOL.VALEUR FROM ANNOTATION_BOOL, CHAMP_ANNOTATION WHERE ANNOTATION_BOOL.OBJET_ID=echantillon_id 
			AND CHAMP_ANNOTATION.NOM like '056 : Inclusion dans un protocole therapeutique%' AND CHAMP_ANNOTATION.ID=ANNOTATION_BOOL.CHAMP_ANNOTATION_ID);
		IF bool = 1 THEN
			SET item56 = 'oui';
			SET item57 = (SELECT ITEM_ANNOTATION_THESAURUS.NOM FROM ITEM_ANNOTATION_THESAURUS, ANNOTATION_THES, CHAMP_ANNOTATION 
				WHERE ANNOTATION_THES.OBJET_ID=echantillon_id AND CHAMP_ANNOTATION.NOM like '057 : Nom du protocole%' AND ITEM_ANNOTATION_THESAURUS.ID=ANNOTATION_THES.VALEUR 
				AND CHAMP_ANNOTATION.ID=ANNOTATION_THES.CHAMP_ANNOTATION_ID);
			IF item57 IS NULL THEN
				SET item57 = '';
			END IF;
		ELSE
			SET item56 = 'non';
		END IF;
	END;

	/*Item58 item59 Caryotype et anomalies eventuelles*/
	BEGIN
		DECLARE bool INT(1);
		SET item59 = '';
		SET bool = (SELECT ANNOTATION_BOOL.VALEUR FROM ANNOTATION_BOOL, CHAMP_ANNOTATION WHERE ANNOTATION_BOOL.OBJET_ID=patient_id 
			AND CHAMP_ANNOTATION.NOM like '058 : Caryotype%' AND CHAMP_ANNOTATION.ID=ANNOTATION_BOOL.CHAMP_ANNOTATION_ID);
		IF bool = 1 THEN
			SET item58 = 'oui';
			SET item59 = (SELECT ITEM_ANNOTATION_THESAURUS.NOM FROM ITEM_ANNOTATION_THESAURUS, ANNOTATION_THES, CHAMP_ANNOTATION 
				WHERE ANNOTATION_THES.OBJET_ID=patient_id AND CHAMP_ANNOTATION.NOM like '059 : Anomalies %' AND ITEM_ANNOTATION_THESAURUS.ID=ANNOTATION_THES.VALEUR 
				AND CHAMP_ANNOTATION.ID=ANNOTATION_THES.CHAMP_ANNOTATION_ID);
			IF item59 IS NULL THEN
				SET item59 = '';
			END IF;
		ELSE
			SET item58 = 'non';
		END IF;
	END;

	/*Item60 item61 Anomalie génomique et description*/
	BEGIN
		DECLARE bool INT(1);
		SET item61 = '';
		SET bool = (SELECT ANNOTATION_BOOL.VALEUR FROM ANNOTATION_BOOL, CHAMP_ANNOTATION WHERE ANNOTATION_BOOL.OBJET_ID=patient_id 
			AND CHAMP_ANNOTATION.NOM like '060 : Anomalies %' AND CHAMP_ANNOTATION.ID=ANNOTATION_BOOL.CHAMP_ANNOTATION_ID);
		IF bool = 1 THEN
			SET item60 = 'oui';
			SET item61 = (SELECT ANNOTATION_TEXTE.VALEUR FROM ANNOTATION_TEXTE, CHAMP_ANNOTATION 
				WHERE ANNOTATION_TEXTE.OBJET_ID=patient_id AND CHAMP_ANNOTATION.NOM like '061 : Description anomalies %' AND CHAMP_ANNOTATION.ID=ANNOTATION_TEXTE.CHAMP_ANNOTATION_ID);
			IF item61 IS NULL THEN
				SET item61 = '';
			END IF;
		ELSE
			SET item60 = 'non';
		END IF;
	END;

	/*Item62 Controle qualité*/
	BEGIN
		DECLARE bool INT(1);
		SET bool = (SELECT ANNOTATION_BOOL.VALEUR FROM ANNOTATION_BOOL, CHAMP_ANNOTATION WHERE ANNOTATION_BOOL.OBJET_ID=echantillon_id 
			AND CHAMP_ANNOTATION.NOM like '062 : Contrôle qualité%' AND CHAMP_ANNOTATION.ID=ANNOTATION_BOOL.CHAMP_ANNOTATION_ID);
		IF bool = 1 THEN
			SET item62 = 'oui';
		ELSE
			SET item62 = 'non';
		END IF;
	END;

	/*Item63 item64 Inclusion dans un protocole de recherche et nom du programme*/
	BEGIN
		DECLARE bool INT(1);
		SET item64 = '';
		SET bool = (SELECT ANNOTATION_BOOL.VALEUR FROM ANNOTATION_BOOL, CHAMP_ANNOTATION WHERE ANNOTATION_BOOL.OBJET_ID=echantillon_id 
			AND CHAMP_ANNOTATION.NOM like '063 : Inclusion dans un protocole de recherche%' AND CHAMP_ANNOTATION.ID=ANNOTATION_BOOL.CHAMP_ANNOTATION_ID);
		IF bool = 1 THEN
			SET item63 = 'oui';
			SET item64 = (SELECT ANNOTATION_TEXTE.VALEUR FROM ANNOTATION_TEXTE, CHAMP_ANNOTATION 
				WHERE ANNOTATION_TEXTE.OBJET_ID=echantillon_id AND CHAMP_ANNOTATION.NOM like '064 : Liste des programmes de recherche%' AND CHAMP_ANNOTATION.ID=ANNOTATION_TEXTE.CHAMP_ANNOTATION_ID);
			IF item64 IS NULL THEN
				SET item64 = '';
			END IF;
		ELSE
			SET item63 = 'non';
		END IF;
	END;


	/*********************************************************************************************************/
	/*************************************** CONTACT TUMOROTHEQUE *********************************/
	/*********************************************************************************************************/
	

	/*Item66 , item67 , item68 Nom, email et telephone du contact*/
	BEGIN
		DECLARE nom, prenom VARCHAR (50);
		SELECT COLLABORATEUR.COLLAB_NOM, COLLABORATEUR.COLLAB_PRENOM, COORDONNEE.COORD_TEL, COORDONNEE.COORD_MAIL
			INTO nom, prenom, item67, item68 FROM COLLABORATEUR, COORDONNEE, BANQUE, PRELEVEMENT WHERE PRELEVEMENT.PRELEVEMENT_ID=prelevement_id AND PRELEVEMENT.BANQUE_ID=BANQUE.BANQUE_ID AND BANQUE.COLLAB_ID=COLLABORATEUR.COLLAB_ID
			AND COLLABORATEUR.COORD_ID=COORDONNEE.COORD_ID;
	
		IF nom IS NOT NULL AND nom <> '' THEN
			IF prenom IS NULL THEN
				SET prenom = '';
			END IF;
			SET item66 = (SELECT CONCAT(nom, ' ', prenom));
		ELSE
			SELECT CONCAT('WARNING! Nom de contact non spécifié pour la banque ', (SELECT BANQUE.BANQUE_NOM FROM BANQUE, PRELEVEMENT WHERE PRELEVEMENT.PRELEVEMENT_ID=prelevement_id AND PRELEVEMENT.BANQUE_ID=BANQUE.BANQUE_ID)) AS 'WARNING';
			LEAVE MAIN_BLOCK;
		END IF;
		
		IF item67 IS NULL OR item67 = '' THEN
			SELECT CONCAT('WARNING! Telephone de contact non spécifié pour la banque ', banque) AS 'WARNING';
			LEAVE MAIN_BLOCK;
		END IF;
		
		IF item68 IS NULL OR item68 = '' THEN
			SELECT CONCAT('WARNING! Email de contact non spécifié pour la banque ', banque) AS 'WARNING';
			LEAVE MAIN_BLOCK;
		END IF;
	END;


	/**Ajouter concordande dates naissance<prelevement=etat**/
	/**Supprimmer dans JAVA valeur NULLES + date*/

	SELECT item1 AS 'Identifiant du site',
		item2 AS 'Code du patient',
		DATE_FORMAT(item3,'%d/%m/%Y') AS 'Date de naissance du patient',
		item4 AS 'Sexe du patient',
		item5 AS 'Etat du patient',
		DATE_FORMAT(item6,'%d/%m/%Y') AS 'Date de l\'etat',
		item76 AS 'Cause du deces',
		item7 AS 'Diagnostic principal',
		DATE_FORMAT(item8,'%d/%m/%Y') AS 'Date du diagnostic',
		item9 AS 'Version cTNM',
		item10 AS 'Taille de la tumeur',
		item11 AS 'Envahissement ganglionnaire',
		item12 AS 'Extension metastatique',
		item13 AS 'Centre de stockage',
		item14 AS 'Code prelevement',
		DATE_FORMAT(item15,'%d/%m/%Y') AS 'Date de prelevement',
		item16 AS 'Mode de prelevement',
		item17 AS 'Classification utilisee',
		item18 AS 'Code organe CIMO',
		item19 AS 'Type lesionnel CIMO',
		item20 AS 'Code organe ADICAP',
		item21 AS 'Type lesionnel ADICAP',
		item22 AS 'Type d\'evenement',
		item23 AS 'Version pTNM',
		item24 AS 'Taille de la tumeur',
		item25 AS 'pN',
		item26 AS 'pM',
		item27 AS 'Tumoral',
		item28 AS 'Mode conservation tumoral',
		item29 AS 'Type echantillon tumoral',
		item30 AS 'Mode preparation tumoral',
		item31 AS 'Delai congelation tumoral',
		item32 AS 'Controles sur tissu tumoral',
		item33 AS 'Quantite echantillon tumoral',
		item34 AS 'Quantite unite echantillon tumoral',
		item35 AS 'Pourcentage de cellules tumorales',
		item36 AS 'ADN derive tumoral',
		item37 AS 'ARN derive tumoral',
		item38 AS 'Proteine derivee tumorale',
		item39 AS 'Non tumoral',
		item40 AS 'Mode conservation non tumoral',
		item41 AS 'Type echantillon non tumoral',
		item42 AS 'Mode preparation non tumoral',
		item43 AS 'Delai congelation non tumoral',
		item44 AS 'Controles sur tissu non tumoral',
		item45 AS 'Quantite echantillon non tumoral',
		item46 AS 'Quantite unite échantillon non tumoral',
		item47 AS 'ADN derive non tumoral',
		item48 AS 'ARN derive non tumoral',
		item49 AS 'Proteine derivee non tumorale',
		item50 AS 'Serum',
		item51 AS 'Plasma',
		item52 AS 'Liquides',
		item53 AS 'ADN',
		item54 AS 'CR anatomopathologique standardise interrogeable',
		item55 AS 'Donnees cliniques disponibles dans une base',
		item56 AS 'Inclusion dans un protocole therapeutique',
		item57 AS 'Nom du protocole',
		item58 AS 'Caryotype',
		item59 AS 'Anomalies eventuelles',
		item60 AS 'Anomalies genomiques',
		item61 AS 'Description anomalies genomiques',
		item62 AS 'Controle qualite biologique',
		item63 AS 'Inclusion programme de recherche',
		item64 AS 'Liste programmmes de recherche',
		item66 AS 'Nom du contact',
		item67 AS 'Telephone du contact',
		item68 AS 'Email du contact';

	
END MAIN_BLOCK!

DELIMITER ;
