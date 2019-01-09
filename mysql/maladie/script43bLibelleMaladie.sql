-- script daniela modification libelle avec valeur annotation champ 43b
-- Date: 16/06/2011

-- HISTIOCYTOSE
select m.* from MALADIE m where (m.libelle = 'Inconnu' or m.libelle ='NEW') and m.patient_id in (select v.objet_id from ANNOTATION_VALEUR v, ITEM i where v.champ_annotation_id = 54 and v.item_id = i.item_id and (i.label = 'HISTIOCYTOSE' or i.label = 'LCH-A1'));
-- -> 106 entrees.

update MALADIE m set m.libelle = 'HISTIOCYTOSE' where (m.libelle = 'Inconnu' or m.libelle ='NEW') and m.patient_id in (select v.objet_id from ANNOTATION_VALEUR v, ITEM i where v.champ_annotation_id = 54 and v.item_id = i.item_id and (i.label = 'HISTIOCYTOSE' or i.label = 'LCH-A1'));

-- CAVECCAS
select m.* from MALADIE m where (m.libelle = 'Inconnu' or m.libelle ='NEW') and m.patient_id in (select v.objet_id from ANNOTATION_VALEUR v, ITEM i where v.champ_annotation_id = 54 and v.item_id = i.item_id and i.label = 'CAVECCAS');
-- -> 311 entrees.

update MALADIE m set m.libelle = 'CANCER DU SEIN' where (m.libelle = 'Inconnu' or m.libelle ='NEW') and m.patient_id in (select v.objet_id from ANNOTATION_VALEUR v, ITEM i where v.champ_annotation_id = 54 and v.item_id = i.item_id and i.label = 'CAVECCAS');

-- CONGELATION LYMPHOME (prelevements prélevés dans les dates 01/01/2009 et 31/12/2010)
select m.* from MALADIE m, PRELEVEMENT p where (m.libelle = 'Inconnu' or m.libelle ='NEW') and m.patient_id in (select v.objet_id from ANNOTATION_VALEUR v, ITEM i where v.champ_annotation_id = 54 and v.item_id = i.item_id and i.label = 'CONGELATION LYMPHOME') and p.maladie_id = m.maladie_id and p.date_prelevement > '2009-01-01' and p.date_prelevement < '2010-12-31'
-- ->699 entrees

update MALADIE m, PRELEVEMENT p set m.libelle = 'LYMPHOME' where (m.libelle = 'Inconnu' or m.libelle ='NEW') and m.patient_id in (select v.objet_id from ANNOTATION_VALEUR v, ITEM i where v.champ_annotation_id = 54 and v.item_id = i.item_id and i.label = 'CONGELATION LYMPHOME') and p.maladie_id = m.maladie_id and p.date_prelevement > '2009-01-01' and p.date_prelevement < '2010-12-31'
