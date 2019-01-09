update ECHANTILLON e SET e.emplacement_id = (select p.emplacement_id
                                  from EMPLACEMENT p 
                                  where p.objet_id = e.echantillon_id and p.entite_id=3)
where e.objet_statut_id in (2,4,5) and e.emplacement_id is null 
and exists (select p.emplacement_id 
		from EMPLACEMENT p 
		where p.objet_id = e.echantillon_id and p.entite_id=3);


