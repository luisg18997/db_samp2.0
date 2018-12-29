# Execute from postgres user:
# sudo -i -u postgres

psql -U postgres db_ucv_fhe_sist -f ./faculty_data_sequence.sql
psql -U postgres db_ucv_fhe_sist -f ./faculty_data_tables.sql
psql -U postgres db_ucv_fhe_sist -f ./faculty_data_functions.sql
psql -U postgres db_ucv_fhe_sist -f ./faculty_data_tables_datas.sql
psql -U postgres db_ucv_fhe_sist -f ./employee_data_sequence.sql
psql -U postgres db_ucv_fhe_sist -f ./employee_data_tables.sql
psql -U postgres db_ucv_fhe_sist -f ./employee_data_functions.sql
psql -U postgres db_ucv_fhe_sist -f ./employee_data_tables_datas.sql
psql -U postgres db_ucv_fhe_sist -f ./process_form_sequence.sql
psql -U postgres db_ucv_fhe_sist -f ./process_form_tables.sql
psql -U postgres db_ucv_fhe_sist -f ./process_form_functions.sql
psql -U postgres db_ucv_fhe_sist -f ./process_form_tables_datas.sql
psql -U postgres db_ucv_fhe_sist -f ./form_data_sequence.sql
psql -U postgres db_ucv_fhe_sist -f ./form_data_tables.sql
psql -U postgres db_ucv_fhe_sist -f ./form_data_functions.sql
psql -U postgres db_ucv_fhe_sist -f ./form_data_tables_datas.sql
psql -U postgres db_ucv_fhe_sist -f ./user_data_sequence.sql
psql -U postgres db_ucv_fhe_sist -f ./user_data_tables.sql
psql -U postgres db_ucv_fhe_sist -f ./user_data_functions.sql
psql -U postgres db_ucv_fhe_sist -f ./user_data_tables_datas.sql
