#!/bin/bash

schema="tumo2test"
user="root"
pass="root"
mysql="mysql -p$pass -u $user $schema"

fksQueryResult=`echo \
"SELECT TABLE_NAME, CONSTRAINT_NAME" \
"FROM information_schema.TABLE_CONSTRAINTS "\
"WHERE CONSTRAINT_TYPE='FOREIGN KEY' AND TABLE_SCHEMA='$schema';"\
| $mysql`
declare -a fks
fks=($fksQueryResult)

for((i=2;i<${#fks[@]};i+=2)); do
  iinc=i+1
  tableName=${fks[$i]}
  keyName=${fks[$iinc]}
  echo "Dropping $tableName : $keyName"
  echo "ALTER TABLE $tableName"\
       "DROP FOREIGN KEY $keyName;"\
    | $mysql 
done

mysql -u$user -p$pass -e "show tables from $schema"| awk '{if(NR>1) print "show index from "$1";"}'| mysql -u$user -p$pass $schema| awk '{if($3 !~ /Key_name/ && $3 !~ /PRIMARY/) print $1" "$3}'| awk '{print "alter table "$1" drop index "$2";"}'
