--functions of faculty_data.schools

-- function insert of faculty_data.schools

CREATE OR REPLACE FUNCTION faculty_data.schools_insert(
  param_code INTEGER,
  param_name VARCHAR,
  param_user_id BIGINT,
  param_faculty_id INTEGER
)
RETURNS BIT
LANGUAGE plpgsql VOLATILE
COST 100.0
AS $udf$
  DECLARE
    local_is_successful BIT := '0';
    local_school_id BIGINT;
  BEGIN
    IF EXISTS
    (
      SELECT sch.code
      FROM faculty_data.schools sch
      WHERE
        sch.code = param_code
      AND
        sch.is_active = '1'
      AND
        sch.is_deleted = '0'
    )
    THEN
      RETURN local_is_successful;
    ELSE
      INSERT INTO faculty_data.schools
      (
        code,
        name,
        faculty_id,
        is_active,
        is_deleted,
        last_modified_by,
        last_modified_date
      )
      VALUES
      (
        param_code,
        param_name,
        param_faculty_id,
        '1',
        '0',
        param_user_id,
        CLOCK_TIMESTAMP()
      )
      RETURNING id
      INTO STRICT local_school_id;

    SELECT schools_insert_history INTO local_is_successful FROM faculty_data.schools_insert_history(
      param_school_id := local_school_id,
      param_change_type := 'FIRST INSERT',
      param_change_description := 'FIRST INSERT'
    );

    RETURN local_is_successful;
    END IF;
  END;
$udf$;

CREATE OR REPLACE FUNCTION faculty_data.schools_insert_history(
  param_school_id BIGINT,
  param_change_type VARCHAR,
  param_change_description VARCHAR
)
RETURNS BIT
LANGUAGE plpgsql VOLATILE
COST 100.0
AS $udf$
  DECLARE
    local_is_successful BIT := '0';
  BEGIN
    INSERT INTO faculty_data.schools_history
    (
      school_id,
      code,
      name,
      faculty_id,
      is_active,
      is_deleted,
      last_modified_by,
      last_modified_date,
      change_type,
      change_description
    )
    SELECT
      id,
      code,
      name,
      faculty_id,
      is_active,
      is_deleted,
      last_modified_by,
      last_modified_date,
      param_change_type,
      param_change_description
    FROM
      faculty_data.schools sch
    WHERE
      sch.id = param_school_id
    ORDER BY
      sch.last_modified_date
    DESC
    LIMIT 1;

    local_is_successful :='1';
    RETURN local_is_successful;
  END;
$udf$;

-- function get all schools

CREATE OR REPLACE FUNCTION faculty_data.get_all_schools_list(
  param_faculty_id INTEGER
)
RETURNS json
LANGUAGE 'sql'
COST 100.0

AS $BODY$
  SELECT ARRAY_TO_JSON(ARRAY_AGG(ROW_TO_JSON(DATA)))
  FROM (
    SELECT
      sch.id,
      sch.code,
      sch.name as school
    FROM
      faculty_data.schools sch
    INNER JOIN
      faculty_data.faculty fac
    ON
      fac.is_active = '1'
    AND
      fac.is_deleted = '0'
    AND
      fac.id = sch.faculty_id
      WHERE
        sch.faculty_id = param_faculty_id
      AND
        sch.is_active = '1'
      AND
        sch.is_deleted = '0'
  )DATA;
$BODY$;

-- function get one school

CREATE OR REPLACE FUNCTION faculty_data.get_school(
  param_id INTEGER,
  param_faculty_id INTEGER
)
RETURNS json
LANGUAGE 'sql'
COST 100.0

AS $BODY$
  SELECT ARRAY_TO_JSON(ARRAY_AGG(ROW_TO_JSON(DATA)))
  FROM (
    SELECT
      sch.id,
      sch.code,
      sch.name as school
    FROM
      faculty_data.schools sch
    INNER JOIN
      faculty_data.faculty fac
    ON
      fac.is_active = '1'
    AND
      fac.is_deleted = '0'
    AND
      fac.id = sch.faculty_id
      WHERE
        sch.faculty_id = param_faculty_id
      AND
        sch.id = param_id
      AND
        sch.is_active = '1'
      AND
        sch.is_deleted = '0'
  )DATA;
$BODY$;


--function update school all columns

CREATE OR REPLACE FUNCTION faculty_data.school_update_all_columns(
  param_id INTEGER,
  param_code INTEGER,
  param_name VARCHAR,
  param_faculty_id INTEGER,
  param_user_id BIGINT,
  param_is_active BIT,
  param_is_deleted BIT
)
RETURNS BIT
LANGUAGE plpgsql VOLATILE
COST 100.0
AS $udf$
  DECLARE
    local_is_successful BIT := '0';
  BEGIN
    UPDATE faculty_data.schools SET
      name = param_name,
      code = param_code,
      faculty_id = param_faculty_id,
      is_active = param_is_active,
      is_deleted = param_is_deleted,
      last_modified_by = param_user_id,
      last_modified_date = CLOCK_TIMESTAMP()
    WHERE
      id = param_id;

    SELECT schools_insert_history INTO local_is_successful FROM faculty_data.schools_insert_history(
      param_school_id := param_id,
      param_change_type := 'UPDATE all_columns',
      param_change_description := 'UPDATE value of all columns'
    );

    RETURN local_is_successful;
  END;
$udf$;

--function update school is active

CREATE OR REPLACE FUNCTION faculty_data.school_update_is_active(
  param_id INTEGER,
  param_user_id BIGINT,
  param_is_active BIT
)
RETURNS BIT
LANGUAGE plpgsql VOLATILE
COST 100.0
AS $udf$
  DECLARE
    local_is_successful BIT := '0';
  BEGIN
    UPDATE faculty_data.schools SET
      is_active = param_is_active,
      last_modified_by = param_user_id,
      last_modified_date = CLOCK_TIMESTAMP()
    WHERE
      id = param_id;

    SELECT schools_insert_history INTO local_is_successful FROM faculty_data.schools_insert_history(
      param_school_id := param_id,
      param_change_type := 'UPDATE is_active',
      param_change_description := 'UPDATE value of is_active'
    );


    RETURN local_is_successful;
  END;
