select 'code échantillon', 'date stockage', 'type échantillon', 'N° Patient', 'type prélèvement', 'CRB Origine', 'statut échantillon', 'date prélèvement', 'code prélèvement'
UNION ALL
select 
	e.CODE, e.DATE_STOCK, et.TYPE, pat.NIP, pt.TYPE, 
	(SELECT i.label from ANNOTATION_VALEUR a join ITEM i on i.item_id=a.item_id where a.champ_annotation_id=(select champ_annotation_id from CHAMP_ANNOTATION where nom = 'CRB Origine') and a.objet_id=p.prelevement_id) as 'CRB Origine',
	os.statut, p.DATE_PRELEVEMENT, p.CODE  
from 
	ECHANTILLON e
		LEFT OUTER JOIN PRELEVEMENT p on p.PRELEVEMENT_ID = e.PRELEVEMENT_ID
		LEFT OUTER JOIN ECHANTILLON_TYPE et on et.ECHANTILLON_TYPE_ID = e.ECHANTILLON_TYPE_ID
		LEFT OUTER JOIN PRELEVEMENT_TYPE pt on pt.prelevement_TYPE_ID = p.PRELEVEMENT_TYPE_ID
		LEFT OUTER JOIN OBJET_STATUT os on os.OBJET_STATUT_ID = e.OBJET_STATUT_ID
		LEFT JOIN MALADIE m on m.maladie_id = p.maladie_id 
		LEFT JOIN PATIENT pat ON pat.patient_id = m.patient_id 
where
et.TYPE='EDTA'

INTO OUTFILE '/tmp/export_bilan2022.csv' FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\n';


-------------------------------
/!\ à lancer en root et la sortie doit être dans /tmp sinon pb de droits
faire ensuite une copie de /tmp dans ~/sql/export (/!\ mv impossible)
