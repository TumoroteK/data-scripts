CREATE OR REPLACE TRIGGER TUMO.TUMO_LOGON_TRG 
AFTER LOGON ON DATABASE
BEGIN
	 IF ( USER = 'TUMO') 
         THEN
		execute immediate 'ALTER SESSION SET NLS_SORT=binary_ci';
		execute immediate 'ALTER SESSION SET NLS_COMP=LINGUISTIC';
		execute immediate 'ALTER SESSION SET nls_numeric_characters =''.,'''; 
	END IF;
END;

select DESCRIPTION, TRIGGER_BODY from user_triggers where trigger_name = 'TUMO_LOGON_TRG';

