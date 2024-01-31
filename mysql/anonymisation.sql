-- identités
update PATIENT set nip = patient_id, nom = concat('PAT', patient_id), nom_naissance = null, prenom = left(prenom, 3), date_naissance = concat(year(date_naissance), '-01-01');

-- projets
update CONTRAT set numero=concat('CONTRAT', contrat_id), titre_projet=concat('PROJET', contrat_id), etablissement_id=1, service_id=1, collaborateur_id=5;
update CESSION c join CONTRAT a on c.contrat_id=a.contrat_id set c.etude_titre=a.titre_projet, c.demandeur_id=a.collaborateur_id, c.destinataire_id=a.collaborateur_id, c.service_dest_id=a.service_id; 

-- si base lyon nettoyage des tables interfacages si existent
-- car mysqldump logiquement fait sans les tables volumineuses --ignore-table=PATIENT_SIP --ignore-table=PATIENT_SIP_SEJOUR --ignore-table=VALEUR_EXTERNE
-- truncate table PATIENT_SIP_SEJOUR;
-- truncate table PATIENT_SIP;
-- truncate table VALEUR_EXTERNE;
-- truncate table BLOC_EXTERNE;
-- truncate table DOSSIER_EXTERNE;

truncate table OPERATION;

-- collaborateurs / utilisateurs
update COLLABORATEUR set NOM = concat('COLLAB', collaborateur_id), prenom = left(prenom, 3);

update COORDONNEE set mail = null where mail is not null;
update COORDONNEE set tel = null where tel is not null;

update UTILISATEUR set email = null where email is not null;
update UTILISATEUR set login = concat('login', utilisateur_id) where login not in ('ADMIN_TUMO', 'dufay', 'dufayadmin', 'eleve1','eleve2','eleve3','eleve4','eleve5','eleve6','eleve7')

-- fichier
update ANNOTATION_VALEUR set fichier_id = null where fichier_id is not null;
update ECHANTILLON set CR_ANAPATH_ID = null where CR_ANAPATH_ID is not null;
delete from FICHIER;

-- nettoyage fantomes
delete from FANTOME;
