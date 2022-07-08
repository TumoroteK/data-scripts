set @id_cession = (select cession_id from CESSION where numero = 'R_2021-003');

-- verif cession partielle -> OBJET_STATUT = RESERVE (id=6)
select distinct e.objet_statut_id from ECHANTILLON e join CEDER_OBJET c on e.echantillon_id=c.objet_id where c.cession_id=@id_cession;

-- ajout date retour = date sortie pour les evements de stockage
update RETOUR set date_retour = date_sortie where cession_id=@id_cession and date_retour is null;


-- MISE A JOUR DES ECHANTILLONS -> STOCKE
-- verification statut STOCKE
select e.echantillon_id from CEDER_OBJET c join ECHANTILLON e on c.objet_id=e.echantillon_id and c.entite_id=3 where cession_id = @id_cession and emplacement_id is null;
update ECHANTILLON set objet_statut_id = 1 where echantillon_id in (select objet_id from CEDER_OBJET c where c.entite_id=3 and c.cession_id=@id_cession) and objet_statut_id = 6 and emplacement_id is not null;


-- cession validee
update CESSION set cession_statut_id = 2 where cession_id = @id_cession;
insert into OPERATION (utilisateur_id, operation_type_id, objet_id, entite_id, date_) values (1, 5, @id_cession, 5, now());

