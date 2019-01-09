-- update STATS tables
alter table STATS_STATEMENT rename to STATS_INDICATEUR;
alter table STATS_INDICATEUR ENGINE INNODB;
alter table STATS_INDICATEUR change STATEMENT_ID STATS_INDICATEUR_ID int(10) not null;
alter table STATS_INDICATEUR drop foreign key FK_UTIL_SIM_INDIC_ID;
alter table STATS_INDICATEUR drop INDICATEUR_MODELE_ID; 
alter table STATS_INDICATEUR add ENTITE_ID int(3);
ALTER TABLE STATS_INDICATEUR ADD CONSTRAINT FK_INDICATEUR_ENTITE_ID 
	FOREIGN KEY (ENTITE_ID) REFERENCES ENTITE (ENTITE_ID);
alter table STATS_INDICATEUR modify CALLING_PROCEDURE varchar(100) not null;

CREATE TABLE STATS_INDICATEUR_MODELE (
  STATS_INDICATEUR_MODELE_ID int(10) NOT NULL,
  NOM varchar(50) DEFAULT NULL,
  PLATEFORME_ID int(2) DEFAULT NULL,
  IS_SUBDIVISED tinyint(1) DEFAULT NULL,
  IS_DEFAULT tinyint(1) DEFAULT NULL,
  SUBDIVISION_TYPE varchar(30) DEFAULT NULL,
  SUBDIVISION_NOM varchar(100) DEFAULT NULL,
  DESCRIPTION varchar(200) DEFAULT NULL,
  PRIMARY KEY (STATS_INDICATEUR_MODELE_ID)
) ENGINE=InnoDB;

alter table STATS_INDICATEUR_MODELE rename to STATS_MODELE;
alter table STATS_MODELE ENGINE INNODB;
alter table STATS_MODELE change INDICATEUR_MODELE_ID STATS_MODELE_ID int(10) not null;
alter table STATS_MODELE drop ENTITE_ID; 

-- create table STATS_INDICATEUR_MODELE_BANQUE (
--  STATS_MODELE_ID int(10) NOT NULL,
--  BANQUE_ID int(10) NOT NULL,
--  PRIMARY KEY (STATS_MODELE_ID,BANQUE_ID)
-- ) ENGINE=InnoDB;

alter table STATS_INDICATEUR_MODELE_BANQUE rename to STATS_MODELE_BANQUE;
alter table STATS_MODELE_BANQUE ENGINE INNODB;
alter table STATS_MODELE_BANQUE change INDICATEUR_MODELE_ID STATS_MODELE_ID int(10) not null;

create table STATS_MODELE_INDICATEUR (STATS_INDICATEUR_ID int(10) not null, STATS_MODELE_ID int(10) not null, ORDRE int(3) not null, primary key (STATS_INDICATEUR_ID, STATS_MODELE_ID));

ALTER TABLE STATS_MODELE_INDICATEUR
	ADD CONSTRAINT FK_SMODELE_INDICATEUR_INDICATEUR_ID 
	FOREIGN KEY (STATS_INDICATEUR_ID) REFERENCES STATS_INDICATEUR (STATS_INDICATEUR_ID);

ALTER TABLE STATS_MODELE_INDICATEUR ADD CONSTRAINT FK_MODELE_INDICATEUR_MODELE_ID 
	FOREIGN KEY (STATS_MODELE_ID) REFERENCES STATS_MODELE (STATS_MODELE_ID);

create table SUBDIVISION (SUBDIVISION_ID int(2), NOM varchar (100), CHAMP_ENTITE_ID int(10), primary key (SUBDIVISION_ID));
insert into SUBDIVISION values (1, 'thesaurus.liste.nature.prelevement', 111), (2, 'thesaurus.liste.type.echantillon', 215), (3, 'thesaurus.liste.type.prelevement', 116), (4, 'thesaurus.liste.type.prodDerive', 140);

alter table STATS_INDICATEUR add SUBDIVISION_ID int(2);

ALTER TABLE STATS_INDICATEUR ADD FOREIGN KEY (SUBDIVISION_ID) REFERENCES SUBDIVISION(SUBDIVISION_ID);


-- drop oldd tables
drop table INDICATEUR_SQL;
drop table INDICATEUR_BANQUE;
drop table INDICATEUR_REQUETE;
drop table INDICATEUR_PLATEFORME;
drop table INDICATEUR;


