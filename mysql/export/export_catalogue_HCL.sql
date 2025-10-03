select ptf.nom as 'plateforme', b.nom as 'collection_nom', mal.libelle as 'maladie_libelle', echtype.type as 'type_echantillon', count(distinct ech.echantillon_id) as nb_echantillons, count(distinct mal.patient_id) as nb_patients_distincts  
from ECHANTILLON ech, ECHANTILLON_TYPE echtype, PRELEVEMENT prel, MALADIE mal, BANQUE b, PLATEFORME ptf, ANNOTATION_VALEUR annoVal, CHAMP_ANNOTATION champAnno, TABLE_ANNOTATION tableAnno
where 
	echtype.echantillon_type_id = ech.echantillon_type_id and ech.prelevement_id = prel.prelevement_id and prel.maladie_id = mal.maladie_id and b.banque_id = ech.banque_id  and ptf.plateforme_id = b.plateforme_id 
	and  annoVal.objet_id=ech.echantillon_id and annoVal.champ_annotation_id=champAnno.champ_annotation_id and tableAnno.table_annotation_id = champAnno.table_annotation_id
	and b.DEFMALADIES=1 and mal.libelle <> 'INDETERMINE' and ech.objet_statut_id = 1 and ptf.nom in ('CRB EST', 'CRB SUD', 'CRB NORD') 
	and champAnno.nom = 'Catalogue' and tableAnno.nom = 'Catalogue' and annoVal.BOOL = 1
	group by  ptf.nom, b.nom, mal.libelle, echtype.type;