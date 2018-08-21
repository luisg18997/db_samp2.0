-- tables of schema employee data

CREATE TABLE employee_data.employees(
	id INTEGER DEFAULT nextval('employee_data.employee_id_seq'::regclass) NOT NULL,
	nacionality VARCHAR(1) NOT NULL,
	identification INTEGER NOT NULL,
	first_name VARCHAR(30) NOT NULL,
	second_name VARCHAR(30),
	surname VARCHAR(30) NOT NULL,
	second_surname VARCHAR(30),
	birth_date date NOT NULL,
	gender VARCHAR(1) NOT NULL,
	email VARCHAR(100) NOT NULL,
	state_id INTEGER NOT NULL,
	municipality_id INTEGER NOT NULL,
	parish_id INTEGER NOT NULL,
	ubication text NOT NULL,
	address text NOT NULL,
	housing_type text NOT NULL,
	housing_identifier text NOT NULL,
	apartament text NOT NULL,
	school_id INTEGER,
	institute_id INTEGER,
	cordination_id INTEGER,
	departament_id INTEGER,
	chair_id INTEGER,
	first_mobile_phone_number VARCHAR(15) NOT NULL,
	second_mobile_phone_number VARCHAR(15),
	local_phone_number VARCHAR(15) NOT NULL,
	ingress_id INTEGER NOT NULL,
	income_type_id INTEGER NOT NULL,
	admission_date date NOT NULL,
	last_updated_date date,
	retirement_date date,
	is_active BIT(1) NOT NULL,
  	is_deleted BIT(1) NOT NULL,
  	last_modified_by BIGINT NOT NULL,
  	last_modified_date TIMESTAMP WITHOUT TIME ZONE NOT NULL,
  	CONSTRAINT employee_identification_unique UNIQUE (identification)
);

CREATE TABLE employee_data.states(
	id INTEGER DEFAULT nextval('employee_data.estates_id_seq'::regclass) NOT NULL,
	name VARCHAR(30) NOT NULL,
	is_active BIT(1) NOT NULL,
	is_deleted BIT(1) NOT NULL,
	last_modified_by BIGINT NOT NULL,
	last_modified_date TIMESTAMP WITHOUT TIME ZONE NOT NULL
);

CREATE TABLE employee_data.municipalitys(
	id INTEGER DEFAULT nextval('employee_data.municipality_id_seq'::regclass) NOT NULL,
	state_id  INTEGER NOT NULL,
	name VARCHAR(30) NOT NULL,
	is_active BIT(1) NOT NULL,
	is_deleted BIT(1) NOT NULL,
	last_modified_by BIGINT NOT NULL,
	last_modified_date TIMESTAMP WITHOUT TIME ZONE NOT NULL
);

CREATE TABLE employee_data.parish(
	id INTEGER DEFAULT nextval('employee_data.parish_id_seq'::regclass) NOT NULL,
	municipality_id INTEGER NOT NULL,
	name VARCHAR(40) NOT NULL,
	is_active BIT(1) NOT NULL,
  	is_deleted BIT(1) NOT NULL,
  	last_modified_by BIGINT NOT NULL,
  	last_modified_date TIMESTAMP WITHOUT TIME ZONE NOT NULL
);

CREATE TABLE employee_data.ingress(
	id INTEGER DEFAULT nextval('employee_data.insgress_id_seq'::regclass) NOT NULL,
	description VARCHAR(30) NOT NULL,
	is_active BIT(1) NOT NULL,
	is_deleted BIT(1) NOT NULL,
	last_modified_by BIGINT NOT NULL,
	last_modified_date TIMESTAMP WITHOUT TIME ZONE NOT NULL
);

CREATE TABLE employee_data.income_types(
	id INTEGER DEFAULT nextval('employee_data.income_types_id_seq'::regclass) NOT NULL,
	description VARCHAR(30) NOT NULL,
	is_active BIT(1) NOT NULL,
  	is_deleted BIT(1) NOT NULL,
  	last_modified_by BIGINT NOT NULL,
  	last_modified_date TIMESTAMP WITHOUT TIME ZONE NOT NULL
);

