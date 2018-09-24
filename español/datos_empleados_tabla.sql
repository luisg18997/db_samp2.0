-- tables of schema datos_empleados

CREATE TABLE datos_empleados.empleados(
	id INTEGER DEFAULT nextval('datos_empleados.id_empleado_seq'::regclass) NOT NULL,
	nacionality_id INTEGER NOT NULL,
	id_documentacion INTEGER NOT NULL,
	identification VARCHAR(20)  NOT NULL,
	primer_nombre VARCHAR(100) NOT NULL,
	segundo_nombre  VARCHAR(100),
	apellido VARCHAR(100) NOT NULL,
	segundo_apellido VARCHAR(100),
	fecha_nac date NOT NULL,
	id_genero INTEGER NOT NULL,
	correo VARCHAR(200) NOT NULL,
	id_estado INTEGER NOT NULL,
	id_municipio INTEGER NOT NULL,
	id_parroquia INTEGER NOT NULL,
	ubicacion text NOT NULL,
	direccion text NOT NULL,
	tipo_vivienda text NOT NULL,
	identificador_vivienda text NOT NULL,
	apartamento text NOT NULL,
	id_escuela INTEGER,
	id_instituto INTEGER,
	id_cordinacion INTEGER,
	id_departamente INTEGER,
	id_catedra INTEGER,
	primer_numero_movil VARCHAR(15) NOT NULL,
	segundo_numero_movil VARCHAR(15),
	numero_local VARCHAR(15) NOT NULL,
	id_ingreso INTEGER NOT NULL,
	id_tipo_ingreso INTEGER NOT NULL,
	fecha_admision date NOT NULL,
	fecha_ultima_actualizacion date,
	fecha_retiro date,
	activo BIT(1) NOT NULL,
  	borrado BIT(1) NOT NULL,
  	ultima_modificacion_por BIGINT NOT NULL,
  	fecha_ultima_modificacion TIMESTAMP WITHOUT TIME ZONE NOT NULL,
  	CONSTRAINT identificacion_empleado_unique UNIQUE (identificacion)
);

CREATE TABLE datos_empleados.documentacion(
	id INTEGER DEFAULT nextval('datos_empleados.id_documentacion_seq'::regclass) NOT NULL,
	descripcion VARCHAR(100) NOT NULL,
	activo BIT(1) NOT NULL,
  	borrado BIT(1) NOT NULL,
  	ultima_modificacion_por BIGINT NOT NULL,
  	fecha_ultima_modificacion TIMESTAMP WITHOUT TIME ZONE NOT NULL,
);

CREATE TABLE datos_empleados.nacionalidades(
	id INTEGER DEFAULT nextval('datos_empleados.id_nacionalidad_seq'::regclass) NOT NULL,
	descripcion VARCHAR(100) NOT NULL,
	activo BIT(1) NOT NULL,
  	borrado BIT(1) NOT NULL,
  	ultima_modificacion_por BIGINT NOT NULL,
  	fecha_ultima_modificacion TIMESTAMP WITHOUT TIME ZONE NOT NULL,

);

CREATE TABLE datos_empleados.generos(
	id INTEGER DEFAULT nextval('datos_empleados.id_genero_seq'::regclass) NOT NULL,
	descripcion VARCHAR(100) NOT NULL,
	activo BIT(1) NOT NULL,
  	borrado BIT(1) NOT NULL,
  	ultima_modificacion_por BIGINT NOT NULL,
  	fecha_ultima_modificacion TIMESTAMP WITHOUT TIME ZONE NOT NULL,

);

CREATE TABLE datos_empleados.estados(
	id INTEGER DEFAULT nextval('datos_empleados.id_estado_seq'::regclass) NOT NULL,
	nombre VARCHAR(100) NOT NULL,
	activo BIT(1) NOT NULL,
  	borrado BIT(1) NOT NULL,
  	ultima_modificacion_por BIGINT NOT NULL,
  	fecha_ultima_modificacion TIMESTAMP WITHOUT TIME ZONE NOT NULL,

);

CREATE TABLE datos_empleados.municipios(
	id INTEGER DEFAULT nextval('datos_empleados.id_municipio_seq'::regclass) NOT NULL,
	id_estado  INTEGER NOT NULL,
	nombre VARCHAR(100) NOT NULL,
	activo BIT(1) NOT NULL,
  	borrado BIT(1) NOT NULL,
  	ultima_modificacion_por BIGINT NOT NULL,
  	fecha_ultima_modificacion TIMESTAMP WITHOUT TIME ZONE NOT NULL,

);