-- populate
DELETE FROM STATS_MODELE_INDICATEUR;
DELETE FROM STATS_INDICATEUR;
INSERT INTO STATS_INDICATEUR (stats_indicateur_id, nom, calling_procedure, subdivision_id) VALUES (1, "echantillon.tot", "count_echan_tot", null);
INSERT INTO STATS_INDICATEUR (stats_indicateur_id, nom, calling_procedure, subdivision_id) VALUES (2, "echantillon.nature", "count_echan_nature", 1);
INSERT INTO STATS_INDICATEUR (stats_indicateur_id, nom, calling_procedure, subdivision_id) VALUES (3, "prelevement.tot", "count_prel_tot", null);
INSERT INTO STATS_INDICATEUR (stats_indicateur_id, nom, calling_procedure, subdivision_id) VALUES (4, "prelevement.nature", "count_prel_nature", 1);
INSERT INTO STATS_INDICATEUR (stats_indicateur_id, nom, calling_procedure, subdivision_id) VALUES (5, "echantillon.echantype", "count_echan_echantype", 2);
INSERT INTO STATS_INDICATEUR (stats_indicateur_id, nom, calling_procedure, subdivision_id) VALUES (6, "prelevement.preltype", "count_prel_preltype", 3);
INSERT INTO STATS_INDICATEUR (stats_indicateur_id, nom, calling_procedure, subdivision_id) VALUES (7, "derive_tot", "count_prod_tot", null);
INSERT INTO STATS_INDICATEUR (stats_indicateur_id, nom, calling_procedure, subdivision_id) VALUES (8, "derive_prodtype", "count_prod_prodtype", 4);

-- calls
select * from counts;
CALL stats_TER_("count_echan_tot", "2004-01-01", "2014-01-01", 1);
CALL stats_TER_("count_echan_nature", "2004-01-01", "2014-01-01", 1);
CALL stats_TER_("count_echan_type", "2004-01-01", "2014-01-01", 1);



CALL stats_count_echan_nature('2004-01-01', '2014-01-01');
call stats_count_echan_nature('2010-01-01', '2014-01-01');

call stats_count_echan_tot('2010-01-01', '2014-01-01');


CALL stats_TER_("count_prel_tot", "2004-01-01", "2014-01-01", 1);
call stats_count_prel_tot('2010-01-01', '2014-01-01');

CALL stats_TER_("count_prel_nature", "2004-01-01", "2014-01-01", 1);
call stats_count_prel_nature('2010-01-01', '2014-01-01');

CALL stats_TER_("count_prel_preltype", "2004-01-01", "2014-01-01", 1);
call stats_count_prel_preltype('2010-01-01', '2014-01-01');

CALL stats_TER_("count_prod_tot", "2004-01-01", "2014-01-01", 1);
call stats_count_prod_tot('2010-01-01', '2014-01-01');

CALL stats_TER_("count_prod_type", "2004-01-01", "2014-01-01", 1);
CALL stats_count_prod_type('2010-01-01', '2014-01-01');

CALL stats_TER_("count_prel_tot_pour_consent", "2004-01-01", "2014-01-01", 1);
CALL stats_count_prel_tot_pour_consent('2010-01-01', '2014-01-01');

CALL stats_TER_("count_prel_tot_complete", "2004-01-01", "2014-01-01", 1);
CALL stats_count_prel_tot_complete('2010-01-01', '2014-01-01');

CALL stats_TER_("count_prel_delai_acheminement", "2004-01-01", "2014-01-01", 1);
CALL stats_count_prel_delai_acheminement('2010-01-01', '2014-01-01');

CALL stats_TER_("count_echan_delai_traitement", "2004-01-01", "2014-01-01", 1);
CALL stats_count_echan_delai_traitement('2010-01-01', '2014-01-01');

CALL stats_TER_("count_echan_delai_traitement", "2004-01-01", "2014-01-01", 1);
CALL stats_count_echan_delai_congelation('2010-01-01', '2014-01-01');

CALL stats_TER_("count_prel_sterile", "2004-01-01", "2014-01-01", 1);
CALL stats_count_prel_sterile('2010-01-01', '2014-01-01');

CALL stats_TER_("count_patient_tot", "2004-01-01", "2014-01-01", 1);
call stats_count_patient_tot('2010-01-01', '2014-01-01');





