
select emplacement_id from EMPLACEMENT where entite_id=3 and objet_id not in (select echantillon_id from ECHANTILLON);

update ECHANTILLON n join EMPLACEMENT e on n.echantillon_id = e.objet_id set n.objet_statut_id = 1, n.emplacement_id = e.emplacement_id where e.entite_id = 3 and n.emplacement_id is null and e.emplacement_id != 1024;

-- incoherence 1: un objets sur plusieurs emplacements
select objet_id, entite_id from EMPLACEMENT group by objet_id,entite_id having count(objet_id) > 1;

-- incoherence 2: emplacement vide?
select e.vide, e.emplacement_id from EMPLACEMENT e join ECHANTILLON n on n.emplacement_id=e.emplacement_id and e.vide=1;

update EMPLACEMENT e join ECHANTILLON n on n.emplacement_id=e.emplacement_id set e.objet_id=n.echantillon_id, e.entite_id=3, e.vide=0 where e.vide=1 and e.objet_id is null and e.entite_id is null and e.terminale_id=26889;
, 
-- incoherence 3: taille boite incohérente (après import de données)
select distinct t.terminale_type_id from TERMINALE t join (select count(e.emplacement_id) as cc, e.terminale_id, y.nb_places from EMPLACEMENT e join TERMINALE t on t.terminale_id=e.terminale_id join TERMINALE_TYPE y on y.terminale_type_id = t.terminale_type_id group by e.terminale_id) zz on zz.terminale_id = t.terminale_id where zz.nb_places < zz.cc; 

-- incoherence 4: position doublons 
select emplacement_id, terminale_id from EMPLACEMENT group by terminale_id, position having count(emplacement_id) > 1;

-- incoherence 5: plusieurs objets sur le même emplacement ->
select emplacement_id from ECHANTILLON where emplacement_id is not null group by emplacement_id having count(echantillon_id) > 1;
select emplacement_id from PROD_DERIVE where emplacement_id is not null group by emplacement_id having count(prod_derive_id) > 1;
select p.emplacement_id, e.echantillon_id, e.code, p.prod_derive_id, p.code, e.banque_id from PROD_DERIVE p join ECHANTILLON e on p.emplacement_id=e.emplacement_id;







