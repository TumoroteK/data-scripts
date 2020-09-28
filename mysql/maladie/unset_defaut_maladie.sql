-- passer en mode maladie pour les banques id=314
select patient_id from MALADIE m join PRELEVEMENT p on p.maladie_id=m.maladie_id where p.banque_id = 314 group by m.patient_id having count(distinct m.maladie_id) > 1;
-- > 0 1 seule maladie / patient 

select distinct m.libelle from MALADIE m join PRELEVEMENT p on p.maladie_id=m.maladie_id where p.banque_id = 314;

-- > visiblement la collection a changé de nom plusieurs fois !
+-------------------------------+
| libelle                       |
+-------------------------------+
| C20-05 French COVID-19-defaut |
| COVID19 CRB-defaut            |
| C20-15 Discovery-defaut       |
| COVID19                       |
+-------------------------------+

-- renommage libelle -defaut
update MALADIE m join PRELEVEMENT p on p.maladie_id=m.maladie_id set m.libelle = 'COVID19', systeme_defaut=0 where p.banque_id=314 and m.systeme_defaut=1;

-- configuration banques
update BANQUE set defmaladies = 1, defaut_maladie = 'COVID19', defaut_maladie_code=null  where banque_id = 314;