$udf$;

--function update school is deleted

CREATE OR REPLACE FUNCTION faculty_data.school_update_is_deleted(
  param_id INTEGER,
  param_user_id BIGINT,
  param_is_deleted BIT
)
RETURNS BIT
LANGUAGE plpgsql VOLATILE
COST 100.0
AS $udf$
  DECLARE
    local_is_successful BIT := '0';
  BEGIN
    UPDATE faculty_data.schools SET
      is_deleted = param_is_deleted,
      last_modified_by = param_user_id,
      last_modified_date = CLOCK_TIMESTAMP()
    WHERE
      id = param_id;

    SELECT schools_insert_history INTO local_is_successful FROM faculty_data.schools_insert_history(
      param_school_id := param_id,
      param_change_type := 'UPDATE is_deleted',
      param_change_description := 'UPDATE value of is_deleted'
    );


    RETURN local_is_successful;
  END;
$udf$;

-- Functions of institute

-- function of institute insert

CREATE OR REPLACE FUNCTION faculty_data.institute_insert(
  param_code INTEGER,
  param_name VARCHAR,
  param_user_id BIGINT,
  param_faculty_id INTEGER
)
RETURNS BIT
LANGUAGE plpgsql VOLATILE
COST 100.0
AS $udf$
  DECLARE
    local_is_successful BIT := '0';
    local_institute_id BIGINT;
  BEGIN
    IF EXISTS
    (
      SELECT code
      FROM faculty_data.institutes inst
      WHERE
       inst.code = param_code
      AND
        inst.is_active = '1'
      AND
        inst.is_deleted = '0'
    )
    THEN
      RETURN local_is_successful;
    ELSE
      INSERT INTO faculty_data.institutes(
        code,
        name,
        faculty_id,
        is_active,
        is_deleted,
        last_modified_by,
        last_modified_date
      )
      VALUES(
        param_code,
        param_name,
        param_faculty_id,
        '1',
        '0',
        param_user_id,
        CLOCK_TIMESTAMP()
      )RETURNING id
      INTO STRICT local_institute_id;

    SELECT institute_insert_history INTO local_is_successful FROM faculty_data.institute_insert_history(
      param_institute_id := local_institute_id,
      param_change_type := 'FIRST INSERT',
      param_change_description := 'FIRST INSERT'
    );


    RETURN local_is_successful;
    END IF;
  END;
$udf$;

-- function insert history
CREATE OR REPLACE FUNCTION faculty_data.institute_insert_history(
  param_institute_id BIGINT,
  param_change_type VARCHAR,
  param_change_description VARCHAR
)RETURNS BIT
LANGUAGE plpgsql VOLATILE
COST 100.0
AS $udf$
  DECLARE
    local_is_successful BIT := '0';
  BEGIN
    INSERT INTO faculty_data.institutes_history
    (
      institute_id,
      code,
      name,
      faculty_id,
      is_active,
      is_deleted,
      last_modified_by,
      last_modified_date,
      change_type,
      change_description
    )
    SELECT
      id,
      code,
      name,
      faculty_id,
      is_active,
      is_deleted,
      last_modified_by,
      last_modified_date,
      param_change_type,
      param_change_description
    FROM
      faculty_data.institutes inst
    WHERE
      inst.id = param_institute_id
    ORDER BY
      inst.last_modified_date
    DESC
    LIMIT 1;

    local_is_successful :='1';
    RETURN local_is_successful;
  END;
$udf$;

-- function get all in list
CREATE OR REPLACE FUNCTION faculty_data.get_all_institutes_list(
  param_faculty_id INTEGER
)
RETURNS json
LANGUAGE 'sql'
COST 100.0

AS $BODY$
  SELECT ARRAY_TO_JSON(ARRAY_AGG(ROW_TO_JSON(DATA)))
  FROM (
    SELECT
      inst.id,
      inst.code,
      inst.name as institute
    FROM
      faculty_data.institutes inst
    INNER JOIN
      faculty_data.faculty fac
    ON
      fac.is_active = '1'
    AND
      fac.is_deleted = '0'
    AND
      fac.id = inst.faculty_id
      WHERE
        inst.faculty_id = param_faculty_id
      AND
        inst.is_active = '1'
      AND
        inst.is_deleted = '0'
  )DATA;
$BODY$;

-- function get a institute

CREATE OR REPLACE FUNCTION faculty_data.get_institute(
  param_id INTEGER,
  param_faculty_id INTEGER
)
RETURNS json
LANGUAGE 'sql'
COST 100.0

AS $BODY$
  SELECT ARRAY_TO_JSON(ARRAY_AGG(ROW_TO_JSON(DATA)))
  FROM (
    SELECT
      inst.id,
      inst.code,
      inst.name as institute
    FROM
      faculty_data.institutes inst
    INNER JOIN
      faculty_data.faculty fac
    ON
      fac.is_active = '1'
    AND
      fac.is_deleted = '0'
    AND
      fac.id = inst.faculty_id
      WHERE
        inst.faculty_id = param_faculty_id
      AND
        inst.id = param_id
      AND
        inst.is_active = '1'
      AND
        inst.is_deleted = '0'
  )DATA;
$BODY$;

--function update institute all columns

CREATE OR REPLACE FUNCTION faculty_data.institute_update_all_columns(
  param_id INTEGER,
  param_code INTEGER,
  param_name VARCHAR,
  param_faculty_id INTEGER,
  param_user_id BIGINT,
  param_is_active BIT,
  param_is_deleted BIT
)
RETURNS BIT
LANGUAGE plpgsql VOLATILE
COST 100.0
AS $udf$
  DECLARE
    local_is_successful BIT := '0';
  BEGIN
    UPDATE faculty_data.institutes SET
      name = param_name,
      code = param_code,
      faculty_id = param_faculty_id,
      is_active = param_is_active,
      is_deleted = param_is_deleted,
      last_modified_by = param_user_id,
      last_modified_date = CLOCK_TIMESTAMP()
    WHERE
      id = param_id;

    SELECT institute_insert_history INTO local_is_successful FROM faculty_data.institute_insert_history(
      param_institute_id := param_id,
      param_change_type := 'UPDATE all_columns',
      param_change_description := 'UPDATE value of all columns'
    );


    RETURN local_is_successful;
  END;
