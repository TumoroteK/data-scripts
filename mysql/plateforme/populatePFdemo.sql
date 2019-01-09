DELIMITER !

DROP PROCEDURE IF EXISTS demo_thes!
CREATE PROCEDURE demo_thes ()
BEGIN

	declare maxPfId INT(10);
	SET maxPfId = (select max(plateforme_id) from PLATEFORME);

	alter table NATURE modify nature_id int(3) NOT NULL auto_increment;
	alter table RISQUE modify risque_id int(3) NOT NULL auto_increment;
	alter table PRELEVEMENT_TYPE modify prelevement_type_id int(3) NOT NULL auto_increment;
	alter table CONDIT_TYPE modify condit_type_id int(3) NOT NULL auto_increment;
	alter table CONDIT_MILIEU modify condit_milieu_id int(3) NOT NULL auto_increment;
	alter table CONSENT_TYPE modify consent_type_id int(2) NOT NULL auto_increment;
	alter table ECHANTILLON_TYPE modify echantillon_type_id int(2) NOT NULL auto_increment;
	alter table ECHAN_QUALITE modify echan_qualite_id int(3) NOT NULL auto_increment;
	alter table MODE_PREPA modify mode_prepa_id int(3) NOT NULL auto_increment;
	alter table PROD_TYPE modify prod_type_id int(2) NOT NULL auto_increment;
	alter table PROD_QUALITE modify prod_qualite_id int(3) NOT NULL auto_increment;
	alter table MODE_PREPA_DERIVE modify mode_prepa_derive_id int(3) NOT NULL auto_increment;
	alter table CESSION_EXAMEN modify cession_examen_id int(3) NOT NULL auto_increment;
	alter table DESTRUCTION_MOTIF modify destruction_motif_id int(3) NOT NULL auto_increment;
	alter table PROTOCOLE_TYPE modify protocole_type_id int(2) NOT NULL auto_increment;
	alter table CONTENEUR_TYPE modify conteneur_type_id int(2) NOT NULL auto_increment;
	alter table ENCEINTE_TYPE modify enceinte_type_id int(2) NOT NULL auto_increment;
			
	-- thesaurus partagés
	-- NATURE		
	insert into NATURE (nature, plateforme_id) values ('TISSU', maxPfId), ('SANG', maxPfId), ('LCR', maxPfId);
	
	-- RISQUE
	insert into RISQUE (nom, infectieux, plateforme_id) values ('HIV', 1, maxPfId), ('HEPATITE', 0, maxPfId);
 
	-- PRELEVEMENT_TYPE
	insert into PRELEVEMENT_TYPE (type, inca_cat, plateforme_id) values ('PONCTION', null, maxPfId), ('BIOPSIE', null, maxPfId);
	
	-- CONDIT_TYPE
	insert into CONDIT_TYPE (type, plateforme_id) values ('TUBE', maxPfId), ('POUDRIER', maxPfId), ('AMPOULE', maxPfId);
	
	-- CONDIT_MILIEU
	insert into CONDIT_MILIEU (milieu, plateforme_id) values ('EDTA', maxPfId), ('SEC', maxPfId), ('HEPARINE', maxPfId);

	-- CONSENT_TYPE
	insert into CONSENT_TYPE (type, plateforme_id) values ('EN ATTENTE', maxPfId), ('RECHERCHE', maxPfId), ('GENETIQUE', maxPfId);
	
	-- ECHANTILLON_TYPE
	insert into ECHANTILLON_TYPE (type, inca_cat, plateforme_id) values ('CELLULES', null, maxPfId), ('SERUM', null, maxPfId), ('TISSU', null, maxPfId);
	
	-- ECHAN_QUALITE
	insert into ECHAN_QUALITE (echan_qualite, plateforme_id) values ('NECROSE', maxPfId), ('NON FAIT', maxPfId), ('INFILTRATION', maxPfId);

	-- MODE_PREPA
	insert into MODE_PREPA (nom, plateforme_id) values ('DMSO', maxPfId), ('CULOT', maxPfId);
	
	-- PROD_TYPE
	insert into PROD_TYPE (type, plateforme_id) values ('ADN', maxPfId), ('ARN', maxPfId), ('PROTEINE', maxPfId);

	-- PROD_QUALITE
	insert into PROD_QUALITE (prod_qualite, plateforme_id) values ('NON FAIT', maxPfId), ('PCR', maxPfId);

	-- MODE_PREPA_DERIVE
	insert into MODE_PREPA_DERIVE (nom, plateforme_id) values ('EDTA', maxPfId), ('TAMPON X', maxPfId);

	-- CESSION_EXAMEN
	insert into CESSION_EXAMEN (examen, plateforme_id) values ('EXTRACTION ARN', maxPfId), ('PURIFICATION PROTEINES', maxPfId);

	-- DESTRUCTION_MOTIF
	insert into DESTRUCTION_MOTIF (motif, plateforme_id) values ('TUBE ILLISIBLE', maxPfId), ('DECONGELATION', maxPfId);

	-- PROTOCOLE_TYPE
	insert into PROTOCOLE_TYPE (type, plateforme_id) values ('RECHERCHE', maxPfId), ('THERAPEUTIQUE', maxPfId);

	-- CONTENEUR_TYPE
	insert into CONTENEUR_TYPE (type, plateforme_id) values ('CONGELATEUR -80', maxPfId), ('AZOTE', maxPfId);

	-- ENCEINTE_TYPE
	insert into ENCEINTE_TYPE (type, prefixe, plateforme_id) values ('TIROIR', 'T', maxPfId), ('RACK', 'R', maxPfId), ('CASIER', 'C', maxPfId);

	alter table NATURE modify nature_id int(3) NOT NULL;
	alter table RISQUE modify risque_id int(3) NOT NULL;
	alter table PRELEVEMENT_TYPE modify prelevement_type_id int(3) NOT NULL;
	alter table CONDIT_TYPE modify condit_type_id int(3) NOT NULL;
	alter table CONDIT_MILIEU modify condit_milieu_id int(3) NOT NULL;
	alter table CONSENT_TYPE modify consent_type_id int(2) NOT NULL;
	alter table ECHANTILLON_TYPE modify echantillon_type_id int(2) NOT NULL;
	alter table ECHAN_QUALITE modify echan_qualite_id int(3) NOT NULL;
	alter table MODE_PREPA modify mode_prepa_id int(3) NOT NULL;
	alter table PROD_TYPE modify prod_type_id int(2) NOT NULL;
	alter table PROD_QUALITE modify prod_qualite_id int(3) NOT NULL;
	alter table MODE_PREPA_DERIVE modify mode_prepa_derive_id int(3) NOT NULL;
	alter table CESSION_EXAMEN modify cession_examen_id int(3) NOT NULL;
	alter table DESTRUCTION_MOTIF modify destruction_motif_id int(3) NOT NULL;
	alter table PROTOCOLE_TYPE modify protocole_type_id int(2) NOT NULL;
	alter table CONTENEUR_TYPE modify conteneur_type_id int(2) NOT NULL;
	alter table ENCEINTE_TYPE modify enceinte_type_id int(2) NOT NULL;

	-- tables cf demo BREST
	
	alter table TABLE_ANNOTATION modify TABLE_ANNOTATION_ID int(10) NOT NULL auto_increment;
	alter table CHAMP_ANNOTATION modify CHAMP_ANNOTATION_ID int(10) NOT NULL auto_increment;
	alter table ITEM modify ITEM_ID int(10) NOT NULL auto_increment;

	insert into TABLE_ANNOTATION (nom, description, entite_id, catalogue_id, plateforme_id) 
		values ('Données cliniques', 'Table demonstration', 1, null, maxPfId);
	
	-- Remarques alphanum
	insert into CHAMP_ANNOTATION (nom, data_type_id, table_annotation_id, combine, ordre, edit) 
		values ('Remarques', 1, (select max(table_annotation_id) from TABLE_ANNOTATION), 0, 1, 1);
	-- Antécédents booléen
	insert into CHAMP_ANNOTATION (nom, data_type_id, table_annotation_id, combine, ordre, edit) 
		values ('Antécédents', 2, (select max(table_annotation_id) from TABLE_ANNOTATION), 0, 2, 1);

	insert into TABLE_ANNOTATION_BANQUE select max(t.table_annotation_id), max(b.banque_id), 1 from TABLE_ANNOTATION t, BANQUE b where b.plateforme_id = maxPfId;

	-- TABLE PRELEVEMENT
	insert into TABLE_ANNOTATION (nom, description, entite_id, catalogue_id, plateforme_id) 
		values ('Annotations biologiques', 'Table demonstration', 2, null, maxPfId);
	
	-- Type event thes
	insert into CHAMP_ANNOTATION (nom, data_type_id, table_annotation_id, combine, ordre, edit) 
		values ('Type évènenement', 7, (select max(table_annotation_id) from TABLE_ANNOTATION), 0, 1, 1);
	insert into ITEM (label, champ_annotation_id) values ('récidive', (select max(champ_annotation_id) from CHAMP_ANNOTATION)),
	('rémission', (select max(champ_annotation_id) from CHAMP_ANNOTATION)),
	('inconnu', (select max(champ_annotation_id) from CHAMP_ANNOTATION));

	-- Commentaires texte
	insert into CHAMP_ANNOTATION (nom, data_type_id, table_annotation_id, combine, ordre, edit) 
		values ('Commentaires operatoire', 6, (select max(table_annotation_id) from TABLE_ANNOTATION), 0, 2, 1);

	insert into TABLE_ANNOTATION_BANQUE select max(t.table_annotation_id), max(b.banque_id), 1 from TABLE_ANNOTATION t, BANQUE b where b.plateforme_id = maxPfId;

	-- TABLE ECHANTILLON
	insert into TABLE_ANNOTATION (nom, description, entite_id, catalogue_id, plateforme_id) 
		values ('Annotations labo', 'Table demonstration', 3, null, maxPfId);
	
	-- Electrophorese fichier
	insert into CHAMP_ANNOTATION (nom, data_type_id, table_annotation_id, combine, ordre, edit) 
		values ('Electrophorèse', 8, (select max(table_annotation_id) from TABLE_ANNOTATION), 0, 1, 1);

	-- Catalogue lien
	insert into CHAMP_ANNOTATION (nom, data_type_id, table_annotation_id, combine, ordre, edit) 
		values ('Lien catalogue', 9, (select max(table_annotation_id) from TABLE_ANNOTATION), 0, 2, 1);

	insert into TABLE_ANNOTATION_BANQUE select max(t.table_annotation_id), max(b.banque_id), 1 from TABLE_ANNOTATION t, BANQUE b where b.plateforme_id = maxPfId;

	-- TABLE DERIVE
	insert into TABLE_ANNOTATION (nom, description, entite_id, catalogue_id, plateforme_id) 
		values ('Annotations genomiques', 'Table demonstration', 8, null, maxPfId);
	
	-- Apps utilisé thesM
	insert into CHAMP_ANNOTATION (nom, data_type_id, table_annotation_id, combine, ordre, edit) 
		values ('Appareils utilisés', 10, (select max(table_annotation_id) from TABLE_ANNOTATION), 0, 2, 1);
	insert into ITEM (label, champ_annotation_id) values ('Microarray', (select max(champ_annotation_id) from CHAMP_ANNOTATION)),
	('NGS', (select max(champ_annotation_id) from CHAMP_ANNOTATION)),
	('PCR', (select max(champ_annotation_id) from CHAMP_ANNOTATION));

	-- Date contrôle date
	insert into CHAMP_ANNOTATION (nom, data_type_id, table_annotation_id, combine, ordre, edit) 
		values ('Date contrôle', 3, (select max(table_annotation_id) from TABLE_ANNOTATION), 0, 1, 1);

	insert into TABLE_ANNOTATION_BANQUE select max(t.table_annotation_id), max(b.banque_id), 1 from TABLE_ANNOTATION t, BANQUE b where b.plateforme_id = maxPfId;
	

	alter table ANNOTATION_VALEUR modify annotation_valeur_id int(10) NOT NULL;-- enleve l'auto_increment
	alter table ITEM modify ITEM_ID int(10) NOT NULL;-- enleve l'auto_increment
	alter table CHAMP_ANNOTATION modify CHAMP_ANNOTATION_ID int(10) NOT NULL;-- enleve l'auto_increment



END!
DELIMITER ;
