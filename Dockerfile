FROM postgres:9.6
ENV POSTGRES_PASSWORD=postgresql
ENV POSTGRES_USER=postgres
ENV POSTGRES_DB=db_ucv_fhe_sist
COPY locale.gen /etc/
RUN locale-gen
ENV POSTGRES_INITDB_ARGS="--locale=es_VE.UTF-8"
COPY 001_faculty_data_sequence.sql /docker-entrypoint-initdb.d/
COPY 002_faculty_data_tables.sql /docker-entrypoint-initdb.d/
COPY 003_faculty_data_functions.sql /docker-entrypoint-initdb.d/
COPY 004_faculty_data_tables_datas.sql /docker-entrypoint-initdb.d/
COPY 005_employee_data_sequence.sql /docker-entrypoint-initdb.d/
COPY 006_employee_data_tables.sql /docker-entrypoint-initdb.d/
COPY 007_employee_data_functions.sql /docker-entrypoint-initdb.d/
COPY 008_employee_data_tables_datas.sql /docker-entrypoint-initdb.d/
COPY 009_process_form_sequence.sql /docker-entrypoint-initdb.d/
COPY 010_process_form_tables.sql /docker-entrypoint-initdb.d/
COPY 011_process_form_functions.sql /docker-entrypoint-initdb.d/
COPY 012_process_form_tables_datas.sql /docker-entrypoint-initdb.d/
COPY 013_form_data_sequence.sql /docker-entrypoint-initdb.d/
COPY 014_form_data_tables.sql /docker-entrypoint-initdb.d/
COPY 015_form_data_functions.sql /docker-entrypoint-initdb.d/
COPY 016_form_data_tables_datas.sql /docker-entrypoint-initdb.d/
COPY 017_user_data_sequence.sql /docker-entrypoint-initdb.d/
COPY 018_user_data_tables.sql /docker-entrypoint-initdb.d/
COPY 019_user_data_functions.sql /docker-entrypoint-initdb.d/
COPY 020_user_data_tables_datas.sql /docker-entrypoint-initdb.d/