$udf$;

-- function update institute is active

CREATE OR REPLACE FUNCTION faculty_data.institute_update_is_active(
  param_id INTEGER,
  param_user_id BIGINT,
  param_is_active BIT
)
RETURNS BIT
LANGUAGE plpgsql VOLATILE
COST 100.0
AS $udf$
  DECLARE
    local_is_successful BIT := '0';
  BEGIN
    UPDATE faculty_data.institutes SET
      is_active = param_is_active,
      last_modified_by = param_user_id,
      last_modified_date = CLOCK_TIMESTAMP()
    WHERE
      id = param_id;

    SELECT institute_insert_history INTO local_is_successful FROM faculty_data.institute_insert_history(
      param_institute_id := param_id,
      param_change_type := 'UPDATE is_active',
      param_change_description := 'UPDATE value of is_active'
    );


    RETURN local_is_successful;
  END;
$udf$;

-- function update institute is deleted

CREATE OR REPLACE FUNCTION faculty_data.institute_update_is_deleted(
  param_id INTEGER,
  param_user_id BIGINT,
  param_is_deleted BIT
)
RETURNS BIT
LANGUAGE plpgsql VOLATILE
COST 100.0
AS $udf$
  DECLARE
    local_is_successful BIT := '0';
  BEGIN
    UPDATE faculty_data.institutes SET
      is_deleted = param_is_deleted,
      last_modified_by = param_user_id,
      last_modified_date = CLOCK_TIMESTAMP()
    WHERE
      id = param_id;

    SELECT institute_insert_history INTO local_is_successful FROM faculty_data.institute_insert_history(
      param_institute_id := param_id,
      param_change_type := 'UPDATE is_deleted',
      param_change_description := 'UPDATE value of is_deleted'
    );


    RETURN local_is_successful;
  END;
$udf$;

-- functions of departaments

-- function of departament insert of the school

CREATE OR REPLACE FUNCTION faculty_data.departament_school_insert(
  param_code INTEGER,
  param_name VARCHAR,
  param_user_id BIGINT,
  param_school_id INTEGER
)
RETURNS BIT
LANGUAGE plpgsql VOLATILE
COST 100.0
AS $udf$
  DECLARE
    local_is_successful BIT := '0';
    local_departament_id BIGINT;
  BEGIN
    IF EXISTS
    (
      SELECT code
      FROM faculty_data.departaments dept
      WHERE
        dept.code = param_code
      AND
        dept.is_active = '1'
      AND
        dept.is_deleted = '0'
    )
    THEN
    RETURN local_is_successful;
    ELSE
      INSERT INTO faculty_data.departaments(
        code,
        name,
        school_id,
        institute_id,
        is_active,
        is_deleted,
        last_modified_by,
        last_modified_date
      )
      VALUES(
        param_code,
        param_name,
        param_school_id,
        null,
        '1',
        '0',
        param_user_id,
        CLOCK_TIMESTAMP()
      )RETURNING id
      INTO STRICT local_departament_id;

    SELECT departament_insert_history INTO local_is_successful FROM faculty_data.departament_insert_history(
      param_departament_id := local_departament_id,
      param_change_type := 'FIRST INSERT',
      param_change_description := 'FIRST INSERT'
    );


    RETURN local_is_successful;
    END IF;
  END;
$udf$;

-- function of departament insert of the institute
CREATE OR REPLACE FUNCTION faculty_data.departament_institute_insert(
  param_code INTEGER,
  param_name VARCHAR,
  param_user_id BIGINT,
  param_institute_id INTEGER
)
RETURNS BIT
LANGUAGE plpgsql VOLATILE
COST 100.0
AS $udf$
  DECLARE
    local_is_successful BIT := '0';
    local_departament_id BIGINT;
  BEGIN
    IF EXISTS
    (
      SELECT code
      FROM faculty_data.departaments dept
      WHERE
        dept.code = param_code
      AND
        dept.is_active = '1'
      AND
        dept.is_deleted = '0'
    )
    THEN
    RETURN local_is_successful;
    ELSE
      INSERT INTO faculty_data.departaments(
        code,
        name,
        school_id,
        institute_id,
        is_active,
        is_deleted,
        last_modified_by,
        last_modified_date
      )
      VALUES(
        param_code,
        param_name,
        null,
        param_institute_id,
        '1',
        '0',
        param_user_id,
        CLOCK_TIMESTAMP()
      )RETURNING id
      INTO local_departament_id;

    SELECT departament_insert_history INTO local_is_successful FROM faculty_data.departament_insert_history(
      param_departament_id := local_departament_id,
      param_change_type := 'FIRST INSERT',
      param_change_description := 'FIRST INSERT'
    );


    RETURN local_is_successful;
    END IF;
  END;
$udf$;

-- function insert history
CREATE OR REPLACE FUNCTION faculty_data.departament_insert_history(
  param_departament_id BIGINT,
  param_change_type VARCHAR,
  param_change_description VARCHAR
)
RETURNS BIT
LANGUAGE plpgsql VOLATILE
COST 100.0
AS $udf$
  DECLARE
    local_is_successful BIT := '0';
  BEGIN
    INSERT INTO faculty_data.departaments_history
    (
      departament_id,
      code,
      name,
      school_id,
      institute_id,
      is_active,
      is_deleted,
      last_modified_by,
      last_modified_date,
      change_type,
      change_description
    )
    SELECT
      id,
      code,
      name,
      school_id,
      institute_id,
      is_active,
      is_deleted,
      last_modified_by,
      last_modified_date,
      param_change_type,
      param_change_description
    FROM
      faculty_data.departaments dept
    WHERE
      dept.id = param_departament_id
    ORDER BY
      dept.last_modified_date
    DESC
    LIMIT 1;

    local_is_successful :='1';
    RETURN local_is_successful;
  END;
$udf$;

