-- cr anapaths
-- tot fichier 88632
-- update FICHIER set path = replace(path, 'tumorotek/tumofiles', 'tumotest/tumofiles2');
-- update PATH
alter table FICHIER add newPath varchar2(100);
update FICHIER set newPath = concat(path, '_', fichier_id) where fichier_id in (select cr_anapath_id from ECHANTILLON); -- 1132

-- verifs
select e.echantillon_id, e.cr_anapath_id from ECHANTILLON e join (select cr_anapath_id,  min(echantillon_id) as mineid from ECHANTILLON group by cr_anapath_id) zz on zz.cr_anapath_id = e.cr_anapath_id where e.echantillon_id > zz.mineid; -- 3529
select e.echantillon_id, e.cr_anapath_id from ECHANTILLON e join (select cr_anapath_id,  min(echantillon_id) as mineid from ECHANTILLON group by cr_anapath_id) zz on zz.cr_anapath_id = e.cr_anapath_id where e.echantillon_id = zz.mineid; -- 1132
select count(*) from ECHANTILLON where cr_anapath_id is not null; -- 4661 = 3529 + 1132
select count(*) from FICHIER where fichier_id in (select cr_anapath_id from ECHANTILLON); -- 1132

-- create echantillons refs
alter table FICHIER modify FICHIER_ID int(10) not null auto_increment;
alter table FICHIER add echan_id int(10);
insert into FICHIER (nom, path, newPath, mimetype, echan_id) select nom, newPath, newPath, mimetype, e.echantillon_id from FICHIER f join ECHANTILLON e on e.cr_anapath_id = f.fichier_id join (select cr_anapath_id,  min(echantillon_id) as mineid from ECHANTILLON group by cr_anapath_id) zz on zz.cr_anapath_id = e.cr_anapath_id where e.echantillon_id > zz.mineid; -- 3529
alter table FICHIER modify FICHIER_ID int(10) not null;
-- update echantillons refs
update ECHANTILLON e join FICHIER f on e.echantillon_id = f.echan_id set e.cr_anapath_id = f.fichier_id; -- 3529
update FICHIER set path = newPath where path != newPath and newPath is not null; -- 1132

alter table ECHANTILLON modify CR_ANAPATH_ID int(10) unique;

-- clean up
update FICHIER set newPath = null;
alter table FICHIER drop echan_id;

-- annotation update PATH
-- si UNIX
update (select f.newPath as NEW, concat(concat(substr(f.path, 0, instr(f.path,'/', 1, 6) - 1),'/'),nom) as CONC from FICHIER f join ANNOTATION_VALEUR v on v.fichier_id = f.fichier_id) t set t.NEW = t.CONC;
-- si WINDOWS
update (select f.newPath as NEW, f.nom as NOM from FICHIER f join ANNOTATION_VALEUR v on v.fichier_id = f.fichier_id) t set t.NEW = t.NOM;
alter table FICHIER add chp_id NUMBER(22);
update FICHIER f set f.chp_id=(select v.champ_annotation_id from ANNOTATION_VALEUR v where f.fichier_id = v.fichier_id);
alter table FICHIER add newPath2 varchar2(100);
update FICHIER f set newPath2 = (select min(f2.fichier_id) from FICHIER f2 where f2.chp_id = f.chp_id and f.nom = f2.nom group by nom, chp_id); 
update FICHIER set newPath = concat(concat(newPath, '_'), newPath2) where newPath is not null;

-- script

!!! AMELIORER
OBLIGE de faire un editer>Remplacer sur la chaine echo ERROR && exit/b
EXECUTER le .bat de manière à sortir les erreurs!!!

set serveroutput off
set heading off 
set feedback off
set termspool off
set echo off 
set pagesize 0 
set linesize 300
spool c:\rename.bat
select 'move ' || replace(path, '/','\\') || '_' || fichier_id || ' ' || newPath || ' || echo ERROR && exit/b' from FICHIER where newPath is not null;
spool off;


-- si UNIX
update FICHIER set path = newPath where path != newPath and newPath is not null;
-- si WINDOWS
update FICHIER f set path = concat(concat(substr(f.path, 0, instr(f.path,'/', 1, 6) - 1),'/'),newPath) where path != newPath and newPath is not null;
alter table ANNOTATION_VALEUR modify FICHIER_ID int(10) unique;

alter table FICHIER drop chp_id;
alter table FICHIER drop newPath2;
alter table FICHIER drop newPath;
