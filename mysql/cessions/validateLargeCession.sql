-- /!\ cas d'une cession ne contenant que des échantillons !!
-- id cession variable
set @id_cession = (select cession_id from CESSION where numero = 'NBT-D35' and banque_id = (select banque_id from BANQUE where nom = 'C10-Synd Neuro Paranéoplasiques'));

-- si CESSION a été créée par utilisateur avec échantillons/dérivés et est EN ATTENTE
-- verif cession totale  : 
-- resultat OBJET_STATUT = RESERVE (id=3) => poursuivre la précédure
-- sinon passer par le script valider_cession_partielle.sql
select distinct e.objet_statut_id from ECHANTILLON e join CEDER_OBJET c on e.echantillon_id=c.objet_id where c.cession_id=@id_cession;

-- validation cessions
-- operation destockage
insert into OPERATION (utilisateur_id, operation_type_id, objet_id, entite_id, date_) select 1, 13, objet_id, entite_id, now() from CEDER_OBJET c where c.cession_id=@id_cession;

-- insert des évènements de stockages (RETOUR) uniquement si aucun existe pour la cession 
-- => select de contrôle : 
select count(1) from RETOUR where cession_id = @id_cession;

-- évènements de stockage
insert into RETOUR (entite_id, objet_id, date_sortie, temp_moyenne, collaborateur_id, cession_id, observations, old_emplacement_adrl, conteneur_id) select d.entite_id, e.echantillon_id, if(c.depart_date is not null, c.depart_date, if(c.destruction_date is not null, c.destruction_date, now())), 20.0, c.executant_id, c.cession_id, 'cession validée en base', get_adrl(e.emplacement_id), get_conteneur(e.emplacement_id) from CEDER_OBJET d join ECHANTILLON e on d.objet_id = e.echantillon_id join CESSION c on c.cession_id=d.cession_id where c.cession_id = @id_cession;

-- MISE A JOUR DES ECHANTILLONS -> EPUISE
update ECHANTILLON set quantite=0, objet_statut_id = 2, emplacement_id = null where echantillon_id in (select objet_id from CEDER_OBJET c where c.entite_id=3 and c.cession_id=@id_cession) and objet_statut_id = 3;

-- nettoyage emplacements
update EMPLACEMENT set vide = 1, objet_id = null, entite_id = null where entite_id = 3 and objet_id in (select objet_id from CEDER_OBJET c where c.entite_id=3 and c.cession_id=@id_cession);

-- cession validee
update CESSION set cession_statut_id = 2 where cession_id = @id_cession;
insert into OPERATION (utilisateur_id, operation_type_id, objet_id, entite_id, date_) values (1, 5, @id_cession, 5, now());
