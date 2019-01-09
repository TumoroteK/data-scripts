delimiter $$

DROP PROCEDURE IF EXISTS `drop_pf`;
CREATE PROCEDURE `drop_pf`(IN _pfId INTEGER)
BEGIN

	set @version = (select version from VERSION where version_id = (select max(version_id) from VERSION));

	-- annotations
	delete from FICHIER where fichier_id in (select fichier_id from ANNOTATION_VALEUR where banque_id in (select banque_id from BANQUE where plateforme_id = _pfId));
	delete from ANNOTATION_VALEUR where banque_id in (select banque_id from BANQUE where plateforme_id = _pfId);
	-- derives
	delete from PROD_DERIVE where banque_id in (select banque_id from BANQUE where plateforme_id = _pfId);
	delete from RETOUR where entite_id=8 and objet_id not in (select prod_derive_id from PROD_DERIVE);
	delete from OBJET_NON_CONFORME where entite_id=8 and objet_id not in (select prod_derive_id from PROD_DERIVE);
	delete from EMPLACEMENT where entite_id=8 and objet_id not in (select prod_derive_id from PROD_DERIVE);
	delete from CEDER_OBJET where entite_id=8 and objet_id not in (select prod_derive_id from PROD_DERIVE);
	delete from OPERATION where entite_id=8 and objet_id not in (select prod_derive_id from PROD_DERIVE); 

	select('derive suppr');

	-- echantillons
	delete from CODE_ASSIGNE where echantillon_id in (select echantillon_id from ECHANTILLON where banque_id in (select banque_id from BANQUE where plateforme_id = _pfId));
	delete from ECHANTILLON where banque_id in (select banque_id from BANQUE where plateforme_id = _pfId);
	-- stockable objs
	delete from RETOUR where entite_id=3 and objet_id not in (select echantillon_id from ECHANTILLON);
	delete from OBJET_NON_CONFORME where entite_id=3 and objet_id not in (select echantillon_id from ECHANTILLON);
	delete from EMPLACEMENT where entite_id=3 and objet_id not in (select echantillon_id from ECHANTILLON); 
	delete from CEDER_OBJET where entite_id=3 and objet_id not in (select echantillon_id from ECHANTILLON); 
	delete from OPERATION where entite_id=3 and objet_id not in (select echantillon_id from ECHANTILLON); 

	delete from TRANSFORMATION where transformation_id not in (select transformation_id from PROD_DERIVE);

	select('echantillon suppr');

	-- cession
	delete from CESSION where banque_id in (select banque_id from BANQUE where plateforme_id = _pfId);
	delete from OPERATION where entite_id=5 and objet_id not in (select cession_id from CESSION);

	select('cession suppr'); 

	-- isolement des ids maladies ne contenant que des prels appartenant à cette PF
	create temporary table maladieToDel (maladie_id int(10) not null, primary key (maladie_id));
	-- cette requete ne passera pas en Oracle?
	insert into maladieToDel select distinct zz1.maladie_id from (select p.maladie_id from MALADIE m join PRELEVEMENT p on m.maladie_id=p.maladie_id join BANQUE b on b.banque_id=p.banque_id group by maladie_id having count(distinct b.plateforme_id) = 1) zz join (select maladie_id from PRELEVEMENT p join BANQUE b on b.banque_id=p.banque_id where b.plateforme_id = _pfId) zz1 on zz.maladie_id=zz1.maladie_id; 

	-- prelevement
	delete from LABO_INTER where prelevement_id in (select prelevement_id from PRELEVEMENT where banque_id in (select banque_id from BANQUE where plateforme_id = _pfId));
	delete from PRELEVEMENT_RISQUE where prelevement_id in (select prelevement_id from PRELEVEMENT where banque_id in (select banque_id from BANQUE where plateforme_id = _pfId)); 
	delete from PRELEVEMENT where banque_id in (select banque_id from BANQUE where plateforme_id = _pfId);
	delete from OBJET_NON_CONFORME where entite_id=2 and objet_id not in (select prelevement_id from PRELEVEMENT);
	delete from OPERATION where entite_id=2 and objet_id not in (select prelevement_id from PRELEVEMENT);

	select('prelevement suppr'); 

	-- maladie
	delete from MALADIE_MEDECIN where maladie_id in (select maladie_id from maladieToDel);
	delete from MALADIE where maladie_id in (select maladie_id from maladieToDel);
	delete from OPERATION where entite_id=7 and objet_id not in (select maladie_id from MALADIE); 

	select('maladie suppr');

	-- patient suppr tous patients ne referencant plus aucune maladie!
	create temporary table patientToDel (patient_id int(10) not null, primary key(patient_id));
	insert patientToDel select distinct patient_id from PATIENT where patient_id not in (select patient_id from MALADIE) and patient_id not in (select objet_id from ANNOTATION_VALEUR v join CHAMP_ANNOTATION c on c.champ_annotation_id=v.champ_annotation_id join TABLE_ANNOTATION t on t.table_annotation_id=c.table_annotation_id where t.entite_id = 1);
	delete from PATIENT_MEDECIN where patient_id in (select patient_id from patientToDel);
	delete from PATIENT where patient_id in (select patient_id from patientToDel);
	delete from OPERATION where entite_id=1 and objet_id not in (select patient_id from PATIENT);

	drop table maladieToDel;
	drop table patientToDel;
	select('patient suppr');

	-- stockage
	update EMPLACEMENT set vide=1, entite_id=null, objet_id=null where entite_id=3 and objet_id not in (select echantillon_id from ECHANTILLON); -- must be 0
	update EMPLACEMENT set vide=1, entite_id=null, objet_id=null where entite_id=8 and objet_id not in (select prod_derive_id from PROD_DERIVE); -- must be 0
	
	-- -------------------------------------------------------------------------------------------------------
	-- REVOIR la copie des types ENCEINTE si conteneur partagé!!
 	-- car PF récupérant le conteneur ne définit pas les types !!!	
	-- copie enceinte_type avant suppr conteneur plateforme
	-- en attendant supprimer manuellement les partages de conteneur avant delete PF OU definir enceinte type 
	-- dans PF receptrcie
	-- -------------------------------------------------------------------------------------------------------


