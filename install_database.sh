# Execute from postgres user:
# sudo -i -u postgres

psql -U postgres db_ucv_fhe_sist -f ./001_faculty_data_sequence.sql
psql -U postgres db_ucv_fhe_sist -f ./002_faculty_data_tables.sql
psql -U postgres db_ucv_fhe_sist -f ./003_faculty_data_functions.sql
psql -U postgres db_ucv_fhe_sist -f ./004_faculty_data_tables_datas.sql
psql -U postgres db_ucv_fhe_sist -f ./005_employee_data_sequence.sql
psql -U postgres db_ucv_fhe_sist -f ./006_employee_data_tables.sql
psql -U postgres db_ucv_fhe_sist -f ./007_employee_data_functions.sql
psql -U postgres db_ucv_fhe_sist -f ./008_employee_data_tables_datas.sql
psql -U postgres db_ucv_fhe_sist -f ./009_process_form_sequence.sql
psql -U postgres db_ucv_fhe_sist -f ./010_process_form_tables.sql
psql -U postgres db_ucv_fhe_sist -f ./011_process_form_functions.sql
psql -U postgres db_ucv_fhe_sist -f ./012_process_form_tables_datas.sql
psql -U postgres db_ucv_fhe_sist -f ./013_user_data_sequence.sql
psql -U postgres db_ucv_fhe_sist -f ./014_user_data_tables.sql
psql -U postgres db_ucv_fhe_sist -f ./015_user_data_functions.sql
psql -U postgres db_ucv_fhe_sist -f ./016_user_data_tables_datas.sql
psql -U postgres db_ucv_fhe_sist -f ./017_form_data_sequence.sql
psql -U postgres db_ucv_fhe_sist -f ./018_form_data_tables.sql
psql -U postgres db_ucv_fhe_sist -f ./019_form_data_functions.sql
psql -U postgres db_ucv_fhe_sist -f ./020_form_data_tables_datas.sql
