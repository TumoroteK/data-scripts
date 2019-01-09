REM LOCATION:   Object Management\Indexes\Reports
REM FUNCTION:   Report all foreign keys that do not have an index on the child table
REM TESTED ON:  7.3.3.5, 8.0.4.1, 8.1.5, 8.1.7, 9.0.1, 10.2.0.3, 11.1.0.6
REM PLATFORM:   non-specific
REM REQUIRES:   all_cons_columns, all_constraints, all_ind_columns
REM
REM  This is a part of the Knowledge Xpert for Oracle Administration library.
REM  Copyright (C) 2008 Quest Software
REM  All rights reserved.
REM
REM******************** Knowledge Xpert for Oracle Administration ********************


SET pages 56 lines 132 feedback off
TTITLE ' Foreign Constraints and Columns Without an Index on Child Table'
SELECT      acc.owner
         || '-> '
         || acc.constraint_name
         || '('
         || acc.column_name
         || '['
         || acc.position
         || '])' "Owner, Name, Column, Position"
    FROM all_cons_columns acc, all_constraints ac
   WHERE ac.constraint_name = acc.constraint_name
     AND ac.constraint_type = 'R'
     AND (acc.owner, acc.table_name, acc.column_name, acc.position) IN
               (SELECT acc.owner, acc.table_name, acc.column_name, acc.position
                  FROM all_cons_columns acc, all_constraints ac
                 WHERE ac.constraint_name = acc.constraint_name
                   AND ac.constraint_type = 'R'
                MINUS
                SELECT table_owner, table_name, column_name, column_position
                  FROM all_ind_columns)
ORDER BY ACC.owner, ACC.constraint_name, ACC.column_name, ACC.position;
