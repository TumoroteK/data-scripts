-- gestion encodage.
SET NAMES 'utf8';

SELECT 
-- new v4 : la collection est dans le prénom du patient
'Collection',
--
'Id', 'Code échantillon', 
-- new 
'Id prélèvement', 'code prélèvement',
-- new v4
'Date arrivée', 'N° CRB', 'Nom laboratoire',
--
'Type d''échantillon','Quantité', 'Unité de la quantité', 'Date de stockage','Opérateur', 'Emplacement', 'Température de stockage', 'Statut', 'Mode de préparation', 
'Conforme après traitement','Non conformité de l''échantillon après traitement', 
-- new
'Conforme pour la cession','Non conformité de l''échantillon pour la cession', 'tumoral',  'lateralité', 'Délai de congélation', 'qualité de l''échantillon', 'stérilité',
-- new annotation
'Couleur du bouchon','Couleur Insert','Coloration', 'Turbidité', 'A noter', 'Date de décongélation', 'Température', 'Aliquotage',
-- new v4 : le code patient est contenu dans le nom usuel du patient
'Code patient',  'Sexe', 
-- new V4 : l'âge au moment du prélèvement est contenu dans une annotation
'Age',
-- new v4 :
'Date de cession', 'Numéro de cession'
UNION ALL
SELECT 
	-- new v4
	pat.PRENOM as 'Collection',
	--
	e.echantillon_id as 'echantillon_id', 
	e.code as 'Code échantillon', 
	p.prelevement_id, p.code,
	-- new v4
	date_format(p.DATE_ARRIVEE, '%Y-%m-%d %r') as 'date arrivée',
	(SELECT a.ALPHANUM from ANNOTATION_VALEUR a where a.champ_annotation_id=(select champ_annotation_id from CHAMP_ANNOTATION where nom = 'N° CRB' and table_annotation_id = 7) and a.objet_id=p.prelevement_id) as 'N° CRB', 
	(SELECT a.texte from ANNOTATION_VALEUR a where a.champ_annotation_id=(select champ_annotation_id from CHAMP_ANNOTATION where nom = 'Nom du Laboratoire' and table_annotation_id = 7) and a.objet_id=p.prelevement_id) as 'Nom du Laboratoire',
	--
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
	(SELECT group_concat(n.nom) from NON_CONFORMITE n join OBJET_NON_CONFORME o on n.non_conformite_id=o.non_conformite_id where o.entite_id=3 and o.objet_id=e.echantillon_id and n.conformite_type_id = 2) as 'Non conformité de l''échantillon après traitement', 
	e.CONFORME_CESSION  as 'Conforme pour la cession',
	(SELECT group_concat(n.nom) from NON_CONFORMITE n join OBJET_NON_CONFORME o on n.non_conformite_id=o.non_conformite_id where o.entite_id=3 and o.objet_id=e.echantillon_id and n.conformite_type_id = 3) as 'Non conformité de l''échantillon après traitement', 
	e.TUMORAL,
	e.LATERALITE,
	e.DELAI_CGL,
	qual.echan_qualite,
	e.STERILE,
	(SELECT i.label from ANNOTATION_VALEUR a join ITEM i on i.item_id=a.item_id where a.champ_annotation_id=(select champ_annotation_id from CHAMP_ANNOTATION where nom = 'Bouchon' and table_annotation_id = 1) and a.objet_id=e.echantillon_id) as 'Couleur du bouchon', 
	(SELECT i.label from ANNOTATION_VALEUR a join ITEM i on i.item_id=a.item_id where a.champ_annotation_id=(select champ_annotation_id from CHAMP_ANNOTATION where nom = 'Insert' and table_annotation_id = 1) and a.objet_id=e.echantillon_id) as 'Couleur Insert',
	 -- pb de données : plusieurs valeurs de thesaurus en base pour certains échantillons => on ramène toutes les valeurs triées par ordre d'annotation_valeur_id (donc de saisie)
	(SELECT group_concat(i.label order by a.annotation_valeur_id) from ANNOTATION_VALEUR a join ITEM i on i.item_id=a.item_id where a.champ_annotation_id=(select champ_annotation_id from CHAMP_ANNOTATION where nom = 'Coloration' and table_annotation_id = 16) and a.objet_id=e.echantillon_id) as 'Coloration', 
	(SELECT group_concat(i.label order by a.annotation_valeur_id) from ANNOTATION_VALEUR a join ITEM i on i.item_id=a.item_id where a.champ_annotation_id=(select champ_annotation_id from CHAMP_ANNOTATION where nom = 'Turbidité' and table_annotation_id = 16) and a.objet_id=e.echantillon_id) as 'Turbidité', 
	--
	(SELECT a.alphanum from ANNOTATION_VALEUR a where a.champ_annotation_id=(select champ_annotation_id from CHAMP_ANNOTATION where nom = 'A noter' and table_annotation_id = 16) and a.objet_id=e.echantillon_id) as 'A noter', 
	(SELECT date_format(a.ANNO_DATE, '%Y-%m-%d %r') from ANNOTATION_VALEUR a where a.champ_annotation_id=(select champ_annotation_id from CHAMP_ANNOTATION where nom = 'Date de décongélation' and table_annotation_id = 17) and a.objet_id=e.echantillon_id) as 'Date de décongélation', 
	(SELECT i.label from ANNOTATION_VALEUR a join ITEM i on i.item_id=a.item_id where a.champ_annotation_id=(select champ_annotation_id from CHAMP_ANNOTATION where nom = 'Température' and table_annotation_id = 17) and a.objet_id=e.echantillon_id) as 'Température', 
	(SELECT date_format(a.ANNO_DATE, '%Y-%m-%d %r') from ANNOTATION_VALEUR a where a.champ_annotation_id=(select champ_annotation_id from CHAMP_ANNOTATION where nom = 'Aliquotage' and table_annotation_id = 19) and a.objet_id=e.echantillon_id) as 'Aliquotage',
	-- new v4
	pat.NOM as 'Code patient', pat.SEXE as 'Sexe',
	(SELECT a.texte from ANNOTATION_VALEUR a where a.champ_annotation_id=(select champ_annotation_id from CHAMP_ANNOTATION where nom = 'Age' and table_annotation_id = 20) and a.objet_id=pat.patient_id) as 'Age', 
	date_format(ces.depart_date, '%Y-%m-%d') as 'Date de cession', 
	ces.numero as 'Numero cession'
