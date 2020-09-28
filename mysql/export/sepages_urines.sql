select e.code, y.type, get_adrl(e.emplacement_id), o.statut, a.nom, e.quantite, u.unite from ECHANTILLON e 
	join ECHANTILLON_TYPE y on e.echantillon_type_id=y.echantillon_type_id 
	left outer join UNITE u on e.quantite_unite_id=u.unite_id 
	join OBJET_STATUT o on o.objet_statut_id=e.objet_statut_id 
	left outer join PRELEVEMENT p on p.prelevement_id = e.prelevement_id 
	left outer join MALADIE m on m.maladie_id=p.maladie_id 
	left outer join PATIENT a on a.patient_id=m.patient_id 
where e.banque_id = 14 and y.type like '%URINE%' 
order by e.code, y.type
INTO OUTFILE 'd:\\sepages_urines.csv' FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\n';
