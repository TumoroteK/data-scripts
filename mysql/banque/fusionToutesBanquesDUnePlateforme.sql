delimiter $$

DROP PROCEDURE IF EXISTS `fusion_all_banques`;
CREATE PROCEDURE `fusion_all_banques`(IN _pf_Id INTEGER, IN _banque_cible_Id INTEGER)

BEGIN
	
	-- codes
	update CODE_SELECT set banque_id=_banque_cible_Id where banque_id in (select banque_id from BANQUE where PLATEFORME_ID = _pf_Id);
	update CODE_UTILISATEUR set banque_id=_banque_cible_Id where banque_id in (select banque_id from BANQUE where PLATEFORME_ID = _pf_Id);
	update CODE_DOSSIER set banque_id=_banque_cible_Id where banque_id in (select banque_id from BANQUE where PLATEFORME_ID = _pf_Id);

	-- imports
	update IMPORT_TEMPLATE set banque_id=_banque_cible_Id where banque_id in (select banque_id from BANQUE where PLATEFORME_ID = _pf_Id);

	-- impression
	update TEMPLATE set banque_id=_banque_cible_Id where banque_id in (select banque_id from BANQUE where PLATEFORME_ID = _pf_Id);

	-- module recherche
	update AFFICHAGE set banque_id=_banque_cible_Id where banque_id in (select banque_id from BANQUE where PLATEFORME_ID = _pf_Id);
	update REQUETE set banque_id=_banque_cible_Id where banque_id in (select banque_id from BANQUE where PLATEFORME_ID = _pf_Id);
	-- banque_id n'existe pas dans la table RECHERCHE
	-- update RECHERCHE set banque_id=_banque_cible_Id where banque_id in (select banque_id from BANQUE where PLATEFORME_ID = _pf_Id);

	-- --------------- stockage
	-- on peut avoir des doublons sur les conteneurs et les enceintes après fusion => dans ce cas, on garde la ligne du banque_id le plus petit :
	-- même logique que pour table_annotation_banque (cf plus bas)
	-- CONTENEUR_BANQUE
	update CONTENEUR_BANQUE as data_to_update 
	inner join 
	(	select conteneur_banque_a_traiter.conteneur_id, min(conteneur_banque_a_traiter.banque_id) as banque_id 
		from CONTENEUR_BANQUE as conteneur_banque_a_traiter 
		inner join  
		(select all_conteneur.conteneur_id from
			(select distinct tab.conteneur_id from CONTENEUR_BANQUE tab where tab.banque_id in (select banque_id from BANQUE where PLATEFORME_ID = _pf_Id)) as all_conteneur
			left outer join
			(select distinct tab.conteneur_id from CONTENEUR_BANQUE tab where tab.banque_id = _banque_cible_Id) as filtered_conteneur
			on all_conteneur.conteneur_id = filtered_conteneur.conteneur_id
			where filtered_conteneur.conteneur_id is null
		) as conteneur_a_ajouter
		on conteneur_banque_a_traiter.conteneur_id=conteneur_a_ajouter.conteneur_id
		group by conteneur_banque_a_traiter.conteneur_id
	) as final_data 
	on data_to_update.conteneur_id = final_data.conteneur_id and data_to_update.banque_id = final_data.banque_id
	set data_to_update.banque_id = _banque_cible_Id;

	delete from CONTENEUR_BANQUE where banque_id<>_banque_cible_Id and banque_id in (select banque_id from BANQUE where PLATEFORME_ID = _pf_Id);	

	-- ENCEINTE_BANQUE : comme pour CONTENEUR_BANQUE il peut y avoir des doublons
	update ENCEINTE_BANQUE as data_to_update 
	inner join 
	(	select enceinte_banque_a_traiter.enceinte_id, min(enceinte_banque_a_traiter.banque_id) as banque_id 
		from ENCEINTE_BANQUE as enceinte_banque_a_traiter 
		inner join  
		(select all_enceinte.enceinte_id from
			(select distinct tab.enceinte_id from ENCEINTE_BANQUE tab where tab.banque_id in (select banque_id from BANQUE where PLATEFORME_ID = _pf_Id)) as all_enceinte
			left outer join
			(select distinct tab.enceinte_id from ENCEINTE_BANQUE tab where tab.banque_id = _banque_cible_Id) as filtered_enceinte
			on all_enceinte.enceinte_id = filtered_enceinte.enceinte_id
			where filtered_enceinte.enceinte_id is null
		) as enceinte_a_ajouter
		on enceinte_banque_a_traiter.enceinte_id=enceinte_a_ajouter.enceinte_id
		group by enceinte_banque_a_traiter.enceinte_id
	) as final_data 
	on data_to_update.enceinte_id = final_data.enceinte_id and data_to_update.banque_id = final_data.banque_id
	set data_to_update.banque_id = _banque_cible_Id;

	delete from ENCEINTE_BANQUE where banque_id<>_banque_cible_Id and banque_id in (select banque_id from BANQUE where PLATEFORME_ID = _pf_Id);	
	-- ---
	update TERMINALE set banque_id=_banque_cible_Id where banque_id in (select banque_id from BANQUE where PLATEFORME_ID = _pf_Id);
	-- --------------- 

	-- TK Objects
	update PRELEVEMENT set banque_id=_banque_cible_Id where banque_id in (select banque_id from BANQUE where PLATEFORME_ID = _pf_Id);
	update ECHANTILLON set banque_id=_banque_cible_Id where banque_id in (select banque_id from BANQUE where PLATEFORME_ID = _pf_Id);
	update PROD_DERIVE set banque_id=_banque_cible_Id where banque_id in (select banque_id from BANQUE where PLATEFORME_ID = _pf_Id);
	update CESSION set banque_id=_banque_cible_Id where banque_id in (select banque_id from BANQUE where PLATEFORME_ID = _pf_Id);

	-- Annotations
	-- TABLE_ANNOTATION_BANQUE /!\ doublon  
	-- il faut basculer toutes les tables d'annotation sur la collection cible en supprimant les doublons :
	-- 1ere étape : mise à jour de toutes les lignes à garder
	-- Logique : 
	-- - récupération de toutes les tables d'annotation à ajouter : mysql n'accepte pas le minus donc left outer join avec clause is null pour le simuler (table_annotation_a_ajouter)
	-- - pour ne l'ajouter qu'une seule fois, jointure sur cette table_annotation_a_ajouter et group by avec min sur banque_id => final_data
	update TABLE_ANNOTATION_BANQUE as data_to_update 
	inner join 
	(	select table_annotation_banque_a_traiter.table_annotation_id, min(table_annotation_banque_a_traiter.banque_id) as banque_id 
		from TABLE_ANNOTATION_BANQUE as table_annotation_banque_a_traiter 
		inner join  
		(select all_anno.table_annotation_id from
			(select distinct tab.table_annotation_id from TABLE_ANNOTATION_BANQUE tab where tab.banque_id in (select banque_id from BANQUE where PLATEFORME_ID = _pf_Id)) as all_anno
			left outer join
			(select distinct tab.table_annotation_id from TABLE_ANNOTATION_BANQUE tab where tab.banque_id = _banque_cible_Id) as filtered_anno
			on all_anno.table_annotation_id = filtered_anno.table_annotation_id
			where filtered_anno.table_annotation_id is null
		) as table_annotation_a_ajouter
		on table_annotation_banque_a_traiter.table_annotation_id=table_annotation_a_ajouter.table_annotation_id
		group by table_annotation_banque_a_traiter.table_annotation_id
	) as final_data 
	on data_to_update.table_annotation_id = final_data.table_annotation_id and data_to_update.banque_id = final_data.banque_id
	set data_to_update.banque_id = _banque_cible_Id;

	-- 2e étape : suppression des lignes correspondant à la plateforme mais dont banque_id est différent de la cible
	delete from TABLE_ANNOTATION_BANQUE where banque_id<>_banque_cible_Id and banque_id in (select banque_id from BANQUE where PLATEFORME_ID = _pf_Id);
	-- -----
	update ANNOTATION_VALEUR set banque_id=_banque_cible_Id where banque_id in (select banque_id from BANQUE where PLATEFORME_ID = _pf_Id);
	update ANNOTATION_DEFAUT set banque_id=_banque_cible_Id where banque_id in (select banque_id from BANQUE where PLATEFORME_ID = _pf_Id);	

	-- profils utilisateur -> delete
	-- table codage -> delete
	-- catalogues -> delete
	-- numerotations -> delete
	-- affectations imrimantes -> delete
	-- etiquettes -> plateforme
	-- couleurs entites --> delete

	SELECT 'done';
	
END$$
