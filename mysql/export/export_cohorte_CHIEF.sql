-- ce fichier doit être exécuté avec un compte root : mysql -u root -p tumorotek < export_cohorte_CHIEF.sql

-- cette commande permet d'afficher correctement les caractères accentués de l'entête
SET NAMES 'utf8';

-- /!\ si l'exécution renvoie l'erreur : ERROR 1290 (HY000) at line 1: The MySQL server is running with the --secure-file-priv option so it cannot execute this statement
-- il faut lancer la commande ci-dessous pour récupérer le chemin complet du répertoire autorisé pour l'export et indiquer le chemin absolu au niveau du "INTO OUTFILE" 
-- (en remplaçant sous windows les \ par /) :
-- mysql -u root -p tumorotek -e"SELECT @@secure_file_priv;"
select 'Nom de la collection', 'N° Patient','Sexe','Date de naissance','Code prélèvement','Type de prélèvement','Date de prélèvement','Heure de prélèvement','Etablissement préleveur','Date d''arrivée','Heure d''arrivée','Code échantillon','Date de stockage','Heure de stockage','Type d''échantillon','Quantité init.','Quantité (unité)','Emplacement','Conforme à l''arrivée','Raison de non conformité à l''arrivée','Conforme après traitement','non conformité après traitement','Délai de congélation'
union ALL
select
	b.nom,
	pat.nip, 
	pat.sexe, 
	date_format(pat.date_naissance, '%d/%m/%Y') as date_naissance,
	prel.code as code_prelevement, 
	nat.nature as type_prelevement, 
	date_format(prel.date_prelevement, '%d/%m/%Y') as date_prelevement, 
	date_format(prel.date_prelevement, '%T') as heure_prelevement,
	etab.nom as etablissement_preleveur,
	date_format(prel.date_arrivee, '%d/%m/%Y') as date_arrivee,
	date_format(prel.date_arrivee, '%T') as heure_arrivee,
	ech.code as code_echantillon,
	date_format(ech.date_stock, '%d/%m/%Y') as date_stockage,
	date_format(ech.date_stock, '%T') as heure_stockage,
	etype.type,
	ech.quantite_init,
	concat(ech.quantite,' (', unit.unite, ') ') as quantite,
	get_adrl(ech.emplacement_id) as emplacement,
	prel.conforme_arrivee,
	(select GROUP_CONCAT(nc.nom)
            FROM OBJET_NON_CONFORME onc
                   LEFT JOIN NON_CONFORMITE nc ON onc.non_conformite_id = nc.non_conformite_id
                   LEFT JOIN CONFORMITE_TYPE ct ON nc.conformite_type_id = ct.conformite_type_id
            WHERE ct.conformite_type_id = 1
              AND prel.prelevement_id = onc.objet_id and nc.plateforme_id = pl.plateforme_id) as raison_non_conformite_arrivee,
	ech.conforme_traitement,
	(select GROUP_CONCAT(nc.nom)
            FROM OBJET_NON_CONFORME onc
                   LEFT JOIN NON_CONFORMITE nc ON onc.non_conformite_id = nc.non_conformite_id
                   LEFT JOIN CONFORMITE_TYPE ct ON nc.conformite_type_id = ct.conformite_type_id
            WHERE ct.conformite_type_id = 2
              AND ech.echantillon_id = onc.objet_id and nc.plateforme_id = pl.plateforme_id) as raison_non_conformite_apres_traitement,
	ech.DELAI_CGL as delai_congelation
from 
ECHANTILLON ech
JOIN BANQUE b on ech.banque_id=b.banque_id
JOIN PLATEFORME pl on b.plateforme_id=pl.plateforme_id 
JOIN PRELEVEMENT prel on ech.prelevement_id=prel.prelevement_id 
LEFT JOIN NATURE nat on prel.nature_id = nat.nature_id
LEFT JOIN PRELEVEMENT_TYPE ptype ON prel.prelevement_type_id = ptype.prelevement_type_id and ptype.plateforme_id=pl.plateforme_id
LEFT JOIN MALADIE m on prel.maladie_id = m.maladie_id 
LEFT JOIN PATIENT pat ON m.patient_id = pat.patient_id
LEFT JOIN ECHANTILLON_TYPE etype ON ech.ECHANTILLON_TYPE_ID = etype.ECHANTILLON_TYPE_ID
LEFT JOIN UNITE unit ON ech.quantite_unite_id = unit.unite_id 
LEFT JOIN SERVICE serv on prel.service_preleveur_id=serv.service_id 
LEFT JOIN ETABLISSEMENT etab on etab.etablissement_id=serv.etablissement_id 
-- INTO OUTFILE '[DIRECTORY_PATH_MYSQL_EXPORT]/export_CHIEF.csv' FIELDS TERMINATED BY ';' ENCLOSED BY '"' LINES TERMINATED BY '\n';
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/export_CHIEF.csv' FIELDS TERMINATED BY ';' ENCLOSED BY '"' LINES TERMINATED BY '\n';