CREATE TABLE employee_data.category_types(
	id INTEGER DEFAULT nextval('employee_data.category_types_id_seq'::regclass) NOT NULL,
	code INTEGER NOT NULL,
	description VARCHAR(30) NOT NULL,
	is_active BIT(1) NOT NULL,
  	is_deleted BIT(1) NOT NULL,
  	last_modified_by BIGINT NOT NULL,
  	last_modified_date TIMESTAMP WITHOUT TIME ZONE NOT NULL,
  	CONSTRAINT category_types_code UNIQUE (code)
);

CREATE TABLE employee_data.dedication_types(
	id INTEGER DEFAULT nextval('employee_data.dedication_types_id_seq'::regclass) NOT NULL,
	code INTEGER NOT NULL,
	description VARCHAR(30) NOT NULL,
	is_active BIT(1) NOT NULL,
  	is_deleted BIT(1) NOT NULL,
  	last_modified_by BIGINT NOT NULL,
  	last_modified_date TIMESTAMP WITHOUT TIME ZONE NOT NULL,
  	CONSTRAINT dedication_types_code UNIQUE (code)
);

CREATE TABLE employee_data.salaries(
	id INTEGER DEFAULT nextval('employee_data.salaries_id_seq'::regclass) NOT NULL,
	category_type_id INTEGER NOT NULL,
	dedication_type_id INTEGER NOT NULL,
	salary MONEY NOT NULL,
	is_active BIT(1) NOT NULL,
  	is_deleted BIT(1) NOT NULL,
  	last_modified_by BIGINT NOT NULL,
  	last_modified_date TIMESTAMP WITHOUT TIME ZONE NOT NULL
);

CREATE TABLE employee_data.employee_salaries(
	id INTEGER DEFAULT nextval('employee_data.employee_salaries_id_seq'::regclass) NOT NULL,
	employee_id INTEGER NOT NULL,
	salary_id INTEGER NOT NULL,
	is_active BIT(1) NOT NULL,
	is_deleted BIT(1) NOT NULL,
	last_modified_by BIGINT NOT NULL,
	last_modified_date TIMESTAMP WITHOUT TIME ZONE NOT NULL
);


CREATE TABLE employee_data.idac_codes(
	id INTEGER DEFAULT nextval('employee_data.idac_codes_id_seq'::regclass) NOT NULL,
	code INTEGER Not NULL,
	execunting_unit_id INTEGER NOT NULL,
	vacante_date  TIMESTAMP WITHOUT TIME ZONE,
	is_active BIT(1) NOT NULL,
	is_deleted BIT(1) NOT NULL,
	last_modified_by BIGINT NOT NULL,
	last_modified_date TIMESTAMP WITHOUT TIME ZONE NOT NULL,
	CONSTRAINT idac_code_unique UNIQUE (code)
);

CREATE TABLE employee_data.execunting_unit(
	id INTEGER DEFAULT nextval('employee_data.execunting_unit_id_seq'::regclass) NOT NULL,
	code INTEGER NOT NULL,
	description VARCHAR(100) NOT NULL,
	is_active BIT(1) NOT NULL,
	is_deleted BIT(1) NOT NULL,
	last_modified_by BIGINT NOT NULL,
	last_modified_date TIMESTAMP WITHOUT TIME ZONE NOT NULL,
	CONSTRAINT execunting_unit_code_unique UNIQUE (code)
);

CREATE TABLE employee_data.employee_idac_code(
	id INTEGER DEFAULT nextval('employee_data.employee_idac_codes_id_seq'::regclass) NOT NULL,
	employee_id INTEGER NOT NULL,
	idac_code_id INTEGER NOT NULL,
	is_active BIT(1) NOT NULL,
	is_deleted BIT(1) NOT NULL,
	last_modified_by BIGINT NOT NULL,
	last_modified_date TIMESTAMP WITHOUT TIME ZONE NOT NULL
);

-- ADD PK in the tables

ALTER TABLE ONLY employee_data.employees
	ADD CONSTRAINT employee_id_pk PRIMARY KEY (id);

ALTER TABLE ONLY employee_data.states
	ADD CONSTRAINT states_id_pk PRIMARY KEY (id);

