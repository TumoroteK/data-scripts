-- Requête lancée directement dans l'éditeur mysql (depuis un fichier). Formatage ensuite du fichier txt récupéré dans excel avec séparateur tabulation et format utgf-8
-- les new et mises en commentaire sont les écart avec la requête faite pour les HCL, collection S-REALYSA.
-- en janvier 2024, le CHU de Cean est en version 2.1.4 
-- 

-- cette commande permet d'afficher correctement les caractères accentués de l'entête
SET NAMES 'utf8';

SELECT 
	-- new :
	e.echantillon_id as id_echantillon,
	-- new
	b.nom as collection,
	e.code as code_echantillon, 
	et.type as type_echantillon, 
    e.quantite, 
    e.quantite_init as quantite_initiale, 
    u.unite as unite_quantite,
	date_format(date_stock, '%Y-%m-%d %r') as date_stockage, 
	e.delai_cgl as delai_congelation, 
	co.nom as operateur, 
	get_adrl(e.emplacement_id) as emplacement,
	-- new
	(SELECT temp FROM CONTENEUR WHERE conteneur_id = get_conteneur(e.emplacement_id)) as temperature_stockage,
	os.statut, 
	mp.nom as mode_preparation, 
	-- e.sterile,
	e.CONFORME_TRAITEMENT as Conforme_apres_traitement,
	(select GROUP_CONCAT(nc.nom)
            FROM OBJET_NON_CONFORME onc
                   LEFT JOIN NON_CONFORMITE nc ON onc.non_conformite_id = nc.non_conformite_id
                   LEFT JOIN CONFORMITE_TYPE ct ON nc.conformite_type_id = ct.conformite_type_id
            WHERE ct.conformite_type_id = 2
              AND e.echantillon_id = onc.objet_id) as 'Non conformité de l''échantillon après traitement', 	
	e.conforme_cession as conforme_cession,
	(select GROUP_CONCAT(nc.nom)
            FROM OBJET_NON_CONFORME onc
                   LEFT JOIN NON_CONFORMITE nc ON onc.non_conformite_id = nc.non_conformite_id
                   LEFT JOIN CONFORMITE_TYPE ct ON nc.conformite_type_id = ct.conformite_type_id
            WHERE ct.conformite_type_id = 3
              AND e.echantillon_id = onc.objet_id) as 'Raison_de_non_conformie_pour_la_cession',
    (SELECT COUNT(tr.objet_id)
            FROM TRANSFORMATION tr
                   INNER JOIN PROD_DERIVE pd ON tr.TRANSFORMATION_ID = pd.TRANSFORMATION_ID
            WHERE tr.OBJET_ID = e.echantillon_id
              and tr.entite_id = 3) as nb_produits_derives,
	(SELECT count(r.retour_id) from RETOUR r where r.entite_id=3 and r.objet_id=e.echantillon_id) as Evts_stockage,
	-- new
    (SELECT op.date_ FROM OPERATION op WHERE op.OPERATION_TYPE_ID = 3
                                                AND op.entite_id = 3
                                                AND op.objet_id = e.echantillon_id) as date_heure_saisie_echantillon,
	-- new
	(SELECT ut.login
            FROM UTILISATEUR ut
                   JOIN OPERATION op ON ut.utilisateur_id = op.utilisateur_id
            WHERE op.OPERATION_TYPE_ID = 3
              AND op.entite_id = 3
              AND op.objet_id = e.echantillon_id)  as Utilisateur_saisie_echantillon,	
	-- new spécifique
	COALESCE((SELECT a.alphanum from ANNOTATION_VALEUR a where a.champ_annotation_id=(select ca.champ_annotation_id from CHAMP_ANNOTATION ca inner join TABLE_ANNOTATION ta on ta.table_annotation_id = ca.table_annotation_id where ca.nom = '% VIABILITE BT' and ta.nom = 'Viabilité cellulaire') and a.objet_id=e.echantillon_id),'') as '% VIABILITE BT', 
	COALESCE((SELECT a.alphanum from ANNOTATION_VALEUR a where a.champ_annotation_id=(select ca.champ_annotation_id from CHAMP_ANNOTATION ca inner join TABLE_ANNOTATION ta on ta.table_annotation_id = ca.table_annotation_id where ca.nom = 'Code barre tube' and ta.nom = 'Code barre tube') and a.objet_id=e.echantillon_id),'') as 'Code barre tube',
	-- new 
	e.prelevement_id, 
	p.code as code_prelevement,
    -- p.numero_labo as numero_laboratoire,
	n.nature as nature,
	-- new /!\ protocoles uniquement dans contexte sérologie .... --- /!\ 2.1.4
