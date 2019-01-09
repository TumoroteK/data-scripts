DROP PROCEDURE IF EXISTS `drop_pf`;
CREATE PROCEDURE `drop_pf`(IN 1 INTEGER)
BEGIN
	-- annotations
	delete from FICHIER where fichier_id in (select fichier_id from ANNOTATION_VALEUR where banque_id in (select banque_id from PLATEFORME where plateforme_id = 1));
	delete from ANNOTATION_VALEUR where banque_id in (select banque_id from PLATEFORME where plateforme_id = 1);

	-- derives
	delete from PROD_DERIVE where banque_id in (select banque_id from PLATEFORME where plateforme_id = 1);
	delete from RETOUR where entite_id=8 and objet_id not in (select prod_derive_id from PROD_DERIVE);
	delete from OBJET_NON_CONFORME where entite_id=8 and objet_id not in (select prod_derive_id from PROD_DERIVE);
	delete from EMPLACEMENT where entite_id=8 and objet_id not in (select prod_derive_id from PROD_DERIVE);
	delete from CEDER_OBJET where entite_id=8 and objet_id not in (select prod_derive_id from PROD_DERIVE);
	delete from OPERATION where entite_id=8 and objet_id not in (select prod_derive_id from PROD_DERIVE); 
	delete from TRANSFORMATION where transformation_id not in (select transformation_id from PROD_DERIVE);

	-- echantillons
	delete from CODE_ASSIGNE where echantillon_id in (select echantillon_id from ECHANTILLON where banque_id in (select banque_id from PLATEFORME where plateforme_id = 1));
	delete from ECHANTILLON where banque_id in (select banque_id from PLATEFORME where plateforme_id = 1);
	-- stockable objs
	delete from RETOUR where entite_id=3 and objet_id not in (select echantillon_id from ECHANTILLON);
	delete from OBJET_NON_CONFORME where entite_id=3 and objet_id not in (select echantillon_id from ECHANTILLON);
	delete from EMPLACEMENT where entite_id=3 and objet_id not in (select echantillon_id from ECHANTILLON); 
	delete from CEDER_OBJET where entite_id=3 and objet_id not in (select echantillon_id from ECHANTILLON); 
	delete from OPERATION where entite_id=3 and objet_id not in (select echantillon_id from ECHANTILLON); 

	-- cession
	delete from CESSION where banque_id in (select banque_id from PLATEFORME where plateforme_id = 1);
	delete from OPERATION where entite_id=5 and objet_id not in (select cession_id from CESSION); 

	-- isolement des ids maladies ne contenant que des prels appartenant à cette PF
	create temporary table maladieToDel (maladie_id int(10) not null, primary key(maladie_id));
	-- cette requete ne passera pas en Oracle?
	insert into maladieToDel select zz1.maladie_id from (select p.maladie_id from MALADIE m join PRELEVEMENT p on m.maladie_id=p.maladie_id join BANQUE b on b.banque_id=p.banque_id group by maladie_id having count(distinct b.plateforme_id) = 1) zz join (select maladie_id from PRELEVEMENT p join BANQUE b on b.banque_id=p.banque_id where b.plateforme_id = 1) zz1 on zz.maladie_id=zz1.maladie_id; 

	-- prelevement
	delete from LABO_INTER where prelevement_id in (select prelevement_id from PRELEVEMENT where banque_id in (select banque_id from PLATEFORME where plateforme_id = 1));
	delete from PRELEVEMENT_RISQUE where prelevement_id in (select prelevement_id from PRELEVEMENT where banque_id in (select banque_id from PLATEFORME where plateforme_id = 1)); 
	delete from PRELEVEMENT where banque_id in (select banque_id from PLATEFORME where plateforme_id = 1);
	delete from OBJET_NON_CONFORME where entite_id=2 and objet_id not in (select prelevement_id from PRELEVEMENT);
	delete from OPERATION where entite_id=2 and objet_id not in (select prelevement_id from PRELEVEMENT); 

	-- maladie
	delete from MALADIE_MEDECIN where maladie_id in (select maladie_id from maladieToDel);
	delete from MALADIE where maladie_id in (select maladie_id from maladieToDel);
	delete from OPERATION where entite_id=7 and objet_id not in (select maladie_id from MALADIE); 

	-- patient suppr tous patients ne referencant plus aucune maladie!
	create temporary table patientToDel (patient_id int(10) not null, primary key(patient_id));
	insert patientToDel select patient_id from PATIENT where patient_id not in (select patient_id from MALADIE) and patient_id not in (select objet_id from ANNOTATION_VALEUR v join CHAMP_ANNOTATION c on c.champ_annotation_id=v.champ_annotation_id join TABLE_ANNOTATION t on t.table_annotation_id=c.table_annotation_id where t.entite_id = 1);
	delete from PATIENT_MEDECIN where patient_id in (select patient_id from patientToDel);
	delete from PATIENT where patient_id in (select patient_id from patientToDel);
	delete from OPERATION where entite_id=1 and objet_id not in (select patient_id from PATIENT);

	-- stockage
	update EMPLACEMENT set vide=1, entite_id=null, objet_id=null where entite_id=3 and objet_id not in (select echantillon_id from ECHANTILLON);
	update EMPLACEMENT set vide=1, entite_id=null, objet_id=null where entite_id=8 and objet_id not in (select prod_derive_id from PROD_DERIVE);
	-- attention partage de conteneurs!
	update CONTENEUR c join CONTENEUR_PLATEFORME p on p.conteneur_id=c.conteneur_id set c.plateforme_orig_id = p.plateforme_id where c.plateforme_orig_id = 1;
	delete from CONTENEUR_PLATEFORME where plateforme_id = 1;
	delete from CONTENEUR_BANQUE where banque_id in (select banque_id from BANQUE where plateforme_id = 1);
	delete from ENCEINTE_BANQUE where banque_id in (select banque_id from BANQUE where plateforme_id = 1);

	-- mysql delete conteneur cascade???? + delete INCIDENT

	-- champ
	create table champToDel (champ_id int(10) not null, primary key (champ_id));
	insert into champToDel select champ_id from CHAMP where champ_id in (select champ_id from IMPORT_COLONNE where import_template_id in (select import_template_id from IMPORT_TEMPLATE where banque_id in (select banque_id from BANQUE where plateforme_id = 1)));
	insert into champToDel select champ_id from CHAMP where champ_id in (select champ_id from CHAMP_LIGNE_ETIQUETTE where ligne_etiquette_id in (select ligne_etiquette_id from LIGNE_ETIQUETTE where modele_id in (select modele_id from MODELE where plateforme_id = 1)));

	-- imports
	delete from IMPORTATION where import_historique_id in (select import_historique_id from IMPORT_HISTORIQUE where import_template_id in (select import_template_id from IMPORT_TEMPLATE where banque_id in (select banque_id from BANQUE where plateforme_id = 1)));
	delete from IMPORT_HISTORIQUE where import_template_id in (select import_template_id from IMPORT_TEMPLATE where banque_id in (select banque_id from BANQUE where plateforme_id = 1));
	delete from IMPORT_COLONNE where import_template_id in (select import_template_id from IMPORT_TEMPLATE where banque_id in (select banque_id from BANQUE where plateforme_id = 1));
	delete from IMPORT_TEMPLATE_ENTITE where import_template_id in (select import_template_id from IMPORT_TEMPLATE where banque_id in (select banque_id from BANQUE where plateforme_id = 1));
	delete from IMPORT_TEMPLATE where banque_id in (select banque_id from BANQUE where plateforme_id = 1);

	-- imprimantes
	delete from AFFECTATION_IMPRIMANTE where imprimante_id in (select imprimante_id from IMPRIMANTE where plateforme_id = 1); 
	delete from IMPRIMANTE where plateforme_id = 1;

	-- modele
	delete from CHAMP_LIGNE_ETIQUETTE where ligne_etiquette_id in (select ligne_etiquette_id from LIGNE_ETIQUETTE where modele_id in (select modele_id from MODELE where plateforme_id = 1));
	delete from LIGNE_ETIQUETTE where modele_id in (select modele_id from MODELE where plateforme_id = 1);
	delete from AFFECTATION_IMPRIMANTE where modele_id in (select modele_id from MODELE where plateforme_id = 1); 
	delete from MODELE where plateforme_id = 1;

	-- impression
	delete from CHAMP_IMPRIME where template_id in (select template_id from TEMPLATE where banque_id in (select banque_id from BANQUE where plateforme_id = 1));
	delete from BLOC_IMPRESSION_TEMPLATE where template_id in (select template_id from TEMPLATE where banque_id in (select banque_id from BANQUE where plateforme_id = 1));
	delete from TABLE_ANNOTATION_TEMPLATE where template_id in (select template_id from TEMPLATE where banque_id in (select banque_id from BANQUE where plateforme_id = 1));	
	delete from TEMPLATE where banque_id in (select banque_id from BANQUE where plateforme_id = 1);

	-- numerotation
	delete from NUMEROTATION where banque_id in (select banque_id from BANQUE where plateforme_id = 1);

	delete from CHAMP where champ_id not in (select champ_id from IMPORT_COLONNE) and champ_id not in (select champ_id from CHAMP_LIGNE_ETIQUETTE) and champ_id not in (select champ_id from AFFICHAGE) and champ_id not in (select champ_id from CRITERE);

	-- annotations
	delete from ITEM where champ_annotation_id in (select champ_annotation_id from CHAMP_ANNOTATION where table_annotation_id in (select table_annotation_id from TABLE_ANNOTATION where plateforme_id = 1));
	delete from ANNOTATION_DEFAUT where champ_annotation_id in (select champ_annotation_id from CHAMP_ANNOTATION where table_annotation_id in (select table_annotation_id from TABLE_ANNOTATION where plateforme_id = 1));
	delete from CRITERE where champ_id in (select champ_id from CHAMP where champ_annotation_id in (select champ_annotation_id from CHAMP_ANNOTATION where table_annotation_id in (select table_annotation_id from TABLE_ANNOTATION where plateforme_id = 1)));
	delete from RESULTAT where champ_id in (select champ_id from CHAMP where champ_annotation_id in (select champ_annotation_id from CHAMP_ANNOTATION where table_annotation_id in (select table_annotation_id from TABLE_ANNOTATION where plateforme_id = 1)));
	delete from CHAMP where champ_annotation_id in (select champ_annotation_id from CHAMP_ANNOTATION where table_annotation_id in (select table_annotation_id from TABLE_ANNOTATION where plateforme_id = 1));	
	delete from CHAMP_ANNOTATION where table_annotation_id in (select table_annotation_id from TABLE_ANNOTATION where plateforme_id = 1);
	delete from TABLE_ANNOTATION_BANQUE where table_annotation_id in (select table_annotation_id from TABLE_ANNOTATION where plateforme_id = 1);
	delete from TABLE_ANNOTATION where plateforme_id = 1;
	
	delete from COULEUR_ENTITE_TYPE where banque_id in (select banque_id from BANQUE where plateforme_id = 1);
	
	-- thesaurii
	delete from NON_CONFORMITE where plateforme_id = 1;
	delete from NATURE where plateforme_id = 1;
	delete from RISQUE where plateforme_id = 1;
	delete from PRELEVEMENT_TYPE where plateforme_id = 1;
	delete from CONDIT_TYPE where plateforme_id = 1;
	delete from CONDIT_MILIEU where plateforme_id = 1;
	delete from CONSENT_TYPE where plateforme_id = 1;
	delete from ECHANTILLON_TYPE where plateforme_id = 1;
	delete from ECHAN_QUALITE where plateforme_id = 1;
	delete from MODE_PREPA where plateforme_id = 1;
	delete from PROD_TYPE where plateforme_id = 1;
	delete from PROD_QUALITE where plateforme_id = 1;
	delete from MODE_PREPA_DERIVE where plateforme_id = 1;
	delete from CESSION_EXAMEN where plateforme_id = 1;
	delete from DESTRUCTION_MOTIF where plateforme_id = 1;
	delete from PROTOCOLE_TYPE where plateforme_id = 1;
	delete from CONTENEUR_TYPE where plateforme_id = 1;


	-- migration enceinte_type conteneur partagé
	update ENCEINTE e join (select e.enceinte_id, zz.enceinte_type_id from ENCEINTE e join CONTENEUR c on c.conteneur_id = e.conteneur_id join ENCEINTE_TYPE t on t.enceinte_type_id=e.enceinte_type_id join ENCEINTE_TYPE zz on zz.type=t.type and zz.plateforme_id=c.plateforme_orig_id where t.plateforme_id = _pfId) yy on yy.enceinte_id=e.enceinte_id set e.enceinte_type_id=yy.enceinte_type_id;
	-- 2eme niveau 
	update ENCEINTE e join (select e.enceinte_id, zz.enceinte_type_id from ENCEINTE e join ENCEINTE p on e.enceinte_pere_id=p.enceinte_id join CONTENEUR c on c.conteneur_id = p.conteneur_id join ENCEINTE_TYPE t on t.enceinte_type_id=e.enceinte_type_id join ENCEINTE_TYPE zz on zz.type=t.type and zz.plateforme_id=c.plateforme_orig_id where t.plateforme_id = _pfId) yy on yy.enceinte_id=e.enceinte_id set e.enceinte_type_id=yy.enceinte_type_id;

	-- correctif difficile à automatiser: enceinte_type_manquant conteneur partagé
	-- pbs doublons enceinte_type!
	alter table ENCEINTE_TYPE modify enceinte_type_id int(10) not null auto_increment;
	insert into ENCEINTE_TYPE (type, plateforme_id) select t.type, c.plateforme_id from ENCEINTE e join CONTENEUR c on c.conteneur_id = e.conteneur_id join ENCEINTE_TYPE t on t.enceinte_type_id=e.enceinte_type_id where t.plateforme_id = _pfId where t.type not in (select type from ENCEINTE_TYPE where plateforme_id = c.conteneur_id) ;

	insert into ENCEINTE_TYPE (type, plateforme_id) select type, 10 from ENCEINTE_TYPE where plateforme_id = 1 and enceinte_type_id in (1,2);
		alter table ENCEINTE_TYPE modify enceinte_type_id int(10) not null;

	delete from ENCEINTE_TYPE where plateforme_id = 1;

	-- codes 
	update CODE_UTILISATEUR set code_parent_id = null where utilisateur_id in (select utilisateur_id from UTILISATEUR where plateforme_orig_id = 1);
	delete from TRANSCODE_UTILISATEUR where code_utilisateur_id in (select code_utilisateur_id from CODE_UTILISATEUR where utilisateur_id in (select utilisateur_id from UTILISATEUR where plateforme_orig_id = 1));
	delete from CODE_SELECT where utilisateur_id in (select utilisateur_id from UTILISATEUR where plateforme_orig_id = 1);
	delete from CODE_UTILISATEUR where utilisateur_id in (select utilisateur_id from UTILISATEUR where plateforme_orig_id = 1);
	delete from CODE_DOSSIER where utilisateur_id in (select utilisateur_id from UTILISATEUR where plateforme_orig_id = 1);

	-- utilisateur
	delete from PROFIL_UTILISATEUR where banque_id in (select banque_id from BANQUE where plateforme_id = 1);
	delete from OPERATION where utilisateur_id in (select utilisateur_id from UTILISATEUR where plateforme_orig_id = 1);
	delete from UTILISATEUR where plateforme_orig_id = 1;

	-- profils
	delete from DROIT_OBJET where profil_id in (select profil_id from PROFIL where plateforme_id = 1);
	delete from PROFIL where plateforme_id = 1;

	-- contrat
	delete from CONTRAT where plateforme_id = 1;

	-- stats
	delete from STATS_MODELE_INDICATEUR where stats_modele_id in (select stats_modele_id from STATS_MODELE where plateforme_id = 1);
	delete from STATS_MODELE_BANQUE where stats_modele_id in (select stats_modele_id from STATS_MODELE where plateforme_id = 1);
	delete from STATS_MODELE where plateforme_id = 1;

	-- banque
	delete from COULEUR_ENTITE_TYPE where banque_id in (select banque_id from BANQUE where plateforme_id = 1);
	delete from BANQUE_CATALOGUE where banque_id in (select banque_id from BANQUE where plateforme_id = 1);
	delete from BANQUE_TABLE_CODAGE where banque_id in (select banque_id from BANQUE where plateforme_id = 1);
	delete from BANQUE where plateforme_id = 1;

	-- plateforme
	delete from PLATEFORME_ADMINISTRATEUR where plateforme_id = 1;
	delete from PLATEFORME where plateforme_id = 1;


END$$

