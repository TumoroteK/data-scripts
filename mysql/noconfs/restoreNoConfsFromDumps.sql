--restaure non conformites echantillon
alter table OBJET_NON_CONFORME modify OBJET_NON_CONFORME_ID int(10) not null auto_increment;

-- echantillon noconfs traitement
select e.echantillon_id from tumo2prod.ECHANTILLON e where e.conforme_traitement = 0 and e.echantillon_id not in (select objet_id from tumo2prod.OBJET_NON_CONFORME o join tumo2prod.NON_CONFORMITE n on o.non_conformite_id=n.non_conformite_id where o.entite_id = 3 and n.conformite_type_id = 2);

insert into tumo2prod.OBJET_NON_CONFORME (NON_CONFORMITE_ID, OBJET_ID, ENTITE_ID) select o.non_conformite_id, o.objet_id, o.entite_id from tumo2tmp.OBJET_NON_CONFORME o join tumo2tmp.NON_CONFORMITE n on o.non_conformite_id=n.non_conformite_id where o.entite_id = 3 and n.conformite_type_id = 2 and objet_id in (select e.echantillon_id from tumo2prod.ECHANTILLON e where e.conforme_traitement = 0 and e.echantillon_id not in (select objet_id from tumo2prod.OBJET_NON_CONFORME o join tumo2prod.NON_CONFORMITE n on o.non_conformite_id=n.non_conformite_id where o.entite_id = 3 and n.conformite_type_id = 2));

select * from tumo2temp.OBJET_NON_CONFORME join tumo2temp.NON_CONFORMITE n on o.non_conformite_id=n.non_conformite_id where objet_non_conforme_id not in (select objet_non_conforme_id from tumo2prod.OBJET_NON_CONFORME);

-- echantillon noconfs cession
select e.echantillon_id from ECHANTILLON e where e.conforme_cession = 0 and e.echantillon_id not in (select objet_id from OBJET_NON_CONFORME o join NON_CONFORMITE n on o.non_conformite_id=n.non_conformite_id where o.entite_id = 3 and n.conformite_type_id = 3);

insert into tumo2prod.OBJET_NON_CONFORME (NON_CONFORMITE_ID, OBJET_ID, ENTITE_ID) select o.non_conformite_id, o.objet_id, o.entite_id from tumo2tmp.OBJET_NON_CONFORME o join tumo2tmp.NON_CONFORMITE n on o.non_conformite_id=n.non_conformite_id where o.entite_id = 3 and n.conformite_type_id = 3 and objet_id in (select e.echantillon_id from tumo2prod.ECHANTILLON e where e.conforme_cession = 0 and e.echantillon_id not in (select objet_id from tumo2prod.OBJET_NON_CONFORME o join tumo2prod.NON_CONFORMITE n on o.non_conformite_id=n.non_conformite_id where o.entite_id = 3 and n.conformite_type_id = 3));

select * from tumo2temp.OBJET_NON_CONFORME join tumo2temp.NON_CONFORMITE n on o.non_conformite_id=n.non_conformite_id where o.entite_id = 3 and n.conformite_type_id = 3 and objet_non_conforme_id not in (select objet_non_conforme_id from tumo2prod.OBJET_NON_CONFORME);


-- derives noconfs traitement
select p.prod_derive_id from PROD_DERIVE p where p.conforme_traitement = 0 and p.prod_derive_id not in (select objet_id from OBJET_NON_CONFORME o join NON_CONFORMITE n on o.non_conformite_id=n.non_conformite_id where o.entite_id = 8 and n.conformite_type_id = 4);

insert into tumo2prod.OBJET_NON_CONFORME (NON_CONFORMITE_ID, OBJET_ID, ENTITE_ID) select o.non_conformite_id, o.objet_id, o.entite_id from tumo2tmp.OBJET_NON_CONFORME o join tumo2tmp.NON_CONFORMITE n on o.non_conformite_id=n.non_conformite_id where o.entite_id = 8 and n.conformite_type_id = 4 and objet_id in (select p.prod_derive_id from tumo2prod.PROD_DERIVE p where p.conforme_traitement = 0 and p.prod_derive_id not in (select objet_id from tumo2prod.OBJET_NON_CONFORME o join tumo2prod.NON_CONFORMITE n on o.non_conformite_id=n.non_conformite_id where o.entite_id = 8 and n.conformite_type_id = 4));

-- derives noconfs cession
select p.prod_derive_id from PROD_DERIVE p where p.conforme_cession = 0 and p.prod_derive_id not in (select objet_id from OBJET_NON_CONFORME o join NON_CONFORMITE n on o.non_conformite_id=n.non_conformite_id where o.entite_id = 8 and n.conformite_type_id = 5);

