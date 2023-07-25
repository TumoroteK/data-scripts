DELIMITER !

DROP PROCEDURE IF EXISTS copy_thesaurus!
CREATE PROCEDURE copy_thesaurus (in _plateforme_source VARCHAR(50), in _plateforme_dest VARCHAR(50))
BEGIN

	declare id_pf_source INT(10);
	declare id_pf_dest INT(10);

	SET id_pf_source = (select plateforme_id from PLATEFORME where nom=_plateforme_source);
	SET id_pf_dest = (select plateforme_id from PLATEFORME where nom=_plateforme_dest);

	IF id_pf_source > 0 AND id_pf_dest > 0
	THEN

		insert into CESSION_EXAMEN (cession_examen_id, examen, plateforme_id) 
		select @rank := @rank+1, examen, id_pf_dest from 
			( SELECT @rank:= (select max(cession_examen_id) from CESSION_EXAMEN) ) tmp,	CESSION_EXAMEN tab1 
		where tab1.plateforme_id = id_pf_source and not exists (select 1 from CESSION_EXAMEN tab2 where tab2.examen=tab1.examen and tab2.plateforme_id=id_pf_dest);
	
		insert into CONDIT_MILIEU (condit_milieu_id, milieu, plateforme_id)
		select @rank := @rank+1, milieu, id_pf_dest from 
			( SELECT @rank:= (select max(condit_milieu_id) from CONDIT_MILIEU) ) tmp, CONDIT_MILIEU tab1 where tab1.plateforme_id = id_pf_source and not exists (select 1 from CONDIT_MILIEU tab2 where tab2.milieu=tab1.milieu and tab2.plateforme_id=id_pf_dest);
	
		insert into MODE_PREPA (mode_prepa_id, nom, plateforme_id)
		select @rank := @rank+1, nom, id_pf_dest from
			( SELECT @rank:= (select max(mode_prepa_id) from MODE_PREPA) ) tmp, MODE_PREPA tab1 where tab1.plateforme_id = id_pf_source and not exists (select 1 from MODE_PREPA tab2 where tab2.nom=tab1.nom and tab2.plateforme_id=id_pf_dest);

		insert into DESTRUCTION_MOTIF (destruction_motif_id, motif, plateforme_id)
		select @rank := @rank+1, motif, id_pf_dest from 
			( SELECT @rank:= (select max(destruction_motif_id) from DESTRUCTION_MOTIF) ) tmp, DESTRUCTION_MOTIF tab1 where tab1.plateforme_id = id_pf_source and not exists (select 1 from DESTRUCTION_MOTIF tab2 where tab2.motif=tab1.motif and tab2.plateforme_id=id_pf_dest);

		insert into NATURE (nature_id, nature, plateforme_id)
		select @rank := @rank+1, nature, id_pf_dest from 
			( SELECT @rank:= (select max(nature_id) from NATURE) ) tmp, NATURE tab1 where tab1.plateforme_id = id_pf_source and not exists (select 1 from NATURE tab2 where tab2.nature=tab1.nature and tab2.plateforme_id=id_pf_dest);

		insert into MODE_PREPA_DERIVE (mode_prepa_derive_id, nom, plateforme_id)
		select @rank := @rank+1, nom, id_pf_dest from 
			( SELECT @rank:= (select max(mode_prepa_derive_id) from MODE_PREPA_DERIVE) ) tmp, MODE_PREPA_DERIVE tab1 where tab1.plateforme_id = id_pf_source and not exists (select 1 from MODE_PREPA_DERIVE tab2 where tab2.nom=tab1.nom and tab2.plateforme_id=id_pf_dest);


		insert into NON_CONFORMITE (non_conformite_id, conformite_type_id, nom, plateforme_id) 
		select @rank := @rank+1, conformite_type_id, nom, id_pf_dest from 
			( SELECT @rank:= (select max(non_conformite_id) from NON_CONFORMITE) ) tmp, NON_CONFORMITE tab1 where tab1.plateforme_id = id_pf_source and not exists (select 1 from NON_CONFORMITE tab2 where tab2.conformite_type_id=tab1.conformite_type_id and tab2.nom=tab1.nom and tab2.plateforme_id=id_pf_dest);
		
		insert into PROTOCOLE (protocole_id, nom, plateforme_id) 
		select @rank := @rank+1, nom, id_pf_dest from 
			( SELECT @rank:= (select max(protocole_id) from PROTOCOLE) ) tmp, PROTOCOLE tab1 where tab1.plateforme_id = id_pf_source and not exists (select 1 from PROTOCOLE tab2 where tab2.nom=tab1.nom and tab2.plateforme_id=id_pf_dest);
		
		insert into DIAGNOSTIC (diagnostic_id, nom, plateforme_id) 
		select @rank := @rank+1, nom, id_pf_dest from 
			( SELECT @rank:= (select max(diagnostic_id) from DIAGNOSTIC) ) tmp, DIAGNOSTIC tab1 where tab1.plateforme_id = id_pf_source and not exists (select 1 from DIAGNOSTIC tab2 where tab2.nom=tab1.nom and tab2.plateforme_id=id_pf_dest);
		
		insert into ECHAN_QUALITE (echan_qualite_id, echan_qualite, plateforme_id) 
		select @rank := @rank+1, echan_qualite, id_pf_dest from 
			( SELECT @rank:= (select max(echan_qualite_id) from ECHAN_QUALITE) ) tmp, ECHAN_QUALITE tab1 where tab1.plateforme_id = id_pf_source and not exists (select 1 from ECHAN_QUALITE tab2 where tab2.echan_qualite=tab1.echan_qualite and tab2.plateforme_id=id_pf_dest);
		
		insert into PROD_QUALITE (prod_qualite_id, prod_qualite, plateforme_id) 
		select @rank := @rank+1, prod_qualite, id_pf_dest from 
			( SELECT @rank:= (select max(prod_qualite_id) from PROD_QUALITE) ) tmp, PROD_QUALITE tab1 where tab1.plateforme_id = id_pf_source and not exists (select 1 from PROD_QUALITE tab2 where tab2.prod_qualite=tab1.prod_qualite and tab2.plateforme_id=id_pf_dest);

		insert into RISQUE (risque_id, nom, infectieux, plateforme_id) 
		select @rank := @rank+1, nom, infectieux, id_pf_dest from 
			( SELECT @rank:= (select max(risque_id) from RISQUE) ) tmp, RISQUE tab1 where tab1.plateforme_id = id_pf_source and not exists (select 1 from RISQUE tab2 where tab2.nom=tab1.nom and tab2.plateforme_id=id_pf_dest);



		insert into CONSENT_TYPE (consent_type_id, type, plateforme_id) 
		select @rank := @rank+1, type, id_pf_dest from 
			( SELECT @rank:= (select max(consent_type_id) from CONSENT_TYPE) ) tmp, CONSENT_TYPE tab1 where tab1.plateforme_id = id_pf_source and not exists (select 1 from CONSENT_TYPE tab2 where tab2.type=tab1.type and tab2.plateforme_id=id_pf_dest);

		insert into ECHANTILLON_TYPE (echantillon_type_id, type, inca_cat, plateforme_id) 
		select @rank := @rank+1, type, inca_cat, id_pf_dest from 
			( SELECT @rank:= (select max(echantillon_type_id) from ECHANTILLON_TYPE) ) tmp, ECHANTILLON_TYPE tab1 where tab1.plateforme_id = id_pf_source and not exists (select 1 from ECHANTILLON_TYPE tab2 where tab2.type=tab1.type and tab2.plateforme_id=id_pf_dest);		
		
		
		
		insert into ENCEINTE_TYPE (enceinte_type_id, type, prefixe, plateforme_id) 
		select @rank := @rank+1, type, prefixe, id_pf_dest from 
			( SELECT @rank:= (select max(enceinte_type_id) from ENCEINTE_TYPE) ) tmp, ENCEINTE_TYPE tab1 where tab1.plateforme_id = id_pf_source and not exists (select 1 from ENCEINTE_TYPE tab2 where tab2.type=tab1.type and tab2.plateforme_id=id_pf_dest);
		
		
		insert into CONDIT_TYPE (condit_type_id, type, plateforme_id) 
		select @rank := @rank+1, type, id_pf_dest from 
			( SELECT @rank:= (select max(condit_type_id) from CONDIT_TYPE) ) tmp, CONDIT_TYPE tab1 where tab1.plateforme_id = id_pf_source and not exists (select 1 from CONDIT_TYPE tab2 where tab2.type=tab1.type and tab2.plateforme_id=id_pf_dest);
		

		insert into CONTENEUR_TYPE (conteneur_type_id, type, plateforme_id) 
		select @rank := @rank+1, type, id_pf_dest from 
			( SELECT @rank:= (select max(conteneur_type_id) from CONTENEUR_TYPE) ) tmp, CONTENEUR_TYPE tab1 where tab1.plateforme_id = id_pf_source and not exists (select 1 from CONTENEUR_TYPE tab2 where tab2.type=tab1.type and tab2.plateforme_id=id_pf_dest);

		insert into PRELEVEMENT_TYPE (prelevement_type_id, type, inca_cat, plateforme_id) 
		select @rank := @rank+1, type, inca_cat, id_pf_dest from 
			( SELECT @rank:= (select max(prelevement_type_id) from PRELEVEMENT_TYPE) ) tmp, PRELEVEMENT_TYPE tab1 where tab1.plateforme_id = id_pf_source and not exists (select 1 from PRELEVEMENT_TYPE tab2 where tab2.type=tab1.type and tab2.plateforme_id=id_pf_dest);

		insert into PROD_TYPE (prod_type_id, type, plateforme_id) 
		select @rank := @rank+1, type, id_pf_dest from 
			( SELECT @rank:= (select max(prod_type_id) from PROD_TYPE) ) tmp, PROD_TYPE tab1 where tab1.plateforme_id = id_pf_source and not exists (select 1 from PROD_TYPE tab2 where tab2.type=tab1.type and tab2.plateforme_id=id_pf_dest);


		insert into PROTOCOLE_TYPE (protocole_type_id, type, plateforme_id) 
		select @rank := @rank+1, type, id_pf_dest from 
			( SELECT @rank:= (select max(protocole_type_id) from PROTOCOLE_TYPE) ) tmp, PROTOCOLE_TYPE tab1 where tab1.plateforme_id = id_pf_source and not exists (select 1 from PROTOCOLE_TYPE tab2 where tab2.type=tab1.type and tab2.plateforme_id=id_pf_dest);
	
		-- spécifique TK 2.3.0
		insert into ORGANISME (organisme_id, nom, plateforme_id) 
		select @rank := @rank+1, nom, id_pf_dest from 
			( SELECT @rank:= (select max(organisme_id) from ORGANISME) ) tmp, ORGANISME tab1 where tab1.plateforme_id = id_pf_source and not exists (select 1 from ORGANISME tab2 where tab2.nom=tab1.nom and tab2.plateforme_id=id_pf_dest);
		

	ELSE
	
		select CONCAT('plateforme source et / ou de destination incorrecte(s) : ', _plateforme_source, ', ', _plateforme_dest) as ERREUR; 
		
	END IF;

END!
DELIMITER ;