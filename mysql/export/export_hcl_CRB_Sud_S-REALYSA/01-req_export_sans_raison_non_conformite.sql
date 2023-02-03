select 'identifiant échantillon', 'Code échantillon','Type d''échantillon','Quantité','Quantité initiale','Unité de la quantité','Date de stockage','Délai de congélation','Opérateur','Emplacement','Statut','Mode de préparation','Stérile','Conforme après traitement','Non conformité de l''échantillon après traitement','Conforme pour la cession','Non conformité de l''échantillon à la cession','Nb. dérivés','Evts de stockage','Identifiant prélèvement','Code prélèvement','N° Laboratoire','Nature','Date de prélèvement','Type de prélèvement','Stérile','Risque Infectieux','Conforme à l''arrivée','Non conformité à l''arrivée','Etablissement préleveur','Service préleveur','Type de conditionnement','Nombre de conditionnements','Milieu','Statut juridique','Date du statut juridique','Date de départ','Transporteur','Temp. de transport','Date d''arrivée','Opérateur','Quantité','N° de dossier patient','Nb total d''échantillons','Nb d''échantillons restants','Nb échantillons stockés','Age au prélèvement','Nb produits dérivés','Libellé','Nom','Sexe','Nb prélèvements'
union all
SELECT e.echantillon_id, e.code as code_echantillon, 
	et.type as type_echantillon, 
    e.quantite, 
    e.quantite_init as quantite_initiale, 
    u.unite as unite_quantite,
	date_format(date_stock, '%Y-%m-%d %r') as date_stockage, 
	e.delai_cgl as delai_congelation, 
	co.nom as operateur, 
	get_adrl(e.emplacement_id) as emplacement,
	os.statut, 
	mp.nom as mode_preparation, 
	e.sterile,
	e.CONFORME_TRAITEMENT as Conforme_apres_traitement,
	'???REQ_NUMERO_2???' as 'Non conformité de l''échantillon après traitement', 	
	e.conforme_cession as conforme_cession,
	'???REQ_NUMERO_3???' as 'Raison_de_non_conformie_pour_la_cession',
        (SELECT COUNT(tr.objet_id)
            FROM TRANSFORMATION tr
                   INNER JOIN PROD_DERIVE pd ON tr.TRANSFORMATION_ID = pd.TRANSFORMATION_ID
            WHERE tr.OBJET_ID = e.echantillon_id
              and tr.entite_id = 3) as nb_produits_derives,
	(SELECT count(r.retour_id) from RETOUR r where r.entite_id=3 and r.objet_id=e.echantillon_id) as Evts_stockage,
	p.prelevement_id,
	p.code as code_prelevement,
	p.numero_labo as numero_laboratoire,
	n.nature as nature,
    	date_format(p.date_prelevement, '%Y-%m-%d %r') as date_prelevement,
	pt.type as type_conditionnement,
	p.sterile,
	(select GROUP_CONCAT(r.nom)
            from RISQUE r
                   JOIN PRELEVEMENT_RISQUE pr ON r.risque_id = pr.risque_id
            WHERE pr.prelevement_id = p.prelevement_id) as risque_infectieux,
        p.CONFORME_ARRIVEE as conforme_a_arrivee,
        '???REQ_NUMERO_4???' as non_conformite_arrivee, 
	st.nom as etablissement_preleveur,
	s.nom as service_preleveur,
	ct.type as type_conditionnement,
	p.condit_nbr as nombre_conditionnements,
	cm.milieu,
        consent.type as statut_juridique,
        p.consent_date as date_statut,
        p.date_depart,
	tr.nom as transporteur,
	p.transport_temp as température_transport,
	p.date_arrivee,
        coco.nom as operateur,
        p.quantite,
        p.patient_nda  as numero_dossier_patient,
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
	m.libelle,
	pat.nom,
	pat.sexe,
        (SELECT count(1) FROM PRELEVEMENT pr
                INNER JOIN MALADIE mal 
                WHERE pr.maladie_id = mal.maladie_id AND mal.patient_id = pat.patient_id) as nb_prelevements
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
	b.NOM = 'S-REALYSA';