insert into tumo2prod.OBJET_NON_CONFORME (NON_CONFORMITE_ID, OBJET_ID, ENTITE_ID) select o.non_conformite_id, o.objet_id, o.entite_id from tumo2tmp.OBJET_NON_CONFORME o join tumo2tmp.NON_CONFORMITE n on o.non_conformite_id=n.non_conformite_id where o.entite_id = 8 and n.conformite_type_id = 5 and objet_id in (select p.prod_derive_id from tumo2prod.PROD_DERIVE p where p.conforme_cession = 0 and p.prod_derive_id not in (select objet_id from tumo2prod.OBJET_NON_CONFORME o join tumo2prod.NON_CONFORMITE n on o.non_conformite_id=n.non_conformite_id where o.entite_id = 8 and n.conformite_type_id = 5));

-- COMMANDES a PASSER

insert into tumo2test.OBJET_NON_CONFORME (objet_non_conforme_id, non_conformite_id, objet_id, entite_id) select o.* from tumo2tmp.OBJET_NON_CONFORME o join tumo2tmp.NON_CONFORMITE n on o.non_conformite_id=n.non_conformite_id where o.entite_id = 3 and n.conformite_type_id = 2 and objet_non_conforme_id not in (select objet_non_conforme_id from tumo2test.OBJET_NON_CONFORME) and objet_id in (select echantillon_id from tumo2test.ECHANTILLON where conforme_traitement = 0);

insert into tumo2test.OBJET_NON_CONFORME (objet_non_conforme_id, non_conformite_id, objet_id, entite_id) select o.* from tumo2tmp.OBJET_NON_CONFORME o join tumo2tmp.NON_CONFORMITE n on o.non_conformite_id=n.non_conformite_id where o.entite_id = 3 and n.conformite_type_id = 3 and objet_non_conforme_id not in (select objet_non_conforme_id from tumo2test.OBJET_NON_CONFORME) and objet_id in (select echantillon_id from tumo2test.ECHANTILLON where conforme_cession = 0);

insert into tumo2test.OBJET_NON_CONFORME (objet_non_conforme_id, non_conformite_id, objet_id, entite_id) select o.* from tumo2tmp.OBJET_NON_CONFORME o join tumo2tmp.NON_CONFORMITE n on o.non_conformite_id=n.non_conformite_id where o.entite_id = 8 and n.conformite_type_id = 4 and objet_non_conforme_id not in (select objet_non_conforme_id from tumo2test.OBJET_NON_CONFORME) and objet_id in (select prod_derive_id from tumo2test.PROD_DERIVE where conforme_traitement = 0);

insert into tumo2test.OBJET_NON_CONFORME (objet_non_conforme_id, non_conformite_id, objet_id, entite_id) select o.* from tumo2tmp.OBJET_NON_CONFORME o join tumo2tmp.NON_CONFORMITE n on o.non_conformite_id=n.non_conformite_id where o.entite_id = 8 and n.conformite_type_id = 5 and objet_non_conforme_id not in (select objet_non_conforme_id from tumo2test.OBJET_NON_CONFORME) and objet_id in (select prod_derive_id from tumo2test.PROD_DERIVE where conforme_cession = 0);

-- Bilans
dump				e_trait	e_cess	d_trait	d_cess
dumpProd21042014.sql 		0	362	NA	NA 
dumpProd210_11062014.sql	0	43	NA	NA
dumpProd210_19082014.sql	104	138	NA	NA
dumpProd210_15092014.sql	37	24 	NA	NA
dumpProd08052015.sql		163	39	0	0
dumpProd10052015.sql		0	0	0	0
dumpProd01062015.sql		54	27	0	0
dumpProd02092015.sql		20	16	0	0
dumpProd011092015.sql		68	0	0	0

-- ne pas faire...
dumpProd08102015.sql		1	0	0	0
dumpProd_18112015.sql		26	26	2	2
dumpProd_22112015.sql
dumpProd16122015.sql



-- check coherences!! 
select n.* from OBJET_NON_CONFORME n where entite_id=2 and objet_id not in (select prelevement_id from PRELEVEMENT);
select '-- ECHANTILLON';
select n.* from OBJET_NON_CONFORME n where entite_id=3 and objet_id not in (select echantillon_id from ECHANTILLON);
select '-- DERIVE';
select n.* from OBJET_NON_CONFORME n where entite_id=8 and objet_id not in (select prod_derive_id from PROD_DERIVE);