FROM ECHANTILLON e 
JOIN BANQUE b on e.banque_id=b.banque_id
JOIN PRELEVEMENT p on e.prelevement_id=p.prelevement_id
LEFT JOIN MALADIE m on p.maladie_id=m.maladie_id 
LEFT JOIN PATIENT pat on pat.patient_id=m.patient_id 
LEFT JOIN ECHANTILLON_TYPE et ON e.ECHANTILLON_TYPE_ID = et.ECHANTILLON_TYPE_ID
LEFT JOIN UNITE u ON e.quantite_unite_id = u.unite_id
LEFT JOIN COLLABORATEUR co ON e.collaborateur_id = co.collaborateur_id
LEFT JOIN OBJET_STATUT os ON e.objet_statut_id = os.objet_statut_id 
LEFT JOIN MODE_PREPA mp ON e.mode_prepa_id = mp.mode_prepa_id
LEFT JOIN ECHAN_QUALITE qual ON e.echan_qualite_id =  qual.echan_qualite_id
LEFT JOIN CEDER_OBJET cdobjet
	INNER JOIN CESSION ces on ces.cession_id = cdobjet.cession_id
on cdobjet.objet_id = e.echantillon_id and cdobjet.entite_id = 3
WHERE 
	e.banque_id = 3

INTO OUTFILE '/Data/20260602-export_albane.txt' FIELDS TERMINATED BY ';' ENCLOSED BY '"' LINES TERMINATED BY '\n';




