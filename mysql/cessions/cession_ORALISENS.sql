insert into CEDER_OBJET (cession_id, objet_id, entite_id, quantite, quantite_unite_id) select 871, echantillon_id, 3, quantite, quantite_unite_id from ECHANTILLON where banque_id=38;

alter table RETOUR modify retour_id int(10) not null auto_increment;

insert into RETOUR (objet_id, entite_id, date_sortie, temp_moyenne, sterile, observations, old_emplacement_adrl, cession_id, old_emplacement_id) select e.echantillon_id, 3, curdate(), 25, 0, 'CESSION TOTALE ORALISENS', p.adrl, 871, p.emplacement_id  from ECHANTILLON e join EMPLACEMENT p on p.emplacement_id = e.emplacement_id where e.banque_id=38;

alter table RETOUR modify retour_id int(10) not null;

update EMPLACEMENT set vide = 1, objet_id=null, entite_id=null where emplacement_id in (select emplacement_id from ECHANTILLON where banque_id=38);

update ECHANTILLON set emplacement_id=null, objet_statut_id=2, quantite=0 where banque_id=38;

mysql> update EMPLACEMENT set vide=1, objet_id=null, entite_id=null where entite_id=3 and objet_id in (select echantillon_id from ECHANTILLON where banque_id=38);




