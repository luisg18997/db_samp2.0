-- data of schemma user_data

-- data of roles
SELECT user_data.roles_insert('Administrador', 0);
SELECT user_data.roles_insert('Secretaria de Escuela', 0);
SELECT user_data.roles_insert('Director de Escuela', 0);
SELECT user_data.roles_insert('Secretaria de Instituto', 0);
SELECT user_data.roles_insert('Director de Instituto', 0);
SELECT user_data.roles_insert('Secretaria de Coordinacion', 0);
SELECT user_data.roles_insert('Director de Coordinacion', 0);
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
('ADMINISTRADOR', 'UCVFHE', 'adminsist@ucvfhe.com.ve','$2b$10$ju3GNfHhBaX9BfV1nxBk4.7wrFDW86myKWUIDSg9oP6TQTUUeR2aS',1,0,0,0,'1','0',0,CLOCK_TIMESTAMP(),CLOCK_TIMESTAMP()), --clave Admin.UCV01
('ESCUELA', 'UCVFHE', 'escuelasist@ucvfhe.com.ve','$2b$10$SXYorupzR1qZk1jrOAF1B.8AhO1qwtlmqG2yylcC7dNpq8r3ODIHi',2,1,0,0,'1','0',0,CLOCK_TIMESTAMP(),CLOCK_TIMESTAMP()), --clave School.UCV02
('DIRECTORESCUELA','UCVFHE','escueladirsist@ucvfhe.com.ve','$2b$10$PrzqywwwtOG68.LijYrdCOrj6.TrrJqm8fFeu0dreikbVJVpOeR2.',2,1,0,0,'1','0',0,CLOCK_TIMESTAMP(),CLOCK_TIMESTAMP()); --clave SchoolPri.UCV02
('INSTITUTO', 'UCVFHE', 'institutosist@ucvfhe.com.ve','$2b$10$BudNA2XmvW7sDHa5HluvAOMM6nvUKRHDvn6Ssp5gWMGBmgJjRw0VS',3,0,1,0,'1','0',0,CLOCK_TIMESTAMP(),CLOCK_TIMESTAMP()), --clave Institute.UCV03
('DIRECTORINSTITUTO','UCVFHE','institutodirsist@ucvfhe.com.ve','$2b$10$4txEBns1o3URfcalMrCNaOifr6TnYjfEmO.7FyupGtyI/AdAyUMcG',3,0,1,0,'1','0',0,CLOCK_TIMESTAMP(),CLOCK_TIMESTAMP()); --clave InstitutePri.UCV03
('COORDINACION', 'UCVFHE', 'coordinacionsist@ucvfhe.com.ve','$2b$10$bzqxae0mm/8VnJ6WsK2ubui0vHO6QggadAqlxUX1OAukHDTPDJb2e',4,0,0,1,'1','0',0,CLOCK_TIMESTAMP(),CLOCK_TIMESTAMP()), --clave Coordination.UCV04
('DIRECTORCOORDINACION','UCVFHE','coordinaciondirsist@ucvfhe.com.ve','$2b$10$GxrQzFd6WpKeOOgpaW/1e.zS6WcdfW.31eAEnelQG7ErhvTO6ftgO','coordinaciondirsist@ucvfhe.com.ve',4,0,0,1,'1','0',0,CLOCK_TIMESTAMP(),CLOCK_TIMESTAMP()); --clave CoordinationlPri.UCV03
('RRHH', 'UCVFHE', 'rrhhsist@ucvfhe.com.ve','$2b$10$okYM7R09R4NDC7bzEjVqguvtoIUY3h3YwG/sr8V9YoyhkgiXgnR4u',5,0,0,0,'1','0',0,CLOCK_TIMESTAMP(),CLOCK_TIMESTAMP()), --clave RRHH.UCV05
('COORDINADORRHH','UCVFHE','rrhhcoordsis@ucvfhe.com.ve','$2b$10$bZrcxK3RnYCg3Y/hFm7hHeCkJ0BN74fUAqREp3Tp6UTdRHul0z1pG',5,0,0,0,'1','0',0,CLOCK_TIMESTAMP(),CLOCK_TIMESTAMP()), --clave RRHHCoord.UCV05
('PRESUPUESTO', 'UCVFHE', 'presupuestosist@ucvfhe.com.ve','$2b$10$JtfbNoneONrWFaChnkitauwlnext0rmdAWlm7N.kBOb1t9qiznc8G',6,0,0,0,'1','0',0,CLOCK_TIMESTAMP(),CLOCK_TIMESTAMP()), --clave Presupuesto.UCV06
('COORDINADORPRESUPUESTO','UCVFHE','presupuestocoordsist@ucvfhe.com.ve','$2b$10$zMYwVTW2bFS243uAkZKyg.y7aP7dGeuDRom0NHMFgX0cysPnWOVna',6,0,0,0,'1','0',0,CLOCK_TIMESTAMP(),CLOCK_TIMESTAMP()); --clave PresupuestoCoord.UCV06

