select 'echanid', 'codeechantillon', 'typedechantillon', 'quantite', 'quantite_initiale', 'unite', 'datedestockage', 'delaidecongelation', 'operateur', 'temp_stockage', 'statutstockage', 'mode_preparation', 'date_heure_saisie', 'utilisateur_saisie', 'ktemperatureurine', 'kvalrefractometre', 'kcommentaire', 'kdecongelation', 'prelid', 'prelid',
'codeprelevement', 'nature', 'datedeprelevement', 'typedeprelevement', 'datestatut', 'datedepart', 'transporteur', 'temptransport', 'datedarrivee', 'congelationaudepartsite', 'congelationalarriveelabo', 'nbtotaldechantillons', 'nbdechantillonsrestants', 'nbechantillonsstockes', 'ageauprel', 'dateheuresaisie', 'utilisateur_saisie', 'patid', 'nomusuel', 'prenom', 'datenaissance', 'sexe', 'etatdupatient', 'commentaires', 'kdatededecongelation'
UNION ALL
select z1.*, z2.* from (SELECT e.echantillon_id as 'objet_id',
e.code as 'codeechantillon', et.type as 'typedechantillon',
quantite as 'quantite', quantite_init as 'quantite_initiale', u.unite as 'unite',
date_stock as'datedestockage', delai_cgl as 'delaidecongelation', co.nom as 'operateur',
(SELECT temp FROM CONTENEUR WHERE conteneur_id = get_conteneur(e.emplacement_id)) as 'temp_stockage',
os.statut as 'statutstockage',
mp.nom as 'mode_preparation',
(SELECT op.date_ FROM OPERATION op WHERE op.OPERATION_TYPE_ID = 3 AND op.entite_id = 3 AND op.objet_id = e.echantillon_id) as 'date_heure_saisie',
(SELECT ut.login FROM UTILISATEUR ut JOIN OPERATION op ON ut.utilisateur_id = op.utilisateur_id WHERE op.OPERATION_TYPE_ID = 3 AND op.entite_id = 3 AND op.objet_id = e.echantillon_id) as 'utilisateur_saisie',
(SELECT a.alphanum from ANNOTATION_VALEUR a where a.champ_annotation_id=157 and a.objet_id=e.echantillon_id) as 'ktemperatureurine',
(SELECT a.alphanum from ANNOTATION_VALEUR a where a.champ_annotation_id=163 and a.objet_id=e.echantillon_id) as 'kvalrefractometre',
(SELECT replace(replace(a.texte, '\n', ' '), '\r', ' ') from ANNOTATION_VALEUR a where a.champ_annotation_id=167 and a.objet_id=e.echantillon_id) as 'kcommentaire',
(SELECT i.label from ANNOTATION_VALEUR a join ITEM i on i.item_id=a.item_id where a.champ_annotation_id=308 and a.objet_id=e.echantillon_id) as 'kdecongelation',
e.prelevement_id
FROM ECHANTILLON e
LEFT JOIN ECHANTILLON_TYPE et ON e.ECHANTILLON_TYPE_ID = et.ECHANTILLON_TYPE_ID
LEFT JOIN UNITE u ON e.quantite_unite_id = u.unite_id
LEFT JOIN COLLABORATEUR co ON e.collaborateur_id = co.collaborateur_id
LEFT JOIN OBJET_STATUT os ON e.objet_statut_id = os.objet_statut_id
LEFT JOIN MODE_PREPA mp ON e.mode_prepa_id = mp.mode_prepa_id
WHERE e.banque_id = 14 GROUP BY e.echantillon_id) z1 join
(SELECT p.prelevement_id, p.code as 'codeprelevement', n.nature as 'nature',
p.date_prelevement as 'datedeprelevement', pt.type as 'typedeprelevement',
p.consent_date as 'datestatut',
p.date_depart as 'datedepart',
tr.nom as 'transporteur', p.transport_temp as 'temptransport', p.date_arrivee as 'datedarrivee',
p.cong_depart as 'congelationaudepartsite', p.cong_arrivee as 'congelationalarriveelabo',
(SELECT count(e.prelevement_id) FROM ECHANTILLON e WHERE e.prelevement_id = p.prelevement_id) AS 'nbtotaldechantillons',
(SELECT count(e1.prelevement_id) FROM ECHANTILLON e1 WHERE e1.prelevement_id = p.prelevement_id AND e1.quantite> 0) AS 'nbdechantillonsrestants',
(SELECT count(e2.prelevement_id) FROM ECHANTILLON e2 INNER JOIN OBJET_STATUT os ON e2.objet_statut_id = os.objet_statut_id AND (os.statut = 'STOCKE' OR os.statut = 'RESERVE') WHERE e2.prelevement_id = p.prelevement_id) as 'nbechantillonsstockes' ,
(select FLOOR(datediff(p.date_prelevement, pat.DATE_NAISSANCE)/365.25)) as 'ageauprel',
(SELECT op.date_ FROM OPERATION op WHERE op.OPERATION_TYPE_ID = 3 AND op.entite_id = 2 AND op.objet_id = p.prelevement_id) as 'dateheuresaisie',
(SELECT ut.login FROM UTILISATEUR ut JOIN OPERATION op ON ut.utilisateur_id = op.utilisateur_id WHERE op.OPERATION_TYPE_ID = 3 AND op.entite_id = 2 AND op.objet_id = p.prelevement_id) as 'utilisateur_saisie',
m.patient_id, pat.nom as 'nomusuel', pat.prenom as 'prenom', pat.date_naissance as 'datenaissance', pat.sexe as 'sexe', patient_etat as 'etatdupatient',
(SELECT replace(a.texte, '\r\n', ' ') from ANNOTATION_VALEUR a where a.champ_annotation_id=152 and a.objet_id=p.prelevement_id) as 'commentaires',
(SELECT a.anno_date from ANNOTATION_VALEUR a where a.champ_annotation_id=171 and a.objet_id=p.prelevement_id) as 'kdatededecongelation'
FROM PRELEVEMENT p INNER JOIN NATURE n on p.nature_id = n.nature_id
LEFT JOIN PRELEVEMENT_TYPE pt ON p.prelevement_type_id = pt.prelevement_type_id
LEFT JOIN TRANSPORTEUR tr ON p.transporteur_id = tr.transporteur_id
LEFT JOIN MALADIE m on p.maladie_id = m.maladie_id
LEFT JOIN PATIENT pat ON m.patient_id = pat.patient_id
WHERE p.banque_id = 14) z2 on z1.prelevement_id = z2.prelevement_id
INTO OUTFILE 'd:\\sepages.csv'FIELDS TERMINATED BY '&|&' LINES TERMINATED BY '&||&';