-- function of get all the departaments of the school
CREATE OR REPLACE FUNCTION faculty_data.get_all_departaments_school_list(
  param_school_id INTEGER
)
RETURNS json
LANGUAGE 'sql'
COST 100.0

AS $BODY$
  SELECT ARRAY_TO_JSON(ARRAY_AGG(ROW_TO_JSON(DATA)))
  FROM (
    SELECT
      dept.id,
      dept.code,
      dept.name as departament
    FROM
      faculty_data.departaments dept
    INNER JOIN
      faculty_data.schools sch
    ON
      sch.is_active = '1'
    AND
      sch.is_deleted = '0'
    AND
     sch.id = dept.school_id
      WHERE
        dept.school_id = param_school_id
      AND
        dept.is_active = '1'
      AND
        dept.is_deleted = '0'
  )DATA;
$BODY$;

-- function of get all the departaments of the institute

CREATE OR REPLACE FUNCTION faculty_data.get_all_departaments_institute_list(
  param_institute_id INTEGER
)
RETURNS json
LANGUAGE 'sql'
COST 100.0

AS $BODY$
  SELECT ARRAY_TO_JSON(ARRAY_AGG(ROW_TO_JSON(DATA)))
  FROM (
    SELECT
      dept.id,
      dept.code,
      dept.name as departament
    FROM
      faculty_data.departaments dept
    INNER JOIN
      faculty_data.institutes inst
    ON
      inst.is_active = '1'
    AND
      inst.is_deleted = '0'
    AND
     inst.id = dept.institute_id
      WHERE
        dept.institute_id = param_institute_id
      AND
        dept.is_active = '1'
      AND
        dept.is_deleted = '0'
  )DATA;
$BODY$;

-- function of get one departament of the school

CREATE OR REPLACE FUNCTION faculty_data.get_departament_school(
  param_id INTEGER,
  param_school_id INTEGER
)
RETURNS json
LANGUAGE 'sql'
COST 100.0

AS $BODY$
  SELECT ARRAY_TO_JSON(ARRAY_AGG(ROW_TO_JSON(DATA)))
  FROM (
    SELECT
      dept.id,
      dept.code,
      dept.name as departament
    FROM
      faculty_data.departaments dept
    INNER JOIN
      faculty_data.schools sch
    ON
      sch.is_active = '1'
    AND
      sch.is_deleted = '0'
    AND
      sch.id = dept.school_id
      WHERE
        dept.school_id = param_school_id
      AND
        dept.id = param_id
      AND
        dept.is_active = '1'
      AND
        dept.is_deleted = '0'
  )DATA;
$BODY$;

-- function of get one departament of the institute

CREATE OR REPLACE FUNCTION faculty_data.get_departament_institute(
  param_id INTEGER,
  param_institute_id INTEGER
)
RETURNS json
LANGUAGE 'sql'
COST 100.0

AS $BODY$
  SELECT ARRAY_TO_JSON(ARRAY_AGG(ROW_TO_JSON(DATA)))
  FROM (
    SELECT
      dept.id,
      dept.code,
      dept.name as departament
    FROM
      faculty_data.departaments dept
    INNER JOIN
      faculty_data.institutes inst
    ON
      inst.is_active = '1'
    AND
      inst.is_deleted = '0'
    AND
      inst.id = dept.institute_id
      WHERE
        dept.institute_id = param_institute_id
      AND
        dept.id = param_id
      AND
        dept.is_active = '1'
      AND
        dept.is_deleted = '0'
  )DATA;
$BODY$;

-- function departament of school update all columns

CREATE OR REPLACE FUNCTION faculty_data.departament_school_update_all_columns(
  param_id INTEGER,
  param_code INTEGER,
  param_name VARCHAR,
  param_school_id INTEGER,
  param_user_id BIGINT,
  param_is_active BIT,
  param_is_deleted BIT
)
RETURNS BIT
LANGUAGE plpgsql VOLATILE
COST 100.0
AS $udf$
  DECLARE
    local_is_successful BIT := '0';
  BEGIN
    UPDATE faculty_data.departaments SET
      name = param_name,
      code = param_code,
      school_id = param_school_id,
      is_active = param_is_active,
      is_deleted = param_is_deleted,
      last_modified_by = param_user_id,
      last_modified_date = CLOCK_TIMESTAMP()
    WHERE
      id = param_id;

    SELECT departament_insert_history INTO local_is_successful FROM faculty_data.departament_insert_history(
      param_departament_id := param_id,
      param_change_type := 'UPDATE all_columns',
      param_change_description := 'UPDATE value of all columns'
    );


    RETURN local_is_successful;
  END;
$udf$;

-- function departament of school update is active

CREATE OR REPLACE FUNCTION faculty_data.departament_school_update_is_active(
  param_id INTEGER,
  param_school_id INTEGER,
  param_user_id BIGINT,
  param_is_active BIT
)
RETURNS BIT
LANGUAGE plpgsql VOLATILE
COST 100.0
AS $udf$
  DECLARE
    local_is_successful BIT := '0';
  BEGIN
    UPDATE faculty_data.departaments SET
      is_active = param_is_active,
      last_modified_by = param_user_id,
      last_modified_date = CLOCK_TIMESTAMP()
    WHERE
      id = param_id
    AND
      school_id = param_school_id;

    SELECT departament_insert_history INTO local_is_successful FROM faculty_data.departament_insert_history(
      param_departament_id := param_id,
      param_change_type := 'UPDATE is_active',
      param_change_description := 'UPDATE value of is_active'
    );


    RETURN local_is_successful;
  END;
$udf$;

-- function departament of school update is deleted

CREATE OR REPLACE FUNCTION faculty_data.departament_school_update_is_deleted(
  param_id INTEGER,
  param_school_id INTEGER,
  param_user_id BIGINT,
  param_is_deleted BIT
)
RETURNS BIT
LANGUAGE plpgsql VOLATILE
COST 100.0
AS $udf$
  DECLARE
    local_is_successful BIT := '0';
  BEGIN
    UPDATE faculty_data.departaments SET
      is_deleted = param_is_deleted,
      last_modified_by = param_user_id,
      last_modified_date = CLOCK_TIMESTAMP()
    WHERE
      id = param_id
    AND
      school_id = param_school_id;

    SELECT departament_insert_history INTO local_is_successful FROM faculty_data.departament_insert_history(
      param_departament_id := param_id,
      param_change_type := 'UPDATE is_deleted',
      param_change_description := 'UPDATE value of is_deleted'
    );


    RETURN local_is_successful;
  END;