INSERT INTO user_data.user_roles(user_id,role_id,is_active,is_deleted,last_modified_by,last_modified_date)
VALUES
(1,1,'1','0',0,CLOCK_TIMESTAMP()),
(2,2,'1','0',0,CLOCK_TIMESTAMP()),
(3,3,'1','0',0,CLOCK_TIMESTAMP()),
(4,4,'1','0',0,CLOCK_TIMESTAMP()),
(5,5,'1','0',0,CLOCK_TIMESTAMP()),
(6,6,'1','0',0,CLOCK_TIMESTAMP()),
(7,7,'1','0',0,CLOCK_TIMESTAMP()),
(8,8,'1','0',0,CLOCK_TIMESTAMP()),
(9,9,'1','0',0,CLOCK_TIMESTAMP()),
(10,10,'1','0',0,CLOCK_TIMESTAMP()),
(11,11,'1','0',0,CLOCK_TIMESTAMP());

INSERT INTO user_data.security_answers(user_id,question_id,answer,is_active,is_deleted,last_modified_by,last_modified_date)
VALUES
(1,3,'$2b$10$BMlOkz/4apx3XS5lEzwIRenYpo0Ew0zWS5DlbBYGxw80SAJJ8ySzq','1','0',0,CLOCK_TIMESTAMP()), -- respuesta chocolate
(2,3,'$2b$10$aj3CRxa6JWTV6neuEazK1Ok0nqz2vsOP68Uh79bYAkkNh8L.NBrVK','1','0',0,CLOCK_TIMESTAMP()), -- respuesta torta
(3,3,'$2b$10$K.seKsnI.Y6LTTU7UCp2wOC0pcLmkZrnmr9qaFAbHNtcri527rWDa','1','0',0,CLOCK_TIMESTAMP()), -- respuesta helado
(4,6,'$2b$10$uG/6txab8JrBOy9Y1N.WBusFpA2WceQx/peIg59fOZ6vlYGUhzFBi','1','0',0,CLOCK_TIMESTAMP()), -- respuesta azul
(4,6,'$2b$10$A/fmPVAEcatzkAaZsuj1hubEVKiVcWu.MBXlsxNKZi2JX4lkXxGf2','1','0',0,CLOCK_TIMESTAMP()), -- respuesta negro
(6,6,'$2b$10$EBFoAqXaoCBlBzpUKDmZN.UmEACvFSArYvo.S22iuxn7PYOHduGRe','1','0',0,CLOCK_TIMESTAMP()), -- respuesta verde
(7,14,'$2b$10$wQdSBvNaUephyLfSy.csqu2L5MnBY5HNK9GKmbwgc39JHezX8aVrS','1','0',0,CLOCK_TIMESTAMP()), -- respuesta empanadas
(8,14,'$2b$10$guWZuj0IOZd/aH83OT4P0urT9zJlloOcKGOCzi1hHG0MFvg3HTls.','1','0',0,CLOCK_TIMESTAMP()), -- respuesta pabellon
(9,15,'$2b$10$iGjFxuXhR9dXyY0ctBQBIuwl9ti1I9UOV9abCypnfz.m8vhTwlkeW','1','0',0,CLOCK_TIMESTAMP()), -- salsa
(10,14,'$2b$10$hb15JE2QOwXbMyMEl6JV2uEnX7RUrf0PSVVSXuSqTamL.V6MRlb7K','1','0',0,CLOCK_TIMESTAMP()), -- respuesta mondogo
(11,15,'$2b$10$RCqV39MiBbqzwpN6/F/7X.J3ZybLglV4DmaiuUIe6lUDcegjtUyBm','1','0',0,CLOCK_TIMESTAMP()); -- bachata
