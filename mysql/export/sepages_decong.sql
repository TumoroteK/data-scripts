select z1.* INTO OUTFILE 'd:/sepages_decong.csv'
  FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\n'
 from (select p.patient_id, p.nom, p.prenom, p.date_naissance, e.prelevement_id, e.code, a.anno_date from PATIENT p 
	join MALADIE m on m.patient_id=p.patient_id 
	join PRELEVEMENT e on e.maladie_id=m.maladie_id 
	join ANNOTATION_VALEUR a on a.objet_id=e.prelevement_id 
where e.banque_id = 14 
	and a.anno_date is not null 
	and a.champ_annotation_id = 171) z1;
	 
