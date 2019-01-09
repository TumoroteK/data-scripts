-- delete les items, champs et tables INCa si ces dernières ont été mal enregistrées lors de la migration (ex: accents etc...) et ne sont donc associées à aucune valeurs d'annotation

delete from ITEM where champ_annotation_id in 
	(select champ_annotation_id from CHAMP_ANNOTATION where table_annotation_id 
		in (select table_annotation_id from TABLE_ANNOTATION where catalogue_id is not null));
		
delete from CHAMP_ANNOTATION where champ_annotation_id in 
	(select champ_annotation_id from CHAMP_ANNOTATION where table_annotation_id 
		in (select table_annotation_id from TABLE_ANNOTATION where catalogue_id is not null));
		
delete from TABLE_ANNOTATION where catalogue_id is not null;

commit;
