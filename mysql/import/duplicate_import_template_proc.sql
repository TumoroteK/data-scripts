delimiter $$

DROP PROCEDURE IF EXISTS `duplicate_import_template`;
CREATE PROCEDURE `duplicate_import_template`(IN _importId INTEGER, IN _banqueId INTEGER)
BEGIN
	set @i = (select max(import_template_id) from IMPORT_TEMPLATE);

	alter table IMPORT_TEMPLATE add parent_id int(10);

	insert into IMPORT_TEMPLATE select @i:=@i+1, _banqueId, i.nom, i.description, i.is_editable, _importId from IMPORT_TEMPLATE i where i.import_template_id = _importId;

	insert into IMPORT_TEMPLATE_ENTITE select i.import_template_id, e.entite_id from IMPORT_TEMPLATE i join IMPORT_TEMPLATE_ENTITE e on i.parent_id = e.import_template_id; 

	set @i = (select max(import_colonne_id) from IMPORT_COLONNE);
	insert into IMPORT_COLONNE select @i:=@i+1, i.import_template_id, c.champ_id, c.nom, c.ordre from IMPORT_TEMPLATE i join IMPORT_COLONNE c on i.parent_id = c.import_template_id;

	alter table CHAMP add import_template_id int(10);
	set @i = (select max(champ_id) from CHAMP);
	insert into CHAMP select @i:=@i+1, c.champ_annotation_id, c.champ_entite_id, null, i.import_template_id from CHAMP c join IMPORT_COLONNE o on o.champ_id = c.champ_id join IMPORT_TEMPLATE i on i.parent_id = o.import_template_id;

	update IMPORT_COLONNE o join (select c1.champ_id as ch1Id, c2.champ_id as ch2Id, c2.import_template_id from CHAMP c1 join CHAMP c2 on c1.champ_entite_id=c2.champ_entite_id where c2.import_template_id is not null and c1.champ_id < c2.champ_id and c1.champ_id in (select champ_id from IMPORT_COLONNE where import_template_id = 2) order by c2.import_template_id, c1.champ_id) zz on o.champ_id = zz.ch1Id and o.import_template_id=zz.import_template_id set o.champ_id = zz.ch2Id;

	update IMPORT_COLONNE o join (select c1.champ_id as ch1Id, c2.champ_id as ch2Id, c2.import_template_id from CHAMP c1 join CHAMP c2 on c1.champ_annotation_id=c2.champ_annotation_id where c2.import_template_id is not null and c1.champ_id < c2.champ_id and c1.champ_id in (select champ_id from IMPORT_COLONNE where import_template_id = 2) order by c2.import_template_id, c1.champ_id) zz on o.champ_id = zz.ch1Id and o.import_template_id=zz.import_template_id set o.champ_id = zz.ch2Id;

	update IMPORT_TEMPLATE set parent_id = null;
	update CHAMP set import_template_id = null;


	alter table IMPORT_TEMPLATE drop parent_id;
	alter table CHAMP drop import_template_id;

END$$