--	alter table ENCEINTE_TYPE modify enceinte_type_id int(10) not null auto_increment;
--	insert into ENCEINTE_TYPE (type, plateforme_id) select t.type, p.plateforme_id from CONTENEUR c join CONTENEUR_PLATEFORME p on p.conteneur_id=c.conteneur_id join ENCEINTE_TYPE t on p.plateforme_id=t.plateforme_id where c.plateforme_orig_id = _pfId;
--	alter table ENCEINTE_TYPE modify enceinte_type_id int(10) not null;
	
	-- attention partage de conteneurs -> attribution au hasard de pf_orig à une pf partagée
	update CONTENEUR c join CONTENEUR_PLATEFORME p on p.conteneur_id=c.conteneur_id set c.plateforme_orig_id = p.plateforme_id where c.plateforme_orig_id = _pfId;

	update ENCEINTE e join (select e.enceinte_id, zz.enceinte_type_id from ENCEINTE e join CONTENEUR c on c.conteneur_id = e.conteneur_id join ENCEINTE_TYPE t on t.enceinte_type_id=e.enceinte_type_id join ENCEINTE_TYPE zz on zz.type=t.type and zz.plateforme_id=c.plateforme_orig_id where t.plateforme_id = _pfId) yy on yy.enceinte_id=e.enceinte_id set e.enceinte_type_id=yy.enceinte_type_id;
	-- 2eme niveau 
	update ENCEINTE e join (select e.enceinte_id, zz.enceinte_type_id from ENCEINTE e join ENCEINTE p on e.enceinte_pere_id=p.enceinte_id join CONTENEUR c on c.conteneur_id = p.conteneur_id join ENCEINTE_TYPE t on t.enceinte_type_id=e.enceinte_type_id join ENCEINTE_TYPE zz on zz.type=t.type and zz.plateforme_id=c.plateforme_orig_id where t.plateforme_id = _pfId) yy on yy.enceinte_id=e.enceinte_id set e.enceinte_type_id=yy.enceinte_type_id;


	delete from CONTENEUR_PLATEFORME where plateforme_id = _pfId;
	delete from CONTENEUR_BANQUE where banque_id in (select banque_id from BANQUE where plateforme_id = _pfId);
	delete from ENCEINTE_BANQUE where banque_id in (select banque_id from BANQUE where plateforme_id = _pfId);

	-- conteneur by supp foreign key
	-- select count(emplacement_id) from EMPLACEMENT where objet_id is not null and get_conteneur(emplacement_id) in (select conteneur_id from CONTENEUR where plateforme_orig_id = _pfId); -- must be 0
	delete from INCIDENT where conteneur_id in (select conteneur_id from CONTENEUR where plateforme_orig_id = _pfId);
	alter table ENCEINTE drop foreign key FK_ENCEINTE_CONTENEUR_ID;
	delete from CONTENEUR where plateforme_orig_id = _pfId;
	alter table ENCEINTE drop foreign key FK_ENCEINTE_ENCEINTE_PERE_ID;
	alter table TERMINALE drop foreign key FK_TERMINALE_ENCEINTE_ID;
	-- 1er niveau enceinte
	delete from INCIDENT where enceinte_id in (select enceinte_id from ENCEINTE where conteneur_id is not null and conteneur_id not in (select conteneur_id from CONTENEUR));
	delete from ENCEINTE where conteneur_id is not null and conteneur_id not in (select conteneur_id from CONTENEUR);
	-- niveaux infs -> jusque 0
	create temporary table enceinteToDel (enceinte_id int(10) not null, primary key(enceinte_id));
	insert into enceinteToDel select distinct enceinte_id from ENCEINTE where enceinte_pere_id is not null and enceinte_pere_id not in (select enceinte_id from ENCEINTE);
	delete from INCIDENT where enceinte_id in (select enceinte_id from enceinteToDel);
	delete from ENCEINTE where enceinte_id in (select enceinte_id from enceinteToDel);
	-- 3eme niveau
	truncate table enceinteToDel;
	insert into enceinteToDel select distinct enceinte_id from ENCEINTE where enceinte_pere_id is not null and enceinte_pere_id not in (select enceinte_id from ENCEINTE);
	delete from INCIDENT where enceinte_id in (select enceinte_id from enceinteToDel);
	delete from ENCEINTE where enceinte_id in (select enceinte_id from enceinteToDel);
	-- 4eme niveau
	truncate table enceinteToDel;
	insert into enceinteToDel select distinct enceinte_id from ENCEINTE where enceinte_pere_id is not null and enceinte_pere_id not in (select enceinte_id from ENCEINTE);
	delete from INCIDENT where enceinte_id in (select enceinte_id from enceinteToDel);
	delete from ENCEINTE where enceinte_id in (select enceinte_id from enceinteToDel);

	delete from INCIDENT where terminale_id in (select terminale_id from TERMINALE where enceinte_id not in (select enceinte_id from ENCEINTE));
	delete from EMPLACEMENT where terminale_id in (select terminale_id from TERMINALE where enceinte_id not in (select enceinte_id from ENCEINTE));
	delete from TERMINALE where enceinte_id not in (select enceinte_id from ENCEINTE);

	delete from OPERATION where entite_id=10 and objet_id not in (select conteneur_id from CONTENEUR);
	delete from OPERATION where entite_id=57 and objet_id not in (select enceinte_id from ENCEINTE);
	delete from OPERATION where entite_id=56 and objet_id not in (select terminale_id from TERMINALE);

	-- retablissement contraintes
	ALTER TABLE ENCEINTE ADD CONSTRAINT FK_ENCEINTE_CONTENEUR_ID FOREIGN KEY (CONTENEUR_ID) REFERENCES CONTENEUR (CONTENEUR_ID);
	ALTER TABLE ENCEINTE ADD CONSTRAINT FK_ENCEINTE_ENCEINTE_PERE_ID FOREIGN KEY (ENCEINTE_PERE_ID) REFERENCES ENCEINTE (ENCEINTE_ID);
	ALTER TABLE TERMINALE ADD CONSTRAINT FK_TERMINALE_ENCEINTE_ID FOREIGN KEY (ENCEINTE_ID) REFERENCES ENCEINTE (ENCEINTE_ID);

	drop table enceinteToDel;
	select('stockage structures suppr');

	-- champ
	create temporary table champToDel (champ_id int(10) not null, primary key (champ_id));
	insert into champToDel select distinct champ_id from CHAMP where champ_id in (select champ_id from IMPORT_COLONNE where import_template_id in (select import_template_id from IMPORT_TEMPLATE where banque_id in (select banque_id from BANQUE where plateforme_id = _pfId)));
	insert into champToDel select distinct champ_id from CHAMP where champ_id in (select champ_id from CHAMP_LIGNE_ETIQUETTE where ligne_etiquette_id in (select ligne_etiquette_id from LIGNE_ETIQUETTE where modele_id in (select modele_id from MODELE where plateforme_id = _pfId)));

	-- imports
	delete from IMPORTATION where import_historique_id in (select import_historique_id from IMPORT_HISTORIQUE where import_template_id in (select import_template_id from IMPORT_TEMPLATE where banque_id in (select banque_id from BANQUE where plateforme_id = _pfId)));
	delete from IMPORT_HISTORIQUE where import_template_id in (select import_template_id from IMPORT_TEMPLATE where banque_id in (select banque_id from BANQUE where plateforme_id = _pfId));
	delete from CHAMP where champ_id in (select champ_id from IMPORT_COLONNE where import_template_id in (select import_template_id from IMPORT_TEMPLATE where banque_id in (select banque_id from BANQUE where plateforme_id = _pfId)));
	delete from IMPORT_COLONNE where import_template_id in (select import_template_id from IMPORT_TEMPLATE where banque_id in (select banque_id from BANQUE where plateforme_id = _pfId));
	delete from IMPORT_TEMPLATE_ENTITE where import_template_id in (select import_template_id from IMPORT_TEMPLATE where banque_id in (select banque_id from BANQUE where plateforme_id = _pfId));
	delete from IMPORT_TEMPLATE where banque_id in (select banque_id from BANQUE where plateforme_id = _pfId);

	select('imports suppr');

	-- imprimantes
	delete from AFFECTATION_IMPRIMANTE where imprimante_id in (select imprimante_id from IMPRIMANTE where plateforme_id = _pfId); 
	delete from IMPRIMANTE where plateforme_id = _pfId;

	-- modele
	delete from CHAMP_LIGNE_ETIQUETTE where ligne_etiquette_id in (select ligne_etiquette_id from LIGNE_ETIQUETTE where modele_id in (select modele_id from MODELE where plateforme_id = _pfId));
	delete from LIGNE_ETIQUETTE where modele_id in (select modele_id from MODELE where plateforme_id = _pfId);
	delete from AFFECTATION_IMPRIMANTE where modele_id in (select modele_id from MODELE where plateforme_id = _pfId); 
	delete from MODELE where plateforme_id = _pfId;

	select('imprimantes suppr');

	-- impression
	delete from CHAMP_IMPRIME where template_id in (select template_id from TEMPLATE where banque_id in (select banque_id from BANQUE where plateforme_id = _pfId));
	delete from BLOC_IMPRESSION_TEMPLATE where template_id in (select template_id from TEMPLATE where banque_id in (select banque_id from BANQUE where plateforme_id = _pfId));
	delete from TABLE_ANNOTATION_TEMPLATE where template_id in (select template_id from TEMPLATE where banque_id in (select banque_id from BANQUE where plateforme_id = _pfId));	
	delete from TEMPLATE where banque_id in (select banque_id from BANQUE where plateforme_id = _pfId);

	select('impressions suppr');

	-- numerotation
	delete from NUMEROTATION where banque_id in (select banque_id from BANQUE where plateforme_id = _pfId);

	-- champ: delete champ utilisé dans import + ligne etiquettes
	delete from CHAMP where champ_id in (select champ_id from champToDel);

	drop table champToDel;


	-- recherche by utilisateur appartenant pf + delete foreign key 
	alter table RECHERCHE drop foreign key FK_RECHERCHE_AFFICHAGE_ID;
	alter table RECHERCHE drop foreign key FK_RECHERCHE_REQUETE_ID;
	delete from RECHERCHE_BANQUE where banque_id in (select banque_id from BANQUE where plateforme_id = _pfId);
	delete from AFFICHAGE where banque_id in (select banque_id from BANQUE where plateforme_id = _pfId);
	delete from RECHERCHE where affichage_id not in (select affichage_id from AFFICHAGE);
	delete from REQUETE where banque_id in (select banque_id from BANQUE where plateforme_id = _pfId);
	delete from RECHERCHE where requete_id not in (select requete_id from REQUETE);
	delete from GROUPEMENT where parent_id is null and groupement_id not in (select groupement_racine_id from REQUETE);
	create temporary table groupementToDel (groupement_id int(10) not null, primary key(groupement_id));
	insert into groupementToDel select distinct groupement_id from GROUPEMENT where parent_id is not null and parent_id not in (select groupement_id from GROUPEMENT);
	delete from GROUPEMENT where groupement_id in (select groupement_id from groupementToDel);
	-- 2eme niveau jusque 0
	insert into groupementToDel select distinct groupement_id from GROUPEMENT where parent_id is not null and parent_id not in (select groupement_id from GROUPEMENT);
	delete from GROUPEMENT where groupement_id in (select groupement_id from groupementToDel);
	-- critere + champ en cascade
	-- insert into champToDel select champ_id from CRITERE where critere_id not in (select critere1_id from GROUPEMENT UNION select critere2_id from GROUPEMENT);
	ALTER TABLE RECHERCHE ADD CONSTRAINT FK_RECHERCHE_AFFICHAGE_ID FOREIGN KEY (AFFICHAGE_ID) REFERENCES AFFICHAGE (AFFICHAGE_ID);	
        ALTER TABLE RECHERCHE ADD CONSTRAINT FK_RECHERCHE_REQUETE_ID FOREIGN KEY (REQUETE_ID) REFERENCES REQUETE (REQUETE_ID);

	drop table groupementToDel;
	select('recherches suppr');

	-- annotations
	delete from ANNOTATION_DEFAUT where banque_id in (select banque_id from BANQUE where plateforme_id = _pfId);
	delete from ITEM where champ_annotation_id in (select champ_annotation_id from CHAMP_ANNOTATION where table_annotation_id in (select table_annotation_id from TABLE_ANNOTATION where plateforme_id = _pfId));		
	delete from CHAMP_ANNOTATION where table_annotation_id in (select table_annotation_id from TABLE_ANNOTATION where plateforme_id = _pfId);
	delete from TABLE_ANNOTATION_BANQUE where table_annotation_id in (select table_annotation_id from TABLE_ANNOTATION where plateforme_id = _pfId);
	delete from TABLE_ANNOTATION where plateforme_id = _pfId;

	select('annotations suppr');
	
	-- thesaurii
	delete from COULEUR_ENTITE_TYPE where banque_id in (select banque_id from BANQUE where plateforme_id = _pfId);
	delete from NON_CONFORMITE where plateforme_id = _pfId;
	delete from NATURE where plateforme_id = _pfId;
	delete from RISQUE where plateforme_id = _pfId;
	delete from PRELEVEMENT_TYPE where plateforme_id = _pfId;
	delete from CONDIT_TYPE where plateforme_id = _pfId;
	delete from CONDIT_MILIEU where plateforme_id = _pfId;
	delete from CONSENT_TYPE where plateforme_id = _pfId;
	delete from ECHANTILLON_TYPE where plateforme_id = _pfId;
	delete from ECHAN_QUALITE where plateforme_id = _pfId;
	delete from MODE_PREPA where plateforme_id = _pfId;
	delete from PROD_TYPE where plateforme_id = _pfId;
	delete from PROD_QUALITE where plateforme_id = _pfId;
	delete from MODE_PREPA_DERIVE where plateforme_id = _pfId;
	delete from CESSION_EXAMEN where plateforme_id = _pfId;
	delete from DESTRUCTION_MOTIF where plateforme_id = _pfId;
	delete from PROTOCOLE_TYPE where plateforme_id = _pfId;
	delete from CONTENEUR_TYPE where plateforme_id = _pfId;
	delete from ENCEINTE_TYPE where plateforme_id = _pfId;
	delete from PROTOCOLE where plateforme_id = _pfId;

	-- migration enceinte_type conteneur partagé
	select('thesaurii suppr');

	-- codes 
	update CODE_UTILISATEUR set code_parent_id = null where utilisateur_id in (select utilisateur_id from UTILISATEUR where plateforme_orig_id = _pfId);
	delete from TRANSCODE_UTILISATEUR where code_utilisateur_id in (select code_utilisateur_id from CODE_UTILISATEUR where utilisateur_id in (select utilisateur_id from UTILISATEUR where plateforme_orig_id = _pfId));
	delete from CODE_SELECT where utilisateur_id in (select utilisateur_id from UTILISATEUR where plateforme_orig_id = _pfId);
	delete from CODE_SELECT where banque_id in (select banque_id from BANQUE where plateforme_id = _pfId);
	delete from CODE_UTILISATEUR where utilisateur_id in (select utilisateur_id from UTILISATEUR where plateforme_orig_id = _pfId);
	-- delete from CODE_DOSSIER where dossier_parent_id is null and utilisateur_id in (select utilisateur_id from UTILISATEUR where plateforme_orig_id = _pfId);
	delete from CODE_DOSSIER where banque_id in (select banque_id from BANQUE where plateforme_id = _pfId);

	-- utilisateur
	delete from PROFIL_UTILISATEUR where banque_id in (select banque_id from BANQUE where plateforme_id = _pfId);
	delete from PROFIL_UTILISATEUR where utilisateur_id in (select utilisateur_id from UTILISATEUR where plateforme_orig_id = _pfId);
	delete from OPERATION where utilisateur_id in (select utilisateur_id from UTILISATEUR where plateforme_orig_id = _pfId);
	delete from AFFECTATION_IMPRIMANTE where utilisateur_id in (select utilisateur_id from UTILISATEUR where plateforme_orig_id = _pfId);
	delete from PLATEFORME_ADMINISTRATEUR where utilisateur_id in (select utilisateur_id from UTILISATEUR where plateforme_orig_id = _pfId);
	delete from RESERVATION where utilisateur_id in (select utilisateur_id from UTILISATEUR where plateforme_orig_id = _pfId);
	delete from UTILISATEUR where plateforme_orig_id = _pfId;

	-- profils IF version >= 2.1.0
	IF @version not like '2.0.%' THEN 
		delete from DROIT_OBJET where profil_id in (select profil_id from PROFIL where plateforme_id = _pfId);
		delete from PROFIL where plateforme_id = _pfId;
	END IF;

	select('utilisateurs/profils suppr');	

	-- contrat
	delete from CONTRAT where plateforme_id = _pfId;

	-- stats
	-- profils IF version >= 2.1.0
	IF @version not like '2.0.%' THEN 
		delete from STATS_MODELE_INDICATEUR where stats_modele_id in (select stats_modele_id from STATS_MODELE where plateforme_id = _pfId);
		delete from STATS_MODELE_BANQUE where stats_modele_id in (select stats_modele_id from STATS_MODELE where plateforme_id = _pfId);
		delete from STATS_MODELE where plateforme_id = _pfId;
	END IF;

	-- banque
	delete from COULEUR_ENTITE_TYPE where banque_id in (select banque_id from BANQUE where plateforme_id = _pfId);
	delete from BANQUE_CATALOGUE where banque_id in (select banque_id from BANQUE where plateforme_id = _pfId);
	delete from BANQUE_TABLE_CODAGE where banque_id in (select banque_id from BANQUE where plateforme_id = _pfId);
	delete from TABLE_ANNOTATION_BANQUE where banque_id in (select banque_id from BANQUE where plateforme_id = _pfId);
	delete from BANQUE where plateforme_id = _pfId;

	-- plateforme
	delete from PLATEFORME_ADMINISTRATEUR where plateforme_id = _pfId;
	delete from PLATEFORME where plateforme_id = _pfId;

	select('banques suppr');	
	


END$$

