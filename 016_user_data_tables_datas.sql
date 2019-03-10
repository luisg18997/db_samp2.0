-- data of schemma user_data

-- data of roles
SELECT user_data.roles_insert('Administrador', 0);
SELECT user_data.roles_insert('Operador de Escuela', 0);
SELECT user_data.roles_insert('Operador de Instituto', 0);
SELECT user_data.roles_insert('Operador de Coordinacion', 0);
SELECT user_data.roles_insert('Trabajador de RRHH', 0);
SELECT user_data.roles_insert('Coordinador de RRHH', 0);
SELECT user_data.roles_insert('Trabajador de Presupuesto', 0);
SELECT user_data.roles_insert('Coordinador de Presupuesto', 0);


-- data of ubication
SELECT user_data.ubication_insert('Departamento de Informatica', 0);
SELECT user_data.ubication_insert('Escuela', 0);
SELECT user_data.ubication_insert('Instituto', 0);
SELECT user_data.ubication_insert('Coordinacion', 0);
SELECT user_data.ubication_insert('Departamento de Recursos Humanos', 0);
SELECT user_data.ubication_insert('Departamento de Presupuesto', 0);

-- data of security question
SELECT user_data.security_question_insert('Donde nació de su padre', 0);
SELECT user_data.security_question_insert('Segundo nombre de su madre', 0);
SELECT user_data.security_question_insert('Postre favorito', 0);
SELECT user_data.security_question_insert('Segundo nombre de su padre', 0);
SELECT user_data.security_question_insert('Donde nació de su madre', 0);
SELECT user_data.security_question_insert('Color favorito', 0);
SELECT user_data.security_question_insert('Apellido de su mejor amig@', 0);
SELECT user_data.security_question_insert('Nombre de su mascota', 0);
SELECT user_data.security_question_insert('Fecha de su graduacion', 0);
SELECT user_data.security_question_insert('Nombre de la escuela de primaria', 0);
SELECT user_data.security_question_insert('Nombre de su primer Jefe', 0);
SELECT user_data.security_question_insert('Fecha de nacimiento de su primer hij@', 0);
SELECT user_data.security_question_insert('Donde vive sus Padres', 0);
SELECT user_data.security_question_insert('Comida favorita', 0);
SELECT user_data.security_question_insert('Genero de Musica favorita', 0);

-- data of user root
INSERT INTO user_data.users(name, surname, email,password, ubication_id, school_id, institute_id, coordination_id, is_active, is_deleted, last_modified_by, user_create_date, last_modified_date)
VALUES
('ADMINISTRADOR', 'UCV-FHE', 'adminsist@ucvfhe.com.ve','$2b$10$ju3GNfHhBaX9BfV1nxBk4.7wrFDW86myKWUIDSg9oP6TQTUUeR2aS',1,0,0,0,'1','0',0,CLOCK_TIMESTAMP(),CLOCK_TIMESTAMP()), --clave Admin.UCV01
('ESCUELA', 'UCV-FHE', 'escuelasist@ucvfhe.com.ve','$2b$10$SXYorupzR1qZk1jrOAF1B.8AhO1qwtlmqG2yylcC7dNpq8r3ODIHi',2,1,0,0,'1','0',0,CLOCK_TIMESTAMP(),CLOCK_TIMESTAMP()), --clave School.UCV02
('INSTITUTO', 'UCV-FHE', 'institutosist@ucvfhe.com.ve','$2b$10$BudNA2XmvW7sDHa5HluvAOMM6nvUKRHDvn6Ssp5gWMGBmgJjRw0VS',3,0,1,0,'1','0',0,CLOCK_TIMESTAMP(),CLOCK_TIMESTAMP()), --clave Institute.UCV03
('COORDINACION', 'UCV-FHE', 'coordinacionsist@ucvfhe.com.ve','$2b$10$bzqxae0mm/8VnJ6WsK2ubui0vHO6QggadAqlxUX1OAukHDTPDJb2e',4,0,0,1,'1','0',0,CLOCK_TIMESTAMP(),CLOCK_TIMESTAMP()), --clave Coordination.UCV04
('RECURSOS HUMANO', 'UCV-FHE', 'rrhhsist@ucvfhe.com.ve','$2b$10$okYM7R09R4NDC7bzEjVqguvtoIUY3h3YwG/sr8V9YoyhkgiXgnR4u',5,0,0,0,'1','0',0,CLOCK_TIMESTAMP(),CLOCK_TIMESTAMP()), --clave RRHH.UCV05
('PRESUPUESTO', 'UCV-FHE', 'presupuestosist@ucvfhe.com.ve','$2b$10$JtfbNoneONrWFaChnkitauwlnext0rmdAWlm7N.kBOb1t9qiznc8G',6,0,0,0,'1','0',0,CLOCK_TIMESTAMP(),CLOCK_TIMESTAMP()); --clave Presupuesto.UCV06


INSERT INTO user_data.user_roles(user_id,role_id,is_active,is_deleted,last_modified_by,last_modified_date)
VALUES
(1,1,'1','0',0,CLOCK_TIMESTAMP()),
(2,2,'1','0',0,CLOCK_TIMESTAMP()),
(3,3,'1','0',0,CLOCK_TIMESTAMP()),
(4,4,'1','0',0,CLOCK_TIMESTAMP()),
(5,6,'1','0',0,CLOCK_TIMESTAMP()),
(6,8,'1','0',0,CLOCK_TIMESTAMP());

INSERT INTO user_data.security_answers(user_id,question_id,answer,is_active,is_deleted,last_modified_by,last_modified_date)
VALUES
(1,3,'$2b$10$BMlOkz/4apx3XS5lEzwIRenYpo0Ew0zWS5DlbBYGxw80SAJJ8ySzq','1','0',0,CLOCK_TIMESTAMP()), -- respuesta chocolate
(2,3,'$2b$10$aj3CRxa6JWTV6neuEazK1Ok0nqz2vsOP68Uh79bYAkkNh8L.NBrVK','1','0',0,CLOCK_TIMESTAMP()), -- respuesta torta
(3,6,'$2b$10$uG/6txab8JrBOy9Y1N.WBusFpA2WceQx/peIg59fOZ6vlYGUhzFBi','1','0',0,CLOCK_TIMESTAMP()), -- azul
(4,6,'$2b$10$EBFoAqXaoCBlBzpUKDmZN.UmEACvFSArYvo.S22iuxn7PYOHduGRe','1','0',0,CLOCK_TIMESTAMP()), -- verde
(5,14,'$2b$10$guWZuj0IOZd/aH83OT4P0urT9zJlloOcKGOCzi1hHG0MFvg3HTls.','1','0',0,CLOCK_TIMESTAMP()), -- pabellon
(6,14,'$2b$10$hb15JE2QOwXbMyMEl6JV2uEnX7RUrf0PSVVSXuSqTamL.V6MRlb7K','1','0',0,CLOCK_TIMESTAMP()); -- mondogo
