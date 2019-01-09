#DELIMITER !

#DROP PROCEDURE IF EXISTS tumo.FromPatientToPrelevement!
#CREATE PROCEDURE tumo.FromPatientToPrelevement (@banque VARCHAR(50), @myregexp VARCHAR(50))

SELECT 'a';

#BEGIN	
	SET @banque= 'Démences';
	SET @myregexp= 'bb007 : Diagnostic Principal';	
	
	SET @prelevement_id= 0;
	SET @patient_id= 0; 
	SET @annot_maxId= 0;

	SET @chp_annotation_id= 0;
 	SET @chp_annotation_type= 0; 	
	SET @done= 0;
	SET @prev_id= 0;
	SET @isNew= 0;
	
	SET @boolValue= 0;
	SET @item= '';

	#Recuperer pour chaque patient les prelevements associés
  	DECLARE cur CURSOR FOR SELECT CONSENTIR.@patient_id, CONSENTIR.@prelevement_id 
		FROM CONSENTIR, PRELEVEMENT WHERE PRELEVEMENT.@banque_ID = (SELECT @banque_ID FROM @banque WHERE @banque_NOM = @banque)
		AND PRELEVEMENT.@prelevement_id = CONSENTIR.@prelevement_id;	

	DECLARE cur2 CURSOR FOR SELECT ID, TYPE FROM CHAMP_ANNOTATION WHERE NOM REGEXP @myregexp;
	#DECLARE cur2 CURSOR FOR SELECT ID, TYPE FROM CHAMP_ANNOTATION WHERE NOM REGEXP @myregexp;	
	
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET @done = 1; 

	#DECLARE CONTINUE HANDLER FOR SQLSTATE '42S02' SELECT 'Pas d\'annotations patients à migrer' AS 'WARNING'; 


	
	
	#Update les chamsp annotations pour les associer à la table
	#d'annotation prelevement
	UPDATE CHAMP_ANNOTATION SET TABLE_ANNOTATION_ID = (SELECT ANNO_BIOL FROM @banque WHERE @banque_NOM = @banque)
	#WHERE CHAMP_ANNOTATION.NOM REGEXP @myregexp;
	WHERE CHAMP_ANNOTATION.NOM REGEXP @myregexp;

	#A l'aide d'un curseur parocourir chaque ligne
	#Pour chaque ligne
	#	Recupere l'ID du patient
	# 	Recupere l'ID du prelevement
	#	Boucle sur les tables annotations
	#	Pour chaque table annotation
	#		Recupere le max(id)
	#		Recupere pour chaque champs les valeurs associées à l'ID patient dans une table temporaire
	#		Remplace l'id_objet par l'id_prelevement
	#		Delete les lignes ou objet_id = id_patient pour tous les champs de la liste	
	
	CREATE TEMPORARY TABLE annotTemp (ID int(11) NOT NULL,
  					VALEUR varchar(2000) NOT NULL,
  					OBJET_ID int(11) NOT NULL,
					@patient_id int(11) NOT NULL,
  					CHAMP_ANNOTATION_ID int(11) NOT NULL);

	OPEN cur;

	patient_loop : LOOP
    		FETCH cur INTO @patient_id, @prelevement_id;

		IF @done=1 THEN
			DELETE FROM ANNOTATION_ALPHANUM WHERE CHAMP_ANNOTATION_ID IN (SELECT ID FROM CHAMP_ANNOTATION WHERE NOM REGEXP @myregexp) AND OBJET_ID = @prev_id;
			DELETE FROM ANNOTATION_BOOL WHERE CHAMP_ANNOTATION_ID IN (SELECT ID FROM CHAMP_ANNOTATION WHERE NOM REGEXP @myregexp) AND OBJET_ID = @prev_id;
			DELETE FROM ANNOTATION_DATE WHERE CHAMP_ANNOTATION_ID IN (SELECT ID FROM CHAMP_ANNOTATION WHERE NOM REGEXP @myregexp) AND OBJET_ID = @prev_id;
			DELETE FROM ANNOTATION_NUM WHERE CHAMP_ANNOTATION_ID IN (SELECT ID FROM CHAMP_ANNOTATION WHERE NOM REGEXP @myregexp) AND OBJET_ID = @prev_id;
			DELETE FROM ANNOTATION_TEXTE WHERE CHAMP_ANNOTATION_ID IN (SELECT ID FROM CHAMP_ANNOTATION WHERE NOM REGEXP @myregexp) AND OBJET_ID = @prev_id;
			DELETE FROM ANNOTATION_THES WHERE CHAMP_ANNOTATION_ID IN (SELECT ID FROM CHAMP_ANNOTATION WHERE NOM REGEXP @myregexp) AND OBJET_ID = @prev_id;
			LEAVE patient_loop;
		END IF;
		
		SET @isNew = (SELECT @patient_id <> @prev_id);
		
		
		OPEN cur2;
		annot_loop : LOOP
			FETCH cur2 INTO @chp_annotation_id, @chp_annotation_type;
    				
			IF @done=1 THEN
				LEAVE annot_loop;
			END IF;
	
			IF @chp_annotation_type=1 THEN
				INSERT annotTemp SELECT (SELECT max(ID) FROM ANNOTATION_ALPHANUM)+1 AS 'ID', VALEUR, @prelevement_id AS 'OBJET_ID', @patient_id, CHAMP_ANNOTATION_ID FROM ANNOTATION_ALPHANUM WHERE CHAMP_ANNOTATION_ID = @chp_annotation_id AND OBJET_ID = @patient_id;
				INSERT ANNOTATION_ALPHANUM SELECT (SELECT max(ID) FROM ANNOTATION_ALPHANUM)+1 AS 'ID', VALEUR, @prelevement_id AS 'OBJET_ID', CHAMP_ANNOTATION_ID FROM ANNOTATION_ALPHANUM WHERE CHAMP_ANNOTATION_ID = @chp_annotation_id AND OBJET_ID = @patient_id;				
			ELSEIF @chp_annotation_type=2 THEN
				SET @boolValue = (SELECT VALEUR FROM ANNOTATION_BOOL WHERE CHAMP_ANNOTATION_ID = @chp_annotation_id AND OBJET_ID = @patient_id);
				IF @boolValue > 0 THEN
					INSERT INTO annotTemp SELECT (SELECT max(ID) FROM ANNOTATION_BOOL)+1 AS 'ID', @boolValue,  @prelevement_id AS 'OBJET_ID', @patient_id, @chp_annotation_id;
					INSERT INTO ANNOTATION_BOOL SELECT (SELECT max(ID) FROM ANNOTATION_BOOL)+1 AS 'ID', @boolValue,  @prelevement_id AS 'OBJET_ID', @chp_annotation_id;
				END IF;
			ELSEIF @chp_annotation_type=3 THEN
				INSERT INTO annotTemp SELECT (SELECT max(ID) FROM ANNOTATION_DATE)+1 AS 'ID', VALEUR,  @prelevement_id AS 'OBJET_ID', @patient_id, CHAMP_ANNOTATION_ID FROM ANNOTATION_DATE WHERE CHAMP_ANNOTATION_ID = @chp_annotation_id AND OBJET_ID = @patient_id;
				INSERT INTO ANNOTATION_DATE SELECT (SELECT max(ID) FROM ANNOTATION_DATE)+1 AS 'ID', VALEUR,  @prelevement_id AS 'OBJET_ID', CHAMP_ANNOTATION_ID FROM ANNOTATION_DATE WHERE CHAMP_ANNOTATION_ID = @chp_annotation_id AND OBJET_ID = @patient_id;
			#WHEN 4 THEN CREATE TEMPORARY TABLE annotTemp AS SELECT VALEUR, OBJET_ID FROM ANNOTATION_LISTE;
			ELSEIF @chp_annotation_type=5 THEN
				INSERT INTO annotTemp SELECT (SELECT max(ID) FROM ANNOTATION_NUM)+1 AS 'ID', VALEUR,  @prelevement_id AS 'OBJET_ID', @patient_id, CHAMP_ANNOTATION_ID FROM ANNOTATION_NUM WHERE CHAMP_ANNOTATION_ID = @chp_annotation_id AND OBJET_ID = @patient_id;
				INSERT INTO ANNOTATION_NUM SELECT (SELECT max(ID) FROM ANNOTATION_NUM)+1 AS 'ID', VALEUR,  @prelevement_id AS 'OBJET_ID', CHAMP_ANNOTATION_ID FROM ANNOTATION_NUM WHERE CHAMP_ANNOTATION_ID = @chp_annotation_id AND OBJET_ID = @patient_id;
			ELSEIF @chp_annotation_type=6 THEN
				INSERT INTO annotTemp SELECT (SELECT max(ID) FROM ANNOTATION_TEXTE)+1 AS 'ID', VALEUR,  @prelevement_id AS 'OBJET_ID', @patient_id, CHAMP_ANNOTATION_ID FROM ANNOTATION_TEXTE WHERE CHAMP_ANNOTATION_ID = @chp_annotation_id AND OBJET_ID = @patient_id;
				INSERT INTO ANNOTATION_TEXTE SELECT (SELECT max(ID) FROM ANNOTATION_TEXTE)+1 AS 'ID', VALEUR,  @prelevement_id AS 'OBJET_ID', CHAMP_ANNOTATION_ID FROM ANNOTATION_TEXTE WHERE CHAMP_ANNOTATION_ID = @chp_annotation_id AND OBJET_ID = @patient_id;
			ELSEIF @chp_annotation_type=7 THEN 
				SET @item = (SELECT NOM FROM @item_ANNOTATION_THESAURUS, ANNOTATION_THES WHERE ANNOTATION_THES.VALEUR=@item_ANNOTATION_THESAURUS.ID AND ANNOTATION_THES.CHAMP_ANNOTATION_ID = @chp_annotation_id AND ANNOTATION_THES.OBJET_ID = @patient_id);
				IF @item IS NOT NULL THEN
					INSERT INTO annotTemp SELECT (SELECT max(ID) FROM ANNOTATION_THES)+1 AS 'ID', @item,  @prelevement_id AS 'OBJET_ID', @patient_id, @chp_annotation_id;
					INSERT INTO ANNOTATION_THES SELECT (SELECT max(ID) FROM ANNOTATION_THES)+1 AS 'ID', VALEUR,  @prelevement_id AS 'OBJET_ID', CHAMP_ANNOTATION_ID FROM ANNOTATION_THES WHERE CHAMP_ANNOTATION_ID = @chp_annotation_id AND OBJET_ID = @patient_id;
				END IF;
			END IF;

		END LOOP;
		
		IF @isNew = 1 THEN
			DELETE FROM ANNOTATION_ALPHANUM WHERE CHAMP_ANNOTATION_ID IN (SELECT ID FROM CHAMP_ANNOTATION WHERE NOM REGEXP @myregexp) AND OBJET_ID = @prev_id;
			DELETE FROM ANNOTATION_BOOL WHERE CHAMP_ANNOTATION_ID IN (SELECT ID FROM CHAMP_ANNOTATION WHERE NOM REGEXP @myregexp) AND OBJET_ID = @prev_id;
			DELETE FROM ANNOTATION_DATE WHERE CHAMP_ANNOTATION_ID IN (SELECT ID FROM CHAMP_ANNOTATION WHERE NOM REGEXP @myregexp) AND OBJET_ID = @prev_id;
			DELETE FROM ANNOTATION_NUM WHERE CHAMP_ANNOTATION_ID IN (SELECT ID FROM CHAMP_ANNOTATION WHERE NOM REGEXP @myregexp) AND OBJET_ID = @prev_id;
			DELETE FROM ANNOTATION_TEXTE WHERE CHAMP_ANNOTATION_ID IN (SELECT ID FROM CHAMP_ANNOTATION WHERE NOM REGEXP @myregexp) AND OBJET_ID = @prev_id;
			DELETE FROM ANNOTATION_THES WHERE CHAMP_ANNOTATION_ID IN (SELECT ID FROM CHAMP_ANNOTATION WHERE NOM REGEXP @myregexp) AND OBJET_ID = @prev_id;
		END IF;
		
		CLOSE cur2;
		SET @done=0;

		SET @prev_id=@patient_id;
		
		#IF annot_moved > 0 THEN
		#	SELECT CONCAT(@patient_id, ' has ', annot_moved ,' to be moved');
		#END IF;

	END LOOP patient_loop;
	CLOSE cur;



	IF (SELECT COUNT(*) FROM annotTemp) > 0 THEN
	SELECT PATIENT_NIP, PRELEVEMENT_CODE, CHAMP_ANNOTATION.NOM, VALEUR FROM annotTemp, PATIENT, PRELEVEMENT, CHAMP_ANNOTATION
			WHERE annotTemp.@patient_id=PATIENT.@patient_id AND annotTemp.OBJET_ID=PRELEVEMENT.@prelevement_id
			AND annotTemp.CHAMP_ANNOTATION_ID=CHAMP_ANNOTATION.ID;
	
	ELSE
		SELECT 'Pas d\'annotations patients à migrer' AS 'WARNING'; 
	END IF;


DROP TEMPORARY TABLE annotTemp;
#END!

#DELIMITER ;
