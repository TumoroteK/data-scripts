mysql> select count(*) from FICHIER where fichier_id in (select fichier_id from ANNOTATION_VALEUR);
+----------+
| count(*) |
+----------+
|     4960 |
+----------+
1 row in set (0.01 sec)

mysql> select count(*) from FICHIER where fichier_id in (select cr_anapath_id from ECHANTILLON);
+----------+
| count(*) |
+----------+
|        0 |
+----------+

-- collection supprimées
insert into colls values ('coll_13');
insert into colls values ('coll_14');
insert into colls values ('coll_15');
insert into colls values ('coll_16');
insert into colls values ('coll_17');
insert into colls values ('coll_18');
insert into colls values ('coll_19');
insert into colls values ('coll_36');
insert into colls values ('coll_44');
insert into colls values ('coll_49');
insert into colls values ('coll_53');
insert into colls values ('coll_57');
insert into colls values ('coll_59');
insert into colls values ('coll_60');
insert into colls values ('coll_61');
insert into colls values ('coll_64');
insert into colls values ('coll_71');
insert into colls values ('coll_72');
insert into colls values ('coll_73');
insert into colls values ('coll_74');
insert into colls values ('coll_77');
insert into colls values ('coll_81');

-- fichiers perdus
-- select * from tumo2.FICHIER f join colls c on f.path like concat('%', c.colid, '%');
|       3244 | 16KH05039.pdf | /srv/TUMO/FICHIER/tumo2prod/pt_1/coll_49/anno/chp_74/16KH05039.pdf_3244 | application/pdf | coll_49 |
|       3246 | 16KH04975.pdf | /srv/TUMO/FICHIER/tumo2prod/pt_1/coll_49/anno/chp_74/16KH04975.pdf_3246 | application/pdf | coll_49 |
|       3256 | 16KH05191.pdf | /srv/TUMO/FICHIER/tumo2prod/pt_1/coll_49/anno/chp_74/16KH05191.pdf_3256 | application/pdf | coll_49 |
|       3298 | 16KH07250.pdf | /srv/TUMO/FICHIER/tumo2prod/pt_1/coll_49/anno/chp_74/16KH07250.pdf_3298 | application/pdf | coll_49 |
|       3350 | 16KH08457.pdf | /srv/TUMO/FICHIER/tumo2prod/pt_1/coll_49/anno/chp_74/16KH08457.pdf_3350 | application/pdf | coll_49 |
|       3351 | 16KH08457.pdf | /srv/TUMO/FICHIER/tumo2prod/pt_1/coll_49/anno/chp_74/16KH08457.pdf_3351 | application/pdf | coll_49 |
|       3352 | 16KH08457.pdf | /srv/TUMO/FICHIER/tumo2prod/pt_1/coll_49/anno/chp_74/16KH08457.pdf_3352 | application/pdf | coll_49 |
|       3354 | 16KH07710.pdf | /srv/TUMO/FICHIER/tumo2prod/pt_1/coll_49/anno/chp_74/16KH07710.pdf_3354 | application/pdf | coll_49 |
|       3367 | 15KH02142.pdf | /srv/TUMO/FICHIER/tumo2prod/pt_1/coll_49/anno/chp_74/15KH02142.pdf_3367 | application/pdf | coll_49 |
|       3442 | 16kh08722.pdf | /srv/TUMO/FICHIER/tumo2prod/pt_1/coll_49/anno/chp_74/16kh08722.pdf_3442 | application/pdf | coll_49 |
|       3447 | 16KH06936.pdf | /srv/TUMO/FICHIER/tumo2prod/pt_1/coll_49/anno/chp_74/16KH06936.pdf_3447 | application/pdf | coll_49 |
|       3471 | 15KH00279.pdf | /srv/TUMO/FICHIER/tumo2prod/pt_1/coll_49/anno/chp_74/15KH00279.pdf_3471 | application/pdf | coll_49 |
|       3491 | 16KH06224.pdf | /srv/TUMO/FICHIER/tumo2prod/pt_1/coll_49/anno/chp_74/16KH06224.pdf_3491 | application/pdf | coll_49 |
|       3493 | 16KH05979.pdf | /srv/TUMO/FICHIER/tumo2prod/pt_1/coll_49/anno/chp_74/16KH05979.pdf_3493 | application/pdf | coll_49 |
|       3494 | 16KH05979.pdf | /srv/TUMO/FICHIER/tumo2prod/pt_1/coll_49/anno/chp_74/16KH05979.pdf_3494 | application/pdf | coll_49 |
|       3495 | 16KH05945.pdf | /srv/TUMO/FICHIER/tumo2prod/pt_1/coll_49/anno/chp_74/16KH05945.pdf_3495 | application/pdf | coll_49 |
|       3497 | 16KH06992.pdf | /srv/TUMO/FICHIER/tumo2prod/pt_1/coll_49/anno/chp_74/16KH06992.pdf_3497 | application/pdf | coll_49 |
|       3516 | 16KH06614.pdf | /srv/TUMO/FICHIER/tumo2prod/pt_1/coll_49/anno/chp_74/16KH06614.pdf_3516 | application/pdf | coll_49 |
|       3517 | 16KH06614.pdf | /srv/TUMO/FICHIER/tumo2prod/pt_1/coll_49/anno/chp_74/16KH06614.pdf_3517 | application/pdf | coll_49 |
|       3518 | 16KH06614.pdf | /srv/TUMO/FICHIER/tumo2prod/pt_1/coll_49/anno/chp_74/16KH06614.pdf_3518 | application/pdf | coll_49 |
|       3520 | 16KH06045.pdf | /srv/TUMO/FICHIER/tumo2prod/pt_1/coll_49/anno/chp_74/16KH06045.pdf_3520 | application/pdf | coll_49 |
|       3521 | 16KH06931.pdf | /srv/TUMO/FICHIER/tumo2prod/pt_1/coll_49/anno/chp_74/16KH06931.pdf_3521 | application/pdf | coll_49 |
|       3749 | 14Z03707.pdf  | /srv/TUMO/FICHIER/tumo2prod/pt_1/coll_73/anno/chp_95/14Z03707.pdf_3749  | application/pdf | coll_73 |
|       3750 | 14Z02463.pdf  | /srv/TUMO/FICHIER/tumo2prod/pt_1/coll_73/anno/chp_95/14Z02463.pdf_3750  | application/pdf | coll_73 |
|       3775 | 12Z13045.pdf  | /srv/TUMO/FICHIER/tumo2prod/pt_1/coll_73/anno/chp_95/12Z13045.pdf_3775  | application/pdf | coll_73 |
|       3778 | 14Z02463.pdf  | /srv/TUMO/FICHIER/tumo2prod/pt_1/coll_73/anno/chp_95/14Z02463.pdf_3778  | application/pdf | coll_73 |
|       3783 | 14KH06491.pdf | /srv/TUMO/FICHIER/tumo2prod/pt_1/coll_73/anno/chp_95/14KH06491.pdf_3783 | application/pdf | coll_73 |
|       3793 | 14KH13663.pdf | /srv/TUMO/FICHIER/tumo2prod/pt_1/coll_73/anno/chp_95/14KH13663.pdf_3793 | application/pdf | coll_73 |
|       3794 | 15KH02546.pdf | /srv/TUMO/FICHIER/tumo2prod/pt_1/coll_73/anno/chp_95/15KH02546.pdf_3794 | application/pdf | coll_73 |
|       3795 | 15KH02640.pdf | /srv/TUMO/FICHIER/tumo2prod/pt_1/coll_73/anno/chp_95/15KH02640.pdf_3795 | application/pdf | coll_73 |
|       3796 | 15KH05545.pdf | /srv/TUMO/FICHIER/tumo2prod/pt_1/coll_73/anno/chp_95/15KH05545.pdf_3796 | application/pdf | coll_73 |
|       3846 | 16KH10524.pdf | /srv/TUMO/FICHIER/tumo2prod/pt_1/coll_53/anno/chp_74/16KH10524.pdf_3846 | application/pdf | coll_53 |
|       3867 | 14KH11184.pdf | /srv/TUMO/FICHIER/tumo2prod/pt_1/coll_73/anno/chp_95/14KH11184.pdf_3867 | application/pdf | coll_73 |
|       3869 | 14KH06539.pdf | /srv/TUMO/FICHIER/tumo2prod/pt_1/coll_73/anno/chp_95/14KH06539.pdf_3869 | application/pdf | coll_73 |
|       3870 | 14KH06868.pdf | /srv/TUMO/FICHIER/tumo2prod/pt_1/coll_73/anno/chp_95/14KH06868.pdf_3870 | application/pdf | coll_73 |
|       3871 | 14KH09661.pdf | /srv/TUMO/FICHIER/tumo2prod/pt_1/coll_73/anno/chp_95/14KH09661.pdf_3871 | application/pdf | coll_73 |
|       3880 | 15KH03331.pdf | /srv/TUMO/FICHIER/tumo2prod/pt_1/coll_73/anno/chp_95/15KH03331.pdf_3880 | application/pdf | coll_73 |
|       3881 | 15KH07376.pdf | /srv/TUMO/FICHIER/tumo2prod/pt_1/coll_73/anno/chp_95/15KH07376.pdf_3881 | application/pdf | coll_73 |
|       3882 | 15KH07595.pdf | /srv/TUMO/FICHIER/tumo2prod/pt_1/coll_73/anno/chp_95/15KH07595.pdf_3882 | application/pdf | coll_73 |
|       3883 | 15KH08233.pdf | /srv/TUMO/FICHIER/tumo2prod/pt_1/coll_73/anno/chp_95/15KH08233.pdf_3883 | application/pdf | coll_73 |
|       3885 | 15KH09645.pdf | /srv/TUMO/FICHIER/tumo2prod/pt_1/coll_73/anno/chp_95/15KH09645.pdf_3885 | application/pdf | coll_73 |
|       3886 | 15KH10062.pdf | /srv/TUMO/FICHIER/tumo2prod/pt_1/coll_73/anno/chp_95/15KH10062.pdf_3886 | application/pdf | coll_73 |
|       3887 | 15KH10373.pdf | /srv/TUMO/FICHIER/tumo2prod/pt_1/coll_73/anno/chp_95/15KH10373.pdf_3887 | application/pdf | coll_73 |
|       3888 | 15KH11483.pdf | /srv/TUMO/FICHIER/tumo2prod/pt_1/coll_73/anno/chp_95/15KH11483.pdf_3888 | application/pdf | coll_73 |
|       3889 | 15KH12001.pdf | /srv/TUMO/FICHIER/tumo2prod/pt_1/coll_73/anno/chp_95/15KH12001.pdf_3889 | application/pdf | coll_73 |
|       3911 | 14KH09712.pdf | /srv/TUMO/FICHIER/tumo2prod/pt_1/coll_73/anno/chp_95/14KH09712.pdf_3911 | application/pdf | coll_73 |
|       3913 | 15KH12985.pdf | /srv/TUMO/FICHIER/tumo2prod/pt_1/coll_73/anno/chp_95/15KH12985.pdf_3913 | application/pdf | coll_73 |
|       3914 | 16KH01542.pdf | /srv/TUMO/FICHIER/tumo2prod/pt_1/coll_73/anno/chp_95/16KH01542.pdf_3914 | application/pdf | coll_73 |
|       3915 | 16KH03694.pdf | /srv/TUMO/FICHIER/tumo2prod/pt_1/coll_73/anno/chp_95/16KH03694.pdf_3915 | application/pdf | coll_73 |
|       3931 | 14KH11961.pdf | /srv/TUMO/FICHIER/tumo2prod/pt_1/coll_73/anno/chp_95/14KH11961.pdf_3931 | application/pdf | coll_73 |
|       3944 | 15KH03790.pdf | /srv/TUMO/FICHIER/tumo2prod/pt_1/coll_73/anno/chp_95/15KH03790.pdf_3944 | application/pdf | coll_73 |
|       3945 | 15KH04331.pdf | /srv/TUMO/FICHIER/tumo2prod/pt_1/coll_73/anno/chp_95/15KH04331.pdf_3945 | application/pdf | coll_73 |
|       3946 | 15KH04690.pdf | /srv/TUMO/FICHIER/tumo2prod/pt_1/coll_73/anno/chp_95/15KH04690.pdf_3946 | application/pdf | coll_73 |
|       3948 | 15KH02667.pdf | /srv/TUMO/FICHIER/tumo2prod/pt_1/coll_73/anno/chp_95/15KH02667.pdf_3948 | application/pdf | coll_73 |
|       3950 | 14Z00229.pdf  | /srv/TUMO/FICHIER/tumo2prod/pt_1/coll_73/anno/chp_95/14Z00229.pdf_3950  | application/pdf | coll_73 |
|       3951 | 11Z02994.pdf  | /srv/TUMO/FICHIER/tumo2prod/pt_1/coll_73/anno/chp_95/11Z02994.pdf_3951  | application/pdf | coll_73 |

-- fichiers encore existants mais non deplacés
select f.nom, f.path, a.banque_id, replace(substring(path, locate('coll_', path) + 5, 2), "/", "") from FICHIER f join ANNOTATION_VALEUR a on a.fichier_id=f.fichier_id where a.banque_id <> replace(substring(path, locate('coll_', path) + 5, 2), "/", "");

-- 2954

-- update references
alter table FICHIER add old_path varchar(250);
update FICHIER set old_path=path;

alter table FICHIER add path2 varchar(250);
update FICHIER f join ANNOTATION_VALEUR a on a.fichier_id=f.fichier_id set path2=concat(left(path, locate('/coll_', path)), 'coll_', a.banque_id, substring(path, locate('/anno', path))) where a.banque_id <> replace(substring(path, locate('coll_', path) + 5, 2), "/", "");

-- move path
mysql -u tumo -p tumo2f -N -e 'select concat(path,";",path2) from FICHIER where path2 is not null' > paths2
./move_paths.sh paths2 >  miss_files

update FICHIER set path=path2 where path2 is not null and trim(path2) != '';
-- alter table FICHIER drop path2;

-- check
mysql -u tumo -p tumo2f -N -e 'select path from FICHIER where path2 is not null' > paths
./check_paths.sh paths >  out

