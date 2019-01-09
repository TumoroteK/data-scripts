-- HCLs principalement
-- certaines tables ont été dupliquées par PF
-- alors que leurs champs annotations étaient utilisés dans des Affichage/Requête (table CHAMP)
-- la duplication des tables champ a laissé ce problème de côté
-- revenu lors recherche complexe Cytathèque (Julie Signoret) -> l'affichage des champs Sérologie ne se fait plus correctement alors que les valeurs existent.

-- affichage
update CHAMP c join (
	select c.champ_annotation_id as corrchp, zz.* from CHAMP_ANNOTATION c 
		join TABLE_ANNOTATION t on c.table_annotation_id = t.table_annotation_id
		join (select c.champ_id, c.champ_annotation_id, t.nom as cnom, b.plateforme_id as affichage_pf, o.plateforme_id as annot_pf from CHAMP c 
			join RESULTAT r on r.champ_id=c.champ_id 
			join AFFICHAGE a on a.affichage_id=r.affichage_id 
			join BANQUE b on a.banque_id=b.banque_id 
			join CHAMP_ANNOTATION t on c.champ_annotation_id=t.champ_annotation_id 
			join TABLE_ANNOTATION o on o.table_annotation_id=t.table_annotation_id
		where o.plateforme_id != b.plateforme_id) zz on zz.cnom = c.nom 
	where t.plateforme_id = zz.affichage_pf) yy on yy.champ_id=c.champ_id 
set c.champ_annotation_id = yy.corrchp;

-- requete
-- critere1
update CHAMP c join (
	select c.champ_annotation_id as corrchp, zz.* from CHAMP_ANNOTATION c 
			join TABLE_ANNOTATION t on c.table_annotation_id = t.table_annotation_id
			join (select c.champ_id, c.champ_annotation_id, t.nom as cnom, b.plateforme_id as affichage_pf, o.plateforme_id as annot_pf from CHAMP c 
				join CRITERE r on r.champ_id=c.champ_id 
				join GROUPEMENT g on g.critere1_id=r.critere_id 
				join REQUETE a on a.requete_id=g.groupement_id 
				join BANQUE b on a.banque_id=b.banque_id 
				join CHAMP_ANNOTATION t on c.champ_annotation_id=t.champ_annotation_id 
				join TABLE_ANNOTATION o on o.table_annotation_id=t.table_annotation_id
			where o.plateforme_id != b.plateforme_id) zz on zz.cnom = c.nom
	where t.plateforme_id = zz.affichage_pf) yy on yy.champ_id=c.champ_id 
set c.champ_annotation_id = yy.corrchp;

-- critere2
update CHAMP c join (
	select c.champ_annotation_id as corrchp, zz.* from CHAMP_ANNOTATION c 
			join TABLE_ANNOTATION t on c.table_annotation_id = t.table_annotation_id
			join (select c.champ_id, c.champ_annotation_id, t.nom as cnom, b.plateforme_id as affichage_pf, o.plateforme_id as annot_pf from CHAMP c 
				join CRITERE r on r.champ_id=c.champ_id 
				join GROUPEMENT g on g.critere2_id=r.critere_id 
				join REQUETE a on a.requete_id=g.groupement_id 
				join BANQUE b on a.banque_id=b.banque_id 
				join CHAMP_ANNOTATION t on c.champ_annotation_id=t.champ_annotation_id 
				join TABLE_ANNOTATION o on o.table_annotation_id=t.table_annotation_id
			where o.plateforme_id != b.plateforme_id) zz on zz.cnom = c.nom
	where t.plateforme_id = zz.affichage_pf) yy on yy.champ_id=c.champ_id 
set c.champ_annotation_id = yy.corrchp;

-- import_colonne
update CHAMP c join (
	select c.champ_annotation_id as corrchp, zz.* from CHAMP_ANNOTATION c 
			join TABLE_ANNOTATION t on c.table_annotation_id = t.table_annotation_id
			join (select c.champ_id, c.champ_annotation_id, t.nom as cnom, b.plateforme_id as affichage_pf, o.plateforme_id as annot_pf from CHAMP c 
				join IMPORT_COLONNE r on r.champ_id=c.champ_id 
				join IMPORT_TEMPLATE i on i.import_template_id=r.import_template_id 
				join BANQUE b on i.banque_id=b.banque_id 
				join CHAMP_ANNOTATION t on c.champ_annotation_id=t.champ_annotation_id 
				join TABLE_ANNOTATION o on o.table_annotation_id=t.table_annotation_id
			where o.plateforme_id != b.plateforme_id) zz on zz.cnom = c.nom
	where t.plateforme_id = zz.affichage_pf) yy on yy.champ_id=c.champ_id 
set c.champ_annotation_id = yy.corrchp;


