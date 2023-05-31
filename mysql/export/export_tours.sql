SELECT 'Id', 'Code échantillon', 'Type d''échantillon','Quantité', 'Unité de la quantité', 'Date de stockage','Opérateur', 'Emplacement', 'Température de stockage', 'Statut', 'Mode de préparation', 
'Conforme après traitement','Non conformité de l''échantillon après traitement', 'Evts de stockage',	'Type de support', 	'Centrifugeuse 1', 'Action NC Echantillon', 'Viabilité', 'Code échantillon',	'Incidence NC Echantillon',	'Description NC Echantillon', 'Centrifugeuse 2',	'NC corrigée après Action', 'Autre préparation',	'Collection',	'Code prélèvement', 'Nature','Date de prélèvement', 'Conforme à l''arrivée',	'Non conformité à l''arrivée', 'Etablissement préleveur',	'Service préleveur', 'Nombre de conditionnements', 	'Transporteur', 'N° Réception',	'Visite',	'Action NC 2',	'Incidence NC 2', 'Description NC 2', 'NC 2 corrigée après action', 'Action NC 1', 'Incidence NC 1',	'Description NC 1', 'NC 1 corrigée après Action', 'Commentaire'
UNION ALL
SELECT e.echantillon_id as 'echantillon_id', 
	e.code as 'Code échantillon', 
	et.type as 'Type d''échantillon', 
    e.quantite as 'Quantité', 
    -- quantite_init as 'quantite_initiale', 
    u.unite as 'Unité de la quantité',
	date_format(date_stock, '%Y-%m-%d %r') as 'Date de stockage', 
	-- delai_cgl as 'delaidecongelation', 
	co.nom as 'Opérateur', 
	get_adrl(e.emplacement_id) as 'Emplacement',
	(SELECT temp FROM CONTENEUR WHERE conteneur_id = get_conteneur(e.emplacement_id)) as 'Température de stockage',
	os.statut as 'Statut', 
	mp.nom as 'Mode de préparation', 
	e.CONFORME_TRAITEMENT as 'Conforme après traitement',
	(SELECT group_concat(n.nom) from NON_CONFORMITE n join OBJET_NON_CONFORME o on n.non_conformite_id=o.non_conformite_id where o.entite_id=3 and o.objet_id=e.echantillon_id) as 'Non conformité de l''échantillon après traitement', 
	(SELECT count(r.retour_id) from RETOUR r where r.entite_id=3 and r.objet_id=e.echantillon_id) as 'Evts de stockage',
	(SELECT i.label from ANNOTATION_VALEUR a join ITEM i on i.item_id=a.item_id where a.champ_annotation_id=(select champ_annotation_id from CHAMP_ANNOTATION where nom = 'Type de support') and a.objet_id=e.echantillon_id) as 'Type de support', 
	(SELECT i.label from ANNOTATION_VALEUR a join ITEM i on i.item_id=a.item_id where a.champ_annotation_id=(select champ_annotation_id from CHAMP_ANNOTATION where nom = 'Centrifugeuse 1' ) and a.objet_id=e.echantillon_id) as 'Centrifugeuse 1',
	(SELECT i.label from ANNOTATION_VALEUR a join ITEM i on i.item_id=a.item_id where a.champ_annotation_id=(select champ_annotation_id from CHAMP_ANNOTATION where nom = 'Action NC Echantillon' ) and a.objet_id=e.echantillon_id) as 'Action NC Echantillon' ,
	(SELECT a.alphanum from ANNOTATION_VALEUR a where a.champ_annotation_id=(select champ_annotation_id from CHAMP_ANNOTATION where nom = 'Viabilité') and a.objet_id=e.echantillon_id) as 'Viabilité', 
	(SELECT a.texte from ANNOTATION_VALEUR a where a.champ_annotation_id=(select champ_annotation_id from CHAMP_ANNOTATION where nom = 'Code échantillon') and a.objet_id=e.echantillon_id)  as 'Code échantillon' , 
	(SELECT i.label from ANNOTATION_VALEUR a join ITEM i on i.item_id=a.item_id where a.champ_annotation_id=(select champ_annotation_id from CHAMP_ANNOTATION where nom = 'Incidence NC Echantillon' ) and a.objet_id=e.echantillon_id) as 'Incidence NC Echantillon', 
	(SELECT a.alphanum from ANNOTATION_VALEUR a where a.champ_annotation_id=(select champ_annotation_id from CHAMP_ANNOTATION where nom = 'Description NC Echantillon') and a.objet_id=e.echantillon_id) as 'Description NC Echantillon', 
	(SELECT i.label from ANNOTATION_VALEUR a join ITEM i on i.item_id=a.item_id where a.champ_annotation_id=(select champ_annotation_id from CHAMP_ANNOTATION where nom = 'Centrifugeuse 2' ) and a.objet_id=e.echantillon_id) as 'Centrifugeuse 2',
	(SELECT a.bool from ANNOTATION_VALEUR a where a.champ_annotation_id=64 and a.objet_id=e.echantillon_id) as 'NC corrigée après Action', 
	(SELECT a.alphanum from ANNOTATION_VALEUR a where a.champ_annotation_id=(select champ_annotation_id from CHAMP_ANNOTATION where nom = 'Autre préparation') and a.objet_id=e.echantillon_id) as 'Autre préparation',
	b.nom as 'Collection',
	p.code as 'Code prélèvement',
	n.nature as 'Nature',
    date_format(p.date_prelevement, '%Y-%m-%d %r') as 'Date de prélèvement',
    p.CONFORME_ARRIVEE as 'Conforme à l''arrivée',
    (SELECT group_concat(n.nom) from NON_CONFORMITE n join OBJET_NON_CONFORME o on n.non_conformite_id=o.non_conformite_id where o.entite_id=2 and o.objet_id=p.prelevement_id) as 'Non conformité à l''arrivée', 
	st.nom as 'Etablissement préleveur',
	s.nom as 'Service préleveur',
	p.condit_nbr as 'Nombre de conditionnements',
	tr.nom as 'Transporteur',
	(SELECT a.alphanum from ANNOTATION_VALEUR a where a.champ_annotation_id=(select champ_annotation_id from CHAMP_ANNOTATION where nom = 'N° Réception') and a.objet_id=p.prelevement_id) as 'N° Réception', 
	(SELECT a.alphanum from ANNOTATION_VALEUR a where a.champ_annotation_id=3 and a.objet_id=p.prelevement_id) as 'Visite',
	(SELECT i.label from ANNOTATION_VALEUR a join ITEM i on i.item_id=a.item_id where a.champ_annotation_id=(select champ_annotation_id from CHAMP_ANNOTATION where nom = 'Action NC 2') and a.objet_id=p.prelevement_id) as 'Action NC 2',
	(SELECT i.label from ANNOTATION_VALEUR a join ITEM i on i.item_id=a.item_id where a.champ_annotation_id=(select champ_annotation_id from CHAMP_ANNOTATION where nom = 'Incidence NC 2') and a.objet_id=p.prelevement_id) as 'Incidence NC 2',
	(SELECT a.alphanum from ANNOTATION_VALEUR a where a.champ_annotation_id=(select champ_annotation_id from CHAMP_ANNOTATION where nom = 'Description NC 2') and a.objet_id=p.prelevement_id) as 'Description NC 2', 
	(SELECT a.bool from ANNOTATION_VALEUR a where a.champ_annotation_id=(select champ_annotation_id from CHAMP_ANNOTATION where nom = 'NC 2 corrigée après action') and a.objet_id=p.prelevement_id) as 'NC 2 corrigée après action',
	(SELECT i.label from ANNOTATION_VALEUR a join ITEM i on i.item_id=a.item_id where a.champ_annotation_id=(select champ_annotation_id from CHAMP_ANNOTATION where nom = 'Action NC 1') and a.objet_id=p.prelevement_id) as 'Action NC 1',
	(SELECT i.label from ANNOTATION_VALEUR a join ITEM i on i.item_id=a.item_id where a.champ_annotation_id=(select champ_annotation_id from CHAMP_ANNOTATION where nom = 'Incidence NC 1') and a.objet_id=p.prelevement_id) as 'Incidence NC 1',
	(SELECT a.alphanum from ANNOTATION_VALEUR a where a.champ_annotation_id=(select champ_annotation_id from CHAMP_ANNOTATION where nom = 'Description NC 1') and a.objet_id=p.prelevement_id) as 'Description NC 1', 
	(SELECT a.bool from ANNOTATION_VALEUR a where a.champ_annotation_id=(select champ_annotation_id from CHAMP_ANNOTATION where nom = 'NC 1 corrigée après action') and a.objet_id=p.prelevement_id) as 'NC 1 corrigée après action',
	(SELECT a.alphanum from ANNOTATION_VALEUR a where a.champ_annotation_id=(select champ_annotation_id from CHAMP_ANNOTATION where nom = 'Commentaire') and a.objet_id=p.prelevement_id) as 'Commentaire' 
	 -- (SELECT date_format(op.date_, '%Y-%m-%d %r') FROM OPERATION op WHERE op.OPERATION_TYPE_ID = 3 AND op.entite_id = 3 AND op.objet_id = e.echantillon_id) as 'date_heure_saisie', 
	-- (SELECT ut.login FROM UTILISATEUR ut JOIN OPERATION op ON ut.utilisateur_id = op.utilisateur_id WHERE op.OPERATION_TYPE_ID = 3 AND op.entite_id = 3 AND op.objet_id = e.echantillon_id) as 'utilisateur_saisie', 