CREATE TABLE datos_empleados.parroquias(
	id INTEGER DEFAULT nextval('datos_empleados.id_parroquia_seq'::regclass) NOT NULL,
	id_municipio INTEGER NOT NULL,
	name VARCHAR(100) NOT NULL,
	activo BIT(1) NOT NULL,
  	borrado BIT(1) NOT NULL,
  	ultima_modificacion_por BIGINT NOT NULL,
  	fecha_ultima_modificacion TIMESTAMP WITHOUT TIME ZONE NOT NULL,

);

CREATE TABLE datos_empleados.ingreso(
	id INTEGER DEFAULT nextval('datos_empleados.id_ingreso_seq'::regclass) NOT NULL,
	descripcion VARCHAR(100) NOT NULL,
	activo BIT(1) NOT NULL,
  	borrado BIT(1) NOT NULL,
  	ultima_modificacion_por BIGINT NOT NULL,
  	fecha_ultima_modificacion TIMESTAMP WITHOUT TIME ZONE NOT NULL,

);

CREATE TABLE datos_empleados.tipo_ingreso(
	id INTEGER DEFAULT nextval('datos_empleados.id_tipo_ingreso_seq'::regclass) NOT NULL,
	descripcion VARCHAR(100) NOT NULL,
	activo BIT(1) NOT NULL,
  	borrado BIT(1) NOT NULL,
  	ultima_modificacion_por BIGINT NOT NULL,
  	fecha_ultima_modificacion TIMESTAMP WITHOUT TIME ZONE NOT NULL,

);

CREATE TABLE datos_empleados.tipos_categoria(
	id INTEGER DEFAULT nextval('datos_empleados.id_tipos_categoria_seq'::regclass) NOT NULL,
	codigo INTEGER NOT NULL,
	descripcion VARCHAR(100) NOT NULL,
	activo BIT(1) NOT NULL,
  	borrado BIT(1) NOT NULL,
  	ultima_modificacion_por BIGINT NOT NULL,
  	fecha_ultima_modificacion TIMESTAMP WITHOUT TIME ZONE NOT NULL,

  	CONSTRAINT codigo_tipos_categoria UNIQUE (codigo)
);

CREATE TABLE datos_empleados.tipos_dedicacion(
	id INTEGER DEFAULT nextval('datos_empleados.id_tipos_dedicacion_seq'::regclass) NOT NULL,
	codigo INTEGER NOT NULL,
	descripcion VARCHAR(100) NOT NULL,
	activo BIT(1) NOT NULL,
  	borrado BIT(1) NOT NULL,
  	ultima_modificacion_por BIGINT NOT NULL,
  	fecha_ultima_modificacion TIMESTAMP WITHOUT TIME ZONE NOT NULL,

  	CONSTRAINT codigo_tipos_dedicacion UNIQUE (codigo)
);

CREATE TABLE datos_empleados.salarios(
	id INTEGER DEFAULT nextval('datos_empleados.id_salarios_seq'::regclass) NOT NULL,
	id_tipos_categoria INTEGER NOT NULL,
	id_tipos_dedicacion INTEGER NOT NULL,
	salario MONEY NOT NULL,
	activo BIT(1) NOT NULL,
  	borrado BIT(1) NOT NULL,
  	ultima_modificacion_por BIGINT NOT NULL,
  	fecha_ultima_modificacion TIMESTAMP WITHOUT TIME ZONE NOT NULL,

);

CREATE TABLE datos_empleados.empleado_salarios(
	id INTEGER DEFAULT nextval('datos_empleados.id_empleado_salario_seq'::regclass) NOT NULL,
	id_empleado INTEGER NOT NULL,
	id_salario INTEGER NOT NULL,
	activo BIT(1) NOT NULL,
  	borrado BIT(1) NOT NULL,
  	ultima_modificacion_por BIGINT NOT NULL,
  	fecha_ultima_modificacion TIMESTAMP WITHOUT TIME ZONE NOT NULL,

);


