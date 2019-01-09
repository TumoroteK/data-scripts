-- cr anapaths
-- tot fichier 88632
-- update FICHIER set path = replace(path, 'tumorotek/tumofiles', 'tumotest/tumofiles2');
-- update PATH
alter table FICHIER add newPath varchar(100);
update FICHIER set newPath = concat(path, '_', fichier_id) where fichier_id in (select cr_anapath_id from ECHANTILLON); -- 1132

-- verifs
select e.echantillon_id, e.cr_anapath_id from ECHANTILLON e join (select cr_anapath_id,  min(echantillon_id) as mineid from ECHANTILLON group by cr_anapath_id) zz on zz.cr_anapath_id = e.cr_anapath_id where e.echantillon_id > zz.mineid; -- 6027
select e.echantillon_id, e.cr_anapath_id from ECHANTILLON e join (select cr_anapath_id,  min(echantillon_id) as mineid from ECHANTILLON group by cr_anapath_id) zz on zz.cr_anapath_id = e.cr_anapath_id where e.echantillon_id = zz.mineid; -- 1889
select count(*) from ECHANTILLON where cr_anapath_id is not null; -- 7916 = 6087 + 1889
select count(*) from FICHIER where fichier_id in (select cr_anapath_id from ECHANTILLON); -- 1829

-- create echantillons refs
alter table FICHIER modify FICHIER_ID int(10) not null auto_increment;
alter table FICHIER add echan_id int(10);
insert into FICHIER (nom, path, newPath, mimetype, echan_id) select nom, newPath, newPath, mimetype, e.echantillon_id from FICHIER f join ECHANTILLON e on e.cr_anapath_id = f.fichier_id join (select cr_anapath_id,  min(echantillon_id) as mineid from ECHANTILLON group by cr_anapath_id) zz on zz.cr_anapath_id = e.cr_anapath_id where e.echantillon_id > zz.mineid; -- 6087
alter table FICHIER modify FICHIER_ID int(10) not null;
-- update echantillons refs
update ECHANTILLON e join FICHIER f on e.echantillon_id = f.echan_id set e.cr_anapath_id = f.fichier_id; -- 6087
update FICHIER set path = newPath where path != newPath and newPath is not null; -- 1829

alter table ECHANTILLON modify CR_ANAPATH_ID int(10) unique;

-- clean up
update FICHIER set newPath = null;
alter table FICHIER drop echan_id;

-- annotation update PATH
update FICHIER set newPath = concat(substring_index(path,'/',7),'/',nom) where fichier_id in (select fichier_id from ANNOTATION_VALEUR); --8147
alter table FICHIER add chp_id int(10);
update FICHIER f join ANNOTATION_VALEUR v on f.fichier_id = v.fichier_id set f.chp_id = v.champ_annotation_id; -- 8147
update FICHIER f join (select min(f.fichier_id) as minid, f.nom, v.champ_annotation_id from FICHIER f join ANNOTATION_VALEUR v on v.fichier_id = f.fichier_id group by f.nom, v.champ_annotation_id) zz on zz.nom = f.nom and zz.champ_annotation_id = f.chp_id set f.newPath = concat(f.newPath, '_', zz.minid) where newPath is not null; -- 2275

-- script
mysql -u tumo2 -p -e "select concat('mv ', path, '_', fichier_id, ' ', newPath, ';') from FICHIER where newPath is not null;" tumo2test -s -N >> test 2>&1


update FICHIER set path = newPath where path != newPath and newPath is not null;
alter table ANNOTATION_VALEUR modify FICHIER_ID int(10) unique;


alter table FICHIER drop chp_id;
alter table FICHIER drop newPath;
