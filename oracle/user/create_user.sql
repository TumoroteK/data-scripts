create tablespace ROOT datafile 'root' size 256m autoextend on next 32m maxsize 2048m extent management local;

create user root identified by root default tablespace ROOT quota unlimited on ROOT;

grant connect, create session, imp_full_database to root;

GRANT UNLIMITED TABLESPACE TO root;
