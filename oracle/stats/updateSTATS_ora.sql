-- update STATS tables
alter table STATS_STATEMENT rename to STATS_INDICATEUR;
alter table STATS_INDICATEUR rename column STATEMENT_ID to STATS_INDICATEUR_ID;
alter table STATS_INDICATEUR drop constraint FK_UTIL_SIM_INDIC_ID;
alter table STATS_INDICATEUR drop column INDICATEUR_MODELE_ID; 
alter table STATS_INDICATEUR add column ENTITE_ID number(3);
ALTER TABLE STATS_INDICATEUR ADD CONSTRAINT FK_INDICATEUR_ENTITE_ID 
	FOREIGN KEY (ENTITE_ID) REFERENCES ENTITE (ENTITE_ID);
alter table STATS_INDICATEUR modify CALLING_PROCEDURE varchar2(100) not null;

alter table STATS_INDICATEUR_MODELE rename to STATS_MODELE;
alter table STATS_MODELE rename column INDICATEUR_MODELE_ID to STATS_MODELE_ID;
alter table STATS_MODELE drop ENTITE_ID; 

alter table STATS_INDICATEUR_MODELE_BANQUE rename to STATS_MODELE_BANQUE;
alter table STATS_MODELE_BANQUE rename column INDICATEUR_MODELE_ID to STATS_MODELE_ID;

create table STATS_MODELE_INDICATEUR (STATS_INDICATEUR_ID number(10) not null, STATS_MODELE_ID number(10) not null, ORDRE number(3) not null, primary key (STATS_INDICATEUR_ID, STATS_MODELE_ID));

ALTER TABLE STATS_MODELE_INDICATEUR
	ADD CONSTRAINT FK_SMODELE_INDIC_INDIC_ID 
	FOREIGN KEY (STATS_INDICATEUR_ID) REFERENCES STATS_INDICATEUR (STATS_INDICATEUR_ID);

ALTER TABLE STATS_MODELE_INDICATEUR ADD CONSTRAINT FK_MODELE_INDICATEUR_MODELE_ID 
	FOREIGN KEY (STATS_MODELE_ID) REFERENCES STATS_MODELE (STATS_MODELE_ID);

create table SUBDIVISION (SUBDIVISION_ID number(2), NOM varchar2(100), CHAMP_ENTITE_ID number(10), primary key (SUBDIVISION_ID));
insert into SUBDIVISION values (1, 'thesaurus.liste.nature.prelevement', 111);
insert into SUBDIVISION values (2, 'thesaurus.liste.type.echantillon', 215);
insert into SUBDIVISION values (3, 'thesaurus.liste.type.prelevement', 116);
insert into SUBDIVISION values (4, 'thesaurus.liste.type.prodDerive', 140);

alter table STATS_INDICATEUR add SUBDIVISION_ID number(2);

ALTER TABLE STATS_INDICATEUR ADD CONSTRAINT FK_STATS_INDIC_SUBDIV FOREIGN KEY (SUBDIVISION_ID) REFERENCES SUBDIVISION(SUBDIVISION_ID);


-- drop oldd tables
drop table INDICATEUR_SQL;
drop table INDICATEUR_BANQUE;
drop table INDICATEUR_REQUETE;
drop table INDICATEUR_PLATEFORME;
drop table INDICATEUR;


-- populate
DELETE FROM STATS_MODELE_INDICATEUR;
DELETE FROM STATS_INDICATEUR;
INSERT numberO STATS_INDICATEUR (stats_indicateur_id, nom, calling_procedure, subdivision_id) VALUES (1, "echantillon.tot", "count_echan_tot", null);
INSERT numberO STATS_INDICATEUR (stats_indicateur_id, nom, calling_procedure, subdivision_id) VALUES (2, "echantillon.nature", "count_echan_nature", 1);
INSERT numberO STATS_INDICATEUR (stats_indicateur_id, nom, calling_procedure, subdivision_id) VALUES (3, "prelevement.tot", "count_prel_tot", null);
INSERT numberO STATS_INDICATEUR (stats_indicateur_id, nom, calling_procedure, subdivision_id) VALUES (4, "prelevement.nature", "count_prel_nature", 1);
INSERT numberO STATS_INDICATEUR (stats_indicateur_id, nom, calling_procedure, subdivision_id) VALUES (5, "echantillon.echantype", "count_echan_echantype", 2);
INSERT numberO STATS_INDICATEUR (stats_indicateur_id, nom, calling_procedure, subdivision_id) VALUES (6, "prelevement.preltype", "count_prel_preltype", 3);
INSERT numberO STATS_INDICATEUR (stats_indicateur_id, nom, calling_procedure, subdivision_id) VALUES (7, "derive_tot", "count_prod_tot", null);
INSERT numberO STATS_INDICATEUR (stats_indicateur_id, nom, calling_procedure, subdivision_id) VALUES (8, "derive_prodtype", "count_prod_prodtype", 4);

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





