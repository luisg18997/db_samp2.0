CREATE TABLE process_from.process_form_movement_personal(
	id INTEGER DEFAULT nextval(''::) NOT NULL,
	form_movement_personal_id INTEGER NOT NULL,
	fecha_revision DATE NOT NULL,
	ubication_id INTEGER NOT NULL,
	form_fase INTEGER NOT NULL,
	is_active BIT(1) NOT NULL,
	is_deleted BIT(1) NOT NULL,
	last_modified_by BIGINT NOT NULL,
	last_modified_date TIMESTAMP WITHOUT TIME ZONE NOT NULL
);