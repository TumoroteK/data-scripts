alter table ITEM modify ITEM_ID int(10) not null auto_increment;

insert into ITEM (label, valeur, champ_annotation_id) values ('1c', '1c', (select c.champ_annotation_id from CHAMP_ANNOTATION c 
    join TABLE_ANNOTATION t on t.table_annotation_id=c.table_annotation_id 
     and t.entite_id=2 and t.catalogue_id=1 and c.nom like '024%'));
insert into ITEM (label, valeur, champ_annotation_id) values ('4a', '4a', (select c.champ_annotation_id from CHAMP_ANNOTATION c 
    join TABLE_ANNOTATION t on t.table_annotation_id=c.table_annotation_id 
     and t.entite_id=2 and t.catalogue_id=1 and c.nom like '024%'));
insert into ITEM (label, valeur, champ_annotation_id) values ('4b', '4b', (select c.champ_annotation_id from CHAMP_ANNOTATION c 
    join TABLE_ANNOTATION t on t.table_annotation_id=c.table_annotation_id 
     and t.entite_id=2 and t.catalogue_id=1 and c.nom like '024%'));
insert into ITEM (label, valeur, champ_annotation_id) values ('4c', '4c', (select c.champ_annotation_id from CHAMP_ANNOTATION c 
    join TABLE_ANNOTATION t on t.table_annotation_id=c.table_annotation_id 
     and t.entite_id=2 and t.catalogue_id=1 and c.nom like '024%'));
insert into ITEM (label, valeur, champ_annotation_id) values ('4d', '4d', (select c.champ_annotation_id from CHAMP_ANNOTATION c 
    join TABLE_ANNOTATION t on t.table_annotation_id=c.table_annotation_id 
     and t.entite_id=2 and t.catalogue_id=1 and c.nom like '024%'));

alter table ITEM modify ITEM_ID int(10) not null;