-- PROCEDURE PRINCIPALE

drop table if exists counts;
create table counts (c int, b int, s varchar(100)) ENGINE=MYISAM;

-- Obligation d'utiliser le sModeleId pour utilisation dans la deuxième partie de la fonction COMPOSESQL
-- sModeleId permet de limiter les comptes aux banques associées aux calculs d'indicateurs.

delimiter $$
DROP PROCEDURE IF EXISTS stats_TER_$$
CREATE PROCEDURE stats_TER_(IN name_Proc varchar(50),
                        IN date_debut DATE,
                        IN date_fin DATE,
                        IN sModeleId INT)
BEGIN    
    CASE
        WHEN name_Proc="count_echan_tot" then CALL stats_count_echan_tot(date_debut, date_fin, sModeleId);
        WHEN name_Proc="count_echan_nature" then CALL stats_count_echan_nature(date_debut, date_fin, sModeleId);
        WHEN name_Proc="count_echan_echantype" then CALL stats_count_echan_type(date_debut, date_fin, sModeleId);

        WHEN name_Proc="count_prel_tot" then CALL stats_count_prel_tot(date_debut, date_fin, sModeleId);
        WHEN name_Proc="count_prel_nature" then CALL stats_count_prel_nature(date_debut, date_fin, sModeleId);
        WHEN name_Proc="count_prel_preltype" then CALL stats_count_prel_preltype(date_debut, date_fin, sModeleId);
        WHEN name_Proc="count_prel_tot_pour_consent" then CALL stats_count_prel_tot_pour_consent(date_debut, date_fin, sModeleId);
        WHEN name_Proc="count_prel_tot_complete" then CALL stats_count_prel_tot_complete(date_debut, date_fin, sModeleId);
        WHEN name_Proc="count_prel_delai_acheminement" then CALL stats_count_prel_delai_acheminement(date_debut, date_fin, sModeleId);
        WHEN name_Proc="count_prel_sterile" then CALL stats_count_prel_sterile(date_debut, date_fin, sModeleId);



        WHEN name_Proc="count_echan_delai_traitement" then CALL stats_count_echan_delai_traitement(date_debut, date_fin, sModeleId);
        WHEN name_Proc="count_echan_delai_congelation" then CALL stats_count_echan_delai_congelation(date_debut, date_fin, sModeleId);


        WHEN name_Proc="count_patient_tot" then CALL stats_count_patient_tot(date_debut, date_fin, sModeleId);
        
        WHEN name_Proc="count_prod_tot" then CALL stats_count_prod_tot(date_debut, date_fin, sModeleId);
        WHEN name_Proc="count_prod_prodtype" then CALL stats_count_prod_prodtype(date_debut, date_fin, sModeleId);


        WHEN name_Proc="count_echan" then CALL stats_count_echan_test(date_debut, date_fin, sModeleId);
        WHEN name_Proc="count_patient" then CALL stats_count_patient_test(date_debut, date_fin, sModeleId);
        WHEN name_Proc="count_prod" then CALL stats_count_prod_test(date_debut, date_fin, sModeleId);
     --   WHEN name_Proc="count_prelev_pourcentage_consent" then CALL stats_count_prel_pour_consent(date_debut, date_fin);
     --   WHEN name_Proc="count_prelev_complete" then CALL stats_count_prel_complete(date_debut, date_fin);
     --   WHEN name_Proc="count_prel_delai_acheminement" then CALL stats_count_prel_delai_acheminement(date_debut, date_fin);
      --  WHEN name_Proc="count_echan_delai_traitement" then CALL stats_count_echan_delai_traitement(date_debut, date_fin);
      --  WHEN name_Proc="count_echan_delai_congelation" then CALL stats_count_echan_delai_congelation(date_debut, date_fin);
     --   WHEN name_Proc="count_prel_sterile" then CALL stats_count_prel_sterile(date_debut, date_fin);

    END CASE;

    SET @sql ='SELECT * from counts';
 /*   IF banqueid IS NOT NULL THEN
        SET @sql = CONCAT(@sql, ' WHERE banque_id = ', banqueid);
    SET @sql = CONCAT(@sql, ' GROUP BY banque_id ');
    END IF;
*/
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt; 
END $$

-- 

-- SOUS PROCEDURES


