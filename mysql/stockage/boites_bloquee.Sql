
select emplacement_id from EMPLACEMENT where entite_id=3 and objet_id not in (select echantillon_id from ECHANTILLON);

update ECHANTILLON n join EMPLACEMENT e on n.echantillon_id = e.objet_id set n.objet_statut_id = 1, n.emplacement_id = e.emplacement_id where e.entite_id = 3 and n.emplacement_id is null and e.emplacement_id != 1024;

-- incoherence 
select objet_id, entite_id from EMPLACEMENT group by objet_id,entite_id having count(objet_id) > 1;

-- emplacement vide?
select e.vide, e.emplacement_id from EMPLACEMENT e join ECHANTILLON n on n.emplacement_id=e.emplacement_id and e.vide=1;
update EMPLACEMENT e join ECHANTILLON n on n.emplacement_id=e.emplacement_id set e.objet_id=n.echantillon_id, e.entite_id=3, e.vide=0 where e.vide=1 and e.objet_id is null and e.entite_id is null and e.terminale_id=1712;




