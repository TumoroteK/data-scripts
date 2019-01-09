BEGIN
	
	DECLARE banque1_id INT(10);
	DECLARE banque2_id INT(10);
	
	SET banque1_id = (select banque_id from BANQUE where nom = 'BANQUE1');
	SET banque2_id = (select banque_id from BANQUE where nom = 'BANQUE1');

	-- codes
	update CODE_SELECT set banque_id=banque1_id where banque_id=banque2_id;
	update CODE_UTILISATEUR set banque_id=banque1_id where banque_id=banque2_id;
	update CODE_DOSSIER set banque_id=banque1_id where banque_id=banque2_id;

	-- imports
	update IMPORT_TEMPLATE set banque_id=banque1_id where banque_id=banque2_id;

	-- impression
	update TEMPLATE set banque_id=banque1_id where banque_id=banque2_id;

	-- module recherche
	update AFFICHAGE set banque_id=banque1_id where banque_id=banque2_id;
	update REQUETE set banque_id=banque1_id where banque_id=banque2_id;
	update RECHERCHE set banque_id=banque1_id where banque_id=banque2_id;

	-- stockage
	update CONTENEUR_BANQUE set banque_id=banque1_id where banque_id=banque2_id; -- doublons éventuels
	update ENCEINTE_BANQUE set banque_id=banque1_id where banque_id=banque2_id; -- doublons éventuels
	update TERMINALE set banque_id=banque1_id where banque_id=banque2_id;

	-- TK Objects
	update PRELEVEMENT set banque_id=banque1_id where banque_id=banque2_id;
	update ECHANTILLON set banque_id=banque1_id where banque_id=banque2_id;
	update PROD_DERIVE set banque_id=banque1_id where banque_id=banque2_id;
	update CESSION set banque_id=banque1_id where banque_id=banque2_id;

	-- Annotations
	update TABLE_ANNOTATION_BANQUE set banque_id=banque1_id where banque_id=banque2_id; -- doublons éventuels
	update ANNOTATION_VALEUR set banque_id=banque1_id where banque_id=banque2_id;
	update ANNOTATION_DEFAUT set banque_id=banque1_id where banque_id=banque2_id;	

	-- profils utilisateur -> delete
	-- table codage -> delete
	-- catalogues -> delete
	-- numerotations -> delete
	-- affectations imrimantes -> delete
	-- etiquettes -> plateforme
	-- couleurs entites --> delete

	SELECT 'done';
	
END;
