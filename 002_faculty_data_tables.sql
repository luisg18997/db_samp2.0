-- tables of schema faculty data

-- faculty of the university
CREATE TABLE faculty_data.faculty(
  id INTEGER DEFAULT nextval('faculty_data.faculty_id_seq'::regclass) NOT NULL,
  code VARCHAR(100) NOT NULL,
  name VARCHAR(100) NOT NULL,
  principal_name VARCHAR(100),
  initials VARCHAR(15),
  is_active BIT(1) NOT NULL,
  is_deleted BIT(1) NOT NULL,
  last_modified_by BIGINT NOT NULL,
  last_modified_date TIMESTAMP WITHOUT TIME ZONE NOT NULL,
  CONSTRAINT faculty_code_unique UNIQUE (code)
);

-- schools of the faculty
CREATE TABLE faculty_data.schools(
  id INTEGER DEFAULT nextval('faculty_data.school_id_seq'::regclass) NOT NULL,
  code VARCHAR(100) NOT NULL,
  name VARCHAR(100) NOT NULL,
  principal_name VARCHAR(100),
  initials VARCHAR(15),
  faculty_id INTEGER NOT NULL,
  is_active BIT(1) NOT NULL,
  is_deleted BIT(1) NOT NULL,
  last_modified_by BIGINT NOT NULL,
  last_modified_date TIMESTAMP WITHOUT TIME ZONE NOT NULL,
  CONSTRAINT schools_code_unique UNIQUE (code)
);

-- institutes of the faculty

CREATE TABLE faculty_data.institutes(
  id INTEGER DEFAULT nextval('faculty_data.institute_id_seq'::regclass) NOT NULL,
  code VARCHAR(100) NOT NULL,
  name VARCHAR(100) NOT NULL,
  principal_name VARCHAR(100),
  initials VARCHAR(15),
  faculty_id INTEGER NOT NULL,
  is_active BIT(1) NOT NULL,
  is_deleted BIT(1) NOT NULL,
  last_modified_by BIGINT NOT NULL,
  last_modified_date TIMESTAMP WITHOUT TIME ZONE NOT NULL,
  CONSTRAINT institutes_code_unique UNIQUE (code)
);

-- departaments of schools or institutes of the faculty

CREATE TABLE faculty_data.departaments(
  id INTEGER DEFAULT nextval('faculty_data.departament_id_seq'::regclass) NOT NULL,
  code VARCHAR(100) NOT NULL,
  name VARCHAR(100) NOT NULL,
  school_id INTEGER,
  institute_id INTEGER,
  is_active BIT(1) NOT NULL,
  is_deleted BIT(1) NOT NULL,
  last_modified_by BIGINT NOT NULL,
  last_modified_date TIMESTAMP WITHOUT TIME ZONE NOT NULL,
  CONSTRAINT departaments_code_unique UNIQUE (code)
);

-- chairs of departaments of the schools or institutes of the faculty

CREATE TABLE faculty_data.chairs(
  id INTEGER DEFAULT nextval('faculty_data.chairs_id_seq'::regclass) NOT NULL,
  code VARCHAR(100) NOT NULL,
  name VARCHAR(100) NOT NULL,
  departament_id INTEGER NOT NULL,
  is_active BIT(1) NOT NULL,
  is_deleted BIT(1) NOT NULL,
  last_modified_by BIGINT NOT NULL,
  last_modified_date TIMESTAMP WITHOUT TIME ZONE NOT NULL,
  CONSTRAINT chairs_code_unique UNIQUE (code)
);

-- cordinations of the faculty

CREATE TABLE faculty_data.coordinations(
  id INTEGER DEFAULT nextval('faculty_data.coordination_id_seq'::regclass) NOT NULL,
  code VARCHAR(100) NOT NULL,
  name VARCHAR(100) NOT NULL,
  principal_name VARCHAR(100),
  initials VARCHAR(15),
  faculty_id INTEGER NOT NULL,
  is_active BIT(1) NOT NULL,
  is_deleted BIT(1) NOT NULL,
  last_modified_by BIGINT NOT NULL,
  last_modified_date TIMESTAMP WITHOUT TIME ZONE NOT NULL,
  CONSTRAINT coordinations_code_unique UNIQUE (code)
);

