-- tables of schema form data

CREATE TABLE form_data.employee_form_personal_movement(
	id INTEGER DEFAULT nextval('form_data.employee_form_personal_movement_perons_id_seq'::regclass) NOT NULL,
	code_form VARCHAR(15) NOT NULL,
	accountant_type_id INTEGER,
	progam_type_id INTEGER,
	reason TEXT NOT NULL,
	registration_date TIMESTAMP WITHOUT TIME ZONE NOT NULL,
	approval_date TIMESTAMP WITHOUT TIME ZONE NOT NULL,
	is_active BIT(1) NOT NULL,
  	is_deleted BIT(1) NOT NULL,
	last_modified_by BIGINT NOT NULL,
	last_modified_date TIMESTAMP WITHOUT TIME ZONE NOT NULL,
  CONSTRAINT employee_form_personal_movement_code UNIQUE (code_form)
);

CREATE TABLE form_data.employee_form_ofices(
	id INTEGER DEFAULT nextval('form_data.employee_form_ofices_id_seq'::regclass) NOT NULL,
	code_form VARCHAR(15) NOT NULL,
	registration_date TIMESTAMP WITHOUT TIME ZONE NOT NULL,
	approval_date TIMESTAMP WITHOUT TIME ZONE NOT NULL,
	is_active BIT(1) NOT NULL,
  	is_deleted BIT(1) NOT NULL,
  	last_modified_by BIGINT NOT NULL,
  	last_modified_date TIMESTAMP WITHOUT TIME ZONE NOT NULL,
  CONSTRAINT employee_form_ofice_code UNIQUE (code_form)
);

CREATE TABLE form_data.movement_types(
	id INTEGER DEFAULT nextval('form_data.movement_types_id_seq'::regclass) NOT NULL,
	code INTEGER NOT NULL,
	description VARCHAR(100) NOT NULL,
	is_active BIT(1) NOT NULL,
	is_deleted BIT(1) NOT NULL,
	last_modified_by BIGINT NOT NULL,
	last_modified_date TIMESTAMP WITHOUT TIME ZONE NOT NULL,
	CONSTRAINT movemt_types_code UNIQUE (code)
);

CREATE TABLE form_data.accountant_types(
	id INTEGER DEFAULT nextval('form_data.accountant_types_id_seq'::regclass) NOT NULL,
	code BIGINT NOT NULL,
	description VARCHAR(100),
	is_active BIT(1) NOT NULL,
	is_deleted BIT(1) NOT NULL,
	last_modified_by BIGINT NOT NULL,
	last_modified_date TIMESTAMP WITHOUT TIME ZONE NOT NULL,
	CONSTRAINT contable_types_code UNIQUE (code)
);

CREATE TABLE form_data.program_types(
	id INTEGER DEFAULT nextval('form_data.program_types_id_seq'::regclass) NOT NULL,
	code VARCHAR(10) NOT NULL,
	description VARCHAR(100),
	is_active BIT(1) NOT NULL,
	is_deleted BIT(1) NOT NULL,
	last_modified_by BIGINT NOT NULL,
	last_modified_date TIMESTAMP WITHOUT TIME ZONE NOT NULL,
	CONSTRAINT program_types_code UNIQUE (code)
);

CREATE TABLE form_data.annex_types(
	id INTEGER DEFAULT nextval('form_data.annex_types_id_seq'::regclass) NOT NULL,
	description VARCHAR(100) NOT NULL,
	is_active BIT(1) NOT NULL,
	is_deleted BIT(1) NOT NULL,
	last_modified_by BIGINT NOT NULL,
	last_modified_date TIMESTAMP WITHOUT TIME ZONE NOT NULL
);

CREATE TABLE form_data.annex_types_for_movement_types(
	id INTEGER DEFAULT nextval('form_data.annex_types_for_movement_types_id_seq'::regclass) NOT NULL,
	annex_type_id INTEGER NOT NULL,
	movement_type_id INTEGER NOT NULL,
	is_active BIT(1) NOT NULL,
	is_deleted BIT(1) NOT NULL,
	last_modified_by BIGINT NOT NULL,
	last_modified_date TIMESTAMP WITHOUT TIME ZONE NOT NULL
);

