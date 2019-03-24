-- tables of schema form data

CREATE TABLE form_data.movement_personal_forms(
	id INTEGER DEFAULT nextval('form_data.movement_personal_forms_person_id_seq'::regclass) NOT NULL,
	code_form VARCHAR(15) NOT NULL,
	salary MONEY NOT NULL,
	accountant_type_id INTEGER,
	progam_type_id INTEGER,
	reason TEXT NOT NULL,
	registration_date TIMESTAMP WITHOUT TIME ZONE NOT NULL,
	approval_date TIMESTAMP WITHOUT TIME ZONE,
	is_active BIT(1) NOT NULL,
  	is_deleted BIT(1) NOT NULL,
	last_modified_by BIGINT NOT NULL,
	last_modified_date TIMESTAMP WITHOUT TIME ZONE NOT NULL,
  CONSTRAINT movement_personal_forms_code UNIQUE (code_form)
);

CREATE TABLE form_data.official_forms(
	id INTEGER DEFAULT nextval('form_data.official_forms_id_seq'::regclass) NOT NULL,
	code_form VARCHAR(15) NOT NULL,
	registration_date TIMESTAMP WITHOUT TIME ZONE NOT NULL,
	approval_date TIMESTAMP WITHOUT TIME ZONE,
	is_active BIT(1) NOT NULL,
  	is_deleted BIT(1) NOT NULL,
  	last_modified_by BIGINT NOT NULL,
  	last_modified_date TIMESTAMP WITHOUT TIME ZONE NOT NULL,
  CONSTRAINT employee_official_form_code UNIQUE (code_form)
);

CREATE TABLE form_data.movement_types(
	id INTEGER DEFAULT nextval('form_data.movement_types_id_seq'::regclass) NOT NULL,
	description VARCHAR(100) NOT NULL,
	is_active BIT(1) NOT NULL,
	is_deleted BIT(1) NOT NULL,
	last_modified_by BIGINT NOT NULL,
	last_modified_date TIMESTAMP WITHOUT TIME ZONE NOT NULL
);

CREATE TABLE form_data.accountant_types(
	id INTEGER DEFAULT nextval('form_data.accountant_types_id_seq'::regclass) NOT NULL,
	code BIGINT NOT NULL,
	description VARCHAR(100) NOT NULL,
	is_active BIT(1) NOT NULL,
	is_deleted BIT(1) NOT NULL,
	last_modified_by BIGINT NOT NULL,
	last_modified_date TIMESTAMP WITHOUT TIME ZONE NOT NULL,
	CONSTRAINT contable_types_code UNIQUE (code)
);