FROM ECHANTILLON e 
JOIN BANQUE b on e.banque_id=b.banque_id
JOIN PLATEFORME pl on b.plateforme_id=pl.plateforme_id 
JOIN PRELEVEMENT p on e.prelevement_id=p.prelevement_id 
JOIN NATURE n on p.nature_id = n.nature_id
LEFT JOIN PRELEVEMENT_TYPE pt ON p.prelevement_type_id = pt.prelevement_type_id 
LEFT JOIN TRANSPORTEUR tr ON p.transporteur_id = tr.transporteur_id
LEFT JOIN MALADIE m on p.maladie_id = m.maladie_id 
LEFT JOIN PATIENT pat ON m.patient_id = pat.patient_id 
LEFT JOIN ECHANTILLON_TYPE et ON e.ECHANTILLON_TYPE_ID = et.ECHANTILLON_TYPE_ID
LEFT JOIN UNITE u ON e.quantite_unite_id = u.unite_id
LEFT JOIN COLLABORATEUR co ON e.collaborateur_id = co.collaborateur_id
LEFT JOIN OBJET_STATUT os ON e.objet_statut_id = os.objet_statut_id 
LEFT JOIN MODE_PREPA mp ON e.mode_prepa_id = mp.mode_prepa_id 
LEFT JOIN SERVICE s on p.service_preleveur_id=s.service_id 
LEFT JOIN ETABLISSEMENT st on s.etablissement_id=st.etablissement_id 
WHERE 
--	p.date_date_arrivee between '2022-01-01' and '2022-03-31'
--	and 
	pl.nom='CRB'
--	p.date_prelevement between '2022-06-01' and '2022-07-31'
	and b.BANQUE_ID = 218
-- WHERE p.date_prelevement between '2021-10-01' and '2021-12-31' 
-- WHERE p.date_prelevement between '2022-01-01' and '2022-03-31' 
-- WHERE p.date_prelevement between '2022-04-01'  and '2022-06-17' 

INTO OUTFILE '/data/export_biosuport.csv' FIELDS TERMINATED BY ';' ENCLOSED BY '"' LINES TERMINATED BY '\n';




