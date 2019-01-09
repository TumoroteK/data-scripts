delimiter $$

DROP PROCEDURE IF EXISTS `fusion_pf`;
CREATE PROCEDURE `fusion_pf`(IN _pf1_Id INTEGER, IN _pf2_Id INTEGER)
BEGIN
	-- thesaurii
	-- CESSION_EXAMEN
	update CESSION_EXAMEN set plateforme_id = _pf1_Id where plateforme_id = _pf2_Id;
	update CESSION c join (select e1.cession_examen_id as id1, e2.cession_examen_id as id2 from CESSION_EXAMEN e1 join CESSION_EXAMEN e2 on e1.examen=e2.examen where e1.plateforme_id= _pf1_id and e2.plateforme_id= _pf1_id and e1.cession_examen_id < e2.cession_examen_id) zz on zz.id2=c.cession_examen_id set c.cession_examen_id=zz.id1;
	delete from CESSION_EXAMEN where plateforme_id=_pf1_id and cession_examen_id not in (select distinct cession_examen_id from CESSION where cession_examen_id is not null);
	-- CONDIT_MILIEU
	update CONDIT_MILIEU set plateforme_id = _pf1_Id where plateforme_id = _pf2_Id;
	update PRELEVEMENT p join (select c1.condit_milieu_id as id1, c2.condit_milieu_id as id2 from CONDIT_MILIEU c1 join CONDIT_MILIEU c2 on c1.milieu=c2.milieu where c1.plateforme_id= _pf1_id and c2.plateforme_id= _pf1_id and c1.condit_milieu_id < c2.condit_milieu_id) zz on zz.id2=p.condit_milieu_id set p.condit_milieu_id=zz.id1;
	delete from CONDIT_MILIEU where plateforme_id = _pf1_Id and condit_milieu_id not in (select distinct condit_milieu_id from PRELEVEMENT where condit_milieu_id is not null);

	-- CONDIT_TYPE
	update CONDIT_TYPE set plateforme_id = _pf1_Id where plateforme_id = _pf2_Id;
	update PRELEVEMENT p join (select c1.condit_type_id as id1, c2.condit_type_id as id2 from CONDIT_TYPE c1 join CONDIT_TYPE c2 on c1.type=c2.type where c1.plateforme_id= _pf1_id and c2.plateforme_id=_pf1_id and c1.condit_type_id < c2.condit_type_id) zz on zz.id2=p.condit_type_id set p.condit_type_id=zz.id1;
	delete from CONDIT_TYPE where plateforme_id = _pf1_Id and condit_type_id not in (select distinct condit_type_id from PRELEVEMENT where condit_type_id is not null);

	-- CONSENT_TYPE
	update CONSENT_TYPE set plateforme_id = _pf1_Id where plateforme_id = _pf2_Id;
	update PRELEVEMENT p join (select c1.consent_type_id as id1, c2.consent_type_id as id2 from CONSENT_TYPE c1 join CONSENT_TYPE c2 on c1.type=c2.type where c1.plateforme_id= _pf1_id and c2.plateforme_id=_pf1_id and c1.consent_type_id < c2.consent_type_id) zz on zz.id2=p.consent_type_id set p.consent_type_id=zz.id1;
	delete from CONSENT_TYPE where plateforme_id = _pf1_Id and consent_type_id not in (select distinct consent_type_id from PRELEVEMENT where consent_type_id is not null);

	-- CONTENEUR_PLATEFORME
	update CONTENEUR_PLATEFORME set plateforme_id = _pf1_Id where plateforme_id = _pf2_Id;

	-- CONTENEUR_TYPE
	update CONTENEUR_TYPE set plateforme_id = _pf1_Id where plateforme_id = _pf2_Id;
	update CONTENEUR c join (select c1.conteneur_type_id as id1, c2.conteneur_type_id as id2 from CONTENEUR_TYPE c1 join CONTENEUR_TYPE c2 on c1.type=c2.type where c1.plateforme_id= _pf1_id and c2.plateforme_id=_pf1_id and c1.conteneur_type_id < c2.conteneur_type_id) zz on zz.id2=c.conteneur_type_id set c.conteneur_type_id=zz.id1;
	delete from CONTENEUR_TYPE where plateforme_id = _pf1_Id and conteneur_type_id not in (select distinct conteneur_type_id from CONTENEUR where conteneur_type_id is not null);

	-- CONTRAT
	update CONTRAT set plateforme_id = _pf1_Id where plateforme_id = _pf2_Id;

	-- DESTRUCTION_MOTIF
	update DESTRUCTION_MOTIF set plateforme_id = _pf1_Id where plateforme_id = _pf2_Id;
	update CESSION c join (select d1.destruction_motif_id as id1, d2.destruction_motif_id as id2 from DESTRUCTION_MOTIF d1 join DESTRUCTION_MOTIF d2 on d1.motif=d2.motif where d1.plateforme_id= _pf1_id and d2.plateforme_id=_pf1_id and d1.destruction_motif_id < d2.destruction_motif_id) zz on zz.id2=c.destruction_motif_id set c.destruction_motif_id=zz.id1;
	delete from DESTRUCTION_MOTIF where plateforme_id = _pf1_Id and destruction_motif_id not in (select distinct destruction_motif_id from CESSION where destruction_motif_id is not null);

	-- ECHANTILLON_TYPE
	update ECHANTILLON_TYPE set plateforme_id = _pf1_Id where plateforme_id = _pf2_Id;
	update ECHANTILLON e join (select e1.echantillon_type_id as id1, e2.echantillon_type_id as id2 from ECHANTILLON_TYPE e1 join ECHANTILLON_TYPE e2 on e1.type=e2.type where e1.plateforme_id= _pf1_id and e2.plateforme_id=_pf1_id and e1.echantillon_type_id < e2.echantillon_type_id) zz on zz.id2=e.echantillon_type_id set e.echantillon_type_id=zz.id1;
	delete from ECHANTILLON_TYPE where plateforme_id = _pf1_Id and echantillon_type_id not in (select distinct echantillon_type_id from ECHANTILLON where echantillon_type_id is not null);

	-- ECHANT_QUALITE
	update ECHAN_QUALITE set plateforme_id = _pf1_Id where plateforme_id = _pf2_Id;
	update ECHANTILLON e join (select e1.echan_qualite_id as id1, e2.echan_qualite_id as id2 from ECHAN_QUALITE e1 join ECHAN_QUALITE e2 on e1.echan_qualite=e2.echan_qualite where e1.plateforme_id= _pf1_id and e2.plateforme_id=_pf1_id and e1.echan_qualite_id < e2.echan_qualite_id) zz on zz.id2=e.echan_qualite_id set e.echan_qualite_id=zz.id1;
	delete from ECHAN_QUALITE where plateforme_id = _pf1_Id and echan_qualite_id not in (select distinct echan_qualite_id from ECHANTILLON where echan_qualite_id is not null);

	-- ENCEINTE_TYPE
	update ENCEINTE_TYPE set plateforme_id = _pf1_Id where plateforme_id = _pf2_Id;
	update ENCEINTE e join (select e1.enceinte_type_id as id1, e2.enceinte_type_id as id2 from ENCEINTE_TYPE e1 join ENCEINTE_TYPE e2 on e1.type=e2.type where e1.plateforme_id= _pf1_id and e2.plateforme_id=_pf1_id and e1.enceinte_type_id < e2.enceinte_type_id) zz on zz.id2=e.enceinte_type_id set e.enceinte_type_id=zz.id1;
	delete from ENCEINTE_TYPE where plateforme_id = _pf1_Id and enceinte_type_id not in (select distinct enceinte_type_id from ENCEINTE where enceinte_type_id is not null);

	-- IMPRIMANTE
	update IMPRIMANTE set plateforme_id = _pf1_Id where plateforme_id = _pf2_Id;

	-- ITEM
	update ITEM set plateforme_id = _pf1_Id where plateforme_id = _pf2_Id;
	update ANNOTATION_VALEUR v join (select i1.item_id as id1, i2.item_id as id2 from ITEM i1 join ITEM i2 on i1.label=i2.label where i1.plateforme_id= _pf1_id and i2.plateforme_id=_pf1_id and i1.item_id < i2.item_id) zz on zz.id2=v.item_id set v.item_id=zz.id1;
	delete from ITEM where plateforme_id = _pf1_Id and item_id not in (select distinct item_id from ANNOTATION_VALEUR where item_id is not null);

	-- MODELE
	update MODELE set plateforme_id = _pf1_Id where plateforme_id = _pf2_Id;

	-- MODE_PREPA
	update MODE_PREPA set plateforme_id = _pf1_Id where plateforme_id = _pf2_Id;
	update ECHANTILLON e join (select m1.mode_prepa_id as id1, m2.mode_prepa_id as id2 from MODE_PREPA m1 join MODE_PREPA m2 on m1.nom=m2.nom where m1.plateforme_id= _pf1_id and m2.plateforme_id=_pf1_id and m1.mode_prepa_id < m2.mode_prepa_id) zz on zz.id2=e.mode_prepa_id set e.mode_prepa_id=zz.id1;
	delete from MODE_PREPA where plateforme_id = _pf1_Id and mode_prepa_id not in (select distinct mode_prepa_id from ECHANTILLON where mode_prepa_id is not null);

	-- MODE_PREPA_DERIVE
	update MODE_PREPA_DERIVE set plateforme_id = _pf1_Id where plateforme_id = _pf2_Id;
	update PROD_DERIVE p join (select m1.mode_prepa_derive_id as id1, m2.mode_prepa_derive_id as id2 from MODE_PREPA_DERIVE m1 join MODE_PREPA_DERIVE m2 on m1.nom=m2.nom where m1.plateforme_id= _pf1_id and m2.plateforme_id=_pf1_id and m1.mode_prepa_derive_id < m2.mode_prepa_derive_id) zz on zz.id2=p.mode_prepa_derive_id set p.mode_prepa_derive_id=zz.id1;
	delete from MODE_PREPA_DERIVE where plateforme_id = _pf1_Id and mode_prepa_derive_id not in (select distinct mode_prepa_derive_id from PROD_DERIVE where mode_prepa_derive_id is not null);

	-- NATURE
	update NATURE set plateforme_id = _pf1_Id where plateforme_id = _pf2_Id;
	update PRELEVEMENT p join (select n1.nature_id as id1, n2.nature_id as id2 from NATURE n1 join NATURE n2 on n1.nature=n2.nature where n1.plateforme_id= _pf1_id and n2.plateforme_id=_pf1_id and n1.nature_id < n2.nature_id) zz on zz.id2=p.nature_id set p.nature_id=zz.id1;
	delete from NATURE where plateforme_id = _pf1_Id and nature_id not in (select distinct nature_id from PRELEVEMENT where nature_id is not null);

	-- NON_CONFORMITE
	update NON_CONFORMITE set plateforme_id = _pf1_Id where plateforme_id = _pf2_Id;
	update OBJET_NON_CONFORME o join (select n1.non_conformite_id as id1, n2.non_conformite_id as id2 from NON_CONFORMITE n1 join NON_CONFORMITE n2 on n1.nom=n2.nom where n1.plateforme_id= _pf1_id and n2.plateforme_id=_pf1_id and n1.non_conformite_id < n2.non_conformite_id) zz on zz.id2=o.non_conformite_id set o.non_conformite_id=zz.id1;
	delete from NON_CONFORMITE where plateforme_id = _pf1_Id and non_conformite_id not in (select distinct non_conformite_id from OBJET_NON_CONFORME where non_conformite_id is not null);

	-- PLATEFORME_ADMINISTRATEUR
	delete from PLATEFORME_ADMINISTRATEUR where plateforme_id = _pf2_Id;

	-- PRELEVEMENT_TYPE
	update PRELEVEMENT_TYPE set plateforme_id = _pf1_Id where plateforme_id = _pf2_Id;
	update PRELEVEMENT p join (select p1.prelevement_type_id as id1, p2.prelevement_type_id as id2 from PRELEVEMENT_TYPE p1 join PRELEVEMENT_TYPE p2 on p1.type=p2.type where p1.plateforme_id= _pf1_id and p2.plateforme_id=_pf1_id and p1.prelevement_type_id < p2.prelevement_type_id) zz on zz.id2=p.prelevement_type_id set p.prelevement_type_id=zz.id1;
	delete from PRELEVEMENT_TYPE where plateforme_id = _pf1_Id and prelevement_type_id not in (select distinct prelevement_type_id from PRELEVEMENT where prelevement_type_id is not null);

	-- PROD_TYPE
	update PROD_TYPE set plateforme_id = _pf1_Id where plateforme_id = _pf2_Id;
	update PROD_DERIVE p join (select p1.prod_type_id as id1, p2.prod_type_id as id2 from PROD_TYPE p1 join PROD_TYPE p2 on p1.type=p2.type where p1.plateforme_id= _pf1_id and p2.plateforme_id=_pf1_id and p1.prod_type_id < p2.prod_type_id) zz on zz.id2=p.prod_type_id set p.prod_type_id=zz.id1;
	delete from PROD_TYPE where plateforme_id = _pf1_Id and prod_type_id not in (select distinct prod_type_id from PROD_DERIVE where prod_type_id is not null);

	-- PROD_QUALITE
	update PROD_QUALITE set plateforme_id = _pf1_Id where plateforme_id = _pf2_Id;
	update PROD_DERIVE p join (select p1.prod_qualite_id as id1, p2.prod_qualite_id as id2 from PROD_QUALITE p1 join PROD_QUALITE p2 on p1.prod_qualite=p2.prod_qualite where p1.plateforme_id= _pf1_id and p2.plateforme_id=_pf1_id and p1.prod_qualite_id < p2.prod_qualite_id) zz on zz.id2=p.prod_qualite_id set p.prod_qualite_id=zz.id1;
	delete from PROD_QUALITE where plateforme_id = _pf1_Id and prod_qualite_id not in (select distinct prod_qualite_id from PROD_DERIVE where prod_qualite_id is not null);

	-- PROTOCOLE
	update PROTOCOLE set plateforme_id = _pf1_Id where plateforme_id = _pf2_Id;

	-- PROTOCOLE_TYPE
	update PROTOCOLE_TYPE set plateforme_id = _pf1_Id where plateforme_id = _pf2_Id;
	update CONTRAT c join (select p1.protocole_type_id as id1, p2.protocole_type_id as id2 from PROTOCOLE_TYPE p1 join PROTOCOLE_TYPE p2 on p1.type=p2.type where p1.plateforme_id= _pf1_id and p2.plateforme_id=_pf1_id and p1.protocole_type_id < p2.protocole_type_id) zz on zz.id2=c.protocole_type_id set c.protocole_type_id=zz.id1;
	delete from PROTOCOLE_TYPE where plateforme_id = _pf1_Id and protocole_type_id not in (select distinct protocole_type_id from CONTRAT where protocole_type_id is not null);

	-- RISQUE
	update RISQUE set plateforme_id = _pf1_Id where plateforme_id = _pf2_Id;
	update PRELEVEMENT_RISQUE p join (select r1.risque_id as id1, r2.risque_id as id2 from RISQUE r1 join RISQUE r2 on r1.nom=r2.nom where r1.plateforme_id= _pf1_id and r2.plateforme_id=_pf1_id and r1.risque_id < r2.risque_id) zz on zz.id2=p.risque_id set p.risque_id=zz.id1;
	delete from RISQUE where plateforme_id = _pf1_Id and risque_id not in (select distinct risque_id from PRELEVEMENT_RISQUE where risque_id is not null);

	-- TABLE_ANNOTATION
	update TABLE_ANNOTATION set nom = concat(nom, ' - ', (select nom from PLATEFORME where plateforme_id = _pf2_Id)) where plateforme_id = _pf1_Id;
	update TABLE_ANNOTATION set plateforme_id = _pf1_Id where plateforme_id = _pf2_Id;

	-- UTILISATEUR
	update UTILISATEUR set plateforme_orig_id = _pf1_Id where plateforme_orig_id = _pf2_Id;

	-- BANQUE
	update BANQUE set plateforme_id = _pf1_Id where plateforme_id = _pf2_Id;

	-- CONTENEUR
	update CONTENEUR set plateforme_orig_id = _pf1_Id where plateforme_orig_id = _pf2_Id;
	
	-- PROFIL
	update PROFIL set plateforme_id = _pf1_Id where plateforme_id = _pf2_Id;

		
	-- STATS_INDICATEUR_PLATEFORME
	update INDICATEUR_PLATEFORME set plateforme_id = _pf1_Id where plateforme_id = _pf2_Id and indicateur_id not in (select stats_indicateur_id from STATS_MODELE_INDICATEUR s join STATS_MODELE o on o.stats_modele_id=s.stats_modele_id where o.plateforme_id = _pf1_Id);
	delete from INDICATEUR_PLATEFORME where plateforme_id = _pf2_Id;

	-- STATS_MODELE
	update STATS_MODELE set plateforme_id = _pf1_Id where plateforme_id = _pf2_Id;
	


END$$