CREATE TABLE datos_empleados.codigo_idac(
	id INTEGER DEFAULT nextval('datos_empleados.id_codigo_idac_seq'::regclass) NOT NULL,
	codigo INTEGER Not NULL,
	id_unidad_ejecutora INTEGER NOT NULL,
	fecha_vacante  TIMESTAMP WITHOUT TIME ZONE,
	activo BIT(1) NOT NULL,
  	borrado BIT(1) NOT NULL,
  	ultima_modificacion_por BIGINT NOT NULL,
  	fecha_ultima_modificacion TIMESTAMP WITHOUT TIME ZONE NOT NULL,

	CONSTRAINT idac_code_unique UNIQUE (code)
);

CREATE TABLE datos_empleados.unidad_ejecutora(
	id INTEGER DEFAULT nextval('datos_empleados.id_unidad_ejecutora_seq'::regclass) NOT NULL,
	codigo INTEGER NOT NULL,
	descripcion VARCHAR(300) NOT NULL,
	activo BIT(1) NOT NULL,
  	borrado BIT(1) NOT NULL,
  	ultima_modificacion_por BIGINT NOT NULL,
  	fecha_ultima_modificacion TIMESTAMP WITHOUT TIME ZONE NOT NULL,

	CONSTRAINT codigo_unidad_ejecutora_unique UNIQUE (codigo)
);

CREATE TABLE datos_empleados.codigo_idac_empleado(
	id INTEGER DEFAULT nextval('datos_empleados.id_codigo_idac_empleado_seq'::regclass) NOT NULL,
	id_empleado INTEGER NOT NULL,
	id_codigo_idac INTEGER NOT NULL,
	activo BIT(1) NOT NULL,
  	borrado BIT(1) NOT NULL,
  	ultima_modificacion_por BIGINT NOT NULL,
  	fecha_ultima_modificacion TIMESTAMP WITHOUT TIME ZONE NOT NULL,

);

-- history of tables

CREATE TABLE datos_empleados.historial_empleados(
	id BIGINT,
  	id_nacionalidad INTEGER NOT NULL,
	id_documentacion INTEGER NOT NULL,
	identificacion VARCHAR(20)  NOT NULL,
	primer_nombre VARCHAR(100) NOT NULL,
	segundo_nombre  VARCHAR(100),
	apellido VARCHAR(100) NOT NULL,
	segundo_apellido VARCHAR(100),
	fecha_nac date NOT NULL,
	id_genero INTEGER NOT NULL,
	correo VARCHAR(200) NOT NULL,
	id_estado INTEGER NOT NULL,
	id_municipio INTEGER NOT NULL,
	id_parroquia INTEGER NOT NULL,
	ubicacion text NOT NULL,
	direccion text NOT NULL,
	tipo_vivienda text NOT NULL,
	identificador_vivienda text NOT NULL,
	apartamento text NOT NULL,
	id_escuela INTEGER,
	id_instituto INTEGER,
	id_cordinacion INTEGER,
	id_departamente INTEGER,
	id_catedra INTEGER,
	primer_numero_movil VARCHAR(15) NOT NULL,
	segundo_numero_movil VARCHAR(15),
	numero_local VARCHAR(15) NOT NULL,
	id_ingreso INTEGER NOT NULL,
	id_tipo_ingreso INTEGER NOT NULL,
	fecha_admision date NOT NULL,
	fecha_ultima_actualizacion date,
	fecha_retiro date,
	activo BIT(1) NOT NULL,
  	borrado BIT(1) NOT NULL,
  	ultima_modificacion_por BIGINT NOT NULL,
  	fecha_ultima_modificacion TIMESTAMP WITHOUT TIME ZONE NOT NULL,
	tipo_cambio character varying(50),
  	descripcion_cambio character varying(500)

);

CREATE TABLE datos_empleados.historial_documentacion(
	id BIGINT,
	descripcion VARCHAR(100),
	activo BIT(1) NOT NULL,
  	borrado BIT(1) NOT NULL,
  	ultima_modificacion_por BIGINT NOT NULL,
  	fecha_ultima_modificacion TIMESTAMP WITHOUT TIME ZONE NOT NULL,
	tipo_cambio character varying(50),
  	descripcion_cambio character varying(500)


);

CREATE TABLE datos_empleados.historial_nacionalidades(
	id BIGINT,
	descripcion VARCHAR(100) NOT NULL,
	activo BIT(1) NOT NULL,
  	borrado BIT(1) NOT NULL,
  	ultima_modificacion_por BIGINT NOT NULL,
  	fecha_ultima_modificacion TIMESTAMP WITHOUT TIME ZONE NOT NULL,
  	tipo_cambio character varying(50),
  	descripcion_cambio character varying(500)
);

