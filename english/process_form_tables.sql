CREATE TABLE process_from.process_form_movement_personal(
	id BIGINT DEFAULT nextval('process_form.process_form_movement_personal_seq'::regclass) NOT NULL,
	form_movement_personal_id INTEGER NOT NULL,
	date_made DATE NOT NULL,
	ubication_id INTEGER NOT NULL,
	status_process_form_id INTEGER NOT NULL,
	is_active BIT(1) NOT NULL,
	is_deleted BIT(1) NOT NULL,
	last_modified_by BIGINT NOT NULL,
	last_modified_date TIMESTAMP WITHOUT TIME ZONE NOT NULL,
	CONSTRAINT form_mov_per_unique UNIQUE
);

CREATE TABLE process_from.process_form_ofice(
	id BIGINT DEFAULT nextval('process_form.process_form_ofice_seq'::regclass) NOT NULL,
	form_ofice_id INTEGER NOT NULL,
	date_made DATE NOT NULL,
	ubication_id INTEGER NOT NULL,
	status_process_form_id INTEGER NOT NULL,
	is_active BIT(1) NOT NULL,
	is_deleted BIT(1) NOT NULL,
	last_modified_by BIGINT NOT NULL,
	last_modified_date TIMESTAMP WITHOUT TIME ZONE NOT NULL
	CONSTRAINT form_office_unique UNIQUE
);

CREATE TABLE process_from.status_process_form(
	id BIGINT DEFAULT nextval('process_form.status_process_form_seq'::regclass) NOT NULL,
	description  VARCHAR(300) NOT NULL,
	is_active BIT(1) NOT NULL,
	is_deleted BIT(1) NOT NULL,
	last_modified_by BIGINT NOT NULL,
	last_modified_date TIMESTAMP WITHOUT TIME ZONE NOT NULL
);

-- tb history
CREATE TABLE process_from.process_form_movement_personal_history(
	id BIGINT DEFAULT nextval('process_form.process_form_movement_personal_history_seq'::regclass) NOT NULL,
	process_form_movement_personal_id BIGINT;
	form_movement_personal_id INTEGER,
	date_made DATE,
	ubication_id INTEGER,
	status_process_form_id INTEGER,
	is_active BIT(1),
	is_deleted BIT(1),
	last_modified_by BIGINT,
	last_modified_date TIMESTAMP WITHOUT TIME ZONE,
	change_type character varying(50),
	change_description character varying(500)
);

CREATE TABLE process_from.process_form_ofice_history(
	id BIGINT DEFAULT nextval('process_form.process_form_ofice_history_seq'::regclass) NOT NULL,
	process_form_ofice_id BIGINT,
	form_ofice_id INTEGER,
	date_made DATE,
	ubication_id INTEGER,
	status_process_form_id INTEGER,
	is_active BIT(1),
	is_deleted BIT(1),
	last_modified_by BIGINT,
	last_modified_date TIMESTAMP WITHOUT TIME ZONE,
	change_type character varying(50),
	change_description character varying(500)
);

CREATE TABLE process_from.status_process_form_history(
	id BIGINT DEFAULT nextval('process_form.status_process_form_history_seq'::regclass) NOT NULL,
	status_process_form_id BIGINT,
	description  VARCHAR(300),
	is_active BIT(1),
	is_deleted BIT(1),
	last_modified_by BIGINT,
	last_modified_date TIMESTAMP WITHOUT TIME ZONE
	change_type character varying(50),
	change_description character varying(500)
);

-- ADD PK in the tables
	ALTER TABLE only process_from.process_form_movement_personal
		ADD CONSTRAINT process_form_movement_personal_id PRIMARY KEY (id);

	ALTER TABLE only process_from.process_form_ofice
		ADD CONSTRAINT process_form_ofice_id PRIMARY KEY (id);

	ALTER TABLE only process_from.status_process_form
		ADD CONSTRAINT status_process_form_id PRIMARY KEY (id);


-- ADD PK in the tables history
	ALTER TABLE only process_from.process_form_movement_personal_history
		ADD CONSTRAINT process_form_movement_personal_history_id PRIMARY KEY (id);

	ALTER TABLE only process_from.process_form_ofice_history
		ADD CONSTRAINT process_form_ofice_history_id PRIMARY KEY (id);

	ALTER TABLE only process_from.status_process_form_history
		ADD CONSTRAINT status_process_form_history_id PRIMARY KEY (id);

-- ADD fk in the tables
	ALTER TABLE ONLY process_from.process_form_movement_personal
		ADD CONSTRAINT process_form_mov_pers_status_process_form_id FOREIGN KEY (status_process_form_id)
		REFERENCES process_from.status_process_form (id);

	ALTER TABLE ONLY process_from.process_form_ofice
		ADD CONSTRAINT process_form_ofice_status_process_form_id FOREIGN KEY (status_process_form_id)
		REFERENCES process_from.status_process_form (id);

-- ADD fk in the tables history
	ALTER TABLE ONLY process_from.process_form_movement_personal_history
		ADD CONSTRAINT process_form_mov_pers_hist_process_form_mov_id FOREIGN KEY (form_movement_personal_id)
		REFERENCES process_from.process_form_movement_personal (id);

	ALTER TABLE ONLY process_from.process_form_ofice_history
		ADD CONSTRAINT process_form_ofice_hist_process_form_ofice_id FOREIGN KEY (form_ofice_id)
		REFERENCES process_from.process_form_ofice (id);

	ALTER TABLE ONLY process_from.status_process_form_history
		ADD CONSTRAINT status_process_form_hist_status_process_form_id FOREIGN KEY (status_process_form_id)
		REFERENCES process_from.status_process_form (id);
