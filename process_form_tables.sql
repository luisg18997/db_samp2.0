CREATE TABLE process_form.process_movement_personal_form(
	id BIGINT DEFAULT nextval('process_form.process_movement_personal_form_seq'::regclass) NOT NULL,
	movement_personal_form_id INTEGER NOT NULL,
	date_made DATE NOT NULL,
	ubication_id INTEGER NOT NULL,
	observation TEXT,
	status_process_form_id INTEGER NOT NULL,
	is_active BIT(1) NOT NULL,
	is_deleted BIT(1) NOT NULL,
	last_modified_by BIGINT NOT NULL,
	last_modified_date TIMESTAMP WITHOUT TIME ZONE NOT NULL,
	CONSTRAINT form_mov_per_unique UNIQUE (movement_personal_form_id)
);

CREATE TABLE process_form.process_official_form(
	id BIGINT DEFAULT nextval('process_form.process_official_form_seq'::regclass) NOT NULL,
	official_form_id INTEGER NOT NULL,
	date_made DATE NOT NULL,
	ubication_id INTEGER NOT NULL,
	observation TEXT,
	status_process_form_id INTEGER NOT NULL,
	is_active BIT(1) NOT NULL,
	is_deleted BIT(1) NOT NULL,
	last_modified_by BIGINT NOT NULL,
	last_modified_date TIMESTAMP WITHOUT TIME ZONE NOT NULL,
	CONSTRAINT form_office_unique UNIQUE (official_form_id)
);

CREATE TABLE process_form.status_process_form(
	id BIGINT DEFAULT nextval('process_form.status_process_form_seq'::regclass) NOT NULL,
	description  VARCHAR(300) NOT NULL,
	is_active BIT(1) NOT NULL,
	is_deleted BIT(1) NOT NULL,
	last_modified_by BIGINT NOT NULL,
	last_modified_date TIMESTAMP WITHOUT TIME ZONE NOT NULL
);

-- tb history
CREATE TABLE process_form.process_movement_personal_form_history(
	id BIGINT DEFAULT nextval('process_form.process_movement_personal_form_history_seq'::regclass) NOT NULL,
	process_movement_personal_form_id BIGINT,
	movement_personal_form_id INTEGER,
	date_made DATE,
	ubication_id INTEGER,
	observation TEXT,
	status_process_form_id INTEGER,
	is_active BIT(1),
	is_deleted BIT(1),
	last_modified_by BIGINT,
	last_modified_date TIMESTAMP WITHOUT TIME ZONE,
	change_type character varying(50),
	change_description character varying(500)
);

CREATE TABLE process_form.process_official_form_history(
	id BIGINT DEFAULT nextval('process_form.process_official_form_history_seq'::regclass) NOT NULL,
	process_official_form_id BIGINT,
	official_form_id INTEGER,
	date_made DATE,
	ubication_id INTEGER,
	observation TEXT,
	status_process_form_id INTEGER,
	is_active BIT(1),
	is_deleted BIT(1),
	last_modified_by BIGINT,
	last_modified_date TIMESTAMP WITHOUT TIME ZONE,
	change_type character varying(50),
	change_description character varying(500)
);

CREATE TABLE process_form.status_process_form_history(
	id BIGINT DEFAULT nextval('process_form.status_process_form_history_seq'::regclass) NOT NULL,
	status_process_form_id BIGINT,
	description  VARCHAR(300),
	is_active BIT(1),
	is_deleted BIT(1),
	last_modified_by BIGINT,
	last_modified_date TIMESTAMP WITHOUT TIME ZONE,
	change_type character varying(50),
	change_description character varying(500)
);

-- ADD PK in the tables
	ALTER TABLE only process_form.process_movement_personal_form
		ADD CONSTRAINT process_movement_personal_form_id PRIMARY KEY (id);

	ALTER TABLE only process_form.process_official_form
		ADD CONSTRAINT process_official_form_id PRIMARY KEY (id);

	ALTER TABLE only process_form.status_process_form
		ADD CONSTRAINT status_process_form_id PRIMARY KEY (id);


-- ADD PK in the tables history
	ALTER TABLE only process_form.process_movement_personal_form_history
		ADD CONSTRAINT process_movement_personal_form_history_id PRIMARY KEY (id);

	ALTER TABLE only process_form.process_official_form_history
		ADD CONSTRAINT process_official_form_history_id PRIMARY KEY (id);

	ALTER TABLE only process_form.status_process_form_history
		ADD CONSTRAINT status_process_form_history_id PRIMARY KEY (id);

-- ADD fk in the tables
	ALTER TABLE ONLY process_form.process_movement_personal_form
		ADD CONSTRAINT process_form_mov_pers_status_process_form_id FOREIGN KEY (status_process_form_id)
		REFERENCES process_form.status_process_form (id);

	ALTER TABLE ONLY process_form.process_official_form
		ADD CONSTRAINT process_official_form_status_process_form_id FOREIGN KEY (status_process_form_id)
		REFERENCES process_form.status_process_form (id);

-- ADD fk in the tables history
	ALTER TABLE ONLY process_form.process_movement_personal_form_history
		ADD CONSTRAINT process_form_mov_pers_hist_process_form_mov_id FOREIGN KEY (process_movement_personal_form_id)
		REFERENCES process_form.process_movement_personal_form (id);

	ALTER TABLE ONLY process_form.process_official_form_history
		ADD CONSTRAINT process_official_form_hist_process_official_form_id FOREIGN KEY (process_official_form_id)
		REFERENCES process_form.process_official_form (id);

	ALTER TABLE ONLY process_form.status_process_form_history
		ADD CONSTRAINT status_process_form_hist_status_process_form_id FOREIGN KEY (status_process_form_id)
		REFERENCES process_form.status_process_form (id);