$udf$;

-- function departament of institutes update all columns

CREATE OR REPLACE FUNCTION faculty_data.departament_institute_update_all_columns(
  param_id INTEGER,
  param_code INTEGER,
  param_name VARCHAR,
  param_institute_id INTEGER,
  param_user_id BIGINT,
  param_is_active BIT,
  param_is_deleted BIT
)
RETURNS BIT
LANGUAGE plpgsql VOLATILE
COST 100.0
AS $udf$
  DECLARE
    local_is_successful BIT := '0';
  BEGIN
    UPDATE faculty_data.departaments SET
      name = param_name,
      code = param_code,
      institute_id = param_institute_id,
      is_active = param_is_active,
      is_deleted = param_is_deleted,
      last_modified_by = param_user_id,
      last_modified_date = CLOCK_TIMESTAMP()
    WHERE
      id = param_id;

    SELECT departament_insert_history INTO local_is_successful FROM faculty_data.departament_insert_history(
      param_departament_id := param_id,
      param_change_type := 'UPDATE all_columns',
      param_change_description := 'UPDATE value of all columns'
    );


    RETURN local_is_successful;
  END;
$udf$;

-- function departament of school update is active

CREATE OR REPLACE FUNCTION faculty_data.departament_institute_update_is_active(
  param_id INTEGER,
  param_institute_id INTEGER,
  param_user_id BIGINT,
  param_is_active BIT
)
RETURNS BIT
LANGUAGE plpgsql VOLATILE
COST 100.0
AS $udf$
  DECLARE
    local_is_successful BIT := '0';
  BEGIN
    UPDATE faculty_data.departaments SET
      is_active = param_is_active,
      last_modified_by = param_user_id,
      last_modified_date = CLOCK_TIMESTAMP()
    WHERE
      id = param_id
    AND
      institute_id = param_institute_id;

    SELECT departament_insert_history INTO local_is_successful FROM faculty_data.departament_insert_history(
      param_departament_id := param_id,
      param_change_type := 'UPDATE is_active',
      param_change_description := 'UPDATE value of is_active'
    );


    RETURN local_is_successful;
  END;
$udf$;

-- function departament of school update is deleted

CREATE OR REPLACE FUNCTION faculty_data.departament_institute_update_is_deleted(
  param_id INTEGER,
  param_institute_id INTEGER,
  param_user_id BIGINT,
  param_is_deleted BIT
)
RETURNS BIT
LANGUAGE plpgsql VOLATILE
COST 100.0
AS $udf$
  DECLARE
    local_is_successful BIT := '0';
  BEGIN
    UPDATE faculty_data.departaments SET
      is_deleted = param_is_deleted,
      last_modified_by = param_user_id,
      last_modified_date = CLOCK_TIMESTAMP()
    WHERE
      id = param_id
    AND
      institute_id = param_institute_id;

    SELECT departament_insert_history INTO local_is_successful FROM faculty_data.departament_insert_history(
      param_departament_id := param_id,
      param_change_type := 'UPDATE is_deleted',
      param_change_description := 'UPDATE value of is_deleted'
    );


    RETURN local_is_successful;
  END;
$udf$;

-- functions of faculty_data.coordinations

--function of insert

CREATE OR REPLACE FUNCTION faculty_data.coordination_insert(
  param_code INTEGER,
  param_name VARCHAR,
  param_user_id BIGINT,
  param_faculty_id INTEGER
)
RETURNS BIT
LANGUAGE plpgsql VOLATILE
COST 100.0
AS $udf$
  DECLARE
    local_is_successful BIT := '0';
    local_coordination_id BIGINT;
  BEGIN
    IF EXISTS
    (
      SELECT coord.code
      FROM faculty_data.coordinations coord
      WHERE
        coord.code = param_code
      AND
        coord.is_active = '1'
      AND
        coord.is_deleted = '0'
    )
    THEN
      RETURN local_is_successful;
    ELSE
      INSERT INTO faculty_data.coordinations(
        code,
        name,
        faculty_id,
        is_active,
        is_deleted,
        last_modified_by,
        last_modified_date
      )
      VALUES
      (
        param_code,
        param_name,
        param_faculty_id,
        '1',
        '0',
        param_user_id,
        CLOCK_TIMESTAMP()
      )RETURNING id
      INTO STRICT local_coordination_id;

      SELECT coordination_insert_history INTO local_is_successful FROM faculty_data.coordination_insert_history(
        param_coordination_id := local_coordination_id,
        param_change_type := 'FIRST INSERT',
        param_change_description := 'FIRST INSERT'
      );


    RETURN local_is_successful;
    END IF;
  END;
$udf$;

-- function insert history
CREATE OR REPLACE FUNCTION faculty_data.coordination_insert_history(
  param_coordination_id BIGINT,
  param_change_type VARCHAR,
  param_change_description VARCHAR
)RETURNS BIT
LANGUAGE plpgsql VOLATILE
COST 100.0
AS $udf$
  DECLARE
    local_is_successful BIT := '0';
  BEGIN
    INSERT INTO faculty_data.coordinations_history
    (
      coordination_id,
      code,
      name,
      is_active,
      is_deleted,
      last_modified_by,
      last_modified_date,
      change_type,
      change_description
    )
    SELECT
      id,
      code,
      name,
      is_active,
      is_deleted,
      last_modified_by,
      last_modified_date,
      param_change_type,
      param_change_description
    FROM
      faculty_data.coordinations coord
    WHERE
      coord.id = param_coordination_id
    ORDER BY
      coord.last_modified_date
    DESC
    LIMIT 1;

    local_is_successful :='1';
    RETURN local_is_successful;
  END;
$udf$;

-- function get all coordinations