--    LEFT((SELECT GROUP_CONCAT(pt.nom)
--		FROM PRELEVEMENT prlt
--		   JOIN PRELEVEMENT_DELEGATE pd ON pd.PRELEVEMENT_ID = prlt.PRELEVEMENT_ID
--		   JOIN PRELEVEMENT_SERO ps ON ps.PRELEVEMENT_DELEGATE_ID = pd.PRELEVEMENT_DELEGATE_ID
--		   JOIN PRELEVEMENT_SERO_PROTOCOLE psp ON psp.PRELEVEMENT_DELEGATE_ID = pd.PRELEVEMENT_DELEGATE_ID
--		   JOIN PROTOCOLE pt ON pt.PROTOCOLE_ID = psp.PROTOCOLE_ID
--		WHERE prlt.PRELEVEMENT_ID = id), 200)  as protocoles,	
    date_format(p.date_prelevement, '%Y-%m-%d %r') as date_prelevement,
	pt.type as type_conditionnement,
	-- p.sterile,
	-- (select GROUP_CONCAT(r.nom)
    --        from RISQUE r
    --               JOIN PRELEVEMENT_RISQUE pr ON r.risque_id = pr.risque_id
    --        WHERE pr.prelevement_id = p.prelevement_id) as risque_infectieux,
    p.CONFORME_ARRIVEE as conforme_a_arrivee,
    (SELECT group_concat(n.nom) from NON_CONFORMITE n join OBJET_NON_CONFORME o on n.non_conformite_id=o.non_conformite_id where o.entite_id=2 and o.objet_id=p.prelevement_id) as non_conformite_arrivee, 
	st.nom as etablissement_preleveur,
	s.nom as service_preleveur,
	ct.type as type_conditionnement,
	p.condit_nbr as nombre_conditionnements,
	-- cm.milieu,
    consent.type as statut_juridique,
    -- p.consent_date as date_statut,
	-- new /!\ complément diagnostic uniquement dans contexte sérologie --- /!\ 2.1.4
--    (SELECT ps.libelle
--            FROM PRELEVEMENT prel
--                   JOIN PRELEVEMENT_DELEGATE pd ON pd.prelevement_id = prel.prelevement_id
--                   JOIN PRELEVEMENT_SERO ps ON ps.prelevement_delegate_id = pd.prelevement_delegate_id
--            WHERE prel.prelevement_id = id)                                                              as 'Complement_diagnostic',	
	p.date_depart,
	tr.nom as transporteur,
	p.transport_temp as température_transport,
	p.date_arrivee,
    coco.nom as operateur,
    -- new
    p.cong_depart,
	-- new
    p.cong_arrivee,
	-- new	
    (select count(l.labo_inter_id) FROM LABO_INTER l where l.prelevement_id = p.prelevement_id) as nb_site_intermediaire,
	p.quantite,
    p.patient_nda  as numero_dossier_patient,
	-- new Diagnostic .... /!\ sero mais version 2.1.4 !!!!
--    (SELECT d.nom
--            FROM PRELEVEMENT prel
--                   JOIN MALADIE m ON prel.maladie_id = m.maladie_id
--                   JOIN MALADIE_DELEGATE md ON md.maladie_id =
--                                               m.maladie_id
--                   JOIN MALADIE_SERO ms ON ms.maladie_delegate_id = md.maladie_delegate_id
--                   JOIN DIAGNOSTIC d ON d.diagnostic_id =
--                                        ms.diagnostic_id
--            WHERE prel.prelevement_id = id) as 'Diagnostic',
    (SELECT count(e.prelevement_id) FROM ECHANTILLON e WHERE e.prelevement_id = p.prelevement_id) AS total_echantillons,
    (SELECT count(e1.prelevement_id) FROM ECHANTILLON e1 WHERE e1.prelevement_id = p.prelevement_id
                                                                  AND e1.quantite > 0)                   AS echantillons_restants,
    (SELECT count(e2.prelevement_id)
            FROM ECHANTILLON e2
                   INNER JOIN OBJET_STATUT os ON e2.objet_statut_id = os.objet_statut_id AND (os.statut = 'STOCKE' OR os.statut = 'RESERVE')
            WHERE e2.prelevement_id = p.prelevement_id)                                                  as echantillons_stockes,
    (select FLOOR(datediff(p.date_prelevement, pat.DATE_NAISSANCE) / 365.25)) as age_au_prelevement,
    (SELECT COUNT(tr.objet_id)
            FROM TRANSFORMATION tr
                   INNER JOIN PROD_DERIVE pd ON tr.TRANSFORMATION_ID = pd.TRANSFORMATION_ID
            WHERE tr.OBJET_ID = p.prelevement_id
              and tr.entite_id = 2)  as nb_produits_derives,
	-- new
    (SELECT op.date_ FROM OPERATION op WHERE op.OPERATION_TYPE_ID = 3
                                                AND op.entite_id = 2
                                                AND op.objet_id = p.prelevement_id)  as 'date_heure_saisie_prelevement',
    -- new
	(SELECT ut.login
            FROM UTILISATEUR ut
                   JOIN OPERATION op ON ut.utilisateur_id = op.utilisateur_id
            WHERE op.OPERATION_TYPE_ID = 3
              AND op.entite_id = 2
              AND op.objet_id = p.prelevement_id)  as 'Utilisateur_saisie_prelevement',	
	-- --------------------------- /!\ annotation
	-- new spécifique
	COALESCE((SELECT a.alphanum from ANNOTATION_VALEUR a where a.champ_annotation_id=(select ca.champ_annotation_id from CHAMP_ANNOTATION ca inner join TABLE_ANNOTATION ta on ta.table_annotation_id = ca.table_annotation_id where ca.nom = 'Remarque' and ta.nom = 'Remarques / Déviations' and ta.entite_id=2) and a.objet_id=p.prelevement_id),'') as 'Remarques / Déviations prélèvement',
	COALESCE((SELECT a.alphanum from ANNOTATION_VALEUR a where a.champ_annotation_id=(select ca.champ_annotation_id from CHAMP_ANNOTATION ca inner join TABLE_ANNOTATION ta on ta.table_annotation_id = ca.table_annotation_id where ca.nom = 'N°TDHC' and ta.nom = 'Dossier TDHC') and a.objet_id=p.prelevement_id),'') as 'N°TDHC',
	m.libelle,
	-- pat.nom,
	pat.sexe,
    -- new : ORGANE /!\ 
