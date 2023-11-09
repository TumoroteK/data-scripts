-- cette commande permet d'afficher correctement les caractères accentués de l'entête
-- si lors de l'ouverture dans excel, les accents s'affichent mal, dans la fenêtre d'importation du fichier,
-- après avoir choisi le mode "délimité", choisir origine du fichier 65001 : Unicode (UTF-8)
SET NAMES 'utf8';

select 'Collection' ,'Code échantillon','Type d''échantillon','Quantité','Quantité initiale','Unité de la quantité','Date de stockage','Opérateur','Emplacement','Statut', 'Code Organe', 'Code Lésionnel', 
'Nb. dérivés','Date heure de saisie','Utilisateur ayant saisi', 'Année de réception-stockage', 'bloc créé au CRB', 'réception CRB', 'année de réception', 'Organe Inspire',
'Code prélèvement','Nature','Date de prélèvement','Statut juridique',
'Nb total d''échantillons','Nb d''échantillons restants','Nb échantillons stockés','Nb produits dérivés','année réception','Collection projet',
'Id patient', 'Nom','Sexe', 'age souris', 'groupe souris'
union all
SELECT
	b.nom,
	e.code as code_echantillon, 
	et.type as type_echantillon, 
    e.quantite, 
    e.quantite_init as quantite_initiale, 
    u.unite as unite_quantite,
	date_format(date_stock, '%Y-%m-%d %r') as date_stockage, 
	co.nom as operateur, 
	get_adrl(e.emplacement_id) as emplacement,
	os.statut,
    LEFT(COALESCE(
		(SELECT GROUP_CONCAT(distinct(ca.code))
		FROM CODE_ASSIGNE ca
 		WHERE ca.IS_ORGANE = 1
			AND ca.echantillon_id = e.echantillon_id
		group by e.echantillon_id ORDER BY ca.ordre), ''), 500) as code_organe,
    LEFT(COALESCE(
		(SELECT GROUP_CONCAT(distinct(ca.code))
		FROM CODE_ASSIGNE ca
		WHERE ca.IS_MORPHO = 1
			AND ca.echantillon_id = e.echantillon_id
		group by ca.echantillon_id ORDER BY ca.ordre),''), 500) as code_lesionnel,	
    (SELECT COUNT(tr.objet_id)
             FROM TRANSFORMATION tr
                    INNER JOIN PROD_DERIVE pd ON tr.TRANSFORMATION_ID = pd.TRANSFORMATION_ID
             WHERE tr.OBJET_ID = e.echantillon_id
               and tr.entite_id = 3) as nb_produits_derives,
   (SELECT op.date_ FROM OPERATION op WHERE op.OPERATION_TYPE_ID = 3
										AND op.entite_id = 3
										AND op.objet_id = e.echantillon_id) as date_heure_saisie,
   (SELECT coalesce(ut.login, '')
	FROM UTILISATEUR ut
		   JOIN OPERATION op ON ut.utilisateur_id = op.utilisateur_id
	WHERE op.OPERATION_TYPE_ID = 3
	  AND op.entite_id = 3
	  AND op.objet_id = e.echantillon_id) as utilisateur_saisie,     			   
	COALESCE((SELECT a.alphanum from ANNOTATION_VALEUR a where a.champ_annotation_id=(select ca.champ_annotation_id from CHAMP_ANNOTATION ca inner join TABLE_ANNOTATION ta on ta.table_annotation_id = ca.table_annotation_id where ca.nom = 'Année de réception-stockage'and ta.nom = 'Stockage CRB') and a.objet_id=e.echantillon_id),'') as 'Année de réception-stockage', 
	COALESCE((SELECT i.label from ANNOTATION_VALEUR a join ITEM i on i.item_id=a.item_id where a.champ_annotation_id=(select champ_annotation_id from CHAMP_ANNOTATION ca inner join TABLE_ANNOTATION ta on ta.table_annotation_id = ca.table_annotation_id where ca.nom = 'bloc créé au CRB'and ta.nom = 'Stockage CRB') and a.objet_id=e.echantillon_id),'') as 'bloc créé au CRB', 
	COALESCE((SELECT i.label from ANNOTATION_VALEUR a join ITEM i on i.item_id=a.item_id where a.champ_annotation_id=(select ca.champ_annotation_id from CHAMP_ANNOTATION ca inner join TABLE_ANNOTATION ta on ta.table_annotation_id = ca.table_annotation_id where ca.nom = 'réception CRB' and ta.nom = 'ECHANTILLON INSPIRE') and a.objet_id=e.echantillon_id),'') as 'réception CRB', 
	COALESCE((SELECT a.alphanum from ANNOTATION_VALEUR a where a.champ_annotation_id=(select champ_annotation_id from CHAMP_ANNOTATION ca inner join TABLE_ANNOTATION ta on ta.table_annotation_id = ca.table_annotation_id where ca.nom = 'année de réception' and ta.nom = 'ECHANTILLON INSPIRE') and a.objet_id=e.echantillon_id),'') as 'année de réception', 
	COALESCE((SELECT i.label from ANNOTATION_VALEUR a join ITEM i on i.item_id=a.item_id where a.champ_annotation_id=(select champ_annotation_id from CHAMP_ANNOTATION ca inner join TABLE_ANNOTATION ta on ta.table_annotation_id = ca.table_annotation_id where ca.nom = 'Organe Inspire' and ta.nom = 'ECHANTILLON INSPIRE') and a.objet_id=e.echantillon_id),'') as 'Organe Inspire', 
	p.code as code_prelevement,
	n.nature as nature,
    date_format(p.date_prelevement, '%Y-%m-%d %r') as date_prelevement,
    consent.type as statut_juridique,
        (SELECT count(e.prelevement_id) FROM ECHANTILLON e WHERE e.prelevement_id = p.prelevement_id) AS total_echantillons,
        (SELECT count(e1.prelevement_id) FROM ECHANTILLON e1 WHERE e1.prelevement_id = p.prelevement_id
                                                                  AND e1.quantite > 0)                   AS echantillons_restants,
        (SELECT count(e2.prelevement_id)
            FROM ECHANTILLON e2
                   INNER JOIN OBJET_STATUT os ON e2.objet_statut_id = os.objet_statut_id AND (os.statut = 'STOCKE' OR os.statut = 'RESERVE')
            WHERE e2.prelevement_id = p.prelevement_id)                                                  as echantillons_stockes,
        (SELECT COUNT(tr.objet_id)
            FROM TRANSFORMATION tr
                   INNER JOIN PROD_DERIVE pd ON tr.TRANSFORMATION_ID = pd.TRANSFORMATION_ID
            WHERE tr.OBJET_ID = p.prelevement_id
              and tr.entite_id = 2)  as nb_produits_derives,
	COALESCE((SELECT a.alphanum from ANNOTATION_VALEUR a where a.champ_annotation_id=(select ca.champ_annotation_id from CHAMP_ANNOTATION ca inner join TABLE_ANNOTATION ta on ta.table_annotation_id = ca.table_annotation_id where ca.nom = 'année réception' and ta.nom = 'Année Réception') and a.objet_id=p.prelevement_id),'') as 'année réception', 
	COALESCE((SELECT i.label from ANNOTATION_VALEUR a join ITEM i on i.item_id=a.item_id where a.champ_annotation_id=(select champ_annotation_id from CHAMP_ANNOTATION ca inner join TABLE_ANNOTATION ta on ta.table_annotation_id = ca.table_annotation_id where ca.nom = 'Collection projet' and ta.nom = 'Collection') and a.objet_id=p.prelevement_id), '') as 'Collection Projet', 
	pat.patient_id,
	pat.nom,
	pat.sexe,
	COALESCE((SELECT i.label from ANNOTATION_VALEUR a join ITEM i on i.item_id=a.item_id where a.champ_annotation_id=(select champ_annotation_id from CHAMP_ANNOTATION ca inner join TABLE_ANNOTATION ta on ta.table_annotation_id = ca.table_annotation_id where ca.nom = 'age souris' and ta.nom = 'PATIENT INSPIRE') and a.objet_id=pat.patient_id), '') as 'age souris', 
	COALESCE((SELECT i.label from ANNOTATION_VALEUR a join ITEM i on i.item_id=a.item_id where a.champ_annotation_id=(select champ_annotation_id from CHAMP_ANNOTATION ca inner join TABLE_ANNOTATION ta on ta.table_annotation_id = ca.table_annotation_id where ca.nom = 'groupe souris' and ta.nom = 'PATIENT INSPIRE') and a.objet_id=pat.patient_id), '') as 'groupe souris'
