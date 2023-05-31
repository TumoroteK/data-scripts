SELECT 'identifiant échantillon', 'Code échantillon', 'identifiant évènement', 'date de sortie', 'date de retour','température moyenne', 'stérile', 'impact', 'collaborateur', 'observations', 'ancien emplacement', 'nom du conteneur', 'précisions'
UNION ALL
    SELECT r.objet_id,
           e.code,
           r.retour_id,
           r.date_sortie,
           r.date_retour,
           r.temp_moyenne,
           r.sterile,
           r.impact,
           c.nom as 'collaborateur',
           r.observations,
           r.old_emplacement_adrl,
           t.nom,
           IF(r.cession_id IS NOT NULL, CONCAT('Cession: ', s.numero),
              IF(r.transformation_id IS NOT NULL, 'Transformation en produits dérivés',
                 IF(r.incident_id IS NOT NULL, CONCAT('Incident: ', i.nom), '')
                  )
               )
    FROM RETOUR r
		JOIN ECHANTILLON e on r.OBJET_ID = e.ECHANTILLON_ID and r.ENTITE_ID=3 
		JOIN PRELEVEMENT p on p.PRELEVEMENT_ID = e.PRELEVEMENT_ID
		JOIN BANQUE b on b.banque_id = e.BANQUE_ID
		JOIN PLATEFORME pl on pl.plateforme_id = b.PLATEFORME_ID
		LEFT JOIN COLLABORATEUR c ON r.collaborateur_id = c.collaborateur_id
		LEFT JOIN CESSION s ON r.cession_id = s.cession_id
		LEFT JOIN INCIDENT i ON r.incident_id = i.incident_id
		LEFT JOIN CONTENEUR t on t.conteneur_id = r.conteneur_id
    WHERE 
		p.date_arrivee between '2022-01-01' and '2022-12-31'
		and pl.NOM='CRB'
    order by 1

INTO OUTFILE '/data/2022—CRB-evt_stockage.csv' FIELDS TERMINATED BY ';' ENCLOSED BY '"' LINES TERMINATED BY '\n';
;