CREATE TABLE form_data.program_types(
	id INTEGER DEFAULT nextval('form_data.program_types_id_seq'::regclass) NOT NULL,
	code VARCHAR(20) NOT NULL,
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

CREATE TABLE form_data.movement_types_annex_types(
	id INTEGER DEFAULT nextval('form_data.movement_types_annex_types_id_seq'::regclass) NOT NULL,
	annex_type_id INTEGER NOT NULL,
	movement_type_id INTEGER NOT NULL,
	is_active BIT(1) NOT NULL,
	is_deleted BIT(1) NOT NULL,
	last_modified_by BIGINT NOT NULL,
	last_modified_date TIMESTAMP WITHOUT TIME ZONE NOT NULL
);

CREATE TABLE form_data.employee_official_mov_personal_forms(
	id BIGINT DEFAULT nextval('form_data.employee_official_mov_personal_forms_id_seq'::regclass) NOT NULL,
	official_form_id BIGINT NOT NULL,
	mov_personal_form_id BIGINT,
	employee_id BIGINT NOT NULL,
	dedication_id INTEGER,
	movement_type_id INTEGER NOT NULL,
	start_date DATE NOT NULL,
	finish_date DATE NOT NULL,
	ubication_id INTEGER NOT NULL,
	school_id INTEGER,
	institute_id INTEGER,
	coordination_id INTEGER,
	is_active BIT(1) NOT NULL,
	is_deleted BIT(1) NOT NULL,
	last_modified_by BIGINT NOT NULL,
	last_modified_date TIMESTAMP WITHOUT TIME ZONE NOT NULL,
	CONSTRAINT official_form_id_unique UNIQUE (official_form_id),
	CONSTRAINT mov_personal_form_id_unique UNIQUE (mov_personal_form_id)
);

CREATE TABLE form_data.employee_annex_types(
	id INTEGER DEFAULT nextval('form_data.employee_annex_types_id_seq'::regclass) NOT NULL,
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

-- table of hitory
CREATE TABLE form_data.movement_personal_forms_history(
	id BIGINT DEFAULT nextval('form_data.movement_personal_forms_person_history_id_seq'::regclass) NOT NULL,
	mov_personal_form_id INTEGER,
	code_form VARCHAR(15),
	salary MONEY,
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

CREATE TABLE form_data.official_forms_history(
	id BIGINT DEFAULT nextval('form_data.official_forms_history_id_seq'::regclass) NOT NULL,
	official_form_id INTEGER,
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
	id BIGINT DEFAULT nextval('form_data.movement_types_history_id_seq'::regclass) NOT NULL,
	movement_type_id INTEGER,
	description VARCHAR(100),
	is_active BIT(1),
	is_deleted BIT(1),
	last_modified_by BIGINT,
	last_modified_date TIMESTAMP WITHOUT TIME ZONE,
	change_type character varying(50),
  	change_description character varying(500)
);

CREATE TABLE form_data.accountant_types_history(
	id BIGINT DEFAULT nextval('form_data.accountant_types_history_id_seq'::regclass) NOT NULL,
	accountant_type_id INTEGER,
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
	id BIGINT DEFAULT nextval('form_data.program_types_history_id_seq'::regclass) NOT NULL,
	progam_type_id INTEGER,
	code VARCHAR(20),
	description VARCHAR(100),
	is_active BIT(1),
	is_deleted BIT(1),
	last_modified_by BIGINT,
	last_modified_date TIMESTAMP WITHOUT TIME ZONE,
	change_type character varying(50),
  	change_description character varying(500)
);

CREATE TABLE form_data.annex_types_history(
	id BIGINT DEFAULT nextval('form_data.annex_types_history_id_seq'::regclass) NOT NULL,
	annex_type_id INTEGER,
	description VARCHAR(100),
	is_active BIT(1),
	is_deleted BIT(1),
	last_modified_by BIGINT,
	last_modified_date TIMESTAMP WITHOUT TIME ZONE,
	change_type character varying(50),
  	change_description character varying(500)
);

CREATE TABLE form_data.movement_types_annex_types_history(
	id BIGINT DEFAULT nextval('form_data.movement_types_annex_types_history_id_seq'::regclass) NOT NULL,
	movement_types_annex_type_id INTEGER,
	annex_type_id INTEGER,
	movement_type_id INTEGER,
	is_active BIT(1),
	is_deleted BIT(1),
	last_modified_by BIGINT,
	last_modified_date TIMESTAMP WITHOUT TIME ZONE,
	change_type character varying(50),
  	change_description character varying(500)
);

CREATE TABLE form_data.employee_official_mov_personal_forms_history(
	id BIGINT DEFAULT nextval('form_data.employee_official_mov_personal_forms_history_id_seq'::regclass) NOT NULL,
	employee_official_mov_personal_form_id INTEGER,
	official_form_id INTEGER,
	mov_personal_form_id INTEGER,
	employee_id INTEGER,
	dedication_id INTEGER,
	movement_type_id INTEGER,
	start_date DATE,
	finish_date DATE,
	ubication_id INTEGER,
	school_id INTEGER,
	institute_id INTEGER,
	is_active BIT(1),
	is_deleted BIT(1),
	last_modified_by BIGINT,
	last_modified_date TIMESTAMP WITHOUT TIME ZONE,
	change_type character varying(50),
  	change_description character varying(500)
);

CREATE TABLE form_data.employee_annex_types_history(
	id BIGINT DEFAULT nextval('form_data.employee_annex_types_history_id_seq'::regclass) NOT NULL,
	employee_annex_types_id INTEGER,
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

ALTER TABLE ONLY form_data.official_forms
  ADD CONSTRAINT employee_official_form_id_pk PRIMARY KEY (id);

ALTER TABLE ONLY form_data.movement_types
  ADD CONSTRAINT movement_type_id_pk PRIMARY KEY (id);

ALTER TABLE ONLY form_data.accountant_types
  ADD CONSTRAINT accountant_type_id_pk PRIMARY KEY (id);

ALTER TABLE ONLY form_data.program_types
  ADD CONSTRAINT program_types_id_pk PRIMARY KEY (id);

ALTER TABLE ONLY form_data.annex_types
  ADD CONSTRAINT annex_type_id_pk PRIMARY KEY (id);

ALTER TABLE ONLY form_data.movement_types_annex_types
  ADD CONSTRAINT movement_types_annex_type_id_pk PRIMARY KEY (id);

ALTER TABLE ONLY form_data.employee_official_mov_personal_forms
  ADD CONSTRAINT employee_official_mov_personal_forms_id_pk PRIMARY KEY (id);

ALTER TABLE ONLY form_data.movement_personal_forms
  ADD CONSTRAINT movement_personal_forms_id_pk PRIMARY KEY (id);

ALTER TABLE ONLY form_data.employee_annex_types
  ADD CONSTRAINT employee_annex_types_id_pk PRIMARY KEY (id);


-- ADD pk in the tables history

ALTER TABLE ONLY form_data.official_forms_history
  ADD CONSTRAINT employee_official_form_history_id_pk PRIMARY KEY (id);

ALTER TABLE ONLY form_data.movement_types_history
  ADD CONSTRAINT movement_type_history_id_pk PRIMARY KEY (id);

ALTER TABLE ONLY form_data.accountant_types_history
  ADD CONSTRAINT accountant_type_history_id_pk PRIMARY KEY (id);

ALTER TABLE ONLY form_data.program_types_history
  ADD CONSTRAINT program_types_history_id_pk PRIMARY KEY (id);

ALTER TABLE ONLY form_data.annex_types_history
  ADD CONSTRAINT annex_type_history_id_pk PRIMARY KEY (id);

ALTER TABLE ONLY form_data.movement_types_annex_types_history
  ADD CONSTRAINT movement_types_annex_type_history_id_pk PRIMARY KEY (id);

ALTER TABLE ONLY form_data.employee_official_mov_personal_forms_history
  ADD CONSTRAINT employee_official_mov_personal_forms_history_id_pk PRIMARY KEY (id);

ALTER TABLE ONLY form_data.movement_personal_forms_history
  ADD CONSTRAINT movement_personal_forms_history_id_pk PRIMARY KEY (id);

ALTER TABLE ONLY form_data.employee_annex_types_history
  ADD CONSTRAINT employee_annex_types_history_id_pk PRIMARY KEY (id);

-- ADD fk in the tables

ALTER TABLE ONLY form_data.movement_personal_forms
  ADD CONSTRAINT form_personal_movement_accountant_type_id_fk FOREIGN KEY (accountant_type_id)
  REFERENCES form_data.accountant_types(id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY form_data.movement_personal_forms
  ADD CONSTRAINT form_personal_movement_program_type_id_fk FOREIGN KEY (progam_type_id)
  REFERENCES form_data.program_types(id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY form_data.employee_official_mov_personal_forms
  ADD CONSTRAINT fofficial_form_and_form_person_movement_movement_type_id_fk FOREIGN KEY (movement_type_id)
  REFERENCES form_data.movement_types(id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY form_data.employee_official_mov_personal_forms
  ADD CONSTRAINT official_form_and_form_person_movement_official_form_id_fk FOREIGN KEY (official_form_id)
  REFERENCES form_data.official_forms(id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY form_data.employee_official_mov_personal_forms
  ADD CONSTRAINT official_mov_per_mov_personal_form_id_fk FOREIGN KEY (mov_personal_form_id)
  REFERENCES form_data.movement_personal_forms(id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY form_data.movement_types_annex_types
  ADD CONSTRAINT movement_types_annex_type_annex_type_id_fk FOREIGN KEY (annex_type_id)
  REFERENCES form_data.annex_types(id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY form_data.movement_types_annex_types
  ADD CONSTRAINT movement_types_annex_type_movement_type_id_fk FOREIGN KEY (movement_type_id)
  REFERENCES form_data.movement_types(id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY form_data.employee_annex_types
  ADD CONSTRAINT movement_types_annex_types_annex_type_id_fk FOREIGN KEY (annex_type_id)
  REFERENCES form_data.annex_types(id) ON UPDATE CASCADE ON DELETE CASCADE;

  -- ADD FK of table history

 ALTER TABLE ONLY form_data.official_forms_history
 	ADD CONSTRAINT official_forms_history_official_form_id_fk FOREIGN KEY (official_form_id)
 	REFERENCES form_data.official_forms(id);

ALTER TABLE ONLY form_data.movement_types_history
 	ADD CONSTRAINT movement_types_history_movement_type_id_fk FOREIGN KEY (movement_type_id)
 	REFERENCES form_data.movement_types (id);

ALTER TABLE ONLY form_data.accountant_types_history
 	ADD CONSTRAINT accountant_types_history_accountant_type_id_fk FOREIGN KEY (accountant_type_id)
 	REFERENCES form_data.accountant_types (id);

ALTER TABLE ONLY form_data.program_types_history
 	ADD CONSTRAINT program_types_history_progam_type_id_fk FOREIGN KEY (progam_type_id)
 	REFERENCES form_data.program_types (id);

ALTER TABLE ONLY form_data.annex_types_history
 	ADD CONSTRAINT annex_types_history_annex_type_id_fk FOREIGN KEY (annex_type_id)
 	REFERENCES form_data.annex_types (id);

ALTER TABLE ONLY form_data.movement_types_annex_types_history
 	ADD CONSTRAINT annex_type_movement_type_history_annex_type_movement_type_id_fk FOREIGN KEY (movement_types_annex_type_id)
 	REFERENCES form_data.movement_types_annex_types (id);

ALTER TABLE ONLY form_data.employee_official_mov_personal_forms_history
 	ADD CONSTRAINT empl_official_mov_per_form_hist_empl_form_ofc_person_mov_id_fk FOREIGN KEY (employee_official_mov_personal_form_id)
 	REFERENCES form_data.employee_official_mov_personal_forms (id);

ALTER TABLE ONLY form_data.movement_personal_forms_history
 	ADD CONSTRAINT movement_personal_forms_history_form_person_mov_id_fk FOREIGN KEY (mov_personal_form_id)
 	REFERENCES form_data.movement_personal_forms (id);

ALTER TABLE ONLY form_data.employee_annex_types_history
 	ADD CONSTRAINT employee_annex_types_history_employee_annex_types_id_fk FOREIGN KEY (employee_annex_types_id)
 	REFERENCES form_data.employee_annex_types (id);