CREATE OR REPLACE FUNCTION faculty_data.get_all_coordinations_list(
  param_faculty_id INTEGER
)
RETURNS json
LANGUAGE 'sql'
COST 100.0

AS $BODY$
  SELECT ARRAY_TO_JSON(ARRAY_AGG(ROW_TO_JSON(DATA)))
  FROM (
    SELECT
      coord.id,
      coord.code,
      coord.name as coordination
    FROM
      faculty_data.coordinations coord
    INNER JOIN
      faculty_data.faculty fac
    ON
      fac.is_active = '1'
    AND
      fac.is_deleted = '0'
    AND
      fac.id = coord.faculty_id
      WHERE
        coord.faculty_id = param_faculty_id
      AND
        coord.is_active = '1'
      AND
        coord.is_deleted = '0'
  )DATA;
$BODY$;

-- function get one coordinations

CREATE OR REPLACE FUNCTION faculty_data.get_coordination(
  param_id INTEGER,
  param_faculty_id INTEGER
)
RETURNS json
LANGUAGE 'sql'
COST 100.0

AS $BODY$
  SELECT ARRAY_TO_JSON(ARRAY_AGG(ROW_TO_JSON(DATA)))
  FROM (
    SELECT
      coord.id,
      coord.code,
      coord.name as coordination
    FROM
      faculty_data.coordinations coord
    INNER JOIN
      faculty_data.faculty fac
    ON
      fac.is_active = '1'
    AND
      fac.is_deleted = '0'
    AND
      fac.id = coord.faculty_id
      WHERE
       coord.faculty_id = param_faculty_id
      AND
        coord.id = param_id
      AND
        coord.is_active = '1'
      AND
        coord.is_deleted = '0'
  )DATA;
$BODY$;


--function update coordnation all columns

CREATE OR REPLACE FUNCTION faculty_data.coordination_update_all_columns(
  param_id INTEGER,
  param_code INTEGER,
  param_name VARCHAR,
  param_faculty_id INTEGER,
  param_user_id BIGINT,
  param_is_active BIT,
  param_is_deleted BIT
)
RETURNS BIT
LANGUAGE plpgsql VOLATILE
COST 100.0
AS $udf$
  DECLARE
    local_is_successful BIT := '0';
  BEGIN
    UPDATE faculty_data.coordinations SET
      name = param_name,
      code = param_code,
      faculty_id = param_faculty_id,
      is_active = param_is_active,
      is_deleted = param_is_deleted,
      last_modified_by = param_user_id,
      last_modified_date = CLOCK_TIMESTAMP()
    WHERE
      id = param_id;

    SELECT coordination_insert_history INTO local_is_successful FROM faculty_data.coordination_insert_history(
      param_coordination_id := param_id,
      param_change_type := 'UPDATE all_columns',
      param_change_description := 'UPDATE value of all columns'
    );


    RETURN local_is_successful;
  END;
$udf$;

--function update coordination is active

CREATE OR REPLACE FUNCTION faculty_data.coordination_update_is_active(
  param_id INTEGER,
  param_user_id BIGINT,
  param_is_active BIT
)
RETURNS BIT
LANGUAGE plpgsql VOLATILE
COST 100.0
AS $udf$
  DECLARE
    local_is_successful BIT := '0';
  BEGIN
    UPDATE faculty_data.coordinations SET
      is_active = param_is_active,
      last_modified_by = param_user_id,
      last_modified_date = CLOCK_TIMESTAMP()
    WHERE
      id = param_id;

    SELECT coordination_insert_history INTO local_is_successful FROM faculty_data.coordination_insert_history(
      param_coordination_id := param_id,
      param_change_type := 'UPDATE is_active',
      param_change_description := 'UPDATE value of is_active'
    );


    RETURN local_is_successful;
  END;
$udf$;

--function update school is deleted

CREATE OR REPLACE FUNCTION faculty_data.coordination_update_is_deleted(
  param_id INTEGER,
  param_user_id BIGINT,
  param_is_deleted BIT
)
RETURNS BIT
LANGUAGE plpgsql VOLATILE
COST 100.0
AS $udf$
  DECLARE
    local_is_successful BIT := '0';
  BEGIN
    UPDATE faculty_data.coordinations SET
      is_deleted = param_is_deleted,
      last_modified_by = param_user_id,
      last_modified_date = CLOCK_TIMESTAMP()
    WHERE
      id = param_id;

    SELECT coordination_insert_history INTO local_is_successful FROM faculty_data.coordination_insert_history(
      param_coordination_id := param_id,
      param_change_type := 'UPDATE is_deleted',
      param_change_description := 'UPDATE value of is_deleted'
    );


    RETURN local_is_successful;
  END;
$udf$;

-- functions of chairs

-- function of insert

CREATE OR REPLACE FUNCTION faculty_data.chair_insert(
  param_code INTEGER,
  param_name VARCHAR,
  param_user_id BIGINT,
  param_departament_id INTEGER
)
RETURNS BIT
LANGUAGE plpgsql VOLATILE
COST 100.0
AS $udf$
  DECLARE
    local_is_successful BIT := '0';
    local_chair_id BIGINT;
  BEGIN
    IF EXISTS
    (
      SELECT cha.code
      FROM faculty_data.chairs cha
      WHERE
        cha.code = param_code
      AND
        cha.is_active = '1'
      AND
        cha.is_deleted = '0'
    )
    THEN
      RETURN local_is_successful;
    ELSE
      INSERT INTO faculty_data.chairs(
        code,
        name,
        departament_id,
        is_active,
        is_deleted,
        last_modified_by,
        last_modified_date
      )
      VALUES(
        param_code,
        param_name,
        param_departament_id,
        '1',
        '0',
        param_user_id,
        CLOCK_TIMESTAMP()
      )
      RETURNING id
      INTO STRICT local_chair_id;

      SELECT chair_insert_history INTO local_is_successful FROM faculty_data.chair_insert_history(
        param_chair_id := local_chair_id,
        param_change_type := 'FIRST INSERT',
        param_change_description := 'FIRST INSERT'
      );


    RETURN local_is_successful;
    END IF;
  END;
$udf$;