-- tables of logs

CREATE TABLE faculty_data.faculty_history(
  id BIGINT DEFAULT nextval('faculty_data.faculty_history_id_seq'::regclass) NOT NULL,
  faculty_id INTEGER,
  code VARCHAR(100) ,
  name VARCHAR(100) ,
  principal_name VARCHAR(100),
  initials VARCHAR(15),
  is_active BIT(1) ,
  is_deleted BIT(1) ,
  last_modified_by BIGINT ,
  last_modified_date TIMESTAMP WITHOUT TIME ZONE,
  change_type character varying(50),
  change_description character varying(500)
);

-- schools of the faculty
CREATE TABLE faculty_data.schools_history(
  id BIGINT DEFAULT nextval('faculty_data.school_history_id_seq'::regclass) NOT NULL,
  school_id INTEGER,
  code VARCHAR(100) ,
  name VARCHAR(100) ,
  principal_name VARCHAR(100),
  initials VARCHAR(15),
  faculty_id INTEGER ,
  is_active BIT(1) ,
  is_deleted BIT(1) ,
  last_modified_by BIGINT ,
  last_modified_date TIMESTAMP WITHOUT TIME ZONE,
  change_type character varying(50),
  change_description character varying(500)
);

-- institutes of the faculty

CREATE TABLE faculty_data.institutes_history(
  id BIGINT DEFAULT nextval('faculty_data.institute_history_id_seq'::regclass) NOT NULL,
  institute_id INTEGER,
  code VARCHAR(100) ,
  name VARCHAR(100) ,
  principal_name VARCHAR(100),
  initials VARCHAR(15),
  faculty_id INTEGER ,
  is_active BIT(1) ,
  is_deleted BIT(1) ,
  last_modified_by BIGINT ,
  last_modified_date TIMESTAMP WITHOUT TIME ZONE,
  change_type character varying(50),
  change_description character varying(500)
);

-- departaments of schools or institutes of the faculty

CREATE TABLE faculty_data.departaments_history(
  id BIGINT DEFAULT nextval('faculty_data.departament_history_id_seq'::regclass) NOT NULL,
  departament_id INTEGER,
  code VARCHAR(100) ,
  name VARCHAR(100) ,
  school_id INTEGER,
  institute_id INTEGER,
  is_active BIT(1) ,
  is_deleted BIT(1) ,
  last_modified_by BIGINT ,
  last_modified_date TIMESTAMP WITHOUT TIME ZONE,
  change_type character varying(50),
  change_description character varying(500)
);

-- chairs of departaments of the schools or institutes of the faculty

CREATE TABLE faculty_data.chairs_history(
  id BIGINT DEFAULT nextval('faculty_data.chairs_history_id_seq'::regclass) NOT NULL,
  chair_id INTEGER,
  code VARCHAR(100) ,
  name VARCHAR(100) ,
  departament_id INTEGER ,
  is_active BIT(1) ,
  is_deleted BIT(1) ,
  last_modified_by BIGINT ,
  last_modified_date TIMESTAMP WITHOUT TIME ZONE,
  change_type character varying(50),
  change_description character varying(500)
);

-- cordinations of the faculty

CREATE TABLE faculty_data.coordinations_history(
  id BIGINT DEFAULT nextval('faculty_data.coordination_history_id_seq'::regclass) NOT NULL,
  coordination_id INTEGER,
  code VARCHAR(100) ,
  name VARCHAR(100) ,
  principal_name VARCHAR(100),
  initials VARCHAR(15),
  faculty_id INTEGER ,
  is_active BIT(1) ,
  is_deleted BIT(1) ,
  last_modified_by BIGINT ,
  last_modified_date TIMESTAMP WITHOUT TIME ZONE,
  change_type character varying(50),
  change_description character varying(500)
);

-- ADD pk in the tables

ALTER TABLE ONLY faculty_data.faculty
  ADD CONSTRAINT faculty_id_pk PRIMARY KEY (id);

