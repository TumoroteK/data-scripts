create temporary table noconfs (objet_id int(10) not null, raison1 varchar(250), raison2 varchar(250), raison3 varchar(250), primary key(objet_id));

insert into noconfs (objet_id, raison1) select o.objet_id, n.nom from NON_CONFORMITE n join OBJET_NON_CONFORME o on o.non_conformite_id=n.non_conformite_id join (select 
min(objet_non_conforme_id) as mn from OBJET_NON_CONFORME group by objet_id) zz on zz.mn = o.objet_non_conforme_id;

update noconfs n join (select o.objet_id, n.nom from NON_CONFORMITE n join OBJET_NON_CONFORME o on o.non_conformite_id=n.non_conformite_id join (select 
max(objet_non_conforme_id) as mx from OBJET_NON_CONFORME group by objet_id having count(objet_non_conforme_id) = 3) zz on zz.mx = o.objet_non_conforme_id) ss on 
ss.objet_id=n.objet_id set raison3 = ss.nom;

update noconfs n join (select o.objet_id, n.nom from NON_CONFORMITE n join OBJET_NON_CONFORME o on o.non_conformite_id=n.non_conformite_id join (select 
max(objet_non_conforme_id) as mx from OBJET_NON_CONFORME group by objet_id having count(objet_non_conforme_id) = 2) zz on zz.mx = o.objet_non_conforme_id) ss on 
ss.objet_id=n.objet_id set raison2 = ss.nom;

update noconfs n join (select o.objet_id, n.nom from NON_CONFORMITE n join OBJET_NON_CONFORME o on o.non_conformite_id=n.non_conformite_id join (select objet_id, 
min(objet_non_conforme_id) as mn, max(objet_non_conforme_id) as mx from OBJET_NON_CONFORME group by objet_id having count(objet_non_conforme_id) = 3) zz on zz.objet_id = 
o.objet_id and o.objet_non_conforme_id > zz.mn and o.objet_non_conforme_id < zz.mx) ss on ss.objet_id=n.objet_id set raison2 = ss.nom where raison2 is null and raison3 
is not null;

select e.code as 'Code d''échantillon', 
	ifnull(get_adrl(emplacement_id), '') as 'Emplacement', 
	ifnull(e.date_stock, '') as 'Date de stockage',
	y.type as 'Type d''échantillon', 
	ifnull(m.nom, '') as 'Mode de préparation',
	ifnull(a3.alphanum, '') as 'Code labo',
	ifnull(a4.anno_date, '') as 'Date de prélèvement',
	ifnull(i1.label, '') as 'Bouchon',
	ifnull(i2.label, '') as 'Insert',
	ifnull(nc.raison1, '') as 'Non conformité 1',
	ifnull(nc.raison2, '') as 'Non conformité 2',
	ifnull(nc.raison3, '') as 'Non conformité 3',
	o.statut as 'statut'
	INTO OUTFILE '/req_output/result.csv'
  FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\n'
	from ECHANTILLON e
	join OBJET_STATUT o on o.objet_statut_id=e.objet_statut_id  
	join ECHANTILLON_TYPE y on e.echantillon_type_id=y.echantillon_type_id 
	join MODE_PREPA m on e.mode_prepa_id=m.mode_prepa_id 
	join ANNOTATION_VALEUR a1 on e.echantillon_id=a1.objet_id join ITEM i1 on a1.item_id=i1.item_id
	join ANNOTATION_VALEUR a2 on e.echantillon_id=a2.objet_id join ITEM i2 on a2.item_id=i2.item_id 
	join ANNOTATION_VALEUR a3 on e.echantillon_id=a3.objet_id 
	join ANNOTATION_VALEUR a4 on e.echantillon_id=a4.objet_id
	left outer join noconfs nc on e.echantillon_id=nc.objet_id or nc.objet_id is null
	where a1.champ_annotation_id=1 and a2.champ_annotation_id=2 and a3.champ_annotation_id=3 and a4.champ_annotation_id=4;
