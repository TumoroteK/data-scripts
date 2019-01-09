DELIMITER &&

CREATE TRIGGER clean_sgl_trg
AFTER INSERT ON DOSSIER_EXTERNE
FOR EACH ROW

BEGIN
DECLARE num_rows INTEGER;
DECLARE first_dos_id INTEGER;

SELECT COUNT(*) INTO num_rows FROM DOSSIER_EXTERNE;
SELECT min(dossier_externe_id) INTO first_dos_id FROM DOSSIER_EXTERNE;

IF num_rows > 1000 THEN
	DELETE FROM VALEUR_EXTERNE where bloc_externe_id in (select bloc_externe_id from BLOC_EXTERNE where dossier_externe_id = first_dos_id);
	DELETE FROM BLOC_EXTERNE where dossier_externe_id = first_dos_id;
	DELETE FROM DOSSIER_EXTERNE where dossier_externe_id = first_dos_id;
END IF;

END&&
DELIMITER ;