CREATE TABLE form_data.employee_form_ofice_and_form_person_movement(
	id INTEGER DEFAULT nextval('form_data.employee_form_ofice_and_form_person_movement_id_seq'::regclass) NOT NULL,
	form_ofice_id INTEGER NOT NULL,
	form_person_movement_id INTEGER,
	employee_id INTEGER NOT NULL,
	dedication_id INTEGER,
	movement_type_id INTEGER NOT NULL,
	start_date DATE NOT NULL,
	finish_date DATE NOT NULL,
	school_id INTEGER NOT NULL,
	institute_id INTEGER NOT NULL,
	is_active BIT(1) NOT NULL,
	is_deleted BIT(1) NOT NULL,
	last_modified_by BIGINT NOT NULL,
	last_modified_date TIMESTAMP WITHOUT TIME ZONE NOT NULL,
	CONSTRAINT form_ofice_id_unique UNIQUE (form_ofice_id),
	CONSTRAINT form_person_movement_id_unique UNIQUE (form_person_movement_id)
);

CREATE TABLE form_data.employee_annex_forms(
	id INTEGER DEFAULT nextval('form_data.employee_annex_forms_id_seq'::regclass) NOT NULL,
	employee_id INTEGER NOT NULL,
	annex_type_id INTEGER NOT NULL,
	route TEXT NOT NULL,
	receiver_date TIMESTAMP WITHOUT TIME ZONE NOT NULL,
	is_active BIT(1) NOT NULL,
	is_deleted BIT(1) NOT NULL,
	last_modified_by BIGINT NOT NULL,
	last_modified_date TIMESTAMP WITHOUT TIME ZONE NOT NULL,
	CONSTRAINT route_annex_unique UNIQUE (route)
);

CREATE TABLE form_data.employee_form_personal_movement_history(
	id BIGINT,
	code_form VARCHAR(15),
	accountant_type_id INTEGER,
	progam_type_id INTEGER,
	reason TEXT,
	registration_date TIMESTAMP WITHOUT TIME ZONE,
	approval_date TIMESTAMP WITHOUT TIME ZONE,
	is_active BIT(1),
  	is_deleted BIT(1),
	last_modified_by BIGINT,
	last_modified_date TIMESTAMP WITHOUT TIME ZONE,
	change_type character varying(50),
  	change_description character varying(500)
);

CREATE TABLE form_data.employee_form_ofices_history(
	id BIGINT,
	code_form VARCHAR(15),
	registration_date TIMESTAMP WITHOUT TIME ZONE,
	approval_date TIMESTAMP WITHOUT TIME ZONE,
	is_active BIT(1),
  	is_deleted BIT(1),
  	last_modified_by BIGINT,
  	last_modified_date TIMESTAMP WITHOUT TIME ZONE,
  	change_type character varying(50),
  	change_description character varying(500)
);

CREATE TABLE form_data.movement_types_history(
	id BIGINT,
	code INTEGER,
	description VARCHAR(100),
	is_active BIT(1),
	is_deleted BIT(1),
	last_modified_by BIGINT,
	last_modified_date TIMESTAMP WITHOUT TIME ZONE,
	change_type character varying(50),
  	change_description character varying(500)
);

CREATE TABLE form_data.accountant_types_history(
	id BIGINT,
	code BIGINT,
	description VARCHAR(100),
	is_active BIT(1),
	is_deleted BIT(1),
	last_modified_by BIGINT,
	last_modified_date TIMESTAMP WITHOUT TIME ZONE,
	change_type character varying(50),
  	change_description character varying(500)
);

CREATE TABLE form_data.program_types_history(
	id BIGINT,
	code VARCHAR(10),
	description VARCHAR(100),
	is_active BIT(1),
	is_deleted BIT(1),
	last_modified_by BIGINT,
	last_modified_date TIMESTAMP WITHOUT TIME ZONE,
	change_type character varying(50),
  	change_description character varying(500)
);

CREATE TABLE form_data.annex_types_history(
	id BIGINT,
	description VARCHAR(100),
	is_active BIT(1),
	is_deleted BIT(1),
	last_modified_by BIGINT,
	last_modified_date TIMESTAMP WITHOUT TIME ZONE,
	change_type character varying(50),
  	change_description character varying(500)
);

CREATE TABLE form_data.annex_types_for_movement_types_history(
	id BIGINT,
	annex_type_id INTEGER,
	movement_type_id INTEGER,
	is_active BIT(1),
	is_deleted BIT(1),
	last_modified_by BIGINT,
	last_modified_date TIMESTAMP WITHOUT TIME ZONE,
	change_type character varying(50),
  	change_description character varying(500)
);