ALTER TABLE ONLY faculty_data.schools
  ADD CONSTRAINT school_id_pk PRIMARY KEY (id);

ALTER TABLE ONLY faculty_data.institutes
  ADD CONSTRAINT institute_id_pk PRIMARY KEY (id);

ALTER TABLE ONLY faculty_data.departaments
  ADD CONSTRAINT departament_id_pk PRIMARY KEY (id);

ALTER TABLE ONLY faculty_data.chairs
  ADD CONSTRAINT chair_id_pk PRIMARY KEY (id);

ALTER TABLE ONLY faculty_data.coordinations
  ADD CONSTRAINT coordination_id_pk PRIMARY KEY (id);


-- ADD pk in the tables history

ALTER TABLE ONLY faculty_data.faculty_history
  ADD CONSTRAINT faculty_history_id_pk PRIMARY KEY (id);

ALTER TABLE ONLY faculty_data.schools_history
  ADD CONSTRAINT school_history_id_pk PRIMARY KEY (id);

ALTER TABLE ONLY faculty_data.institutes_history
  ADD CONSTRAINT institute_history_id_pk PRIMARY KEY (id);

ALTER TABLE ONLY faculty_data.departaments_history
  ADD CONSTRAINT departament_history_id_pk PRIMARY KEY (id);

ALTER TABLE ONLY faculty_data.chairs_history
  ADD CONSTRAINT chair_history_id_pk PRIMARY KEY (id);

ALTER TABLE ONLY faculty_data.coordinations_history
  ADD CONSTRAINT coordination_history_id_pk PRIMARY KEY (id);

-- ADD fk in the tables

ALTER TABLE ONLY faculty_data.schools
  ADD CONSTRAINT school_faculty_id_fk FOREIGN KEY (faculty_id)
  REFERENCES faculty_data.faculty(id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY faculty_data.institutes
  ADD CONSTRAINT institute_faculty_id_fk FOREIGN KEY (faculty_id)
  REFERENCES faculty_data.faculty(id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY faculty_data.coordinations
  ADD CONSTRAINT coordinations_faculty_id_fk FOREIGN KEY (faculty_id)
  REFERENCES faculty_data.faculty(id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY faculty_data.departaments
  ADD CONSTRAINT departaments_school_id_fk FOREIGN KEY (school_id)
  REFERENCES faculty_data.schools(id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY faculty_data.departaments
  ADD CONSTRAINT departaments_institute_id_fk FOREIGN KEY (institute_id)
  REFERENCES faculty_data.institutes(id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY faculty_data.chairs
  ADD CONSTRAINT chairs_departament_id_fk FOREIGN KEY (departament_id)
  REFERENCES faculty_data.departaments(id) ON UPDATE CASCADE ON DELETE CASCADE;

  -- ADD FK of table history

ALTER TABLE ONLY faculty_data.faculty_history
  ADD CONSTRAINT faculty_history_faculty_id_fk FOREIGN KEY (faculty_id)
  REFERENCES faculty_data.faculty(id);

ALTER TABLE ONLY faculty_data.schools_history
  ADD CONSTRAINT school_history_school_id_fk FOREIGN KEY (school_id)
  REFERENCES faculty_data.schools(id);

ALTER TABLE ONLY faculty_data.institutes_history
  ADD CONSTRAINT institute_history_institute_id_fk FOREIGN KEY(institute_id)
REFERENCES faculty_data.institutes(id);

ALTER TABLE ONLY faculty_data.departaments_history
  ADD CONSTRAINT departament_history_departament_id_fk FOREIGN KEY(departament_id)
REFERENCES faculty_data.departaments(id);

ALTER TABLE ONLY faculty_data.chairs_history
  ADD CONSTRAINT chair_history_chair_id_fk FOREIGN KEY (chair_id)
  REFERENCES faculty_data.chairs(id);

ALTER TABLE ONLY faculty_data.coordinations_history
  ADD CONSTRAINT coordination_history_coordination_id_fk FOREIGN KEY(coordination_id)
  REFERENCES faculty_data.coordinations(id);
