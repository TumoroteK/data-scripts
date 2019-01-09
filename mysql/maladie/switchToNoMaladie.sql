-- 1 seule maladie par patient pour les banques id=54, 72, 147
select patient_id from MALADIE m join PRELEVEMENT p on p.maladie_id=m.maladie_id where p.banque_id in (54, 72, 147) group by m.patient_id having count(distinct m.maladie_id) > 1;

-- patients à corriger
select patient_id, min(m.maladie_id) from MALADIE m join PRELEVEMENT p on p.maladie_id=m.maladie_id where p.banque_id in (54, 72, 147) group by m.patient_id having count(distinct m.maladie_id) > 1;
update PRELEVEMENT p join (select min(m.maladie_id) as minM, max(m.maladie_id) as maxM from MALADIE m join PRELEVEMENT p on p.maladie_id=m.maladie_id where p.banque_id in (54, 72, 147) group by m.patient_id having count(distinct m.maladie_id) > 1) zz on zz.maxM = p.maladie_id set p.maladie_id = zz.minM;
-- ce script peut être passé plusieurs fois, tant qu'il y a plusieurs maladies/patient (premier select)

-- renommage libelle -defaut
update MALADIE m join PRELEVEMENT p on p.maladie_id=m.maladie_id join BANQUE b on b.banque_id=p.banque_id 
	set m.libelle = concat(b.nom, '-defaut'), systeme_defaut=1 where b.banque_id in (54, 72, 147);

-- configuration banques
update BANQUE set defmaladies = 0, defaut_maladie = null, defaut_maladie_code=null  where banque_id in (54, 72, 147);