-- function insert history
CREATE OR REPLACE FUNCTION faculty_data.chair_insert_history(
  param_chair_id BIGINT,
  param_change_type VARCHAR,
  param_change_description VARCHAR
)RETURNS BIT
LANGUAGE plpgsql VOLATILE
COST 100.0
AS $udf$
  DECLARE
    local_is_successful BIT := '0';
  BEGIN
    INSERT INTO faculty_data.chairs_history
    (
      chair_id,
      code,
      name,
      departament_id,
      is_active,
      is_deleted,
      last_modified_by,
      last_modified_date,
      change_type,
      change_description
    )
    SELECT
      id,
      code,
      name,
      departament_id,
      is_active,
      is_deleted,
      last_modified_by,
      last_modified_date,
      param_change_type,
      param_change_description
    FROM
      faculty_data.chairs cha
    WHERE
      cha.id = param_chair_id
    ORDER BY
      cha.last_modified_date
    DESC
    LIMIT 1;

    local_is_successful :='1';
    RETURN local_is_successful;
  END;
$udf$;

-- function get all the chairs
CREATE OR REPLACE FUNCTION faculty_data.get_all_chairs_list(
  param_departament_id INTEGER
)
RETURNS json
LANGUAGE 'sql'
COST 100.0

AS $BODY$
  SELECT ARRAY_TO_JSON(ARRAY_AGG(ROW_TO_JSON(DATA)))
  FROM (
    SELECT
      cha.id,
      cha.code,
      cha.name as chair
    FROM
      faculty_data.chairs cha
    INNER JOIN
      faculty_data.departaments dept
    ON
      dept.is_active = '1'
    AND
      dept.is_deleted = '0'
    AND
      dept.id = cha.departament_id
      WHERE
        cha.departament_id = param_departament_id
      AND
        cha.is_active = '1'
      AND
        cha.is_deleted = '0'
  )DATA;
$BODY$;

-- function get a cahirs

CREATE OR REPLACE FUNCTION faculty_data.get_chair(
  param_id INTEGER,
  param_departament_id INTEGER
)
RETURNS json
LANGUAGE 'sql'
COST 100.0

AS $BODY$
  SELECT ARRAY_TO_JSON(ARRAY_AGG(ROW_TO_JSON(DATA)))
  FROM (
    SELECT
      cha.id,
      cha.code,
      cha.name as chair
    FROM
      faculty_data.chairs cha
    INNER JOIN
      faculty_data.departaments dept
    ON
      dept.is_active = '1'
    AND
      dept.is_deleted = '0'
    AND
      dept.id = cha.departament_id
      WHERE
      cha.departament_id = param_departament_id
      AND
        cha.id = param_id
      AND
        cha.is_active = '1'
      AND
        cha.is_deleted = '0'
  )DATA;
$BODY$;

-- function update all columns

CREATE OR REPLACE FUNCTION faculty_data.chair_update_all_columns(
  param_id INTEGER,
  param_code INTEGER,
  param_name VARCHAR,
  param_departament_id INTEGER,
  param_user_id BIGINT,
  param_is_active BIT,
  param_is_deleted BIT
)
RETURNS BIT
LANGUAGE plpgsql VOLATILE
COST 100.0
AS $udf$
  DECLARE
    local_is_successful BIT := '0';
  BEGIN
    UPDATE faculty_data.chairs SET
      name = param_name,
      code = param_code,
      departament_id = param_departament_id,
      is_active = param_is_active,
      is_deleted = param_is_deleted,
      last_modified_by = param_user_id,
      last_modified_date = CLOCK_TIMESTAMP()
    WHERE
      id = param_id;

    SELECT chair_insert_history INTO local_is_successful FROM faculty_data.chair_insert_history(
      param_chair_id := param_id,
      param_change_type := 'UPDATE all_columns',
      param_change_description := 'UPDATE value of all columns'
    );


    RETURN local_is_successful;
  END;
$udf$;

-- function update is active

CREATE OR REPLACE FUNCTION faculty_data.chair_update_is_active(
  param_id INTEGER,
  param_departament_id INTEGER,
  param_user_id BIGINT,
  param_is_active BIT
)
RETURNS BIT
LANGUAGE plpgsql VOLATILE
COST 100.0
AS $udf$
  DECLARE
    local_is_successful BIT := '0';
  BEGIN
    UPDATE faculty_data.chairs SET
      is_active = param_is_active,
      last_modified_by = param_user_id,
      last_modified_date = CLOCK_TIMESTAMP()
    WHERE
      id = param_id
    AND
      departament_id = param_departament_id;

    SELECT chair_insert_history INTO local_is_successful FROM faculty_data.chair_insert_history(
      param_chair_id := param_id,
      param_change_type := 'UPDATE is_active',
      param_change_description := 'UPDATE value of is_active'
    );


    RETURN local_is_successful;
  END;
$udf$;

-- function departament of school update is deleted

CREATE OR REPLACE FUNCTION faculty_data.chair_update_is_deleted(
  param_id INTEGER,
  param_departament_id INTEGER,
  param_user_id BIGINT,
  param_is_deleted BIT
)
RETURNS BIT
LANGUAGE plpgsql VOLATILE
COST 100.0
AS $udf$
  DECLARE
    local_is_successful BIT := '0';
  BEGIN
    UPDATE faculty_data.cahirs SET
      is_deleted = param_is_deleted,
      last_modified_by = param_user_id,
      last_modified_date = CLOCK_TIMESTAMP()
    WHERE
      id = param_id
    AND
      departament_id = param_departament_id;

    SELECT chair_insert_history INTO local_is_successful FROM faculty_data.chair_insert_history(
      param_chair_id := param_id,
      param_change_type := 'UPDATE is_deleted',
      param_change_description := 'UPDATE value of is_deleted'
    );


    RETURN local_is_successful;
  END;
$udf$;

-- functions of faculty table

-- function insert

