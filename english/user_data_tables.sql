-- tables of user data

-- user que usyng the system

CREATE TABLE user_data.users(
	id INTEGER DEFAULT nextval('user_data.user_id_seq'::regclass) NOT NULL,
	name VARCHAR(100) NOT NULL,
	surname VARCHAR(100) NOT NULL,
	email VARCHAR(200) NOT NULL,
	password TEXT NOT NULL,
	ubication_id INTEGER NOT NULL,
	school_id INTEGER,
	institute_id INTEGER,
	coordination_id INTEGER,
	is_active BIT(1) NOT NULL,
	is_deleted BIT(1) NOT NULL,
	last_modified_by BIGINT NOT NULL,
	user_create_date TIMESTAMP WITHOUT TIME ZONE NOT NULL,
	last_modified_date TIMESTAMP WITHOUT TIME ZONE NOT NULL,
	CONSTRAINT user_email_unique UNIQUE (email)
);

CREATE TABLE user_data.roles(
	id INTEGER DEFAULT nextval('user_data.role_id_seq'::regclass) NOT NULL,
	description VARCHAR(100) NOT NULL,
	is_active BIT(1) NOT NULL,
	is_deleted BIT(1) NOT NULL,
	last_modified_by BIGINT NOT NULL,
	last_modified_date TIMESTAMP WITHOUT TIME ZONE NOT NULL
);

CREATE TABLE user_data.user_roles(
	id INTEGER DEFAULT nextval('user_data.user_roles_id_seq'::regclass) NOT NULL,
	user_id INTEGER NOT NULL,
	role_id INTEGER,
	is_active BIT(1) NOT NULL,
	is_deleted BIT(1) NOT NULL,
	last_modified_by BIGINT NOT NULL,
	last_modified_date TIMESTAMP WITHOUT TIME ZONE NOT NULL
);

CREATE TABLE user_data.security_questions(
	id INTEGER DEFAULT nextval('user_data.security_questions_id_seq'::regclass) NOT NULL,
	description text NOT NULL,
	is_active BIT(1) NOT NULL,
	is_deleted BIT(1) NOT NULL,
	last_modified_by BIGINT NOT NULL,
	last_modified_date TIMESTAMP WITHOUT TIME ZONE NOT NULL
);

CREATE TABLE user_data.security_answers(
	id INTEGER DEFAULT nextval('user_data.security_answers_id_seq'::regclass) NOT NULL,
	user_id INTEGER NOT NULL,
	question_id INTEGER,
	answer text,
	is_active BIT(1) NOT NULL,
	is_deleted BIT(1) NOT NULL,
	last_modified_by BIGINT NOT NULL,
	last_modified_date TIMESTAMP WITHOUT TIME ZONE NOT NULL
);

CREATE TABLE user_data.ubications(
	id INTEGER DEFAULT nextval('user_data.ubications_id_seq'::regclass) NOT NULL,
	name VARCHAR(100) NOT NULL,
	is_active BIT(1) NOT NULL,
	is_deleted BIT(1) NOT NULL,
	last_modified_by BIGINT NOT NULL,
	last_modified_date TIMESTAMP WITHOUT TIME ZONE NOT NULL
);

--tables of history

CREATE TABLE user_data.users_history(
	id BIGINT DEFAULT nextval('user_data.user_history_id_seq'::regclass) NOT NULL,
	user_id INTEGER,
	name VARCHAR(100),
	surname VARCHAR(100),
	email VARCHAR(200),
	password TEXT,
	ubication_id INTEGER,
	school_id INTEGER,
	institute_id INTEGER,
	coordination_id INTEGER,
	is_active BIT(1),
	is_deleted BIT(1),
	last_modified_by BIGINT,
	user_create_date TIMESTAMP WITHOUT TIME ZONE,
	last_modified_date TIMESTAMP WITHOUT TIME ZONE,
	change_type character varying(50),
  	change_description character varying(500)
);


CREATE TABLE user_data.roles_history(
	id BIGINT DEFAULT nextval('user_data.role_history_id_seq'::regclass) NOT NULL,
	role_id INTEGER,
	description VARCHAR(100),
	is_active BIT(1),
	is_deleted BIT(1),
	last_modified_by BIGINT,
	last_modified_date TIMESTAMP WITHOUT TIME ZONE,
	change_type character varying(50),
  	change_description character varying(500)
);

CREATE TABLE user_data.user_roles_history(
	id BIGINT DEFAULT nextval('user_data.user_roles_history_id_seq'::regclass) NOT NULL,
	user_role_id INTEGER,
	user_id INTEGER,
	role_id INTEGER,
	is_active BIT(1),
	is_deleted BIT(1),
	last_modified_by BIGINT,
	last_modified_date TIMESTAMP WITHOUT TIME ZONE,
	change_type character varying(50),
  	change_description character varying(500)
);

CREATE TABLE user_data.security_questions_history(
	id BIGINT DEFAULT nextval('user_data.security_questions_history_id_seq'::regclass) NOT NULL,
	security_question_id INTEGER,
	description text,
	is_active BIT(1),
	is_deleted BIT(1),
	last_modified_by BIGINT,
	last_modified_date TIMESTAMP WITHOUT TIME ZONE,
	change_type character varying(50),
  	change_description character varying(500)
);