CREATE TABLE form_data.employee_form_ofice_and_form_person_movement_history(
	id BIGINT,
	form_ofice_id INTEGER,
	form_person_movement_id INTEGER,
	employee_id INTEGER,
	dedication_id INTEGER,
	movement_type_id INTEGER,
	start_date DATE,
	finish_date DATE,
	school_id INTEGER,
	institute_id INTEGER,
	is_active BIT(1),
	is_deleted BIT(1),
	last_modified_by BIGINT,
	last_modified_date TIMESTAMP WITHOUT TIME ZONE,
	change_type character varying(50),
  	change_description character varying(500)
);

CREATE TABLE form_data.employee_annex_forms_history(
	id BIGINT,
	employee_id INTEGER,
	annex_type_id INTEGER,
	route TEXT,
	receiver_date TIMESTAMP WITHOUT TIME ZONE,
	is_active BIT(1),
	is_deleted BIT(1),
	last_modified_by BIGINT,
	last_modified_date TIMESTAMP WITHOUT TIME ZONE,
	change_type character varying(50),
  	change_description character varying(500)
);

-- ADD pk in the tables

ALTER TABLE ONLY form_data.employee_form_ofices
  ADD CONSTRAINT employee_form_ofice_id_pk PRIMARY KEY (id);

ALTER TABLE ONLY form_data.movement_types
  ADD CONSTRAINT movement_type_id_pk PRIMARY KEY (id);

ALTER TABLE ONLY form_data.accountant_types
  ADD CONSTRAINT accountant_type_id_pk PRIMARY KEY (id);

ALTER TABLE ONLY form_data.program_types
  ADD CONSTRAINT program_types_id_pk PRIMARY KEY (id);

ALTER TABLE ONLY form_data.annex_types
  ADD CONSTRAINT annex_type_id_pk PRIMARY KEY (id);

ALTER TABLE ONLY form_data.annex_types_for_movement_types
  ADD CONSTRAINT annex_types_for_movement_type_id_pk PRIMARY KEY (id);

ALTER TABLE ONLY form_data.employee_form_ofice_and_form_person_movement
  ADD CONSTRAINT employee_form_ofice_and_form_person_movement_id_pk PRIMARY KEY (id);

ALTER TABLE ONLY form_data.employee_form_personal_movement
  ADD CONSTRAINT employee_form_personal_movement_id_pk PRIMARY KEY (id);

ALTER TABLE ONLY form_data.employee_annex_forms
  ADD CONSTRAINT employee_annex_forms_id_pk PRIMARY KEY (id);

-- ADD fk in the tables

ALTER TABLE ONLY form_data.employee_form_personal_movement 
  ADD CONSTRAINT form_personal_movement_accountant_type_id_fk FOREIGN KEY (accountant_type_id) 
  REFERENCES form_data.accountant_types(id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY form_data.employee_form_personal_movement 
  ADD CONSTRAINT form_personal_movement_program_type_id_fk FOREIGN KEY (progam_type_id) 
  REFERENCES form_data.program_types(id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY form_data.employee_form_ofice_and_form_person_movement
  ADD CONSTRAINT fform_ofice_and_form_person_movement_movement_type_id_fk FOREIGN KEY (movement_type_id) 
  REFERENCES form_data.movement_types(id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY form_data.employee_form_ofice_and_form_person_movement
  ADD CONSTRAINT form_ofice_and_form_person_movement_form_ofice_id_fk FOREIGN KEY (form_ofice_id) 
  REFERENCES form_data.employee_form_personal_movement(id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY form_data.employee_form_ofice_and_form_person_movement
  ADD CONSTRAINT form_ofice_and_form_person_movement_form_person_movement_id_fk FOREIGN KEY (form_person_movement_id) 
  REFERENCES form_data.employee_form_ofices(id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY form_data.annex_types_for_movement_types
  ADD CONSTRAINT annex_types_for_movement_type_annex_type_id_fk FOREIGN KEY (annex_type_id) 
  REFERENCES form_data.annex_types(id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY form_data.annex_types_for_movement_types
  ADD CONSTRAINT annex_types_for_movement_type_movement_type_id_fk FOREIGN KEY (movement_type_id) 
  REFERENCES form_data.movement_types(id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY form_data.employee_annex_forms
  ADD CONSTRAINT employee_annex_forms_annex_type_id_fk FOREIGN KEY (annex_type_id) 
  REFERENCES form_data.annex_types(id) ON UPDATE CASCADE ON DELETE CASCADE;