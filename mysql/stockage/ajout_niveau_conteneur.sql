-- intercale un niveau d'enceinte à la racine d'un conteneur
update CONTENEUR set nbr_niv = 4 where conteneur_id = @id_conteneur;
insert into ENCEINTE (enceinte_id, enceinte_type_id, conteneur_id, nom, position, nb_places, archive) select max(enceinte_id) + 1, @enceinte_type_id, @id_conteneur, 'AA1', 3, 10, 0 from ENCEINTE;

update ENCEINTE set enceinte_pere_id = (select max(enceinte_id) from ENCEINTE), conteneur_id = null where conteneur_id = @id_conteneur and enceine_id < (select max(enceinte_id) from ENCEINTE);