CREATE TABLE user_data.security_answers_history(
	id BIGINT DEFAULT nextval('user_data.security_answers_history_id_seq'::regclass) NOT NULL,
	security_answer_id INTEGER,
	user_id INTEGER,
	question_id INTEGER,
	answer text,
	is_active BIT(1),
	is_deleted BIT(1),
	last_modified_by BIGINT,
	last_modified_date TIMESTAMP WITHOUT TIME ZONE,
	change_type character varying(50),
  	change_description character varying(500)
);

CREATE TABLE user_data.ubications_history(
	id BIGINT DEFAULT nextval('user_data.ubications_history_id_seq'::regclass) NOT NULL,
	ubication_id INTEGER,
	name VARCHAR(100),
	is_active BIT(1),
	is_deleted BIT(1),
	last_modified_by BIGINT,
	last_modified_date TIMESTAMP WITHOUT TIME ZONE,
	change_type character varying(50),
  	change_description character varying(500)
);

-- ADD PK in the tables

ALTER TABLE ONLY user_data.users
	ADD CONSTRAINT users_id_pk PRIMARY KEY (id);

ALTER TABLE ONLY user_data.roles
	ADD CONSTRAINT role_id_pk PRIMARY KEY (id);

ALTER TABLE ONLY user_data.user_roles
	ADD CONSTRAINT user_roles_id_pk PRIMARY KEY (id);

ALTER TABLE ONLY user_data.security_questions
	ADD CONSTRAINT security_question_id_pk PRIMARY KEY (id);

ALTER TABLE ONLY user_data.security_answers
	ADD CONSTRAINT security_answer_id_pk PRIMARY KEY (id);

ALTER TABLE ONLY user_data.ubications
	ADD CONSTRAINT ubication_id_pk PRIMARY KEY (id);

-- ADD PK in the tables history

ALTER TABLE ONLY user_data.users_history
	ADD CONSTRAINT users_history_id_pk PRIMARY KEY (id);

ALTER TABLE ONLY user_data.roles_history
	ADD CONSTRAINT role_history_id_pk PRIMARY KEY (id);

ALTER TABLE ONLY user_data.user_roles_history
	ADD CONSTRAINT user_roles_history_id_pk PRIMARY KEY (id);

ALTER TABLE ONLY user_data.security_questions_history
	ADD CONSTRAINT security_question_history_id_pk PRIMARY KEY (id);

ALTER TABLE ONLY user_data.security_answers_history
	ADD CONSTRAINT security_answer_history_id_pk PRIMARY KEY (id);

ALTER TABLE ONLY user_data.ubications_history
	ADD CONSTRAINT ubication_history_id_pk PRIMARY KEY (id);

-- ADD fk in the tables

ALTER TABLE ONLY user_data.users
  ADD CONSTRAINT user_ubication_id_fk FOREIGN KEY (ubication_id)
  REFERENCES user_data.ubications(id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY user_data.user_roles
  ADD CONSTRAINT user_role_user_id_fk FOREIGN KEY (user_id)
  REFERENCES user_data.users(id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY user_data.user_roles
  ADD CONSTRAINT user_role_role_id_fk FOREIGN KEY (role_id)
  REFERENCES user_data.roles(id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY user_data.security_answers
  ADD CONSTRAINT security_answer_user_id_fk FOREIGN KEY (user_id)
  REFERENCES user_data.users(id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY user_data.security_answers
  ADD CONSTRAINT security_answer_question_id_fk FOREIGN KEY (question_id)
  REFERENCES user_data.security_questions(id) ON UPDATE CASCADE ON DELETE CASCADE;

--  ADD fk in tables history

	ALTER TABLE ONLY user_data.users_history
		ADD CONSTRAINT users_history_user_id_fk FOREIGN KEY (user_id)
		REFERENCES user_data.users(id);

	ALTER TABLE ONLY user_data.roles_history
		ADD CONSTRAINT roles_history_role_id_fk FOREIGN KEY (role_id)
		REFERENCES user_data.roles(id);

	ALTER TABLE ONLY user_data.user_roles_history
		ADD CONSTRAINT user_roles_history_user_role_id_fk FOREIGN KEY (user_role_id)
		REFERENCES user_data.user_roles(id);

	ALTER TABLE ONLY user_data.security_questions_history
		ADD CONSTRAINT security_questions_history_security_question_id_fk FOREIGN KEY(security_question_id)
		REFERENCES user_data.security_questions(id);

	ALTER TABLE ONLY user_data.security_answers_history
		ADD CONSTRAINT security_answers_history_security_answer_id_fk FOREIGN KEY(security_answer_id)
		REFERENCES user_data.security_answers(id);

	ALTER TABLE ONLY user_data.ubications_history
	 	ADD CONSTRAINT ubications_history_ubication_id_fk FOREIGN KEY(ubication_id)
		REFERENCES user_data.ubications(id);