--    LEFT((SELECT GROUP_CONCAT(distinct(ca.code) ORDER BY ca.ordre) 
--                FROM PATIENT p
--                   INNER JOIN MALADIE m
--                   INNER JOIN PRELEVEMENT pr
--                   INNER JOIN ECHANTILLON e
--                   JOIN CODE_ASSIGNE ca
--                WHERE p.patient_id = m.patient_id
--                   AND m.maladie_id = pr.maladie_id
--                   AND pr.prelevement_id = e.prelevement_id
--                   AND e.echantillon_id = ca.echantillon_id
--                   AND ca.IS_ORGANE = 1
--                   AND p.patient_id = id), 500) as organe,	
	(SELECT count(1) FROM PRELEVEMENT pr
                INNER JOIN MALADIE mal 
                WHERE pr.maladie_id = mal.maladie_id AND mal.patient_id = pat.patient_id) as nb_prelevements,
    -- new
	(SELECT ut.login
            FROM UTILISATEUR ut
                   JOIN OPERATION op ON ut.utilisateur_id = op.utilisateur_id
            WHERE op.OPERATION_TYPE_ID = 3
              AND op.entite_id = 1
              AND op.objet_id = pat.patient_id) as utilisateur_saisie_patient,
    -- new
	(SELECT op.date_ FROM OPERATION op WHERE op.OPERATION_TYPE_ID = 3
                                                AND op.entite_id = 1
                                                AND op.objet_id = pat.patient_id) as date_saisie_patient,
	-- new spécifique : Remarques est défini comme libellé de champ sur 2 tables d'annotation => ajout de l'id de la table d'annotation :
	COALESCE((SELECT a.alphanum from ANNOTATION_VALEUR a where a.champ_annotation_id=(select ca.champ_annotation_id from CHAMP_ANNOTATION ca inner join TABLE_ANNOTATION ta on ta.table_annotation_id = ca.table_annotation_id where ca.nom = 'Remarques' and ta.nom = 'Remarques / Déviations' and ta.entite_id=1) and a.objet_id=pat.patient_id),'') as '% VIABILITE BT'
FROM ECHANTILLON e 
JOIN BANQUE b on e.banque_id=b.banque_id 
JOIN PRELEVEMENT p on e.prelevement_id=p.prelevement_id 
JOIN NATURE n on p.nature_id = n.nature_id
LEFT JOIN PRELEVEMENT_TYPE pt ON p.prelevement_type_id = pt.prelevement_type_id
LEFT JOIN CONSENT_TYPE consent ON p.consent_type_id = consent.consent_type_id 
LEFT JOIN CONDIT_TYPE ct ON p.condit_type_id = ct.condit_type_id 
LEFT JOIN CONDIT_MILIEU cm ON p.condit_milieu_id = cm.condit_milieu_id
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
LEFT JOIN COLLABORATEUR coco ON p.operateur_id = coco.collaborateur_id 
WHERE 
	-- b.NOM not in ('EFS', 'EFS_Méthode', 'SANITAIRE_ANAPATH', 'SENTINELLE', 'VALIDATION_AUTOMACS')
	b.banque_id not in (61, 107, 116, 94, 130)
	and 
	b.PLATEFORME_ID = 1
	-- and
	-- date_stock <= '2024-12-31-23:59:59'
	-- condition ci-dessous non présente lors de l'export de janvier 2024 mais ce filtre supplémentaire correspond mieux à ce qui était demandé
	-- tout en limitant le nombre de lignes exportées
	and
	os.statut = 'STOCKE';	
	;