FROM ECHANTILLON e 
JOIN BANQUE b on e.banque_id=b.banque_id 
JOIN PRELEVEMENT p on e.prelevement_id=p.prelevement_id 
JOIN NATURE n on p.nature_id = n.nature_id
LEFT JOIN PRELEVEMENT_TYPE pt ON p.prelevement_type_id = pt.prelevement_type_id
LEFT JOIN CONSENT_TYPE consent ON p.consent_type_id = consent.consent_type_id 
LEFT JOIN MALADIE m on p.maladie_id = m.maladie_id 
LEFT JOIN PATIENT pat ON m.patient_id = pat.patient_id 
LEFT JOIN ECHANTILLON_TYPE et ON e.ECHANTILLON_TYPE_ID = et.ECHANTILLON_TYPE_ID
LEFT JOIN UNITE u ON e.quantite_unite_id = u.unite_id
LEFT JOIN COLLABORATEUR co ON e.collaborateur_id = co.collaborateur_id
LEFT JOIN OBJET_STATUT os ON e.objet_statut_id = os.objet_statut_id 
WHERE 
	b.NOM = 'INSPIRE' 
	
INTO OUTFILE 'D:/MySQL/Uploads/exportINSPIRE.csv' FIELDS TERMINATED BY ';' ENCLOSED BY '"' LINES TERMINATED BY '\n';	