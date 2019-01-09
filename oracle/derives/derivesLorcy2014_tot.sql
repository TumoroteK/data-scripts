set pagesize 0 
set trimspool on 
set headsep off
set linesize 32000 

spool out2.csv

select p.code || chr(9) || m.code|| chr(9) ||  a.label || chr(9) || e.code || chr(9) ||  co.code || chr(9) ||  cl.code || chr(9) || z.code || chr(9) || z.date_stock
    from PRELEVEMENT p
    join MALADIE m on m.maladie_id = p.maladie_id
    join ECHANTILLON e on e.prelevement_id = p.prelevement_id
    left outer join (select code, echantillon_id from CODE_ASSIGNE where export = 1 and is_organe = 1) co on co.echantillon_id = e.echantillon_id
    left outer join (select code, echantillon_id from CODE_ASSIGNE where export = 1 and is_morpho = 1) cl on cl.echantillon_id = e.echantillon_id
    left outer join (select i.label, v.objet_id from ANNOTATION_VALEUR v join ITEM i on i.item_id = v.item_id where v.champ_annotation_id = 45) a on a.objet_id=p.prelevement_id
    join (select e.echantillon_id as eid, p.code, p.date_stock
        from ECHANTILLON e 
        join TRANSFORMATION t on t.objet_id = e.echantillon_id
        join PROD_DERIVE p on p.transformation_id = t.transformation_id
    where p.banque_id = 1 and t.entite_id = 3) z on z.eid = e.echantillon_id
where p.banque_id = 1;

spool off;