CREATE TABLE datos_empleados.registro_generos(
	id BIGINT,
	descripcion VARCHAR(100) NOT NULL,
	activo BIT(1) NOT NULL,
  	borrado BIT(1) NOT NULL,
  	ultima_modificacion_por BIGINT NOT NULL,
  	fecha_ultima_modificacion TIMESTAMP WITHOUT TIME ZONE NOT NULL,
  	tipo_cambio character varying(50),
  	descripcion_cambio character varying(500)
);

CREATE TABLE datos_empleados.historial_estados(
	id BIGINT,
	nombre VARCHAR(100) NOT NULL,
	activo BIT(1) NOT NULL,
  	borrado BIT(1) NOT NULL,
  	ultima_modificacion_por BIGINT NOT NULL,
  	fecha_ultima_modificacion TIMESTAMP WITHOUT TIME ZONE NOT NULL,
	tipo_cambio character varying(50),
  	descripcion_cambio character varying(500)
);

CREATE TABLE datos_empleados.historial_municipios(
	id BIGINT,
	id_estado  INTEGER NOT NULL,
	nombre VARCHAR(100) NOT NULL,
	activo BIT(1) NOT NULL,
  	borrado BIT(1) NOT NULL,
  	ultima_modificacion_por BIGINT NOT NULL,
  	fecha_ultima_modificacion TIMESTAMP WITHOUT TIME ZONE NOT NULL,
	tipo_cambio character varying(50),
  	descripcion_cambio character varying(500)
);

CREATE TABLE datos_empleados.historial_parroquia(
	id BIGINT,
	id_municipio INTEGER NOT NULL,
	name VARCHAR(100) NOT NULL,
	activo BIT(1) NOT NULL,
  	borrado BIT(1) NOT NULL,
  	ultima_modificacion_por BIGINT NOT NULL,
  	fecha_ultima_modificacion TIMESTAMP WITHOUT TIME ZONE NOT NULL,
  	tipo_cambio character varying(50),
  	descripcion_cambio character varying(500)
);

CREATE TABLE datos_empleados.historial_ingreso(
	id BIGINT,
	descripcion VARCHAR(100) NOT NULL,
	activo BIT(1) NOT NULL,
  	borrado BIT(1) NOT NULL,
  	ultima_modificacion_por BIGINT NOT NULL,
  	fecha_ultima_modificacion TIMESTAMP WITHOUT TIME ZONE NOT NULL,
	tipo_cambio character varying(50),
  	descripcion_cambio character varying(500)
);

CREATE TABLE datos_empleados.historial_tipo_ingreso(
	id BIGINT,
	descripcion VARCHAR(100) NOT NULL,
	activo BIT(1) NOT NULL,
  	borrado BIT(1) NOT NULL,
  	ultima_modificacion_por BIGINT NOT NULL,
  	fecha_ultima_modificacion TIMESTAMP WITHOUT TIME ZONE NOT NULL,
  	tipo_cambio character varying(50),
  	descripcion_cambio character varying(500)
);

CREATE TABLE datos_empleados.historial_tipos_categoria(
	id BIGINT,
	codigo INTEGER NOT NULL,
	descripcion VARCHAR(100) NOT NULL,
	activo BIT(1) NOT NULL,
  	borrado BIT(1) NOT NULL,
  	ultima_modificacion_por BIGINT NOT NULL,
  	fecha_ultima_modificacion TIMESTAMP WITHOUT TIME ZONE NOT NULL,
  	tipo_cambio character varying(50),
  	descripcion_cambio character varying(500)
);

CREATE TABLE datos_empleados.historial_tipos_dedicacion(
	id BIGINT,
	codigo INTEGER NOT NULL,
	descripcion VARCHAR(100) NOT NULL,
	activo BIT(1) NOT NULL,
  	borrado BIT(1) NOT NULL,
  	ultima_modificacion_por BIGINT NOT NULL,
  	fecha_ultima_modificacion TIMESTAMP WITHOUT TIME ZONE NOT NULL,
  	tipo_cambio character varying(50),
  	descripcion_cambio character varying(500)
);

