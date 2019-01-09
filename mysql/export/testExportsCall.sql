call create_tmp_echantillon_table();
call create_tmp_derive_table();
call create_tmp_echan_retour_table();
call create_tmp_derive_retour_table();

call fill_tmp_table_echan(153692);
call fill_tmp_echan_retour_table(153692);

select * from TMP_ECHAN_RETOUR_EXPORT;

call fill_tmp_table_derive(139);
call fill_tmp_derive_retour_table(139);

select * from TMP_DERIVE_RETOUR_EXPORT;
