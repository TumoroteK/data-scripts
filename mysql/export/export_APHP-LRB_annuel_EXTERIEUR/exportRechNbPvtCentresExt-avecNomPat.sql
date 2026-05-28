-- les patients sont anonymisés
-- en 2026, ajout de l'emplacement
SELECT 
	e.echantillon_id,
	e.code as code_echantillon,
	date_format(date_stock, '%Y-%m-%d %r') as date_stockage, 	
	e.CONFORME_TRAITEMENT as Conforme_apres_traitement,
	(select GROUP_CONCAT(nc.nom)
            FROM OBJET_NON_CONFORME onc
                   LEFT JOIN NON_CONFORMITE nc ON onc.non_conformite_id = nc.non_conformite_id
                   LEFT JOIN CONFORMITE_TYPE ct ON nc.conformite_type_id = ct.conformite_type_id
            WHERE ct.conformite_type_id = 2
              AND e.echantillon_id = onc.objet_id) as 'Non conformité de l''échantillon après traitement', 	
	co.nom as operateur_ech,
	p.code as code_prelevement,
	pt.type as type_conditionnement,
   	date_format(p.date_prelevement, '%Y-%m-%d %r') as date_prelevement,
    p.CONFORME_ARRIVEE as conforme_a_arrivee,
        (SELECT group_concat(n.nom) from NON_CONFORMITE n join OBJET_NON_CONFORME o on n.non_conformite_id=o.non_conformite_id where o.entite_id=2 and o.objet_id=p.prelevement_id) as non_conformite_arrivee, 
	p.date_arrivee,
    coco.nom as operateur_prel,
	(SELECT a.texte from ANNOTATION_VALEUR a where a.champ_annotation_id=(select champ_annotation_id from CHAMP_ANNOTATION where nom = 'Description NC pvt') and a.objet_id=p.prelevement_id) as desc_non_conform_arrivee,
	(SELECT a.texte from ANNOTATION_VALEUR a where a.champ_annotation_id=(select champ_annotation_id from CHAMP_ANNOTATION where nom = 'Description NC échantillon') and a.objet_id=e.echantillon_id) as desc_non_conform_ttt,
	pat.patient_id,
	pat.nom,
	get_adrl(e.emplacement_id) as emplacement
FROM ECHANTILLON e
JOIN BANQUE b on e.banque_id=b.banque_id  
JOIN PRELEVEMENT p on e.prelevement_id=p.prelevement_id 
LEFT JOIN PRELEVEMENT_TYPE pt ON p.prelevement_type_id = pt.prelevement_type_id
LEFT JOIN MALADIE m on p.maladie_id = m.maladie_id 
LEFT JOIN PATIENT pat ON m.patient_id = pat.patient_id 
LEFT JOIN COLLABORATEUR co ON e.collaborateur_id = co.collaborateur_id
LEFT JOIN COLLABORATEUR coco ON p.operateur_id = coco.collaborateur_id 
where 
	b.plateforme_id = 1
	and p.date_arrivee between '2025-01-01 00:00:00' and '2025-12-31 23:59:59'
	and co.NOM = 'EXTERIEUR';