CREATE TABLE datos_empleados.historial_salarios(
	id BIGINT,
	id_tipos_categoria INTEGER NOT NULL,
	id_tipos_dedicacion INTEGER NOT NULL,
	salario MONEY NOT NULL,
	activo BIT(1) NOT NULL,
  	borrado BIT(1) NOT NULL,
  	ultima_modificacion_por BIGINT NOT NULL,
  	fecha_ultima_modificacion TIMESTAMP WITHOUT TIME ZONE NOT NULL,
  	tipo_cambio character varying(50),
  	descripcion_cambio character varying(500)
);

CREATE TABLE datos_empleados.historial_empleado_salarios(
	id BIGINT,
	id_empleado INTEGER NOT NULL,
	id_salario INTEGER NOT NULL,
	activo BIT(1) NOT NULL,
  	borrado BIT(1) NOT NULL,
  	ultima_modificacion_por BIGINT NOT NULL,
  	fecha_ultima_modificacion TIMESTAMP WITHOUT TIME ZONE NOT NULL,
	tipo_cambio character varying(50),
  	descripcion_cambio character varying(500)
);

CREATE TABLE datos_empleados.historial_codigo_idac(
	id BIGINT,
	codigo INTEGER Not NULL,
	id_unidad_ejecutora INTEGER NOT NULL,
	fecha_vacante  TIMESTAMP WITHOUT TIME ZONE,
	activo BIT(1) NOT NULL,
  	borrado BIT(1) NOT NULL,
  	ultima_modificacion_por BIGINT NOT NULL,
  	fecha_ultima_modificacion TIMESTAMP WITHOUT TIME ZONE NOT NULL,
	tipo_cambio character varying(50),
  	descripcion_cambio character varying(500)
);

CREATE TABLE datos_empleados.historial_unidad_ejecutora(
	id BIGINT,
	codigo INTEGER NOT NULL,
	descripcion VARCHAR(300) NOT NULL,
	activo BIT(1) NOT NULL,
  	borrado BIT(1) NOT NULL,
  	ultima_modificacion_por BIGINT NOT NULL,
  	fecha_ultima_modificacion TIMESTAMP WITHOUT TIME ZONE NOT NULL,
	tipo_cambio character varying(50),
  	descripcion_cambio character varying(500)
);

CREATE TABLE datos_empleados.historial_codigo_idac_empleado(
	id BIGINT,
	id_empleado INTEGER NOT NULL,
	id_codigo_idac INTEGER NOT NULL,
	activo BIT(1) NOT NULL,
  	borrado BIT(1) NOT NULL,
  	ultima_modificacion_por BIGINT NOT NULL,
  	fecha_ultima_modificacion TIMESTAMP WITHOUT TIME ZONE NOT NULL,
	tipo_cambio character varying(50),
  	descripcion_cambio character varying(500)
);

-- ADD PK in the tables

ALTER TABLE ONLY datos_empleados.empleados
	ADD CONSTRAINT id_empleado_pk PRIMARY KEY (id);

ALTER TABLE ONLY datos_empleados.documentacion
	ADD CONSTRAINT id_documentacion_pk PRIMARY KEY (id);

ALTER TABLE ONLY datos_empleados.nacionalidades
	ADD CONSTRAINT id_nacionalidad_pk PRIMARY KEY (id);

ALTER TABLE ONLY datos_empleados.generos
	ADD CONSTRAINT id_genero_pk PRIMARY KEY (id);

ALTER TABLE ONLY datos_empleados.estados
	ADD CONSTRAINT id_estado_pk PRIMARY KEY (id);

ALTER TABLE ONLY datos_empleados.municipios
	ADD CONSTRAINT id_municipio_pk PRIMARY KEY (id);

ALTER TABLE ONLY datos_empleados.parroquias
	ADD CONSTRAINT id_parroquia_pk PRIMARY KEY (id);

ALTER TABLE ONLY datos_empleados.ingreso
	ADD CONSTRAINT id_ingreso_pk PRIMARY KEY (id);

ALTER TABLE ONLY datos_empleados.tipo_ingreso
	ADD CONSTRAINT id_tipo_ingreso_pk PRIMARY KEY (id);

ALTER TABLE ONLY datos_empleados.tipos_categoria
	ADD CONSTRAINT id_tipos_categoria_pk PRIMARY KEY (id);

ALTER TABLE ONLY datos_empleados.tipos_dedicacion
	ADD CONSTRAINT id_tipos_dedicacion_pk PRIMARY KEY (id);