ALTER TABLE ONLY employee_data.municipalitys
	ADD CONSTRAINT municipality_id_pk PRIMARY KEY (id);

ALTER TABLE ONLY employee_data.parish
	ADD CONSTRAINT parish_id_pk PRIMARY KEY (id);

ALTER TABLE ONLY employee_data.ingress
	ADD CONSTRAINT ingres_id_pk PRIMARY KEY (id);

ALTER TABLE ONLY employee_data.income_types
	ADD CONSTRAINT income_type_id_pk PRIMARY KEY (id);

ALTER TABLE ONLY employee_data.category_types
	ADD CONSTRAINT category_type_id_pk PRIMARY KEY (id);

ALTER TABLE ONLY employee_data.dedication_types
	ADD CONSTRAINT dedication_type_id_pk PRIMARY KEY (id);

ALTER TABLE ONLY employee_data.salaries
	ADD CONSTRAINT salary_id_pk PRIMARY KEY (id);

ALTER TABLE ONLY employee_data.employee_salaries
	ADD CONSTRAINT employee_salary_id_pk PRIMARY KEY (id);

ALTER TABLE ONLY employee_data.execunting_unit
	ADD CONSTRAINT execunting_unit_id_pk PRIMARY KEY (id);

ALTER TABLE ONLY employee_data.idac_codes
	ADD CONSTRAINT idac_code_id_pk PRIMARY KEY (id);

ALTER TABLE ONLY employee_data.employee_idac_code
	ADD CONSTRAINT employee_idac_code_id_pk PRIMARY KEY (id);

-- ADD fk in the tables

ALTER TABLE ONLY employee_data.employees
  ADD CONSTRAINT employee_state_id_fk FOREIGN KEY (state_id) 
  REFERENCES employee_data.states(id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY employee_data.employees
  ADD CONSTRAINT employee_municipality_id_fk FOREIGN KEY (municipality_id) 
  REFERENCES employee_data.municipalitys(id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY employee_data.employees
  ADD CONSTRAINT employee_parish_id_fk FOREIGN KEY (parish_id) 
  REFERENCES employee_data.parish(id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY employee_data.municipalitys
  ADD CONSTRAINT municipality_state_id_fk FOREIGN KEY (state_id) 
  REFERENCES employee_data.states(id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY employee_data.parish
  ADD CONSTRAINT parish_municipality_id_fk FOREIGN KEY (municipality_id) 
  REFERENCES employee_data.municipalitys(id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY employee_data.employees
  ADD CONSTRAINT employee_ingres_id_fk FOREIGN KEY (ingress_id) 
  REFERENCES employee_data.ingress(id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY employee_data.employees
  ADD CONSTRAINT employee_income_type_id_fk FOREIGN KEY (income_type_id) 
  REFERENCES employee_data.income_types(id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY employee_data.salaries
  ADD CONSTRAINT salary_dedication_type_id_fk FOREIGN KEY (dedication_type_id) 
  REFERENCES employee_data.dedication_types(id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY employee_data.salaries
  ADD CONSTRAINT salary_category_type_id_fk FOREIGN KEY (category_type_id) 
  REFERENCES employee_data.category_types(id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY employee_data.employee_salaries
  ADD CONSTRAINT employee_salary_employee_id_fk FOREIGN KEY (employee_id) 
  REFERENCES employee_data.employees(id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY employee_data.employee_salaries
  ADD CONSTRAINT employee_salary_salary_id_fk FOREIGN KEY (salary_id) 
  REFERENCES employee_data.salaries(id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY employee_data.idac_codes
  ADD CONSTRAINT idac_code_execunting_unit_id_fk FOREIGN KEY (execunting_unit_id) 
  REFERENCES employee_data.execunting_unit(id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY employee_data.employee_idac_code
  ADD CONSTRAINT employee_idac_code_employee_id_fk FOREIGN KEY (employee_id) 
  REFERENCES employee_data.employees(id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY employee_data.employee_idac_code
  ADD CONSTRAINT employee_idac_code_idac_code_id_fk FOREIGN KEY (idac_code_id) 
  REFERENCES employee_data.idac_codes(id) ON UPDATE CASCADE ON DELETE CASCADE;