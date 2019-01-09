select count(*) from OPERATION where operation_type_id = 6;
select count(*) from OBJET_NON_CONFORME;

select count(*) from PRELEVEMENT where conforme_arrivee = 0 and prelevement_id in (select objet_id from OPERATION where operation_type_id = 6 and entite_id = 2);
select count(*) from ECHANTILLON where conforme_traitement = 0 and echantillon_id in (select objet_id from OPERATION where operation_type_id = 6 and entite_id = 3);
select count(*) from ECHANTILLON where conforme_cession = 0 and echantillon_id in (select objet_id from OPERATION where operation_type_id = 6 and entite_id = 3);
select count(*) from PROD_DERIVE where conforme_traitement = 0 and prod_derive_id in (select objet_id from OPERATION where operation_type_id = 6 and entite_id = 8);
select count(*) from PROD_DERIVE where conforme_cession = 0 and prod_derive_id in (select objet_id from OPERATION where operation_type_id = 6 and entite_id = 8);

select p.prelevement_id, p.code, b.nom from PRELEVEMENT p 
	join BANQUE b on b.banque_id = p.banque_id where p.conforme_arrivee = 0 
	and p.prelevement_id not in (select objet_id from OBJET_NON_CONFORME o 
		join NON_CONFORMITE n on o.non_conformite_id=n.non_conformite_id 
		where o.entite_id = 2 and n.conformite_type_id = 1)
and prelevement_id in (select objet_id from OPERATION where operation_type_id = 6 and entite_id = 2);

select e.echantillon_id, e.code, b.nom from ECHANTILLON e 
	join BANQUE b on b.banque_id = e.banque_id where e.conforme_traitement = 0 
	and e.echantillon_id not in (select objet_id from OBJET_NON_CONFORME o 
		join NON_CONFORMITE n on o.non_conformite_id=n.non_conformite_id 
		where o.entite_id = 3 and n.conformite_type_id = 2)
and echantillon_id in (select objet_id from OPERATION where operation_type_id = 6 and entite_id = 3);

select e.echantillon_id, e.code, b.nom from ECHANTILLON e 
	join BANQUE b on b.banque_id = e.banque_id where e.conforme_cession = 0 
	and e.echantillon_id not in (select objet_id from OBJET_NON_CONFORME o 
	join NON_CONFORMITE n on o.non_conformite_id=n.non_conformite_id 
	where o.entite_id = 3 and n.conformite_type_id = 3)
and echantillon_id in (select objet_id from OPERATION where operation_type_id = 6 and entite_id = 3);

select p.prod_derive_id from PROD_DERIVE p where p.conforme_traitement = 0 
	and p.prod_derive_id not in (select objet_id from OBJET_NON_CONFORME o 
	join NON_CONFORMITE n on o.non_conformite_id=n.non_conformite_id 
	where o.entite_id = 8 and n.conformite_type_id = 4)
and prod_derive_id in (select objet_id from OPERATION where operation_type_id = 6 and entite_id = 8);

select p.prod_derive_id from PROD_DERIVE p where p.conforme_cession = 0 
	and p.prod_derive_id not in (select objet_id from OBJET_NON_CONFORME o 
	join NON_CONFORMITE n on o.non_conformite_id=n.non_conformite_id 
	where o.entite_id = 8 and n.conformite_type_id = 5)
and prod_derive_id in (select objet_id from OPERATION where operation_type_id = 6 and entite_id = 8);


-- ora
select e.echantillon_id || ';' || e.code || ';' || b.nom from ECHANTILLON e 
	join BANQUE b on b.banque_id = e.banque_id where e.conforme_traitement = 0 
	and e.echantillon_id not in (select objet_id from OBJET_NON_CONFORME o 
		join NON_CONFORMITE n on o.non_conformite_id=n.non_conformite_id 
		where o.entite_id = 3 and n.conformite_type_id = 2)
and echantillon_id in (select objet_id from OPERATION where operation_type_id = 6 and entite_id = 3);

-- mysql
echo "select concat(e.echantillon_id, ';', e.code, ';', b.nom) from ECHANTILLON e 
	join BANQUE b on b.banque_id = e.banque_id where e.conforme_traitement = 0 
	and e.echantillon_id not in (select objet_id from OBJET_NON_CONFORME o 
		join NON_CONFORMITE n on o.non_conformite_id=n.non_conformite_id 
		where o.entite_id = 3 and n.conformite_type_id = 2)
and echantillon_id in (select objet_id from OPERATION where operation_type_id = 6 and entite_id = 3);" | mysql -u tumo -p tumo2 > d:\echans_traitement.txt