ALTER TABLE ONLY datos_empleados.salarios
	ADD CONSTRAINT id_salarios_pk PRIMARY KEY (id);

ALTER TABLE ONLY datos_empleados.empleado_salarios
	ADD CONSTRAINT id_empleado_salario_pk PRIMARY KEY (id);

ALTER TABLE ONLY datos_empleados.unidad_ejecutora
	ADD CONSTRAINT id_unidad_ejecutora_pk PRIMARY KEY (id);

ALTER TABLE ONLY datos_empleados.codigo_idac
	ADD CONSTRAINT id_codigo_idac_pk PRIMARY KEY (id);

ALTER TABLE ONLY datos_empleados.codigo_idac_empleado
	ADD CONSTRAINT id_codigo_idac_empleado_pk PRIMARY KEY (id);

-- ADD fk in the tables

ALTER TABLE ONLY datos_empleados.empleados
  ADD CONSTRAINT id_estado_empleado_fk FOREIGN KEY (id_estado) 
  REFERENCES datos_empleados.estados(id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY datos_empleados.empleados
  ADD CONSTRAINT id_municipio_empleado_fk FOREIGN KEY (id_municipio) 
  REFERENCES datos_empleados.municipios(id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY datos_empleados.empleados
  ADD CONSTRAINT id_parroquia_empleado_fk FOREIGN KEY (id_parroquia) 
  REFERENCES datos_empleados.parroquias(id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY datos_empleados.empleados
  ADD CONSTRAINT id_documentacion_empleado_fk FOREIGN KEY (id_documentacion) 
  REFERENCES datos_empleados.documentacion(id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY datos_empleados.empleados
  ADD CONSTRAINT empleado_nacionality_id_fk FOREIGN KEY (nacionality_id) 
  REFERENCES datos_empleados.nacionalities(id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY datos_empleados.empleados
  ADD CONSTRAINT empleado_id_genero_fk FOREIGN KEY (id_genero) 
  REFERENCES datos_empleados.generos(id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY datos_empleados.municipios
  ADD CONSTRAINT id_estado_municiios_fk FOREIGN KEY (id_estado) 
  REFERENCES datos_empleados.estados(id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY datos_empleados.parroquias
  ADD CONSTRAINT id_municipio_parroquias_fk FOREIGN KEY (id_municipio) 
  REFERENCES datos_empleados.municipios(id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY datos_empleados.empleados
  ADD CONSTRAINT id_ingreso_empleado_fk FOREIGN KEY (id_ingreso) 
  REFERENCES datos_empleados.ingreso(id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY datos_empleados.empleados
  ADD CONSTRAINT id_tipo_ingreso_empleado_id_fk FOREIGN KEY (id_tipo_ingreso) 
  REFERENCES datos_empleados.tipo_ingreso(id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY datos_empleados.salarios
  ADD CONSTRAINT id_tipos_dedicacion_salarios_fk FOREIGN KEY (id_tipos_dedicacion) 
  REFERENCES datos_empleados.tipos_dedicacion(id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY datos_empleados.salarios
  ADD CONSTRAINT id_tipos_categoria_salarios_fk FOREIGN KEY (id_tipos_categoria) 
  REFERENCES datos_empleados.tipos_categoria(id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY datos_empleados.empleado_salarios
  ADD CONSTRAINT id_empleado_salario_empleado_fk FOREIGN KEY (id_empleado) 
  REFERENCES datos_empleados.empleados(id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY datos_empleados.empleado_salarios
  ADD CONSTRAINT id_empleado_salario_empleado_salario_fk FOREIGN KEY (id_salario) 
  REFERENCES datos_empleados.salarios(id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY datos_empleados.codigo_idac
  ADD CONSTRAINT id_unidad_ejecutora_codigo_idac_fk FOREIGN KEY (id_unidad_ejecutora) 
  REFERENCES datos_empleados.unidad_ejecutora(id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY datos_empleados.codigo_idac_empleado
  ADD CONSTRAINT id_codigo_idac_empleado_fk FOREIGN KEY (id_empleado) 
  REFERENCES datos_empleados.empleados(id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY datos_empleados.codigo_idac_empleado
  ADD CONSTRAINT id_codigo_idac_codigo_idac_empleado_fk FOREIGN KEY (id_codigo_idac) 
  REFERENCES datos_empleados.codigo_idac(id) ON UPDATE CASCADE ON DELETE CASCADE;