CREATE OR REPLACE FUNCTION faculty_data.faculty_insert(
  param_code INTEGER,
  param_name VARCHAR,
  param_user_id BIGINT
)
RETURNS BIT
LANGUAGE plpgsql VOLATILE
COST 100.0
AS $udf$
  DECLARE
    local_is_successful BIT := '0';
    local_faculty_id BIGINT;
  BEGIN
    IF EXISTS
    (
      SELECT code
      FROM faculty_data.faculty fac
      WHERE
        fac.code = param_code
      AND
        fac.is_active = '1'
      AND
        fac.is_deleted = '0'
    )
    THEN
      RETURN local_is_successful;
    ELSE
      INSERT INTO faculty_data.faculty(
        code,
        name,
        is_active,
        is_deleted,
        last_modified_by,
        last_modified_date
      )
      VALUES(
        param_code,
        param_name,
        '1',
        '0',
        param_user_id,
        CLOCK_TIMESTAMP()
      )
      RETURNING id
      INTO STRICT local_faculty_id;

      SELECT faculty_insert_history INTO local_is_successful FROM faculty_data.faculty_insert_history(
        param_faculty_id := local_faculty_id,
        param_change_type := 'FIRST INSERT',
        param_change_description := 'FIRST INSERT'
      );


    RETURN local_is_successful;
    END IF;
  END;
$udf$;

-- function insert history
CREATE OR REPLACE FUNCTION faculty_data.faculty_insert_history(
  param_faculty_id BIGINT,
  param_change_type VARCHAR,
  param_change_description VARCHAR
)RETURNS BIT
LANGUAGE plpgsql VOLATILE
COST 100.0
AS $udf$
  DECLARE
    local_is_successful BIT := '0';
  BEGIN
    INSERT INTO faculty_data.faculty_history
    (
      faculty_id,
      code,
      name,
      is_active,
      is_deleted,
      last_modified_by,
      last_modified_date,
      change_type,
      change_description
    )
    SELECT
      id,
      code,
      name,
      is_active,
      is_deleted,
      last_modified_by,
      last_modified_date,
      param_change_type,
      param_change_description
    FROM
      faculty_data.faculty fac
    WHERE
      fac.id = param_faculty_id
    ORDER BY
      fac.last_modified_date
    DESC
    LIMIT 1;

    local_is_successful :='1';
    RETURN local_is_successful;
  END;
$udf$;

-- function get all data

CREATE OR REPLACE FUNCTION faculty_data.get_all_facultys_list()
RETURNS json
LANGUAGE 'sql'
COST 100.0

AS $BODY$
  SELECT ARRAY_TO_JSON(ARRAY_AGG(ROW_TO_JSON(DATA)))
  FROM (
    SELECT
      id,
      code,
      name as faculty
    FROM
      faculty_data.faculty fac
    WHERE
      fac.is_active = '1'
    AND
      fac.is_deleted = '0'
  )DATA;
$BODY$;

-- function get a faculty

CREATE OR REPLACE FUNCTION faculty_data.get_faculty(
  param_id INTEGER
)
RETURNS json
LANGUAGE 'sql'
COST 100.0

AS $BODY$
  SELECT ARRAY_TO_JSON(ARRAY_AGG(ROW_TO_JSON(DATA)))
  FROM (
    SELECT
      id,
      code,
      name as faculty
    FROM
      faculty_data.faculty fac
    WHERE
      fac.id = param_id
    AND
      fac.is_active = '1'
    AND
      fac.is_deleted = '0'
  )DATA;
$BODY$;

-- function update all columns

CREATE OR REPLACE FUNCTION faculty_data.faculty_update_all_columns(
  param_id INTEGER,
  param_code INTEGER,
  param_name VARCHAR,
  param_user_id BIGINT,
  param_is_active BIT,
  param_is_deleted BIT
)
RETURNS BIT
LANGUAGE plpgsql VOLATILE
COST 100.0
AS $udf$
  DECLARE
    local_is_successful BIT := '0';
  BEGIN
    UPDATE faculty_data.faculty SET
      name = param_name,
      code = param_code,
      is_active = param_is_active,
      is_deleted = param_is_deleted,
      last_modified_by = param_user_id,
      last_modified_date = CLOCK_TIMESTAMP()
    WHERE
      id = param_id;

    SELECT faculty_insert_history INTO local_is_successful FROM faculty_data.faculty_insert_history(
      param_faculty_id := param_id,
      param_change_type := 'UPDATE all_columns',
      param_change_description := 'UPDATE value of all columns'
    );


    RETURN local_is_successful;
  END;
$udf$;

-- function update is active

CREATE OR REPLACE FUNCTION faculty_data.faculty_update_is_active(
  param_id INTEGER,
  param_user_id BIGINT,
  param_is_active BIT
)
RETURNS BIT
LANGUAGE plpgsql VOLATILE
COST 100.0
AS $udf$
  DECLARE
    local_is_successful BIT := '0';
  BEGIN
    UPDATE faculty_data.faculty SET
      is_active = param_is_active,
      last_modified_by = param_user_id,
      last_modified_date = CLOCK_TIMESTAMP()
    WHERE
      id = param_id;

    SELECT faculty_insert_history INTO local_is_successful FROM faculty_data.faculty_insert_history(
      param_faculty_id := param_id,
      param_change_type := 'UPDATE is_active',
      param_change_description := 'UPDATE value of is_active'
    );


    RETURN local_is_successful;
  END;
$udf$;

-- function update is deleted

CREATE OR REPLACE FUNCTION faculty_data.faculty_update_is_deleted(
  param_id INTEGER,
  param_user_id BIGINT,
  param_is_deleted BIT
)
RETURNS BIT
LANGUAGE plpgsql VOLATILE
COST 100.0
AS $udf$
  DECLARE
    local_is_successful BIT := '0';
  BEGIN
    UPDATE faculty_data.faculty SET
      is_deleted = param_is_deleted,
      last_modified_by = param_user_id,
      last_modified_date = CLOCK_TIMESTAMP()
    WHERE
      id = param_id;

    SELECT faculty_insert_history INTO local_is_successful FROM faculty_data.faculty_insert_history(
      param_faculty_id := param_id,
      param_change_type := 'UPDATE is_deleted',
      param_change_description := 'UPDATE value of is_deleted'
    );


    RETURN local_is_successful;
  END;
$udf$;
