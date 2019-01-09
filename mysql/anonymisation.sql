-- identités
update PATIENT set nip = patient_id, nom = concat('LYON', patient_id), nom_naissance = null, prenom = left(prenom, 3), date_naissance = concat(year(date_naissance), '-01-01');

-- projets
update CONTRAT set numero=concat('CONTRAT', contrat_id), titre_projet=concat('PROJET', contrat_id), etablissement_id=1, service_id=1, collaborateur_id=5;
update CESSION c join CONTRAT a on c.contrat_id=a.contrat_id set c.etude_titre=a.titre_projet, c.demandeur_id=a.collaborateur_id, c.destinataire_id=a.collaborateur_id, c.service_dest_id=a.service_id; 

-- si base lyon drops tables interfacages si existent
-- car mysqldump logiquement sans les tables volumineuses --ignore-table=PATIENT_SIP --ignore-table=PATIENT_SIP_SEJOUR --ignore-table=VALEUR_EXTERNE
drop table IF EXISTS PATIENT_SIP_SEJOUR;
drop table IF EXISTS PATIENT_SIP;
drop table IF EXISTS VALEUR_EXTERNE;
drop table IF EXISTS BLOC_EXTERNE;
drop table IF EXISTS DOSSIER_EXTERNE;
drop table IF EXISTS EMETTEUR;
drop table IF EXISTS RECEPTEUR;
drop table IF EXISTS LOGICIEL;
drop table IF EXISTS SCAN_TUBE;
drop table IF EXISTS SCAN_TERMINALE;
drop table IF EXISTS SCAN_DEVICE;
drop table IF EXISTS 

-- nettoyage fantomes
delete from FANTOME;
