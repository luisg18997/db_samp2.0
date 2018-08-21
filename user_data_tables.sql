-- tables of user data

-- user que usyng the system

CREATE TABLE user_data.users(
	id INTEGER DEFAULT nextval('user_data.user_id_seq'::regclass) NOT NULL,
	name VARCHAR(25) NOT NULL,
	surname VARCHAR(25) NOT NULL,
	email VARCHAR(100) NOT NULL,
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
	description VARCHAR(50) NOT NULL,
	is_active BIT(1) NOT NULL,
	is_deleted BIT(1) NOT NULL,
	last_modified_by BIGINT NOT NULL,
	last_modified_date TIMESTAMP WITHOUT TIME ZONE NOT NULL
);

CREATE TABLE user_data.user_roles(
	id INTEGER DEFAULT nextval('user_data.user_roles_id_seq'::regclass) NOT NULL,
	user_id INTEGER NOT NULL,
	role_id INTEGER NOT NULL,
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
	question_id INTEGER NOT NULL,
	answer text NOT NULL,
	is_active BIT(1) NOT NULL,
	is_deleted BIT(1) NOT NULL,
	last_modified_by BIGINT NOT NULL,
	last_modified_date TIMESTAMP WITHOUT TIME ZONE NOT NULL
);

CREATE TABLE user_data.action_types(
	id INTEGER DEFAULT nextval('user_data.action_types_id_seq'::regclass) NOT NULL,
	description TEXT NOT NULL,
	is_active BIT(1) NOT NULL,
	is_deleted BIT(1) NOT NULL,
	last_modified_by BIGINT NOT NULL,
	last_modified_date TIMESTAMP WITHOUT TIME ZONE NOT NULL
);

CREATE TABLE user_data.user_action_types(
	id INTEGER DEFAULT nextval('user_data.user_action_types_id_seq'::regclass) NOT NULL,
	user_id INTEGER NOT NULL,
	action_id INTEGER NOT NULL,
	description text NOT NULL,
	action_date TIMESTAMP WITHOUT TIME ZONE NOT NULL
);

CREATE TABLE user_data.user_ubications(
	id INTEGER DEFAULT nextval('user_data.user_ubications_id_seq'::regclass) NOT NULL,
	name VARCHAR(75) NOT NULL,
	is_active BIT(1) NOT NULL,
	is_deleted BIT(1) NOT NULL,
	last_modified_by BIGINT NOT NULL,
	last_modified_date TIMESTAMP WITHOUT TIME ZONE NOT NULL
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

ALTER TABLE ONLY user_data.action_types
	ADD CONSTRAINT action_type_id_pk PRIMARY KEY (id);

ALTER TABLE ONLY user_data.user_action_types
	ADD CONSTRAINT user_action_type_id_pk PRIMARY KEY (id);

ALTER TABLE ONLY user_data.user_ubications
	ADD CONSTRAINT user_ubication_id_pk PRIMARY KEY (id);

-- ADD fk in the tables

ALTER TABLE ONLY user_data.users
  ADD CONSTRAINT user_ubication_id_fk FOREIGN KEY (ubication_id) 
  REFERENCES user_data.user_ubications(id) ON UPDATE CASCADE ON DELETE CASCADE;

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

ALTER TABLE ONLY user_data.user_action_types
  ADD CONSTRAINT user_action_type_user_id_fk FOREIGN KEY (user_id) 
  REFERENCES user_data.users(id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY user_data.user_action_types
  ADD CONSTRAINT user_action_type_action_type_id_fk FOREIGN KEY (action_id) 
  REFERENCES user_data.action_types(id) ON UPDATE CASCADE ON DELETE CASCADE;