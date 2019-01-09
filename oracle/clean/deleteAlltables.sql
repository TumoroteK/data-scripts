set head off

set pagesize 0

set verify off

set feedback off

select 'drop table ' || TABLESPACE_NAME || '.' || table_name || ' cascade constraints' || CHR(59) from user_tables where TABLESPACE_NAME = 'TUMO' order by table_name;

spool drop_tables.sql

/

spool off

@drop_tables.sql