DELIMITER $$
DROP FUNCTION IF EXISTS COMPOSE_PRELSQL $$
CREATE FUNCTION COMPOSE_PRELSQL(query VARCHAR(3000), date_debut DATE, date_fin DATE, subdiv VARCHAR(100), sModeleId INT(10))
RETURNS VARCHAR(3000)
BEGIN 
  IF query is null then 
    RETURN CONCAT('insert into counts SELECT ifnull(zz.cc, 0), b.banque_id as banque_id, ', subdiv, ' as subdiv');
  ELSE
    SET query = CONCAT(query, ' WHERE b.banque_id in (select banque_id from STATS_MODELE_BANQUE where stats_modele_id = ', sModeleId, ')');   
    SET query = CONCAT(query, ' ORDER BY b.banque_id, subdiv');   
    RETURN query;
  END IF;
END $$

DELIMITER $$
DROP PROCEDURE IF EXISTS stats_count_prel_tot$$
CREATE PROCEDURE stats_count_prel_tot(IN date_debut DATE, IN date_fin DATE, IN sModeleId INT)
BEGIN
    TRUNCATE TABLE counts;
    SET @sql = COMPOSE_PRELSQL(null, null ,null, 'null', null);
    
    SET @sql = CONCAT(@sql, ' FROM BANQUE b');
    SET @sql = CONCAT(@sql, ' LEFT JOIN
                (SELECT banque_id, count(prelevement_id) as cc FROM PRELEVEMENT p
    LEFT JOIN OPERATION op ON p.prelevement_id = op.objet_id');
    SET @sql = CONCAT(@sql, ' WHERE op.operation_type_id = 3 AND op.ENTITE_ID = 2');
    SET @sql = CONCAT(@sql, ' AND op.date_ BETWEEN ''', date_debut, ''' AND ''', date_fin, '''');
    SET @sql = CONCAT(@sql, ' GROUP BY p.banque_id) zz ');
    SET @sql = CONCAT(@sql, ' ON b.banque_id = zz.banque_id');

    SET @sql = COMPOSE_PRELSQL(@sql, date_debut, date_fin, null, sModeleId);

    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt; 
END $$



DELIMITER $$
DROP PROCEDURE IF EXISTS stats_count_prel_nature$$
CREATE PROCEDURE stats_count_prel_nature(IN date_debut DATE, IN date_fin DATE, IN sModeleId INT)
BEGIN
    TRUNCATE TABLE counts;
    SET @sql = COMPOSE_PRELSQL(null, null ,null, 'n.nature_id', null);
    
    SET @sql = CONCAT(@sql, ' FROM BANQUE b');
    SET @sql = CONCAT(@sql, ' LEFT JOIN NATURE n ON n.plateforme_id = b.plateforme_id LEFT JOIN
                (SELECT p.banque_id, p.nature_id, count(p.prelevement_id) as cc FROM PRELEVEMENT p
    LEFT JOIN OPERATION op ON p.prelevement_id = op.objet_id
    LEFT JOIN NATURE n on p.NATURE_ID = n.NATURE_ID');
    SET @sql = CONCAT(@sql, ' WHERE op.operation_type_id = 3 AND op.ENTITE_ID = 2');
    SET @sql = CONCAT(@sql, ' AND op.date_ BETWEEN ''', date_debut, ''' AND ''', date_fin, '''');
    SET @sql = CONCAT(@sql, ' GROUP BY p.banque_id, n.nature_id) zz ');
    SET @sql = CONCAT(@sql, ' ON zz.nature_id = n.nature_id AND b.banque_id = zz.banque_id');

    SET @sql = COMPOSE_PRELSQL(@sql, date_debut, date_fin, null, sModeleId);

    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt; 
END $$

DELIMITER $$
DROP PROCEDURE IF EXISTS stats_count_prel_preltype$$
CREATE PROCEDURE stats_count_prel_preltype(IN date_debut DATE, IN date_fin DATE, IN sModeleId INT)
BEGIN
    TRUNCATE TABLE counts;
    SET @sql = COMPOSE_PRELSQL(null, null ,null, 'pt.prelevement_type_id', null);
    
    SET @sql = CONCAT(@sql, ' FROM BANQUE b');
    SET @sql = CONCAT(@sql, ' LEFT JOIN PRELEVEMENT_TYPE pt ON pt.plateforme_id = b.plateforme_id LEFT JOIN
                (SELECT banque_id, p.prelevement_type_id, count(prelevement_id) as cc FROM PRELEVEMENT p
    LEFT JOIN OPERATION op ON p.prelevement_id = op.objet_id
    LEFT JOIN PRELEVEMENT_TYPE pt on p.PRELEVEMENT_TYPE_ID = pt.PRELEVEMENT_TYPE_ID');
 --   LEFT JOIN PRELEVEMENT_TYPE pt on p.prelevement_type_id = pt.prelevement_type_id');
    SET @sql = CONCAT(@sql, ' WHERE op.operation_type_id = 3 AND op.ENTITE_ID = 2');
    SET @sql = CONCAT(@sql, ' AND op.date_ BETWEEN ''', date_debut, ''' AND ''', date_fin, '''');
    SET @sql = CONCAT(@sql, ' GROUP BY p.banque_id, pt.prelevement_type_id) zz ');
    SET @sql = CONCAT(@sql, ' ON zz.prelevement_type_id = pt.prelevement_type_id AND b.banque_id = zz.banque_id');

    SET @sql = COMPOSE_PRELSQL(@sql, date_debut, date_fin, null, sModeleId);

    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt; 
END $$

-- --------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------
DELIMITER $$
DROP PROCEDURE IF EXISTS stats_count_echan_tot$$
CREATE PROCEDURE stats_count_echan_tot(IN date_debut DATE, IN date_fin DATE, IN sModeleId INT)
BEGIN
    TRUNCATE TABLE counts;
    SET @sql = COMPOSE_ECHANSQL(null, null ,null, 'null', null);

    SET @sql = CONCAT(@sql, ' FROM BANQUE b');
    SET @sql = CONCAT(@sql, ' LEFT JOIN 
                            (select banque_id, count(echantillon_id) as cc FROM ECHANTILLON e');
    SET @sql = CONCAT(@sql, ' LEFT JOIN OPERATION op ON e.ECHANTILLON_ID = op.objet_id');
    SET @sql = CONCAT(@sql, ' WHERE op.operation_type_id = 3 AND op.ENTITE_ID = 3');
    SET @sql = CONCAT(@sql, ' AND op.date_ BETWEEN ''', date_debut, ''' AND ''', date_fin, '''');
    SET @sql = CONCAT(@sql, ' GROUP BY banque_id) zz
    ON b.banque_id = zz.banque_id');

    SET @sql = COMPOSE_ECHANSQL(@sql, date_debut, date_fin, null, sModeleId);

    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt; 
END $$

DELIMITER $$
DROP PROCEDURE IF EXISTS stats_count_echan_nature$$
CREATE PROCEDURE stats_count_echan_nature(IN date_debut DATE, IN date_fin DATE, IN sModeleId INT)
BEGIN
    TRUNCATE TABLE counts;
    SET @sql = COMPOSE_ECHANSQL(null, null ,null, 'n.nature_id', null);

    SET @sql = CONCAT(@sql, ' FROM BANQUE b
     LEFT JOIN NATURE n ON n.plateforme_id = b.plateforme_id LEFT JOIN
     (select e.banque_id, p.nature_id, count(e.echantillon_id) as cc FROM ECHANTILLON e
     LEFT JOIN OPERATION op ON e.ECHANTILLON_ID = op.objet_id
     LEFT JOIN PRELEVEMENT p ON e.PRELEVEMENT_ID = p.PRELEVEMENT_id
     LEFT JOIN NATURE n ON p.NATURE_ID = n.NATURE_ID
     WHERE op.operation_type_id = 3 AND op.ENTITE_ID = 3
     AND op.date_ BETWEEN ''', date_debut, ''' AND ''', date_fin, '''
     GROUP BY banque_id, n.nature_id) zz

     ON zz.nature_id = n.nature_id AND b.banque_id = zz.banque_id
    ');
    
    SET @sql = COMPOSE_ECHANSQL(@sql, date_debut, date_fin, null, sModeleId);
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt; 
END $$


DELIMITER $$
DROP PROCEDURE IF EXISTS stats_count_echan_type$$
CREATE PROCEDURE stats_count_echan_type(IN date_debut DATE, IN date_fin DATE, IN sModeleId INT)
BEGIN
    TRUNCATE TABLE counts;
    SET @sql = COMPOSE_ECHANSQL(null, null ,null, 'et.echantillon_type_id', null);

    SET @sql = CONCAT(@sql, ' FROM BANQUE b join ECHANTILLON_TYPE et on et.plateforme_id = b.plateforme_id');
    SET @sql = CONCAT(@sql, ' LEFT JOIN 
                            (select banque_id, echantillon_type_id, count(echantillon_id) as cc FROM ECHANTILLON e');
    SET @sql = CONCAT(@sql, ' LEFT JOIN OPERATION op ON e.ECHANTILLON_ID = op.objet_id');
    SET @sql = CONCAT(@sql, ' WHERE op.operation_type_id = 3 AND op.ENTITE_ID = 3');
    SET @sql = CONCAT(@sql, ' AND op.date_ BETWEEN ''', date_debut, ''' AND ''', date_fin, '''');
    SET @sql = CONCAT(@sql, ' GROUP BY banque_id, echantillon_type_id) zz ');
    SET @sql = CONCAT(@sql, ' ON zz.echantillon_type_id = et.echantillon_type_id AND b.banque_id = zz.banque_id');

    SET @sql = COMPOSE_ECHANSQL(@sql, date_debut, date_fin, null, sModeleId);
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt; 
END $$


DELIMITER $$
DROP FUNCTION IF EXISTS COMPOSE_ECHANSQL $$
CREATE FUNCTION COMPOSE_ECHANSQL(query VARCHAR(3000), date_debut DATE, date_fin DATE, subdiv VARCHAR(100), sModeleId INT(10))
RETURNS VARCHAR(3000)
BEGIN 
  IF query is null then 
    RETURN CONCAT('insert into counts SELECT ifnull(zz.cc, 0), b.banque_id as banque_id, ', subdiv, ' as subdiv');
  ELSE
    SET query = CONCAT(query, ' WHERE b.banque_id in (select banque_id from STATS_MODELE_BANQUE where stats_modele_id = ', sModeleId, ')');   
    SET query = CONCAT(query, ' ORDER BY b.banque_id, subdiv');   
    RETURN query;
  END IF;
END $$

-- --------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------

DELIMITER $$
DROP PROCEDURE IF EXISTS stats_count_patient_tot$$
CREATE PROCEDURE stats_count_patient_tot(IN date_debut DATE, IN date_fin DATE)
BEGIN

    TRUNCATE TABLE counts;
    SET @sql = COMPOSE_PATSQL(null, null ,null, 'null');
    
    SET @sql = CONCAT(@sql, ' FROM BANQUE b');
    SET @sql = CONCAT(@sql, ' LEFT JOIN
                (SELECT p.banque_id, count(pa.patient_id) as cc FROM PATIENT pa
                LEFT JOIN OPERATION op ON pa.patient_id = op.objet_id
                LEFT JOIN MALADIE m ON pa.patient_id = m.patient_id
                LEFT JOIN PRELEVEMENT p ON m.maladie_id = p.maladie_id');
    SET @sql = CONCAT(@sql, ' WHERE op.operation_type_id = 3 AND op.ENTITE_ID = 2');
    SET @sql = CONCAT(@sql, ' AND op.date_ BETWEEN ''', date_debut, ''' AND ''', date_fin, '''');
    SET @sql = CONCAT(@sql, ' GROUP BY p.banque_id) zz ');
    SET @sql = CONCAT(@sql, ' ON b.banque_id = zz.banque_id');

    SET @sql = COMPOSE_PATSQL(@sql, date_debut, date_fin, null);

    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt; 
END $$


DELIMITER $$
DROP FUNCTION IF EXISTS COMPOSE_PATSQL $$
CREATE FUNCTION COMPOSE_PATSQL(query VARCHAR(3000), date_debut DATE, date_fin DATE, subdiv VARCHAR(100))
RETURNS VARCHAR(3000)
BEGIN 
  IF query is null then 
    RETURN CONCAT('insert into counts SELECT ifnull(zz.cc, 0), b.banque_id as banque_id, ', subdiv, ' as subdiv');
  ELSE
    SET query = CONCAT(query, ' ORDER BY b.banque_id, subdiv');   
    RETURN query;
  END IF;
END $$






-- --------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------

DELIMITER $$
DROP PROCEDURE IF EXISTS stats_count_prod_tot$$
CREATE PROCEDURE stats_count_prod_tot(IN date_debut DATE, IN date_fin DATE)
BEGIN
    TRUNCATE TABLE counts;
    SET @sql = COMPOSE_PRODSQL(null, null ,null, 'null');

    SET @sql = CONCAT(@sql, ' FROM BANQUE b');
    SET @sql = CONCAT(@sql, ' LEFT JOIN 
                            (select pd.banque_id, count(pd.prod_derive_id) as cc FROM PROD_DERIVE pd');
    SET @sql = CONCAT(@sql, ' LEFT JOIN OPERATION op ON pd.prod_derive_id = op.objet_id');
    SET @sql = CONCAT(@sql, ' WHERE op.operation_type_id = 3 AND op.ENTITE_ID = 8');
    SET @sql = CONCAT(@sql, ' AND op.date_ BETWEEN ''', date_debut, ''' AND ''', date_fin, '''');
    SET @sql = CONCAT(@sql, ' GROUP BY pd.banque_id) zz
    ON b.banque_id = zz.banque_id');

    SET @sql = COMPOSE_PRODSQL(@sql, date_debut, date_fin, null);

    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt; 
END $$


DELIMITER $$
DROP PROCEDURE IF EXISTS stats_count_prod_prodtype$$
CREATE PROCEDURE stats_count_prod_prodtype(IN date_debut DATE, IN date_fin DATE)
BEGIN
    TRUNCATE TABLE counts;
    SET @sql = COMPOSE_ECHANSQL(null, null ,null, 'pt.prod_type_id');

    SET @sql = CONCAT(@sql, ' FROM BANQUE b join PROD_TYPE pt on pt.plateforme_id = b.plateforme_id');
    SET @sql = CONCAT(@sql, ' LEFT JOIN 
                            (select banque_id, prod_type_id, count(prod_derive_id) as cc FROM PROD_DERIVE pd');
    SET @sql = CONCAT(@sql, ' LEFT JOIN OPERATION op ON prod_derive_id = op.objet_id');
    SET @sql = CONCAT(@sql, ' WHERE op.operation_type_id = 3 AND op.ENTITE_ID = 8');
    SET @sql = CONCAT(@sql, ' AND op.date_ BETWEEN ''', date_debut, ''' AND ''', date_fin, '''');
    SET @sql = CONCAT(@sql, ' GROUP BY banque_id, prod_type_id) zz ');
    SET @sql = CONCAT(@sql, ' ON zz.prod_type_id = pt.prod_type_id AND b.banque_id = zz.banque_id');

    SET @sql = COMPOSE_ECHANSQL(@sql, date_debut, date_fin, null);
PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt; 
END $$


DELIMITER $$
DROP FUNCTION IF EXISTS COMPOSE_PRODSQL $$
CREATE FUNCTION COMPOSE_PRODSQL(query VARCHAR(3000), date_debut DATE, date_fin DATE, subdiv VARCHAR(100))
RETURNS VARCHAR(3000)
BEGIN 
  IF query is null then 
    RETURN CONCAT('insert into counts SELECT ifnull(zz.cc, 0), b.banque_id as banque_id, ', subdiv, ' as subdiv');
  ELSE
    SET query = CONCAT(query, ' ORDER BY b.banque_id, subdiv');   
    RETURN query;
  END IF;
END $$


DELIMITER $$
DROP PROCEDURE IF EXISTS stats_count_prel_tot_pour_consent$$
CREATE PROCEDURE stats_count_prel_tot_pour_consent(IN date_debut DATE, IN date_fin DATE)
BEGIN
    TRUNCATE TABLE counts;
    SET @sql = COMPOSE_PRELSQL(null, null ,null, 'null');
    
    SET @sql = CONCAT(@sql, ' FROM BANQUE b');
    SET @sql = CONCAT(@sql, ' LEFT JOIN
                (SELECT banque_id, count(prelevement_id) as cc FROM PRELEVEMENT p
    LEFT JOIN OPERATION op ON p.prelevement_id = op.objet_id');
    SET @sql = CONCAT(@sql, ' LEFT JOIN CONSENT_TYPE c on p.consent_type_id = c.consent_type_id');
    SET @sql = CONCAT(@sql, ' WHERE op.operation_type_id = 3 AND op.ENTITE_ID = 2');
    SET @sql = CONCAT(@sql, ' AND op.date_ BETWEEN ''', date_debut, ''' AND ''', date_fin, '''');
    SET @sql = CONCAT(@sql, ' AND c.TYPE = ''EN ATTENTE''');
    SET @sql = CONCAT(@sql, ' GROUP BY p.banque_id) zz ');
    SET @sql = CONCAT(@sql, ' ON b.banque_id = zz.banque_id');

    SET @sql = COMPOSE_PRELSQL(@sql, date_debut, date_fin, null);

    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt; 
END $$


DELIMITER $$
DROP PROCEDURE IF EXISTS stats_count_prel_tot_complete$$
CREATE PROCEDURE stats_count_prel_tot_complete(IN date_debut DATE, IN date_fin DATE)
BEGIN
    TRUNCATE TABLE counts;
    SET @sql = COMPOSE_PRELSQL(null, null ,null, 'null');
    
    SET @sql = CONCAT(@sql, ' FROM BANQUE b');
    SET @sql = CONCAT(@sql, ' LEFT JOIN
                (SELECT banque_id, count(prelevement_id) as cc FROM PRELEVEMENT p
    LEFT JOIN OPERATION op ON p.prelevement_id = op.objet_id');
    SET @sql = CONCAT(@sql, ' LEFT JOIN CONSENT_TYPE c on p.consent_type_id = c.consent_type_id');
    SET @sql = CONCAT(@sql, ' WHERE op.operation_type_id = 3 AND op.ENTITE_ID = 2');
    SET @sql = CONCAT(@sql, ' AND op.date_ BETWEEN ''', date_debut, ''' AND ''', date_fin, '''');
    SET @sql = CONCAT(@sql, ' AND PRELEV_HEURE IS NOT NULL AND DATE_PRELEVEMENT IS NOT NULL
    AND SERVICE_PRELEVEUR_ID IS NOT NULL');
    SET @sql = CONCAT(@sql, ' GROUP BY p.banque_id) zz ');
    SET @sql = CONCAT(@sql, ' ON b.banque_id = zz.banque_id');

    SET @sql = COMPOSE_PRELSQL(@sql, date_debut, date_fin, null);

    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt; 
END $$


DELIMITER $$
DROP PROCEDURE IF EXISTS stats_count_prel_delai_acheminement$$
CREATE PROCEDURE stats_count_prel_delai_acheminement(IN date_debut DATE, IN date_fin DATE)
BEGIN
    TRUNCATE TABLE counts;
    SET @sql = COMPOSE_PRELSQL(null, null ,null, 'null');
    
    SET @sql = CONCAT(@sql, ' FROM BANQUE b');
    SET @sql = CONCAT(@sql, ' LEFT JOIN
                (SELECT banque_id, AVG(TIMESTAMPDIFF(HOUR, p.DATE_PRELEVEMENT, p.DATE_ARRIVEE)) as cc FROM PRELEVEMENT p
    LEFT JOIN OPERATION op ON p.prelevement_id = op.objet_id');
    SET @sql = CONCAT(@sql, ' LEFT JOIN CONSENT_TYPE c on p.consent_type_id = c.consent_type_id');
    SET @sql = CONCAT(@sql, ' WHERE op.operation_type_id = 3 AND op.ENTITE_ID = 2');
    SET @sql = CONCAT(@sql, ' AND op.date_ BETWEEN '', date_debut, '' AND '', date_fin, ''');
    SET @sql = CONCAT(@sql, ' AND p.DATE_PRELEVEMENT IS NOT NULL
    AND p.DATE_ARRIVEE IS NOT NULL
    AND HOUR(p.DATE_PRELEVEMENT) > 0
    AND HOUR(p.DATE_ARRIVEE) > 0
    AND p.DATE_PRELEVEMENT < p.DATE_ARRIVEE');
    SET @sql = CONCAT(@sql, ' GROUP BY p.banque_id) zz ');
    SET @sql = CONCAT(@sql, ' ON b.banque_id = zz.banque_id');

    SET @sql = COMPOSE_PRELSQL(@sql, date_debut, date_fin, null);
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt; 
END $$

DELIMITER $$
DROP PROCEDURE IF EXISTS stats_count_echan_delai_traitement$$
CREATE PROCEDURE stats_count_echan_delai_traitement(IN date_debut DATE, IN date_fin DATE)
BEGIN
    TRUNCATE TABLE counts;
    SET @sql = COMPOSE_ECHANSQL(null, null ,null, 'null');

    SET @sql = CONCAT(@sql, ' FROM BANQUE b LEFT JOIN

     (select e.banque_id, AVG(TIMESTAMPDIFF(HOUR, p.DATE_ARRIVEE, e.DATE_STOCK)) as cc
     FROM ECHANTILLON e
     LEFT JOIN OPERATION op ON e.ECHANTILLON_ID = op.objet_id
     LEFT JOIN PRELEVEMENT p ON e.PRELEVEMENT_ID = p.PRELEVEMENT_id
     WHERE op.operation_type_id = 3 AND op.ENTITE_ID = 3
     AND op.date_ BETWEEN ''', date_debut, ''' AND ''', date_fin, '''
     AND e.DATE_STOCK IS NOT NULL
    AND p.DATE_ARRIVEE IS NOT NULL
    AND HOUR(e.DATE_STOCK) > 0
    AND HOUR(p.DATE_ARRIVEE) > 0
    AND p.DATE_ARRIVEE < e.DATE_STOCK
    GROUP BY banque_id) zz
     ON b.banque_id = zz.banque_id
    ');
    SET @sql = COMPOSE_ECHANSQL(@sql, date_debut, date_fin, null);
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt; 
END $$

DELIMITER $$
DROP PROCEDURE IF EXISTS stats_count_echan_delai_congelation$$
CREATE PROCEDURE stats_count_echan_delai_congelation(IN date_debut DATE, IN date_fin DATE)
BEGIN
    TRUNCATE TABLE counts;
    SET @sql = COMPOSE_ECHANSQL(null, null ,null, 'null');

    SET @sql = CONCAT(@sql, ' FROM BANQUE b LEFT JOIN

     (select e.banque_id, AVG(TIMESTAMPDIFF(HOUR, p.DATE_PRELEVEMENT, e.DATE_STOCK)) as cc
     FROM ECHANTILLON e
     LEFT JOIN OPERATION op ON e.ECHANTILLON_ID = op.objet_id
     LEFT JOIN PRELEVEMENT p ON e.PRELEVEMENT_ID = p.PRELEVEMENT_id
     WHERE op.operation_type_id = 3 AND op.ENTITE_ID = 3
     AND op.date_ BETWEEN ''', date_debut, ''' AND ''', date_fin, '''
     AND e.DATE_STOCK IS NOT NULL
    AND p.DATE_PRELEVEMENT IS NOT NULL
    AND HOUR(e.DATE_STOCK) > 0
    AND HOUR(p.DATE_PRELEVEMENT) > 0
    AND p.DATE_PRELEVEMENT < e.DATE_STOCK
    GROUP BY banque_id) zz
     ON b.banque_id = zz.banque_id
    ');
    SET @sql = COMPOSE_ECHANSQL(@sql, date_debut, date_fin, null);
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt; 
END $$


DELIMITER $$
DROP PROCEDURE IF EXISTS stats_count_prel_sterile$$
CREATE PROCEDURE stats_count_prel_sterile(IN date_debut DATE, IN date_fin DATE)
BEGIN
    TRUNCATE TABLE counts;
    SET @sql = COMPOSE_PRELSQL(null, null ,null, 'null');
    
    SET @sql = CONCAT(@sql, ' FROM BANQUE b');
    SET @sql = CONCAT(@sql, ' LEFT JOIN
                (SELECT banque_id, count(prelevement_id) as cc FROM PRELEVEMENT p
    LEFT JOIN OPERATION op ON p.prelevement_id = op.objet_id');
    SET @sql = CONCAT(@sql, ' LEFT JOIN CONSENT_TYPE c on p.consent_type_id = c.consent_type_id');
    SET @sql = CONCAT(@sql, ' WHERE op.operation_type_id = 3 AND op.ENTITE_ID = 2');
    SET @sql = CONCAT(@sql, ' AND op.date_ BETWEEN ''', date_debut, ''' AND ''', date_fin, '''');
    SET @sql = CONCAT(@sql, ' AND p.STERILE = 1');
    SET @sql = CONCAT(@sql, ' GROUP BY p.banque_id) zz ');
    SET @sql = CONCAT(@sql, ' ON b.banque_id = zz.banque_id');

    SET @sql = COMPOSE_PRELSQL(@sql, date_debut, date_fin, null);

    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt; 
END $$


DELIMITER $$
DROP PROCEDURE IF EXISTS stats_count_prel_sterile$$
CREATE PROCEDURE stats_count_prel_sterile(IN date_debut DATE, IN date_fin DATE)
BEGIN
    DROP TEMPORARY TABLE IF EXISTS counts;
    SET @sql = 'CREATE TEMPORARY TABLE counts '; 
    SET @sql = CONCAT(@sql, 'SELECT count(p.prelevement_id) as entity_count,
    op.date_ as op_date, p.banque_id as banque_id, pt.type as entity_type, n.nature as nature');
    SET @sql = CONCAT(@sql, ' FROM PRELEVEMENT p
    LEFT JOIN OPERATION op ON p.prelevement_id = op.objet_id
    LEFT JOIN NATURE n on p.NATURE_ID = n.NATURE_ID
    LEFT JOIN PRELEVEMENT_TYPE pt on p.prelevement_type_id = pt.prelevement_type_id');
    SET @sql = CONCAT(@sql, ' WHERE op.operation_type_id = 3 AND op.ENTITE_ID = 2');
    SET @sql = CONCAT(@sql, ' AND p.STERILE = 1');
    SET @sql = CONCAT(@sql, ' AND op.date_ BETWEEN ''', date_debut, ''' AND ''', date_fin, '''');
    SET @sql = CONCAT(@sql, ' GROUP BY p.banque_id, nature, entity_type');

    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt; 

END $$

-- A REPRENDRE!!!!!!!
DELIMITER $$
DROP PROCEDURE IF EXISTS stats_count_echan_tracabilite$$
CREATE PROCEDURE stats_count_echan_tracabilite(IN date_debut DATE, IN date_fin DATE)
BEGIN
    DROP TEMPORARY TABLE IF EXISTS counts;
    SET @sql = 'CREATE TEMPORARY TABLE counts '; 
    SET @sql = CONCAT(@sql, 'count(p.prelevement_id) as entity_count,
    op.date_ as op_date, p.banque_id as banque_id, p.prelevement_type_id as entity_type_id,
    p.nature_id as nature_id');
    SET @sql = CONCAT(@sql, ' FROM ECHANTILLON e
    LEFT JOIN OPERATION op ON e.ECHANTILLON_ID = op.objet_id
    LEFT JOIN PRELEVEMENT p ON e.PRELEVEMENT_ID = p.PRELEVEMENT_ID');
    SET @sql = CONCAT(@sql, ' WHERE op.operation_type_id = 3 AND op.ENTITE_ID = 3');
    SET @sql = CONCAT(@sql, '
    AND p.code IS NOT NULL AND p.code !=""
    AND p.DATE_PRELEVEMENT IS NOT NULL AND p.DATE_PRELEVEMENT !=""
    AND p.SERVICE_PRELEVEUR_ID IS NOT NULL AND p.SERVICE_PRELEVEUR_ID !=""
    AND p.PRELEVEMENT_TYPE_ID IS NOT NULL AND p.PRELEVEMENT_TYPE_ID !=""
    AND p.DATE_ARRIVEE IS NOT NULL AND p.DATE_ARRIVEE !=""
    AND p.ARRIVEE_BANQUE_HEURE IS NOT NULL AND p.ARRIVEE_BANQUE_HEURE !=""
    AND p.DATE_ARRIVEE IS NOT NULL AND p.DATE_ARRIVEE !=""
    AND p.DATE_ARRIVEE IS NOT NULL AND p.DATE_ARRIVEE !=""
    AND p.DATE_ARRIVEE IS NOT NULL AND p.DATE_ARRIVEE !=""
');
    SET @sql = CONCAT(@sql, ' AND op.date_ BETWEEN ''', date_debut, ''' AND ''', date_fin, '''');
    SET @sql = CONCAT(@sql, ' GROUP BY p.banque_id, p.nature_id, p.prelevement_type_id');

    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt; 

END $$

-- --------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------
