select 'code', 'service preleveur', 'UF', 'nom de l''UF', 'prélèvement', 'code prélèvement','date de prélèvement', 'code échantillon', 'date de stockage', 'collection', 'germe', 'résistance méticilline', 'dépistage', 'BLSE'
UNION ALL
select p.code as 'code prelevement', 
    s.nom as 'service preleveur', 
    (SELECT a.alphanum from ANNOTATION_VALEUR a join CHAMP_ANNOTATION c on a.champ_annotation_id=c.champ_annotation_id where c.nom like 'UF' and a.objet_id=p.prelevement_id) as 'UF', 
    (SELECT a.alphanum from ANNOTATION_VALEUR a join CHAMP_ANNOTATION c on a.champ_annotation_id=c.champ_annotation_id where c.nom like 'nom de l''UF' and a.objet_id=p.prelevement_id) as 'nom de l''UF', 
    (SELECT a.alphanum from ANNOTATION_VALEUR a join CHAMP_ANNOTATION c on a.champ_annotation_id=c.champ_annotation_id where c.nom like 'Prélèvement' and a.objet_id=p.prelevement_id) as 'prélèvement', 
    (SELECT a.alphanum from ANNOTATION_VALEUR a join CHAMP_ANNOTATION c on a.champ_annotation_id=c.champ_annotation_id where c.nom like 'Code Prélèvement' and a.objet_id=p.prelevement_id) as 'code prélèvement', 
    p.date_prelevement as 'date de prélèvement', 
    e.code as 'code échantillon', 
    e.date_stock as 'date de stockage',
    (SELECT i.label from ITEM i join ANNOTATION_VALEUR a on i.item_id=a.item_id join CHAMP_ANNOTATION c on a.champ_annotation_id=c.champ_annotation_id where c.nom like 'Collection' and a.objet_id=e.echantillon_id) as 'collection', 
    (SELECT i.label from ITEM i join ANNOTATION_VALEUR a on i.item_id=a.item_id join CHAMP_ANNOTATION c on a.champ_annotation_id=c.champ_annotation_id where c.nom like 'germe' and a.objet_id=e.echantillon_id) as 'germe', 
     (SELECT i.label from ITEM i join ANNOTATION_VALEUR a on i.item_id=a.item_id join CHAMP_ANNOTATION c on a.champ_annotation_id=c.champ_annotation_id where c.nom like 'Résistance Méticilline' and a.objet_id=e.echantillon_id) as 'résistance méticilline', 
     (SELECT a.bool from ANNOTATION_VALEUR a join CHAMP_ANNOTATION c on a.champ_annotation_id=c.champ_annotation_id where c.nom like 'Dépistage' and a.objet_id=e.echantillon_id) as 'dépistage', 
     (SELECT a.bool from ANNOTATION_VALEUR a join CHAMP_ANNOTATION c on a.champ_annotation_id=c.champ_annotation_id where c.nom like 'BLSE' and a.objet_id=e.echantillon_id) as 'BLSE'
from PRELEVEMENT p 
left outer join SERVICE s on p.service_preleveur_id = s.service_id 
join ECHANTILLON e on p.prelevement_id=e.prelevement_id
where e.date_stock between '2020-09-01' and '2020-09-30';
-- INTO OUTFILE 'd:\\sepages_sep.csv'FIELDS TERMINATED BY '&|&' LINES TERMINATED BY '\n';


