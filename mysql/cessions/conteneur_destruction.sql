/*Le script va céder totalement tous les échantillons ou les dérivés qui sont stockés dans une liste de conteneur*/
/* par appel de la procédure largeCesion donc par remplissage préalable de la table TEMP_TRSFT */
/* la table TEMP_TRSFT sera alimentée par deux tables temporaires intermédiaires permettant le dump de données utiles en cas de restauration */ 
/* la destruction du contenu du conteneur va donc se faire en deux cessions: une pour les échantillons, une pour les dérivés */

/* sauvegarde */
mysqldump -u TUMO_SLS -p TUMO_SLS_HEMA --routines > dumpHemao_beforeCuvesDestruction.sql

SET autocommit = false;

/* conteneurs */
create temporary table DESTR_CONT (conteneur_id int(10) not null, code varchar(10) not null, nom varchar(100) not null, plateforme_id int(3) not null, primary key(conteneur_id));
insert into DESTR_CONT select conteneur_id, code, nom, plateforme_orig_id from CONTENEUR where code in ('C19', 'C20', 'C21', 'C22', 'C23', 'C24', 'C25');
-- attention vérifier ici
-- si doublons de code
select code from DESTR_CONT group by code having count(distinct(conteneur_id)) > 1; 
-- plateforme
select distinct plateforme_id from DESTR_CONT; --1

/* echantillons */
create table DESTR_ECH (echantillon_id int(10) not null, banque_id int(3) not null, quantite decimal(12,3), emplacement_id int(10) not null, primary key(echantillon_id));
insert into DESTR_ECH select echantillon_id, banque_id, quantite, emplacement_id from ECHANTILLON e where get_conteneur(e.emplacement_id) in (select conteneur_id from DESTR_CONT);

-- sauvegarde
mysqldump -u root -p hemato --tables DESTR_ECH > dumpDestrEchantillons.sql

-- creation CESSION
set @id_cession = (select max(cession_id) + 1 from CESSION);

insert into CESSION (cession_id, numero, banque_id, cession_type_id, cession_statut_id) values (@id_cession, 'destr echantillons',  (select distinct banque_id from DESTR_ECH), 3, 1);
insert into OPERATION (utilisateur_id, entite_id, operation_type_id, date_, objet_id) values (1, 5, 3, now(), @id_cession);

-- remplissage et validation cession
create temporary table TEMP_TRSFT (id int(10));
insert into TEMP_TRSFT select echantillon_id from DESTR_ECH;

call largeCession(@id_cession, 3, 1);

-- verifications
select count(*) from CEDER_OBJET e where cession_id = @id_cession; -- 25692
select count(*) from ECHANTILLON e join DESTR_ECH d on e.echantillon_id = d.echantillon_id where e.emplacement_id is null and e.quantite = 0 and e.objet_statut_id = 5; --25692
select count(echantillon_id)from ECHANTILLON e where get_conteneur(e.emplacement_id) in (select conteneur_id from DESTR_CONT); -- 0
select count(*) from EMPLACEMENT e join DESTR_ECH d on e.emplacement_id=d.emplacement_id where e.vide = 0 or e.entite_id is not null or e.objet_id is not null; -- 0
select count(*) from ECHANTILLON e join DESTR_ECH d on e.echantillon_id = d.echantillon_id where e.emplacement_id is not null or e.quantite > 0 or e.objet_statut_id != 5; --0


/* derives */
create table DESTR_DER (prod_derive_id int(10) not null, banque_id int(3) not null, quantite decimal(12,3), volum decimal(12, 3), conc decimal(12,3), emplacement_id int(10) not null, primary key(prod_derive_id));
insert into DESTR_DER select prod_derive_id, banque_id, quantite, volume, conc, emplacement_id from PROD_DERIVE e where get_conteneur(e.emplacement_id) in (select conteneur_id from DESTR_CONT); -- 0 !!

-- sauvegarde
mysqldump -u root -p hemato --tables DESTR_DER > dumpDestrDerives.sql

-- creation CESSION
set @id_cession = (select max(cession_id) + 1 from CESSION);

insert into CESSION (cession_id, numero, banque_id, cession_type_id, cession_statut_id) values (@id_cession, 'destr derives',  (select distinct banque_id from DESTR_DER), 3, 1);
insert into OPERATION (utilisateur_id, entite_id, operation_type_id, date_, objet_id) values (1, 5, 3, now(), @id_cession);

-- remplissage et validation cession
truncate table TEMP_TRSFT (id int(10));
insert into TEMP_TRSFT select prod_derive from DESTR_DER;

call largeCession(@id_cession, 8, 1);

-- verifications
select count(*) from CEDER_OBJET e where cession_id = @id_cession; -- 25692
select count(*) from PROD_DERIVE e join DESTR_DER d on e.prod_derive_id = d.prod_derive_id where e.emplacement_id is null and e.quantite = 0 and e.objet_statut_id = 5; --0
select count(prod_derive_id)from PROD_DERIVE e where get_conteneur(e.emplacement_id) in (select conteneur_id from DESTR_CONT); -- 0
select count(*) from PROD_DERIVE e join DESTR_DER d on e.emplacement_id=d.emplacement_id where e.vide = 0 or e.entite_id is not null or e.objet_id is not null; -- 0
select count(*) from PROD_DERIVE e join DESTR_DER d on e.prod_derive_id = d.prod_derive_id where e.emplacement_id is not null or e.quantite > 0 or e.volume > 0 or e.conc > 0 or e.objet_statut_id != 5; --0


-- last verification
select count(*) from EMPLACEMENT e where get_conteneur(e.emplacement_id) in (select conteneur_id from DESTR_CONT);  -- 26096
select count(*) from EMPLACEMENT e where get_conteneur(e.emplacement_id) in (select conteneur_id from DESTR_CONT) and e.vide = 1 and e.entite_id is null and e.objet_id is null; -- 26096
select count(*) from EMPLACEMENT e where get_conteneur(e.emplacement_id) in (select conteneur_id from DESTR_CONT) and (e.vide = 0 or e.entite_id is not null or e.objet_id is not null); -- 0

drop table DESTR_DER;
drop table DESTR_ECH;

commit;

