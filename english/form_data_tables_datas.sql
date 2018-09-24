-- data of shemma form_data

-- data of table movement type
SELECT form_data.movement_type_insert('Ingreso', 0);
SELECT form_data.movement_type_insert('Prórroga de Contrato', 0);
SELECT form_data.movement_type_insert('Nombramiento Definitivo', 0);
SELECT form_data.movement_type_insert('Ascenso', 0);
SELECT form_data.movement_type_insert('Cambio de Dedicación', 0);
SELECT form_data.movement_type_insert('Aumento de Horas', 0);
SELECT form_data.movement_type_insert('Disminución de Horas', 0);
SELECT form_data.movement_type_insert('Traslado', 0);
SELECT form_data.movement_type_insert('Transferencia', 0);
SELECT form_data.movement_type_insert('Permiso Remunerado', 0);
SELECT form_data.movement_type_insert('Permiso No Remunerado', 0);
SELECT form_data.movement_type_insert('Año Sabático', 0);
SELECT form_data.movement_type_insert('Retiro: Por Renuncia', 0);
SELECT form_data.movement_type_insert('Retiro: Por Término de Contrato', 0);
SELECT form_data.movement_type_insert('Retiro: Defunción', 0);
SELECT form_data.movement_type_insert('Retiro: Remoción', 0);
SELECT form_data.movement_type_insert('Retiro', 0);
SELECT form_data.movement_type_insert('Jubilación', 0);
SELECT form_data.movement_type_insert('Reincorporación', 0);
SELECT form_data.movement_type_insert('Reposo Medico', 0);

-- data of table ccountant_type
SELECT form_data.accountant_type_insert(401011800100, 'Contratado', 0);
SELECT form_data.accountant_type_insert(401011800300, 'Auxiliares Docentes', 0);
SELECT form_data.accountant_type_insert(401010200100, 'Docentes Medio Tiempo Regular', 0);
SELECT form_data.accountant_type_insert(401010100100, 'Docentes Tiempo Completo/ Ded. Exclusiva Regular', 0);
SELECT form_data.accountant_type_insert(401010300100, 'Docentes Suplentes', 0);

-- data of table program_type
SELECT form_data.program_type_insert('AC11', null, 0);

-- data of table annex_type
SELECT form_data.annex_type_insert('Curriculum con sus anexos', 0);
SELECT form_data.annex_type_insert('Planilla de solicitud de empleo', 0);
SELECT form_data.annex_type_insert('Planilla de datos personales', 0);
SELECT form_data.annex_type_insert('cedula de identidad', 0);
SELECT form_data.annex_type_insert('Rif', 0);
SELECT form_data.annex_type_insert('Cheque o libreta bancaria', 0);
SELECT form_data.annex_type_insert('Informes 1,2,3/Cronograma de actividades', 0);
SELECT form_data.annex_type_insert('Informes 1,2,3', 0);
SELECT form_data.annex_type_insert('Acta del concurso', 0);
SELECT form_data.annex_type_insert('Carta de Renuncia', 0);
