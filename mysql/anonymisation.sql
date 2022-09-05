-- identités
update PATIENT set nip = patient_id, nom = concat('LYON', patient_id), nom_naissance = null, prenom = left(prenom, 3), date_naissance = concat(year(date_naissance), '-01-01');

-- projets
update CONTRAT set numero=concat('CONTRAT', contrat_id), titre_projet=concat('PROJET', contrat_id), etablissement_id=1, service_id=1, collaborateur_id=5;
update CESSION c join CONTRAT a on c.contrat_id=a.contrat_id set c.etude_titre=a.titre_projet, c.demandeur_id=a.collaborateur_id, c.destinataire_id=a.collaborateur_id, c.service_dest_id=a.service_id; 

-- si base lyon nettoyage des tables interfacages si existent
-- car mysqldump logiquement fait sans les tables volumineuses --ignore-table=PATIENT_SIP --ignore-table=PATIENT_SIP_SEJOUR --ignore-table=VALEUR_EXTERNE
truncate table PATIENT_SIP_SEJOUR;
truncate table PATIENT_SIP;
truncate table VALEUR_EXTERNE;
truncate table BLOC_EXTERNE;
truncate table DOSSIER_EXTERNE;

truncate table OPERATION;

-- nettoyage fantomes
delete from FANTOME;
