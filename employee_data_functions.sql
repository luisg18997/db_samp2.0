 --functions of states

--function of insert
CREATE OR REPLACE FUNCTION employee_data.state_insert(
	param_name VARCHAR,
	param_user_id BIGINT
)
RETURNS BIT
LANGUAGE plpgsql VOLATILE
COST 100.0
AS $udf$
	DECLARE
		local_is_successful BIT := '0';
		local_state_id BIGINT;
	BEGIN
		INSERT INTO employee_data.states(
			name,
			is_active,
			is_deleted,
			last_modified_by,
			last_modified_date
		)
		VALUES(
			param_name,
			'1',
			'0',
			param_user_id,
			CLOCK_TIMESTAMP()
		)
		RETURNING id
      	INTO STRICT local_state_id;

      	SELECT state_insert_history into local_is_successful FROM employee_data.state_insert_history(
      		param_state_id := local_state_id,
      		param_change_type := 'FIRST INSERT',
      		param_change_description := 'FIRST INSERT'
      	);

    	RETURN local_is_successful;
    END;
$udf$;



--function of insert log
CREATE OR REPLACE FUNCTION employee_data.state_insert_history(
  param_state_id BIGINT,
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
  	INSERT INTO employee_data.states_history
  	(
  		state_id,
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
  		name,
		is_active,
		is_deleted,
		last_modified_by,
		last_modified_date,
		param_change_type,
		param_change_description
	FROM
		employee_data.states st
	WHERE
		st.id = param_state_id
	ORDER BY
		st.last_modified_date
	DESC
	LIMIT 1;

	local_is_successful := '1';
    RETURN local_is_successful;
  END;
$udf$;

-- funciton of list
CREATE OR REPLACE FUNCTION employee_data.get_states_list()
RETURNS json
LANGUAGE 'sql'
COST 100.0

AS $BODY$
	SELECT ARRAY_TO_JSON(ARRAY_AGG(ROW_TO_JSON(DATA)))
	FROM (
		SELECT
			st.id,
			st.name as state
		FROM
			employee_data.states st
		WHERE
			st.is_active = '1'
		AND
			st.is_deleted = '0'
	)DATA;
$BODY$;

--function get one data
CREATE OR REPLACE FUNCTION employee_data.get_state(
	param_id INTEGER
)
RETURNS json
LANGUAGE 'sql'
COST 100.0

AS $BODY$
	SELECT ARRAY_TO_JSON(ARRAY_AGG(ROW_TO_JSON(DATA)))
	FROM (
		SELECT
			st.id,
			st.name as state
		FROM
			employee_data.states st
		WHERE
			st.id = param_id
		AND
			st.is_active = '1'
		AND
			st.is_deleted = '0'
	)DATA;
$BODY$;

-- function update all columns
CREATE OR REPLACE FUNCTION employee_data.state_update_all_columns(
	param_id INTEGER,
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
  		UPDATE employee_data.states SET
  			name = param_name,
  			is_active = param_is_active,
  			is_deleted = param_is_deleted,
  			last_modified_by = param_user_id,
      		last_modified_date = CLOCK_TIMESTAMP()
      	WHERE
      		id = param_id;

      	SELECT state_insert_history into local_is_successful FROM employee_data.state_insert_history(
      		param_state_id := param_id,
      		param_change_type := 'UPDATE all_columns',
      		param_change_description := 'UPDATE value of all columns'
      	);

    	RETURN local_is_successful;
  	END;
$udf$;

-- function update is active
CREATE OR REPLACE FUNCTION employee_data.state_update_is_active(
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
  		UPDATE employee_data.states SET
  			is_active = param_is_active,
  			last_modified_by = param_user_id,
      		last_modified_date = CLOCK_TIMESTAMP()
      	WHERE
      		id = param_id;

      	SELECT state_insert_history into local_is_successful FROM employee_data.state_insert_history(
      		param_state_id := param_id,
      		param_change_type := 'UPDATE is_active',
      		param_change_description := 'UPDATE value of is_active'
      	);

    	RETURN local_is_successful;
  	END;
$udf$;

-- function update is deleted
CREATE OR REPLACE FUNCTION employee_data.state_update_is_deleted(
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
  		UPDATE employee_data.states SET
  			is_deleted = param_is_deleted,
  			last_modified_by = param_user_id,
      		last_modified_date = CLOCK_TIMESTAMP()
      	WHERE
      		id = param_id;

      	SELECT state_insert_history into local_is_successful FROM employee_data.state_insert_history(
      		param_state_id := param_id,
      		param_change_type := 'UPDATE is_deleted',
      		param_change_description := 'UPDATE value of is_deleted'
      	);

    	RETURN local_is_successful;
  	END;
$udf$;

-- functions of municipalities

--function of insert
CREATE OR REPLACE FUNCTION employee_data.municipality_insert(
	param_state_id INTEGER,
	param_name VARCHAR,
	param_user_id BIGINT
)
RETURNS BIT
LANGUAGE plpgsql VOLATILE
COST 100.0
AS $udf$
	DECLARE
		local_is_successful BIT := '0';
		local_municipality_id BIGINT;
	BEGIN
		INSERT INTO employee_data.municipalities(
			state_id,
			name,
			is_active,
			is_deleted,
			last_modified_by,
			last_modified_date
		)
		VALUES(
			param_state_id,
			param_name,
			'1',
			'0',
			param_user_id,
			CLOCK_TIMESTAMP()
		)
		RETURNING id
		INTO STRICT local_municipality_id;

		SELECT municipality_insert_history into local_is_successful FROM employee_data.municipality_insert_history(
      		param_municipality_id := local_municipality_id,
      		param_change_type := 'FIRST INSERT',
      		param_change_description := 'FIRST INSERT'
      	);

    	RETURN local_is_successful;
    END;
$udf$;


--function of insert log
CREATE OR REPLACE FUNCTION employee_data.municipality_insert_history(
  param_municipality_id BIGINT,
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
  	INSERT INTO employee_data.municipalities_history
  	(
  		municipality_id,
  		state_id,
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
  		state_id,
  		name,
		is_active,
		is_deleted,
		last_modified_by,
		last_modified_date,
		param_change_type,
		param_change_description
	FROM
		employee_data.municipalities mun
	WHERE
		mun.id = param_municipality_id
	ORDER BY
		mun.last_modified_date
	DESC
	LIMIT 1;
	local_is_successful := '1';
    RETURN local_is_successful;
  END;
$udf$;

-- funciton of list
CREATE OR REPLACE FUNCTION employee_data.get_municipalities_list(
	param_state_id INTEGER
)
RETURNS json
LANGUAGE 'sql'
COST 100.0

AS $BODY$
	SELECT ARRAY_TO_JSON(ARRAY_AGG(ROW_TO_JSON(DATA)))
	FROM (
		SELECT
			mun.id,
			mun.name as municipality
		FROM
			employee_data.municipalities mun
		INNER JOIN
			employee_data.states st
		ON
			st.id = mun.state_id
		AND
			st.is_active = '1'
		AND
			st.is_deleted = '0'
			WHERE
				mun.state_id = param_state_id
			AND
				mun.is_active = '1'
			AND
				mun.is_deleted = '0'
	)DATA;
$BODY$;

--function get one data
CREATE OR REPLACE FUNCTION employee_data.get_state(
	param_id INTEGER,
	param_state_id INTEGER
)
RETURNS json
LANGUAGE 'sql'
COST 100.0

AS $BODY$
	SELECT ARRAY_TO_JSON(ARRAY_AGG(ROW_TO_JSON(DATA)))
	FROM (
		SELECT
			mun.id,
			mun.name as municipality
		FROM
			employee_data.municipalities mun
		INNER JOIN
			employee_data.states st
		ON
			st.id = mun.state_id
		AND
			st.is_active = '1'
		AND
			st.is_deleted = '0'
			WHERE
				mun.state_id = param_state_id
			AND
				mun.id = param_id
			AND
				mun.is_active = '1'
			AND
				mun.is_deleted = '0'
	)DATA;
$BODY$;

-- function update all columns
CREATE OR REPLACE FUNCTION employee_data.municipality_update_all_columns(
	param_id INTEGER,
	param_name VARCHAR,
	param_state_id INTEGER,
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
  		UPDATE employee_data.states SET
  			name = param_name,
  			is_active = param_is_active,
  			is_deleted = param_is_deleted,
  			last_modified_by = param_user_id,
      		last_modified_date = CLOCK_TIMESTAMP()
      	WHERE
      		id = param_id
      	AND
      		state_id = param_state_id;

      	SELECT municipality_insert_history into local_is_successful FROM employee_data.municipality_insert_history(
      		param_municipality_id := param_id,
      		param_change_type := 'UPDATE all_columns',
      		param_change_description := 'UPDATE value of all columns'
      	);

    	RETURN local_is_successful;
  	END;
$udf$;

-- function update is active
CREATE OR REPLACE FUNCTION employee_data.municipality_update_is_active(
	param_id INTEGER,
	param_state_id INTEGER,
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
  		UPDATE employee_data.municipalities SET
  			is_active = param_is_active,
  			last_modified_by = param_user_id,
      		last_modified_date = CLOCK_TIMESTAMP()
      	WHERE
      		id = param_id
      	AND
      		state_id = param_state_id;

      	SELECT municipality_insert_history into local_is_successful FROM employee_data.municipality_insert_history(
      		param_municipality_id := param_id,
      		param_change_type := 'UPDATE is_active',
      		param_change_description := 'UPDATE value of is_active'
      	);


    	RETURN local_is_successful;
  	END;
$udf$;

-- function update is deleted
CREATE OR REPLACE FUNCTION employee_data.municipality_update_is_deleted(
	param_id INTEGER,
	param_state_id INTEGER,
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
  		UPDATE employee_data.municipalities SET
  			is_deleted = param_is_deleted,
  			last_modified_by = param_user_id,
      		last_modified_date = CLOCK_TIMESTAMP()
      	WHERE
      		id = param_id
      	AND
      		state_id = param_state_id;

      	SELECT municipality_insert_history into local_is_successful FROM employee_data.municipality_insert_history(
      		param_municipality_id := param_id,
      		param_change_type := 'UPDATE is_deleted',
      		param_change_description := 'UPDATE value of is_deleted'
      	);


    	RETURN local_is_successful;
  	END;
$udf$;

-- functions of parish

--function of insert
CREATE OR REPLACE FUNCTION employee_data.parish_insert(
	param_municipality_id INTEGER,
	param_name VARCHAR,
	param_user_id BIGINT
)
RETURNS BIT
LANGUAGE plpgsql VOLATILE
COST 100.0
AS $udf$
	DECLARE
		local_is_successful BIT := '0';
		local_parish_id BIGINT;
	BEGIN
		INSERT INTO employee_data.parish(
			municipality_id,
			name,
			is_active,
			is_deleted,
			last_modified_by,
			last_modified_date
		)
		VALUES(
			param_municipality_id,
			param_name,
			'1',
			'0',
			param_user_id,
			CLOCK_TIMESTAMP()
		)
		RETURNING id
		INTO STRICT local_parish_id;

		SELECT parish_insert_history into local_is_successful FROM employee_data.parish_insert_history(
      		param_parish_id := local_parish_id,
      		param_change_type := 'FIRST INSERT',
      		param_change_description := 'FIRST INSERT'
      	);


    	RETURN local_is_successful;
    END;
$udf$;

--function of insert log
CREATE OR REPLACE FUNCTION employee_data.parish_insert_history(
  param_parish_id BIGINT,
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
  	INSERT INTO employee_data.parish_history
  	(
  		parish_id,
  		municipality_id,
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
  		municipality_id,
  		name,
		is_active,
		is_deleted,
		last_modified_by,
		last_modified_date,
		param_change_type,
		param_change_description
	FROM
		employee_data.parish par
	WHERE
		par.id = param_parish_id
	ORDER BY
		par.last_modified_date
	DESC
	LIMIT 1;
	local_is_successful := '1';
    RETURN local_is_successful;
  END;
$udf$;

-- funciton of list
CREATE OR REPLACE FUNCTION employee_data.get_parish_list(
	param_municipality_id INTEGER
)
RETURNS json
LANGUAGE 'sql'
COST 100.0

AS $BODY$
	SELECT ARRAY_TO_JSON(ARRAY_AGG(ROW_TO_JSON(DATA)))
	FROM (
		SELECT
			par.id,
			par.name as parish
		FROM
			employee_data.parish par
		INNER JOIN
			employee_data.municipalities mun
		ON
			mun.id = par.municipality_id
		AND
			mun.is_active = '1'
		AND
			mun.is_deleted = '0'
			WHERE
				par.municipality_id = param_municipality_id
			AND
				par.is_active = '1'
			AND
				par.is_deleted = '0'
	)DATA;
$BODY$;

--function get one data
CREATE OR REPLACE FUNCTION employee_data.get_parish(
	param_id INTEGER,
	param_municipality_id INTEGER
)
RETURNS json
LANGUAGE 'sql'
COST 100.0

AS $BODY$
	SELECT ARRAY_TO_JSON(ARRAY_AGG(ROW_TO_JSON(DATA)))
	FROM (
		SELECT
			par.id,
			par.name as parish
		FROM
			employee_data.parish par
		INNER JOIN
			employee_data.municipalities mun
		ON
			mun.id = par.municipality_id
		AND
			mun.is_active = '1'
		AND
			mun.is_deleted = '0'
			WHERE
				par.municipality_id = param_municipality_id
			AND
				par.id = param_id
			AND
				par.is_active = '1'
			AND
				par.is_deleted = '0'
	)DATA;
$BODY$;

-- function update all columns
CREATE OR REPLACE FUNCTION employee_data.parish_update_all_columns(
	param_id INTEGER,
	param_name VARCHAR,
	param_municipality_id INTEGER,
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
  		UPDATE employee_data.parish SET
  			name = param_name,
  			is_active = param_is_active,
  			is_deleted = param_is_deleted,
  			last_modified_by = param_user_id,
      		last_modified_date = CLOCK_TIMESTAMP()
      	WHERE
      		id = param_id
      	AND
      		municipality_id = param_municipality_id;

      	SELECT parish_insert_history into local_is_successful FROM employee_data.parish_insert_history(
      		param_parish_id := param_id,
      		param_change_type := 'UPDATE all_columns',
      		param_change_description := 'UPDATE value of all columns'
      	);


    	RETURN local_is_successful;
  	END;
$udf$;

-- function update is active
CREATE OR REPLACE FUNCTION employee_data.parish_update_is_active(
	param_id INTEGER,
	param_municipality_id INTEGER,
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
  		UPDATE employee_data.parish SET
  			is_active = param_is_active,
  			last_modified_by = param_user_id,
      		last_modified_date = CLOCK_TIMESTAMP()
      	WHERE
      		id = param_id
      	AND
      		municipality_id = param_municipality_id;

      	SELECT parish_insert_history into local_is_successful FROM employee_data.parish_insert_history(
      		param_parish_id := param_id,
      		param_change_type := 'UPDATE is_active',
      		param_change_description := 'UPDATE value of is_active'
      	);


    	RETURN local_is_successful;
  	END;
$udf$;

-- function update is deleted
CREATE OR REPLACE FUNCTION employee_data.parish_update_is_deleted(
	param_id INTEGER,
	param_municipality_id INTEGER,
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
  		UPDATE employee_data.parish SET
  			is_deleted = param_is_deleted,
  			last_modified_by = param_user_id,
      		last_modified_date = CLOCK_TIMESTAMP()
      	WHERE
      		id = param_id
      	AND
      		municipality_id = param_municipality_id;

      	SELECT parish_insert_history into local_is_successful FROM employee_data.parish_insert_history(
      		param_parish_id := param_id,
      		param_change_type := 'UPDATE is_deleted',
      		param_change_description := 'UPDATE value of is_deleted'
      	);


    	RETURN local_is_successful;
  	END;
$udf$;

-- functions of ingress

--function of insert
CREATE OR REPLACE FUNCTION employee_data.ingress_insert(
	param_description VARCHAR,
	param_user_id BIGINT
)
RETURNS BIT
LANGUAGE plpgsql VOLATILE
COST 100.0
AS $udf$
	DECLARE
		local_is_successful BIT := '0';
		local_ingress_id BIGINT;
	BEGIN
		INSERT INTO employee_data.ingress(
			description,
			is_active,
			is_deleted,
			last_modified_by,
			last_modified_date
		)
		VALUES(
			param_description,
			'1',
			'0',
			param_user_id,
			CLOCK_TIMESTAMP()
		)
		RETURNING id
		INTO STRICT local_ingress_id;

		SELECT ingress_insert_history into local_is_successful FROM employee_data.ingress_insert_history(
      		param_ingress_id := local_ingress_id,
      		param_change_type := 'FIRST INSERT',
      		param_change_description := 'FIRST INSERT'
      	);


    	RETURN local_is_successful;
    END;
$udf$;

--function of insert log
CREATE OR REPLACE FUNCTION employee_data.ingress_insert_history(
  param_ingress_id BIGINT,
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
  	INSERT INTO employee_data.ingress_history
  	(
  		ingress_id,
  		description,
		is_active,
		is_deleted,
		last_modified_by,
		last_modified_date,
		change_type,
      	change_description
  	)
  	SELECT
  		id,
  		description,
		is_active,
		is_deleted,
		last_modified_by,
		last_modified_date,
		param_change_type,
		param_change_description
	FROM
		employee_data.ingress ing
	WHERE
		ing.id = param_ingress_id
	ORDER BY
		ing.last_modified_date
	DESC
	LIMIT 1;
	local_is_successful := '1';
    RETURN local_is_successful;
  END;
$udf$;

-- funciton of list
CREATE OR REPLACE FUNCTION employee_data.get_ingress_list()
RETURNS json
LANGUAGE 'sql'
COST 100.0

AS $BODY$
	SELECT ARRAY_TO_JSON(ARRAY_AGG(ROW_TO_JSON(DATA)))
	FROM (
		SELECT
			ing.id,
			ing.description as ingres
		FROM
			employee_data.ingress ing
		WHERE
			ing.is_active = '1'
		AND
			ing.is_deleted = '0'
	)DATA;
$BODY$;

--function get one data
CREATE OR REPLACE FUNCTION employee_data.get_ingres(
	param_id INTEGER
)
RETURNS json
LANGUAGE 'sql'
COST 100.0

AS $BODY$
	SELECT ARRAY_TO_JSON(ARRAY_AGG(ROW_TO_JSON(DATA)))
	FROM (
		SELECT
			ing.id,
			ing.description as ingres
		FROM
			employee_data.ingress ing
		WHERE
			ing.id = param_id
		AND
			ing.is_active = '1'
		AND
			ing.is_deleted = '0'
	)DATA;
$BODY$;

-- function update all columns
CREATE OR REPLACE FUNCTION employee_data.ingres_update_all_columns(
	param_id INTEGER,
	param_description VARCHAR,
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
  		UPDATE employee_data.ingress SET
  			description = param_description,
  			is_active = param_is_active,
  			is_deleted = param_is_deleted,
  			last_modified_by = param_user_id,
      		last_modified_date = CLOCK_TIMESTAMP()
      	WHERE
      		id = param_id;

      	SELECT ingress_insert_history into local_is_successful FROM employee_data.ingress_insert_history(
      		param_ingress_id := param_id,
      		param_change_type := 'UPDATE all_columns',
      		param_change_description := 'UPDATE value of all columns'
      	);


    	RETURN local_is_successful;
  	END;
$udf$;

-- function update is active
CREATE OR REPLACE FUNCTION employee_data.ingres_update_is_active(
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
  		UPDATE employee_data.ingress SET
  			is_active = param_is_active,
  			last_modified_by = param_user_id,
      		last_modified_date = CLOCK_TIMESTAMP()
      	WHERE
      		id = param_id;

      	SELECT ingress_insert_history into local_is_successful FROM employee_data.ingress_insert_history(
      		param_ingress_id := param_id,
      		param_change_type := 'UPDATE is_active',
      		param_change_description := 'UPDATE value of is_active'
      	);


    	RETURN local_is_successful;
  	END;
$udf$;

-- function update is deleted
CREATE OR REPLACE FUNCTION employee_data.ingres_update_is_deleted(
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
  		UPDATE employee_data.ingress SET
  			is_deleted = param_is_deleted,
  			last_modified_by = param_user_id,
      		last_modified_date = CLOCK_TIMESTAMP()
      	WHERE
      		id = param_id;

      	SELECT ingress_insert_history into local_is_successful FROM employee_data.ingress_insert_history(
      		param_ingress_id := param_id,
      		param_change_type := 'UPDATE is_deleted',
      		param_change_description := 'UPDATE value of is_deleted'
      	);

    	RETURN local_is_successful;
  	END;
$udf$;

-- functions of income types

--function of insert
CREATE OR REPLACE FUNCTION employee_data.income_type_insert(
	param_description VARCHAR,
	param_user_id BIGINT
)
RETURNS BIT
LANGUAGE plpgsql VOLATILE
COST 100.0
AS $udf$
	DECLARE
		local_is_successful BIT := '0';
		local_income_type_id BIGINT;
	BEGIN
		INSERT INTO employee_data.income_types(
			description,
			is_active,
			is_deleted,
			last_modified_by,
			last_modified_date
		)
		VALUES(
			param_description,
			'1',
			'0',
			param_user_id,
			CLOCK_TIMESTAMP()
		)
		RETURNING id
		INTO STRICT local_income_type_id;

		SELECT income_type_insert_history into local_is_successful FROM employee_data.income_type_insert_history(
			param_income_type_id := local_income_type_id,
  			param_change_type := 'FIRST INSERT',
      		param_change_description := 'FIRST INSERT'
		);


    	RETURN local_is_successful;
    END;
$udf$;

--function of insert log
CREATE OR REPLACE FUNCTION employee_data.income_type_insert_history(
  param_income_type_id BIGINT,
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
  	INSERT INTO employee_data.income_types_history
  	(
  		income_type_id,
  		description,
		is_active,
		is_deleted,
		last_modified_by,
		last_modified_date,
		change_type,
      	change_description
  	)
  	SELECT
  		id,
  		description,
		is_active,
		is_deleted,
		last_modified_by,
		last_modified_date,
		param_change_type,
		param_change_description
	FROM
		employee_data.income_types inc
	WHERE
		inc.id = param_income_type_id
	ORDER BY
		inc.last_modified_date
	DESC
	LIMIT 1;
	local_is_successful := '1';
    RETURN local_is_successful;
  END;
$udf$;

-- funciton of list
CREATE OR REPLACE FUNCTION employee_data.get_income_type_list()
RETURNS json
LANGUAGE 'sql'
COST 100.0

AS $BODY$
	SELECT ARRAY_TO_JSON(ARRAY_AGG(ROW_TO_JSON(DATA)))
	FROM (
		SELECT
			inc.id,
			inc.description as income_type
		FROM
			employee_data.income_types inc
		WHERE
			inc.is_active = '1'
		AND
			inc.is_deleted = '0'
	)DATA;
$BODY$;

--function get one data
CREATE OR REPLACE FUNCTION employee_data.get_income_type(
	param_id INTEGER
)
RETURNS json
LANGUAGE 'sql'
COST 100.0

AS $BODY$
	SELECT ARRAY_TO_JSON(ARRAY_AGG(ROW_TO_JSON(DATA)))
	FROM (
		SELECT
			inc.id,
			inc.description as income_type
		FROM
			employee_data.income_types inc
		WHERE
			inc.id = param_id
		AND
			inc.is_active = '1'
		AND
			inc.is_deleted = '0'
	)DATA;
$BODY$;

-- function update all columns
CREATE OR REPLACE FUNCTION employee_data.income_type_update_all_columns(
	param_id INTEGER,
	param_description VARCHAR,
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
  		UPDATE employee_data.income_types SET
  			description = param_description,
  			is_active = param_is_active,
  			is_deleted = param_is_deleted,
  			last_modified_by = param_user_id,
      		last_modified_date = CLOCK_TIMESTAMP()
      	WHERE
      		id = param_id;

      	SELECT income_type_insert_history into local_is_successful FROM employee_data.income_type_insert_history(
      		param_income_type_id := param_id,
      		param_change_type := 'UPDATE all_columns',
      		param_change_description := 'UPDATE value of all columns'
      	);


    	RETURN local_is_successful;
  	END;
$udf$;

-- function update is active
CREATE OR REPLACE FUNCTION employee_data.income_type_update_is_active(
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
  		UPDATE employee_data.income_types SET
  			is_active = param_is_active,
  			last_modified_by = param_user_id,
      		last_modified_date = CLOCK_TIMESTAMP()
      	WHERE
      		id = param_id;

      	SELECT income_type_insert_history into local_is_successful FROM employee_data.income_type_insert_history(
      		param_income_type_id := param_id,
      		param_change_type := 'UPDATE is_active',
      		param_change_description := 'UPDATE value of is_active'
      	);


    	RETURN local_is_successful;
  	END;
$udf$;

-- function update is deleted
CREATE OR REPLACE FUNCTION employee_data.income_type_update_is_deleted(
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
  		UPDATE employee_data.income_types SET
  			is_deleted = param_is_deleted,
  			last_modified_by = param_user_id,
      		last_modified_date = CLOCK_TIMESTAMP()
      	WHERE
      		id = param_id;

      	SELECT income_type_insert_history into local_is_successful FROM employee_data.income_type_insert_history(
      		param_income_type_id := param_id,
      		param_change_type := 'UPDATE is_deleted',
      		param_change_description := 'UPDATE value of is_deleted'
      	);


    	RETURN local_is_successful;
  	END;
$udf$;

-- fucntions of category types

--function of insert
CREATE OR REPLACE FUNCTION employee_data.category_type_insert(
	param_code INTEGER,
	param_description VARCHAR,
	param_user_id BIGINT
)
RETURNS BIT
LANGUAGE plpgsql VOLATILE
COST 100.0
AS $udf$
	DECLARE
		local_is_successful BIT := '0';
		local_category_id BIGINT;
	BEGIN
		IF EXISTS
		(
			SELECT cat.code
			FROM employee_data.category_types cat
			WHERE
				cat.code = param_code
			AND
				cat.is_active = '1'
			AND
				cat.is_deleted = '0'
		)
		THEN
			RETURN local_is_successful;
		ELSE
			INSERT INTO employee_data.category_types(
				code,
				description,
				is_active,
				is_deleted,
				last_modified_by,
				last_modified_date
			)
			VALUES(
				param_code,
				param_description,
				'1',
				'0',
				param_user_id,
				CLOCK_TIMESTAMP()
			)
			RETURNING id
			INTO STRICT local_category_id;

			SELECT category_type_insert_history into local_is_successful FROM employee_data.category_type_insert_history(
      			param_category_id := local_category_id,
      			param_change_type := 'FIRST INSERT',
      			param_change_description := 'FIRST INSERT'
      		);


    		RETURN local_is_successful;
    	END IF;
  	END;
$udf$;

--function of insert log
CREATE OR REPLACE FUNCTION employee_data.category_type_insert_history(
  param_category_id BIGINT,
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
  	INSERT INTO employee_data.category_types_history
  	(
  		category_type_id,
  		code,
		description,
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
		description,
		is_active,
		is_deleted,
		last_modified_by,
		last_modified_date,
		param_change_type,
		param_change_description
	FROM
		employee_data.category_types cat
	WHERE
		cat.id = param_category_id
	ORDER BY
		cat.last_modified_date
	DESC
	LIMIT 1;
	local_is_successful := '1';
    RETURN local_is_successful;
  END;
$udf$;

-- function get list
CREATE OR REPLACE FUNCTION employee_data.get_category_types_list()
RETURNS json
LANGUAGE 'sql'
COST 100.0

AS $BODY$
	SELECT ARRAY_TO_JSON(ARRAY_AGG(ROW_TO_JSON(DATA)))
	FROM (
		SELECT
			cat.id,
			cat.code,
			cat.description as category_type
		FROM
			employee_data.category_types cat
		WHERE
			cat.is_active = '1'
		AND
			cat.is_deleted = '0'
	)DATA;
$BODY$;

--function get one data
CREATE OR REPLACE FUNCTION employee_data.get_category_type(
	param_id INTEGER
)
RETURNS json
LANGUAGE 'sql'
COST 100.0

AS $BODY$
	SELECT ARRAY_TO_JSON(ARRAY_AGG(ROW_TO_JSON(DATA)))
	FROM (
		SELECT
			cat.id,
			cat.code,
			cat.description as category_type
		FROM
			employee_data.category_types cat
		WHERE
			cat.id = param_id
		AND
			cat.is_active = '1'
		AND
			cat.is_deleted = '0'
	)DATA;
$BODY$;

-- function update all columns
CREATE OR REPLACE FUNCTION employee_data.category_type_update_all_columns(
	param_id INTEGER,
	param_description VARCHAR,
	param_code INTEGER,
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
  		UPDATE employee_data.category_types SET
  			description = param_description,
  			code = param_code,
  			is_active = param_is_active,
  			is_deleted = param_is_deleted,
  			last_modified_by = param_user_id,
      		last_modified_date = CLOCK_TIMESTAMP()
      	WHERE
      		id = param_id;

      	SELECT category_type_insert_history into local_is_successful FROM employee_data.category_type_insert_history(
      		param_category_id := param_id,
      		param_change_type := 'UPDATE all_columns',
      		param_change_description := 'UPDATE value of all columns'
      	);


    	RETURN local_is_successful;
  	END;
$udf$;

-- function update is active
CREATE OR REPLACE FUNCTION employee_data.category_type_update_is_active(
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
  		UPDATE employee_data.category_types SET
  			is_active = param_is_active,
  			last_modified_by = param_user_id,
      		last_modified_date = CLOCK_TIMESTAMP()
      	WHERE
      		id = param_id;

      	SELECT category_type_insert_history into local_is_successful FROM employee_data.category_type_insert_history(
      		param_category_id := param_id,
      		param_change_type := 'UPDATE is_active',
      		param_change_description := 'UPDATE value of is_active'
      	);


    	RETURN local_is_successful;
  	END;
$udf$;

-- function update is deleted
CREATE OR REPLACE FUNCTION employee_data.category_type_update_is_deleted(
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
  		UPDATE employee_data.category_types SET
  			is_deleted = param_is_deleted,
  			last_modified_by = param_user_id,
      		last_modified_date = CLOCK_TIMESTAMP()
      	WHERE
      		id = param_id;

      	SELECT category_type_insert_history into local_is_successful FROM employee_data.category_type_insert_history(
      		param_category_id := param_id,
      		param_change_type := 'UPDATE is_deleted',
      		param_change_description := 'UPDATE value of is_deleted'
      	);


    	RETURN local_is_successful;
  	END;
$udf$;

-- functions of dedication types

--function of insert
CREATE OR REPLACE FUNCTION employee_data.dedication_type_insert(
	param_code INTEGER,
	param_description VARCHAR,
	param_user_id BIGINT
)
RETURNS BIT
LANGUAGE plpgsql VOLATILE
COST 100.0
AS $udf$
	DECLARE
		local_is_successful BIT := '0';
		local_dedication_id BIGINT;
	BEGIN
		IF EXISTS
		(
			SELECT ded.code
			FROM employee_data.dedication_types ded
			WHERE
				ded.code = param_code
			AND
				ded.is_active = '1'
			AND
				ded.is_deleted = '0'
		)
		THEN
			RETURN local_is_successful;
		ELSE
			INSERT INTO employee_data.dedication_types(
				code,
				description,
				is_active,
				is_deleted,
				last_modified_by,
				last_modified_date
			)
			VALUES(
				param_code,
				param_description,
				'1',
				'0',
				param_user_id,
				CLOCK_TIMESTAMP()
			)
			RETURNING id
			INTO STRICT local_dedication_id;

			SELECT dedication_type_insert_history into local_is_successful FROM employee_data.dedication_type_insert_history(
      			param_dedication_id := local_dedication_id,
      			param_change_type := 'FIRST INSERT',
      			param_change_description := 'FIRST INSERT'
      		);


    		RETURN local_is_successful;
    	END IF;
  	END;
$udf$;

--function of insert log
CREATE OR REPLACE FUNCTION employee_data.dedication_type_insert_history(
  param_dedication_id BIGINT,
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
  	INSERT INTO employee_data.dedication_types_history
  	(
  		dedication_type_id,
  		code,
		description,
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
		description,
		is_active,
		is_deleted,
		last_modified_by,
		last_modified_date,
		param_change_type,
		param_change_description
	FROM
		employee_data.dedication_types ded
	WHERE
		ded.id = param_dedication_id
	ORDER BY
		ded.last_modified_date
	DESC
	LIMIT 1;
	local_is_successful := '1';
    RETURN local_is_successful;
  END;
$udf$;

-- function get list
CREATE OR REPLACE FUNCTION employee_data.get_dedication_types_list()
RETURNS json
LANGUAGE 'sql'
COST 100.0

AS $BODY$
	SELECT ARRAY_TO_JSON(ARRAY_AGG(ROW_TO_JSON(DATA)))
	FROM (
		SELECT
			ded.id,
			ded.code,
			ded.description as dedication_type
		FROM
			employee_data.dedication_types ded
		WHERE
			ded.is_active = '1'
		AND
			ded.is_deleted = '0'
	)DATA;
$BODY$;

--function get one data
CREATE OR REPLACE FUNCTION employee_data.get_dedication_type(
	param_id INTEGER
)
RETURNS json
LANGUAGE 'sql'
COST 100.0

AS $BODY$
	SELECT ARRAY_TO_JSON(ARRAY_AGG(ROW_TO_JSON(DATA)))
	FROM (
		SELECT
			ded.id,
			ded.code,
			ded.description as dedication_type
		FROM
			employee_data.dedication_types ded
		WHERE
			ded.id = param_id
		AND
			ded.is_active = '1'
		AND
			ded.is_deleted = '0'
	)DATA;
$BODY$;

-- function update all columns
CREATE OR REPLACE FUNCTION employee_data.dedication_type_update_all_columns(
	param_id INTEGER,
	param_code INTEGER,
	param_description VARCHAR,
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
  		UPDATE employee_data.dedication_types SET
  			description = param_description,
  			code = param_code,
  			is_active = param_is_active,
  			is_deleted = param_is_deleted,
  			last_modified_by = param_user_id,
      		last_modified_date = CLOCK_TIMESTAMP()
      	WHERE
      		id = param_id;

      	SELECT dedication_type_insert_history into local_is_successful FROM employee_data.dedication_type_insert_history(
      		param_dedication_id := param_id,
      		param_change_type := 'UPDATE all_columns',
      		param_change_description := 'UPDATE value of all columns'
      	);


    	RETURN local_is_successful;
  	END;
$udf$;

-- function update is active
CREATE OR REPLACE FUNCTION employee_data.dedication_type_update_is_active(
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
  		UPDATE employee_data.dedication_types SET
  			is_active = param_is_active,
  			last_modified_by = param_user_id,
      		last_modified_date = CLOCK_TIMESTAMP()
      	WHERE
      		id = param_id;

      	SELECT dedication_type_insert_history into local_is_successful FROM employee_data.dedication_type_insert_history(
      		param_dedication_id := param_id,
      		param_change_type := 'UPDATE is_active',
      		param_change_description := 'UPDATE value of is_active'
      	);


    	RETURN local_is_successful;
  	END;
$udf$;

-- function update is deleted
CREATE OR REPLACE FUNCTION employee_data.dedication_type_update_is_deleted(
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
  		UPDATE employee_data.dedication_types SET
  			is_deleted = param_is_deleted,
  			last_modified_by = param_user_id,
      		last_modified_date = CLOCK_TIMESTAMP()
      	WHERE
      		id = param_id;

      	SELECT dedication_type_insert_history into local_is_successful FROM employee_data.dedication_type_insert_history(
      		param_dedication_id := param_id,
      		param_change_type := 'UPDATE is_deleted',
      		param_change_description := 'UPDATE value of is_deleted'
      	);

    	RETURN local_is_successful;
  	END;
$udf$;

-- functions of execunting unit

--function of insert
CREATE OR REPLACE FUNCTION employee_data.execunting_unit_insert(
	param_code VARCHAR,
	param_description VARCHAR,
	param_user_id BIGINT
)
RETURNS BIT
LANGUAGE plpgsql VOLATILE
COST 100.0
AS $udf$
	DECLARE
		local_is_successful BIT := '0';
		local_execunting_unit_id BIGINT;
	BEGIN
		IF EXISTS
		(
			SELECT exec.code
			FROM employee_data.execunting_unit exec
			WHERE
				exec.code = param_code
			AND
				exec.is_active = '1'
			AND
				exec.is_deleted = '0'
		)
		THEN
			RETURN local_is_successful;
		ELSE
			INSERT INTO employee_data.execunting_unit(
				code,
				description,
				is_active,
				is_deleted,
				last_modified_by,
				last_modified_date
			)
			VALUES(
				param_code,
				param_description,
				'1',
				'0',
				param_user_id,
				CLOCK_TIMESTAMP()
			)
			RETURNING id
			INTO STRICT local_execunting_unit_id;

			SELECT execunting_unit_insert_history into local_is_successful FROM employee_data.execunting_unit_insert_history(
      			param_execunting_unit_id := local_execunting_unit_id,
      			param_change_type := 'FIRST INSERT',
      			param_change_description := 'FIRST INSERT'
      		);


    		RETURN local_is_successful;
    	END IF;
  	END;
$udf$;

--function of insert log
CREATE OR REPLACE FUNCTION employee_data.execunting_unit_insert_history(
  param_execunting_unit_id BIGINT,
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
  	INSERT INTO employee_data.execunting_unit_history
  	(
  		execunting_unit_id,
  		code,
		description,
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
		description,
		is_active,
		is_deleted,
		last_modified_by,
		last_modified_date,
		param_change_type,
		param_change_description
	FROM
		employee_data.execunting_unit exec
	WHERE
		exec.id = param_execunting_unit_id
	ORDER BY
		exec.last_modified_date
	DESC
	LIMIT 1;
	local_is_successful := '1';
    RETURN local_is_successful;
  END;
$udf$;

-- function get list
CREATE OR REPLACE FUNCTION employee_data.get_execunting_unit_list()
RETURNS json
LANGUAGE 'sql'
COST 100.0

AS $BODY$
	SELECT ARRAY_TO_JSON(ARRAY_AGG(ROW_TO_JSON(DATA)))
	FROM (
		SELECT
			exec.id,
			exec.code,
			exec.description as execunting_unit
		FROM
			employee_data.execunting_unit exec
		WHERE
			exec.is_active = '1'
		AND
			exec.is_deleted = '0'
	)DATA;
$BODY$;

--function get list for filter
CREATE OR REPLACE FUNCTION employee_data.get_execunting_unit_filter_code(
	param_code VARCHAR
)
RETURNS json
LANGUAGE 'sql'
COST 100.0

AS $BODY$
	SELECT ARRAY_TO_JSON(ARRAY_AGG(ROW_TO_JSON(DATA)))
	FROM (
		SELECT
			exec.id,
			exec.code,
			exec.description as execunting_unit
		FROM
			employee_data.execunting_unit exec
		WHERE
			exec.code LIKE param_code||'%'
		AND
			exec.is_active = '1'
		AND
			exec.is_deleted = '0'
	)DATA;
$BODY$;

--function get one data
CREATE OR REPLACE FUNCTION employee_data.get_execunting_unit(
	param_id INTEGER
)
RETURNS json
LANGUAGE 'sql'
COST 100.0

AS $BODY$
	SELECT ARRAY_TO_JSON(ARRAY_AGG(ROW_TO_JSON(DATA)))
	FROM (
		SELECT
			exec.id,
			exec.code,
			exec.description as execunting_unit
		FROM
			employee_data.execunting_unit exec
		WHERE
			exec.id = param_id
		AND
			exec.is_active = '1'
		AND
			exec.is_deleted = '0'
	)DATA;
$BODY$;

-- function update all columns
CREATE OR REPLACE FUNCTION employee_data.execunting_unit_update_all_columns(
	param_id INTEGER,
	param_code VARCHAR,
	param_description VARCHAR,
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
  		UPDATE employee_data.execunting_unit SET
  			description = param_description,
				code = param_code,
  			is_active = param_is_active,
  			is_deleted = param_is_deleted,
  			last_modified_by = param_user_id,
      		last_modified_date = CLOCK_TIMESTAMP()
      	WHERE
      		id = param_id;

      	SELECT execunting_unit_insert_history into local_is_successful FROM employee_data.execunting_unit_insert_history(
      		param_execunting_unit_id := param_id,
      		param_change_type := 'UPDATE all_columns',
      		param_change_description := 'UPDATE value of all columns'
      	);


    	RETURN local_is_successful;
  	END;
$udf$;

-- function update is active
CREATE OR REPLACE FUNCTION employee_data.execunting_unit_update_is_active(
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
  		UPDATE employee_data.execunting_unit SET
  			is_active = param_is_active,
  			last_modified_by = param_user_id,
      		last_modified_date = CLOCK_TIMESTAMP()
      	WHERE
      		id = param_id;

      	SELECT execunting_unit_insert_history into local_is_successful FROM employee_data.execunting_unit_insert_history(
      		param_execunting_unit_id := param_id,
      		param_change_type := 'UPDATE is_active',
      		param_change_description := 'UPDATE value of is_active'
      	);

    	RETURN local_is_successful;
  	END;
$udf$;

-- function update is deleted
CREATE OR REPLACE FUNCTION employee_data.execunting_unit_update_is_deleted(
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
  		UPDATE employee_data.execunting_unit SET
  			is_deleted = param_is_deleted,
  			last_modified_by = param_user_id,
      		last_modified_date = CLOCK_TIMESTAMP()
      	WHERE
      		id = param_id;

      	SELECT execunting_unit_insert_history into local_is_successful FROM employee_data.execunting_unit_insert_history(
      		param_execunting_unit_id := param_id,
      		param_change_type := 'UPDATE is_deleted',
      		param_change_description := 'UPDATE value of is_deleted'
      	);

    	RETURN local_is_successful;
  	END;
$udf$;

--functions of salaries

-- function of insert
CREATE OR REPLACE FUNCTION employee_data.salary_insert(
	param_category_id INTEGER,
	param_dedication_id INTEGER,
	param_salary INTEGER,
	param_user_id BIGINT
)
RETURNS BIT
LANGUAGE plpgsql VOLATILE
COST 100.0
AS $udf$
	DECLARE
		local_is_successful BIT := '0';
		local_salary_id BIGINT;
	BEGIN
		INSERT INTO employee_data.salaries(
			category_type_id,
			dedication_type_id,
			salary,
			is_active,
			is_deleted,
			last_modified_by,
			last_modified_date
		)
		VALUES(
			param_category_id,
			param_dedication_id,
			param_salary,
			'1',
			'0',
			param_user_id,
			CLOCK_TIMESTAMP()
		)
		RETURNING id
		INTO STRICT local_salary_id;

		SELECT salary_insert_history into local_is_successful FROM employee_data.salary_insert_history(
      		param_salary_id := local_salary_id,
      		param_change_type := 'FIRST INSERT',
      		param_change_description := 'FIRST INSERT'
      	);


    	RETURN local_is_successful;
    END;
$udf$;

--function of insert log
CREATE OR REPLACE FUNCTION employee_data.salary_insert_history(
  param_salary_id BIGINT,
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
  	INSERT INTO employee_data.salaries_history
  	(
  		salary_id,
  		category_type_id,
		dedication_type_id,
		salary,
		is_active,
		is_deleted,
		last_modified_by,
		last_modified_date,
		change_type,
      	change_description
  	)
  	SELECT
  		id,
  		category_type_id,
		dedication_type_id,
		salary,
		is_active,
		is_deleted,
		last_modified_by,
		last_modified_date,
		param_change_type,
		param_change_description
	FROM
		employee_data.salaries sal
	WHERE
		sal.id = param_salary_id
	ORDER BY
		sal.last_modified_date
	DESC
	LIMIT 1;
	local_is_successful := '1';
    RETURN local_is_successful;
  END;
$udf$;

--function get list
CREATE OR REPLACE FUNCTION employee_data.get_salary_list()
RETURNS json
LANGUAGE 'sql'
COST 100.0

AS $BODY$
	SELECT ARRAY_TO_JSON(ARRAY_AGG(ROW_TO_JSON(DATA)))
	FROM (
		SELECT
			id,
			category_type_id,
			dedication_type_id,
			salary
		FROM
			employee_data.salaries sal
		WHERE
			sal.is_active = '1'
		AND
			sal.is_deleted = '0'
	)DATA;
$BODY$;

--function get list fo category_type
CREATE OR REPLACE FUNCTION employee_data.get_salary_for_category_type_list(
	param_category_id INTEGER
)
RETURNS json
LANGUAGE 'sql'
COST 100.0

AS $BODY$
	SELECT ARRAY_TO_JSON(ARRAY_AGG(ROW_TO_JSON(DATA)))
	FROM (
		SELECT
			sal.id,
			sal.category_type_id,
			sal.dedication_type_id,
			sal.salary
		FROM
			employee_data.salaries sal
			INNER JOIN
				employee_data.category_types cat
			ON
				cat.id = sal.category_type_id
			AND
				cat.is_deleted = '0'
			AND
				cat.is_active = '1'
		WHERE
			sal.is_active = '1'
		AND
			sal.is_deleted = '0'
		AND
			sal.category_type_id = param_category_id
	)DATA;
$BODY$;

--function get list for dedication_type
CREATE OR REPLACE FUNCTION employee_data.get_salary_for_dedication_type_list(
	param_dedication_id INTEGER
)
RETURNS json
LANGUAGE 'sql'
COST 100.0

AS $BODY$
	SELECT ARRAY_TO_JSON(ARRAY_AGG(ROW_TO_JSON(DATA)))
	FROM (
		SELECT
			sal.id,
			sal.category_type_id,
			sal.dedication_type_id,
			sal.salary
		FROM
			employee_data.salaries sal
			INNER JOIN
				employee_data.dedication_types ded
			ON
				ded.id = sal.category_type_id
			AND
				ded.is_deleted = '0'
			AND
				ded.is_active = '1'
		WHERE
			sal.is_active = '1'
		AND
			sal.is_deleted = '0'
		AND
			sal.category_type_id = param_dedication_id
	)DATA;
$BODY$;

--function get list for dedication_type and category_type
CREATE OR REPLACE FUNCTION employee_data.get_salary_for_dedication_type_category_type_list(
	param_dedication_id INTEGER,
	param_category_id INTEGER
)
RETURNS json
LANGUAGE 'sql'
COST 100.0

AS $BODY$
	SELECT ROW_TO_JSON(DATA)
	FROM (
		SELECT
			sal.id,
			sal.category_type_id,
			sal.dedication_type_id,
			sal.salary
		FROM
			employee_data.salaries sal
			INNER JOIN
				employee_data.dedication_types ded
			ON
				sal.dedication_type_id = param_dedication_id
			AND
				ded.id = sal.category_type_id
			AND
				ded.is_deleted = '0'
			AND
				ded.is_active = '1'
			AND
				sal.is_active = '1'
			AND
				sal.is_deleted = '0'
			INNER JOIN
				employee_data.category_types cat
			ON
				sal.category_type_id =  param_category_id
			AND
				cat.id = sal.category_type_id
			AND
				cat.is_deleted = '0'
			AND
				cat.is_active = '1'
		)DATA;
$BODY$;

--function get list for dedication_type and category_type
CREATE OR REPLACE FUNCTION employee_data.get_salary(
	param_salary_id INTEGER,
	param_dedication_id INTEGER,
	param_category_id INTEGER
)
RETURNS json
LANGUAGE 'sql'
COST 100.0

AS $BODY$
	SELECT ARRAY_TO_JSON(ARRAY_AGG(ROW_TO_JSON(DATA)))
	FROM (
		SELECT
			sal.id,
			sal.category_type_id,
			sal.dedication_type_id,
			sal.salary
		FROM
			employee_data.salaries sal
			INNER JOIN
				employee_data.dedication_types ded
			ON
				ded.id = sal.category_type_id
			AND
				ded.is_deleted = '0'
			AND
				ded.is_active = '1'
			INNER JOIN
				employee_data.category_types cat
			ON
				cat.id = sal.category_type_id
			AND
				cat.is_deleted = '0'
			AND
				cat.is_active = '1'
		WHERE
			sal.is_active = '1'
		AND
			sal.is_deleted = '0'
		AND
			sal.category_type_id =  param_category_id
		AND
			sal.dedication_type_id = param_dedication_id
		AND
			sal.id  = param_salary_id
	)DATA;
$BODY$;

-- function of update all colums

CREATE OR REPLACE FUNCTION employee_data.salary_update_all_columns(
	param_id INTEGER,
	param_category_id INTEGER,
	param_dedication_id INTEGER,
	param_salary INTEGER,
	param_is_active BIT,
	param_is_deleted BIT,
	param_user_id INTEGER
)
RETURNS BIT
LANGUAGE plpgsql VOLATILE
COST 100.0
AS $udf$
	DECLARE
    	local_is_successful BIT := '0';
  	BEGIN
  		UPDATE employee_data.salaries SET
  			category_type_id = param_category_id,
  			dedication_type_id = param_dedication_id,
  			salary = param_salary,
  			is_active = param_is_active,
  			is_deleted = param_is_deleted,
  			last_modified_by = param_user_id,
  			last_modified_date = CLOCK_TIMESTAMP()
  		WHERE
  			id = param_id;

  			SELECT salary_insert_history into local_is_successful FROM employee_data.salary_insert_history(
      		param_salary_id := param_id,
      		param_change_type := 'UPDATE all_columns',
      		param_change_description := 'UPDATE value of all columns'
      	);

    	RETURN local_is_successful;
  	END;
$udf$;

-- function update is active
CREATE OR REPLACE FUNCTION employee_data.salary_update_is_active(
	param_id INTEGER,
	param_is_active BIT,
	param_user_id INTEGER
)
RETURNS BIT
LANGUAGE plpgsql VOLATILE
COST 100.0
AS $udf$
	DECLARE
    	local_is_successful BIT := '0';
  	BEGIN
  		UPDATE employee_data.salaries SET
  			is_active = param_is_active,
  			last_modified_by = param_user_id,
  			last_modified_date = CLOCK_TIMESTAMP()
  		WHERE
  			id = param_id;

  			SELECT salary_insert_history into local_is_successful FROM employee_data.salary_insert_history(
      		param_salary_id := param_id,
      		param_change_type := 'UPDATE is_active',
      		param_change_description := 'UPDATE value of is_active'
      	);

    	RETURN local_is_successful;
  	END;
$udf$;

--function is deleted
CREATE OR REPLACE FUNCTION employee_data.salary_update_is_deleted(
	param_id INTEGER,
	param_is_deleted BIT,
	param_user_id INTEGER
)
RETURNS BIT
LANGUAGE plpgsql VOLATILE
COST 100.0
AS $udf$
	DECLARE
    	local_is_successful BIT := '0';
  	BEGIN
  		UPDATE employee_data.salaries SET
  			is_deleted = param_is_deleted,
  			last_modified_by = param_user_id,
  			last_modified_date = CLOCK_TIMESTAMP()
  		WHERE
  			id = param_id;

  			SELECT salary_insert_history into local_is_successful FROM employee_data.salary_insert_history(
      		param_salary_id := param_id,
      		param_change_type := 'UPDATE is_deleted',
      		param_change_description := 'UPDATE value of is_deleted'
      	);

    	RETURN local_is_successful;
  	END;
$udf$;

-- function of  documentations

--function of insert
CREATE OR REPLACE FUNCTION employee_data.documentations_insert(
	param_description VARCHAR,
	param_user_id BIGINT
)
RETURNS BIT
LANGUAGE plpgsql VOLATILE
COST 100.0
AS $udf$
	DECLARE
		local_is_successful BIT := '0';
		local_documentation_id BIGINT;
	BEGIN
		INSERT INTO employee_data.documentations(
			description,
			is_active,
			is_deleted,
			last_modified_by,
			last_modified_date
		)
		VALUES(
			param_description,
			'1',
			'0',
			param_user_id,
			CLOCK_TIMESTAMP()
		)
		RETURNING id
		INTO local_documentation_id;

		SELECT documentations_insert_history into local_is_successful FROM employee_data.documentations_insert_history(
      		param_documentation_id := local_documentation_id,
      		param_change_type := 'FIRST INSERT',
      		param_change_description := 'FIRST INSERT'
      	);


    	RETURN local_is_successful;
    END;
$udf$;

--function of insert log
CREATE OR REPLACE FUNCTION employee_data.documentations_insert_history(
  param_documentation_id BIGINT,
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
  	INSERT INTO employee_data.documentations_history
  	(
  		documentation_id,
  		description,
		is_active,
		is_deleted,
		last_modified_by,
		last_modified_date,
		change_type,
      	change_description
  	)
  	SELECT
  		id,
  		description,
		is_active,
		is_deleted,
		last_modified_by,
		last_modified_date,
		param_change_type,
		param_change_description
	FROM
		employee_data.documentations doc
	WHERE
		doc.id = param_documentation_id
	ORDER BY
		doc.last_modified_date
	DESC
	LIMIT 1;
	local_is_successful := '1';
    RETURN local_is_successful;
  END;
$udf$;

-- funciton of list
CREATE OR REPLACE FUNCTION employee_data.get_documentations_list()
RETURNS json
LANGUAGE 'sql'
COST 100.0

AS $BODY$
	SELECT ARRAY_TO_JSON(ARRAY_AGG(ROW_TO_JSON(DATA)))
	FROM (
		SELECT
			doc.id,
			doc.description as documentation
		FROM
			employee_data.documentations doc
		WHERE
			doc.is_active = '1'
		AND
			doc.is_deleted = '0'
	)DATA;
$BODY$;

--function get one data
CREATE OR REPLACE FUNCTION employee_data.get_documentation(
	param_id INTEGER
)
RETURNS json
LANGUAGE 'sql'
COST 100.0

AS $BODY$
	SELECT ARRAY_TO_JSON(ARRAY_AGG(ROW_TO_JSON(DATA)))
	FROM (
		SELECT
			doc.id,
			doc.description as documentation
		FROM
			employee_data.documentations doc
		WHERE
			doc.is_active = '1'
		AND
			doc.is_deleted = '0'
		AND
			doc.id = param_id
	)DATA;
$BODY$;

-- function update all columns
CREATE OR REPLACE FUNCTION employee_data.documentation_update_all_columns(
	param_id INTEGER,
	param_description VARCHAR,
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
  		UPDATE employee_data.documentations SET
  			description = param_description,
  			is_active = param_is_active,
  			is_deleted = param_is_deleted,
  			last_modified_by = param_user_id,
      		last_modified_date = CLOCK_TIMESTAMP()
      	WHERE
      		id = param_id;

      	SELECT documentations_insert_history into local_is_successful FROM employee_data.documentations_insert_history(
      		param_documentation_id := param_id,
      		param_change_type := 'UPDATE all_columns',
      		param_change_description := 'UPDATE value of all columns'
      	);


    	RETURN local_is_successful;
  	END;
$udf$;

-- function update is active
CREATE OR REPLACE FUNCTION employee_data.documentation_update_is_active(
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
  		UPDATE employee_data.documentations SET
  			is_active = param_is_active,
  			last_modified_by = param_user_id,
      		last_modified_date = CLOCK_TIMESTAMP()
      	WHERE
      		id = param_id;

      	SELECT documentations_insert_history into local_is_successful FROM employee_data.documentations_insert_history(
      		param_documentation_id := param_id,
      		param_change_type := 'UPDATE is_active',
      		param_change_description := 'UPDATE value of is_active'
      	);


    	RETURN local_is_successful;
  	END;
$udf$;

-- function update is deleted
CREATE OR REPLACE FUNCTION employee_data.documentation_update_is_deleted(
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
  		UPDATE employee_data.documentations SET
  			is_deleted = param_is_deleted,
  			last_modified_by = param_user_id,
      		last_modified_date = CLOCK_TIMESTAMP()
      	WHERE
      		id = param_id;

      	SELECT documentations_insert_history into local_is_successful FROM employee_data.documentations_insert_history(
      		param_documentation_id := param_id,
      		param_change_type := 'UPDATE is_deleted',
      		param_change_description := 'UPDATE value of is_deleted'
      	);

    	RETURN local_is_successful;
  	END;
$udf$;

-- function gender

--function of insert
CREATE OR REPLACE FUNCTION employee_data.genders_insert(
	param_description VARCHAR,
	param_user_id BIGINT
)
RETURNS BIT
LANGUAGE plpgsql VOLATILE
COST 100.0
AS $udf$
	DECLARE
		local_is_successful BIT := '0';
		local_gender_id BIGINT;
	BEGIN
		INSERT INTO employee_data.genders(
			description,
			is_active,
			is_deleted,
			last_modified_by,
			last_modified_date
		)
		VALUES(
			param_description,
			'1',
			'0',
			param_user_id,
			CLOCK_TIMESTAMP()
		)
		RETURNING id
		INTO STRICT local_gender_id;

		SELECT genders_insert_history into local_is_successful FROM employee_data.genders_insert_history(
      		param_gender_id := local_gender_id,
      		param_change_type := 'FIRST INSERT',
      		param_change_description := 'FIRST INSERT'
      	);


    	RETURN local_is_successful;
    END;
$udf$;

--function of insert log
CREATE OR REPLACE FUNCTION employee_data.genders_insert_history(
  param_gender_id BIGINT,
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
  	INSERT INTO employee_data.genders_history
  	(
  		gender_id,
  		description,
		is_active,
		is_deleted,
		last_modified_by,
		last_modified_date,
		change_type,
      	change_description
  	)
  	SELECT
  		id,
  		description,
		is_active,
		is_deleted,
		last_modified_by,
		last_modified_date,
		param_change_type,
		param_change_description
	FROM
		employee_data.genders gen
	WHERE
		gen.id = param_gender_id
	ORDER BY
		gen.last_modified_date
	DESC
	LIMIT 1;
	local_is_successful := '1';
    RETURN local_is_successful;
  END;
$udf$;

-- funciton of list
CREATE OR REPLACE FUNCTION employee_data.get_genders_list()
RETURNS json
LANGUAGE 'sql'
COST 100.0

AS $BODY$
	SELECT ARRAY_TO_JSON(ARRAY_AGG(ROW_TO_JSON(DATA)))
	FROM (
		SELECT
			gen.id,
			gen.description as gender
		FROM
			employee_data.genders gen
		WHERE
			gen.is_active = '1'
		AND
			gen.is_deleted = '0'
	)DATA;
$BODY$;

--function get one data
CREATE OR REPLACE FUNCTION employee_data.get_gender(
	param_id INTEGER
)
RETURNS json
LANGUAGE 'sql'
COST 100.0

AS $BODY$
	SELECT ARRAY_TO_JSON(ARRAY_AGG(ROW_TO_JSON(DATA)))
	FROM (
		SELECT
			gen.id,
			gen.description as gender
		FROM
			employee_data.genders gen
		WHERE
			gen.is_active = '1'
		AND
			gen.is_deleted = '0'
		AND
			gen.id = param_id
	)DATA;
$BODY$;

-- function update all columns
CREATE OR REPLACE FUNCTION employee_data.gender_update_all_columns(
	param_id INTEGER,
	param_description VARCHAR,
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
  		UPDATE employee_data.genders SET
  			description = param_description,
  			is_active = param_is_active,
  			is_deleted = param_is_deleted,
  			last_modified_by = param_user_id,
      		last_modified_date = CLOCK_TIMESTAMP()
      	WHERE
      		id = param_id;

      	SELECT genders_insert_history into local_is_successful FROM employee_data.genders_insert_history(
      		param_gender_id := param_id,
      		param_change_type := 'UPDATE all_columns',
      		param_change_description := 'UPDATE value of all columns'
      	);


    	RETURN local_is_successful;
  	END;
$udf$;

-- function update is active
CREATE OR REPLACE FUNCTION employee_data.gender_update_is_active(
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
  		UPDATE employee_data.genders SET
  			is_active = param_is_active,
  			last_modified_by = param_user_id,
      		last_modified_date = CLOCK_TIMESTAMP()
      	WHERE
      		id = param_id;

      	SELECT genders_insert_history into local_is_successful FROM employee_data.genders_insert_history(
      		param_gender_id := param_id,
      		param_change_type := 'UPDATE is_active',
      		param_change_description := 'UPDATE value of is_active'
      	);


    	RETURN local_is_successful;
  	END;
$udf$;

-- function update is deleted
CREATE OR REPLACE FUNCTION employee_data.gender_update_is_deleted(
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
  		UPDATE employee_data.genders SET
  			is_deleted = param_is_deleted,
  			last_modified_by = param_user_id,
      		last_modified_date = CLOCK_TIMESTAMP()
      	WHERE
      		id = param_id;

      	SELECT genders_insert_history into local_is_successful FROM employee_data.genders_insert_history(
      		param_gender_id := param_id,
      		param_change_type := 'UPDATE is_deleted',
      		param_change_description := 'UPDATE value of is_deleted'
      	);

    	RETURN local_is_successful;
  	END;
$udf$;

--function of nacionality

--function of insert
CREATE OR REPLACE FUNCTION employee_data.nacionalities_insert(
	param_description VARCHAR,
	param_user_id BIGINT
)
RETURNS BIT
LANGUAGE plpgsql VOLATILE
COST 100.0
AS $udf$
	DECLARE
		local_is_successful BIT := '0';
		local_nacionality_id BIGINT;
	BEGIN
		INSERT INTO employee_data.nacionalities(
			description,
			is_active,
			is_deleted,
			last_modified_by,
			last_modified_date
		)
		VALUES(
			param_description,
			'1',
			'0',
			param_user_id,
			CLOCK_TIMESTAMP()
		)
		RETURNING id
		INTO STRICT local_nacionality_id;

		SELECT nacionalities_insert_history into local_is_successful FROM employee_data.nacionalities_insert_history(
      		param_nacionality_id := local_nacionality_id,
      		param_change_type := 'FIRST INSERT',
      		param_change_description := 'FIRST INSERT'
      	);


    	RETURN local_is_successful;
    END;
$udf$;

--function of insert log
CREATE OR REPLACE FUNCTION employee_data.nacionalities_insert_history(
  param_nacionality_id BIGINT,
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
  	INSERT INTO employee_data.nacionalities_history
  	(
  		nacionality_id,
  		description,
		is_active,
		is_deleted,
		last_modified_by,
		last_modified_date,
		change_type,
      	change_description
  	)
  	SELECT
  		id,
  		description,
		is_active,
		is_deleted,
		last_modified_by,
		last_modified_date,
		param_change_type,
		param_change_description
	FROM
		employee_data.nacionalities nac
	WHERE
		nac.id = param_nacionality_id
	ORDER BY
		nac.last_modified_date
	DESC
	LIMIT 1;
	local_is_successful := '1';
    RETURN local_is_successful;
  END;
$udf$;

-- funciton of list
CREATE OR REPLACE FUNCTION employee_data.get_nacionalities_list()
RETURNS json
LANGUAGE 'sql'
COST 100.0

AS $BODY$
	SELECT ARRAY_TO_JSON(ARRAY_AGG(ROW_TO_JSON(DATA)))
	FROM (
		SELECT
			nac.id,
			nac.description as nacionality
		FROM
			employee_data.nacionalities nac
		WHERE
			nac.is_active = '1'
		AND
			nac.is_deleted = '0'
	)DATA;
$BODY$;

--function get one data
CREATE OR REPLACE FUNCTION employee_data.get_nacionality(
	param_id INTEGER
)
RETURNS json
LANGUAGE 'sql'
COST 100.0

AS $BODY$
	SELECT ARRAY_TO_JSON(ARRAY_AGG(ROW_TO_JSON(DATA)))
	FROM (
		SELECT
			nac.id,
			nac.description as nacionality
		FROM
			employee_data.nacionalities nac
		WHERE
			nac.is_active = '1'
		AND
			nac.is_deleted = '0'
		AND
			nac.id = param_id
	)DATA;
$BODY$;

-- function update all columns
CREATE OR REPLACE FUNCTION employee_data.nacionality_update_all_columns(
	param_id INTEGER,
	param_description VARCHAR,
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
  		UPDATE employee_data.nacionalities SET
  			description = param_description,
  			is_active = param_is_active,
  			is_deleted = param_is_deleted,
  			last_modified_by = param_user_id,
      		last_modified_date = CLOCK_TIMESTAMP()
      	WHERE
      		id = param_id;

      	SELECT nacionalities_insert_history into local_is_successful FROM employee_data.nacionalities_insert_history(
      		param_nacionality_id := param_id,
      		param_change_type := 'UPDATE all_columns',
      		param_change_description := 'UPDATE value of all columns'
      	);


    	RETURN local_is_successful;
  	END;
$udf$;

-- function update is active
CREATE OR REPLACE FUNCTION employee_data.nacionality_update_is_active(
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
  		UPDATE employee_data.nacionalities SET
  			is_active = param_is_active,
  			last_modified_by = param_user_id,
      		last_modified_date = CLOCK_TIMESTAMP()
      	WHERE
      		id = param_id;

      	SELECT nacionalities_insert_history into local_is_successful FROM employee_data.nacionalities_insert_history(
      		param_nacionality_id := param_id,
      		param_change_type := 'UPDATE is_active',
      		param_change_description := 'UPDATE value of is_active'
      	);


    	RETURN local_is_successful;
  	END;
$udf$;

-- function update is deleted
CREATE OR REPLACE FUNCTION employee_data.nacionality_update_is_deleted(
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
  		UPDATE employee_data.nacionalities SET
  			is_deleted = param_is_deleted,
  			last_modified_by = param_user_id,
      		last_modified_date = CLOCK_TIMESTAMP()
      	WHERE
      		id = param_id;

      	SELECT nacionalities_insert_history into local_is_successful FROM employee_data.nacionalities_insert_history(
      		param_nacionality_id := param_id,
      		param_change_type := 'UPDATE is_deleted',
      		param_change_description := 'UPDATE value of is_deleted'
      	);

    	RETURN local_is_successful;
  	END;
$udf$;

-- function of employee salares

-- function of insert

CREATE OR REPLACE FUNCTION employee_data.employee_salaries_insert(
	param_employee_id INTEGER,
	param_salary_id INTEGER,
	param_user_id BIGINT
)
RETURNS BIT
LANGUAGE plpgsql VOLATILE
COST 100.0
AS $udf$
	DECLARE
		local_is_successful BIT := '0';
		local_employee_salaries BIGINT;
	BEGIN
		INSERT INTO employee_data.employee_salaries(
			employee_id,
			salary_id,
			insert_date,
			is_active,
			is_deleted,
			last_modified_by,
			last_modified_date
		)
		VALUES(
			param_employee_id,
			param_salary_id,
			CLOCK_TIMESTAMP(),
			'0',
			'0',
			param_user_id,
			CLOCK_TIMESTAMP()
		)
		RETURNING  id
		INTO STRICT local_employee_salaries;

		SELECT employee_salaries_insert_history INTO local_is_successful FROM employee_data.employee_salaries_insert_history(
			param_employee_salary_id := local_employee_salaries,
			param_change_type := 'FIRST INSERT',
      		param_change_description := 'FIRST INSERT'
      	);


    	RETURN local_is_successful;
    END;
$udf$;


--function of insert log
CREATE OR REPLACE FUNCTION employee_data.employee_salaries_insert_history(
	param_employee_salary_id BIGINT,
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
  	INSERT INTO employee_data.employee_salaries_history(
  		employee_salary_id,
  		employee_id,
  		salary_id,
		insert_date,
  		is_active,
  		is_deleted,
  		last_modified_by,
  		last_modified_date,
  		change_type,
  		change_description
  	)
  	SELECT
  		id,
  		employee_id,
  		salary_id,
		insert_date,
  		is_active,
  		is_deleted,
  		last_modified_by,
  		last_modified_date,
  		param_change_type,
  		param_change_description
  	FROM
  		employee_data.employee_salaries emsal
  	WHERE
  		emsal.id = param_employee_salary_id
  	ORDER BY
  		emsal.last_modified_date
  	DESC
	LIMIT 1;
	local_is_successful := '1';
    RETURN local_is_successful;
  END;
$udf$;

 -- function get list
CREATE OR REPLACE FUNCTION employee_data.get_employee_salaries_list()
RETURNS json
LANGUAGE 'sql'
COST 100.0

AS $BODY$
	SELECT ARRAY_TO_JSON(ARRAY_AGG(ROW_TO_JSON(DATA)))
	FROM (
		SELECT
			emsal.id,
			emp.first_name,
			emp.surname,
			sal.salary
		FROM
			employee_data.employee_salaries emsal
			INNER JOIN
				employee_data.employees emp ON
					emp.id = emsal.employee_id
				AND
					emp.is_active = '1'
				AND
					emp.is_deleted = '0'
			INNER JOIN
				employee_data.salaries sal ON
					sal.id = emsal.salary_id
				AND
					sal.is_active = '1'
				AND
					sal.is_deleted = '0'
		WHERE
			emsal.is_active = '1'
		AND
			emsal.is_deleted = '0'
	)DATA;
$BODY$;

-- function get list filter 1
CREATE OR REPLACE FUNCTION employee_data.get_employee_salaries_filter_employe_search(
	param_employee_id BIGINT
)
RETURNS json
LANGUAGE 'sql'
COST 100.0

AS $BODY$
	SELECT ARRAY_TO_JSON(ARRAY_AGG(ROW_TO_JSON(DATA)))
	FROM (
		SELECT
			emsal.id,
			emp.first_name,
			emp.surname,
			sal.salary
		FROM
			employee_data.employee_salaries emsal
			INNER JOIN
				employee_data.employees emp ON
					emp.id = emsal.employee_id
				AND
					emp.is_active = '1'
				AND
					emp.is_deleted = '0'
			INNER JOIN
				employee_data.salaries sal ON
					sal.id = emsal.salary_id
				AND
					sal.is_active = '1'
				AND
					sal.is_deleted = '0'
		WHERE
			emsal.is_active = '1'
		AND
			emsal.is_deleted = '0'
		AND
			emsal.employee_id = param_employee_id
	)DATA;
$BODY$;

-- function get list filter 2
CREATE OR REPLACE FUNCTION employee_data.get_employee_salaries_filter_salay_list(
	param_salary_id BIGINT
)
RETURNS json
LANGUAGE 'sql'
COST 100.0

AS $BODY$
	SELECT ARRAY_TO_JSON(ARRAY_AGG(ROW_TO_JSON(DATA)))
	FROM (
		SELECT
			emsal.id,
			emp.first_name,
			emp.surname,
			sal.salary
		FROM
			employee_data.employee_salaries emsal
			INNER JOIN
				employee_data.employees emp ON
					emp.id = emsal.employee_id
				AND
					emp.is_active = '1'
				AND
					emp.is_deleted = '0'
			INNER JOIN
				employee_data.salaries sal ON
					sal.id = emsal.salary_id
				AND
					sal.is_active = '1'
				AND
					sal.is_deleted = '0'
		WHERE
			emsal.is_active = '1'
		AND
			emsal.is_deleted = '0'
		AND
			emsal.salary_id = param_salary_id
	)DATA;
$BODY$;

-- function get one
CREATE OR REPLACE FUNCTION employee_data.get_employee_salary_search(
	param_id BIGINT
)
RETURNS json
LANGUAGE 'sql'
COST 100.0

AS $BODY$
	SELECT ARRAY_TO_JSON(ARRAY_AGG(ROW_TO_JSON(DATA)))
	FROM (
		SELECT
			emsal.id,
			emp.first_name,
			emp.surname,
			sal.salary
		FROM
			employee_data.employee_salaries emsal
			INNER JOIN
				employee_data.employees emp ON
					emp.id = emsal.employee_id
				AND
					emp.is_active = '1'
				AND
					emp.is_deleted = '0'
			INNER JOIN
				employee_data.salaries sal ON
					sal.id = emsal.salary_id
				AND
					sal.is_active = '1'
				AND
					sal.is_deleted = '0'
		WHERE
			emsal.is_active = '1'
		AND
			emsal.is_deleted = '0'
		AND
			emsal.id = param_id
	)DATA;
$BODY$;

--function filter 3
CREATE OR REPLACE FUNCTION employee_data.get_employee_salaries_filter_salay_employee_search(
	param_salary_id BIGINT,
	param_employee_id BIGINT
)
RETURNS json
LANGUAGE 'sql'
COST 100.0

AS $BODY$
	SELECT ARRAY_TO_JSON(ARRAY_AGG(ROW_TO_JSON(DATA)))
	FROM (
		SELECT
			emsal.id,
			emp.first_name,
			emp.surname,
			sal.salary
		FROM
			employee_data.employee_salaries emsal
			INNER JOIN
				employee_data.employees emp ON
					emp.id = emsal.employee_id
				AND
					emp.is_active = '1'
				AND
					emp.is_deleted = '0'
			INNER JOIN
				employee_data.salaries sal ON
					sal.id = emsal.salary_id
				AND
					sal.is_active = '1'
				AND
					sal.is_deleted = '0'
		WHERE
			emsal.is_active = '1'
		AND
			emsal.is_deleted = '0'
		AND
			emsal.salary_id = param_salary_id
		AND
			emsal.employee_id = param_employee_id
	)DATA;
$BODY$;


--function update all columns
CREATE OR REPLACE FUNCTION employee_data.employee_salary_update_all_columns(
	param_id INTEGER,
	param_employee_id INTEGER,
	param_salary_id INTEGER,
	param_is_active BIT,
	param_is_deleted BIT,
	param_user_id INTEGER
)
RETURNS BIT
LANGUAGE plpgsql VOLATILE
COST 100.0
AS $udf$
	DECLARE
    	local_is_successful BIT := '0';
  	BEGIN
  		UPDATE employee_data.employee_salaries SET
  			salary_id = param_salary_id,
  			insert_date = CLOCK_TIMESTAMP(),
  			is_active = param_is_active,
  			is_deleted = param_is_deleted,
  			last_modified_by = param_user_id,
  			last_modified_date = CLOCK_TIMESTAMP()
  		WHERE
  			id = param_id
  		AND
  			employee_id = param_employee_id;

  		SELECT employee_salaries_insert_history into local_is_successful FROM employee_data.employee_salaries_insert_history(
      		param_employee_salary_id := param_id,
      		param_change_type := 'UPDATE all_columns',
      		param_change_description := 'UPDATE value of all columns'
      	);


    	RETURN local_is_successful;
  	END;
$udf$;

--function update salary
CREATE OR REPLACE FUNCTION employee_data.employee_salary_update_salary(
	param_id INTEGER,
	param_employee_id INTEGER,
	param_salary_id INTEGER,
	param_user_id INTEGER
)
RETURNS BIT
LANGUAGE plpgsql VOLATILE
COST 100.0
AS $udf$
	DECLARE
    	local_is_successful BIT := '0';
  	BEGIN
  		UPDATE employee_data.employee_salaries SET
  			salary_id = param_salary_id,
  			insert_date = CLOCK_TIMESTAMP(),
  			last_modified_by = param_user_id,
  			last_modified_date = CLOCK_TIMESTAMP()
  		WHERE
  			id = param_id
  		AND
  			employee_id = param_employee_id;

  		SELECT employee_salaries_insert_history into local_is_successful FROM employee_data.employee_salaries_insert_history(
      		param_employee_salary_id := param_id,
      		param_change_type := 'UPDATE salary',
      		param_change_description := 'UPDATE value of salary'
      	);


    	RETURN local_is_successful;
  	END;
$udf$;


-- function update is_active
CREATE OR REPLACE FUNCTION employee_data.employee_salary_update_is_active(
	param_id INTEGER,
	param_employee_id INTEGER,
	oaram_is_active BIT,
	param_user_id INTEGER
)
RETURNS BIT
LANGUAGE plpgsql VOLATILE
COST 100.0
AS $udf$
	DECLARE
    	local_is_successful BIT := '0';
  	BEGIN
  		UPDATE employee_data.employee_salaries SET
  			is_active = param_is_active,
  			last_modified_by = param_user_id,
  			last_modified_date = CLOCK_TIMESTAMP()
  		WHERE
  			id = param_id
  		AND
  			employee_id = param_employee_id;

  		SELECT employee_salaries_insert_history into local_is_successful FROM employee_data.employee_salaries_insert_history(
      		param_employee_salary_id := param_id,
      		param_change_type := 'UPDATE is_active',
      		param_change_description := 'UPDATE value of is_active'
      	);


    	RETURN local_is_successful;
  	END;
$udf$;

-- function update is_deleted
CREATE OR REPLACE FUNCTION employee_data.employee_salary_update_is_deleted(
	param_id INTEGER,
	param_employee_id INTEGER,
	param_is_deleted BIT,
	param_user_id INTEGER
)
RETURNS BIT
LANGUAGE plpgsql VOLATILE
COST 100.0
AS $udf$
	DECLARE
    	local_is_successful BIT := '0';
  	BEGIN
  		UPDATE employee_data.employee_salaries SET
  			is_deleted = param_is_deleted,
  			last_modified_by = param_user_id,
  			last_modified_date = CLOCK_TIMESTAMP()
  		WHERE
  			id = param_id
  		AND
  			employee_id = param_employee_id;

  		SELECT employee_salaries_insert_history into local_is_successful FROM employee_data.employee_salaries_insert_history(
      		param_employee_salary_id := param_id,
      		param_change_type := 'UPDATE is_deleted',
      		param_change_description := 'UPDATE value of is_deleted'
      	);


    	RETURN local_is_successful;
  	END;
$udf$;


-- function of idac

--function of insert
CREATE OR REPLACE FUNCTION employee_data.idac_codes_insert(
 param_idac_code VARCHAR,
 param_execunting_unit_id INTEGER,
 param_vacant_date DATE,
 param_user_id INTEGER
)
RETURNS BIT
LANGUAGE plpgsql VOLATILE
COST 100.0
AS $udf$
	DECLARE
    	local_is_successful BIT := '0';
    	local_idac_id BIGINT;
  	BEGIN
  		IF EXISTS (
  			SELECT
  				idac.code
  			FROM
  				employee_data.idac_codes idac
  				INNER JOIN
  					employee_data.execunting_unit exec ON
  						exec.id = idac.execunting_unit_id
  					AND
  						exec.is_active = '1'
  					AND
  						exec.is_deleted = '0'
  				WHERE
  					idac.is_active = '1'
  				AND
  					idac.is_deleted = '0'
  				AND
  					idac.code = param_idac_code
  				AND
  					idac.execunting_unit_id = param_execunting_unit_id
  		)
  		THEN
  			RETURN local_idac_id;
  		ELSE
  			INSERT INTO employee_data.idac_codes(
	  			code,
	  			execunting_unit_id,
	  			vacant_date,
	  			is_active,
	  			is_deleted,
	  			last_modified_by,
	  			last_modified_date
	  		)
	  		VALUES(
	  			param_idac_code,
	  			param_execunting_unit_id,
	  			param_vacant_date,
	  			'1',
	  			'0',
	  			param_user_id,
	  			CLOCK_TIMESTAMP()
	  		)
	  		RETURNING id
	  		INTO STRICT local_idac_id;

	  		SELECT idac_codes_insert_history INTO local_is_successful FROM employee_data.idac_codes_insert_history(
	  			param_idac_id := local_idac_id,
	  			param_change_type := 'FIRST INSERT',
      			param_change_description := 'FIRST INSERT'
	  		);

	  		RETURN local_is_successful;
	  	END IF;
	END;
$udf$;

-- function insert log
CREATE OR REPLACE FUNCTION employee_data.idac_codes_insert_history(
	param_idac_id BIGINT,
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
    	INSERT INTO employee_data.idac_codes_history(
    		idac_code_id,
    		code,
    		execunting_unit_id,
    		vacant_date,
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
    		execunting_unit_id,
    		vacant_date,
    		is_active,
    		is_deleted,
    		last_modified_by,
    		last_modified_date,
    		param_change_type,
    		param_change_description
    	FROM
    		employee_data.idac_codes idac
    	WHERE
    		idac.id = param_idac_id
    	ORDER BY
    		idac.last_modified_date
    	DESC
    	LIMIT 1;

    	local_is_successful :='1';
   		RETURN local_is_successful;
  	END;
$udf$;

-- function get list
CREATE OR REPLACE FUNCTION employee_data.get_idac_codes_list()
RETURNS json
LANGUAGE 'sql'
COST 100.0

AS $BODY$
	SELECT ARRAY_TO_JSON(ARRAY_AGG(ROW_TO_JSON(DATA)))
	FROM (
		SELECT
			idac.id,
			idac.code,
			idac.execunting_unit_id,
			vacant_date
		FROM
			employee_data.idac_codes idac
			INNER JOIN
				employee_data.execunting_unit exec ON
					exec.id = idac.execunting_unit_id
				AND
					exec.is_active = '1'
				AND
					exec.is_deleted = '0'
		WHERE
			idac.is_active = '1'
		AND
			idac.is_deleted = '0'
	)DATA;
$BODY$;

-- function get list with vacant_date is null
CREATE OR REPLACE FUNCTION employee_data.get_idac_codes_filter_vacant_date_null_list()
RETURNS json
LANGUAGE 'sql'
COST 100.0

AS $BODY$
	SELECT ARRAY_TO_JSON(ARRAY_AGG(ROW_TO_JSON(DATA)))
	FROM (
		SELECT
			idac.id,
			idac.code,
			idac.execunting_unit_id
		FROM
			employee_data.idac_codes idac
			INNER JOIN
				employee_data.execunting_unit exec ON
					exec.id = idac.execunting_unit_id
				AND
					exec.is_active = '1'
				AND
					exec.is_deleted = '0'
		WHERE
			idac.is_active = '1'
		AND
			idac.is_deleted = '0'
		AND
			idac.vacant_date = null
	)DATA;
$BODY$;


--function get list filter vacant not is null
CREATE OR REPLACE FUNCTION employee_data.get_idac_codes_filter_vacant_date_not_null_list()
RETURNS json
LANGUAGE 'sql'
COST 100.0

AS $BODY$
	SELECT ARRAY_TO_JSON(ARRAY_AGG(ROW_TO_JSON(DATA)))
	FROM (
		SELECT
			idac.id,
			idac.code,
			idac.execunting_unit_id
		FROM
			employee_data.idac_codes idac
			INNER JOIN
				employee_data.execunting_unit exec ON
					exec.id = idac.execunting_unit_id
				AND
					exec.is_active = '1'
				AND
					exec.is_deleted = '0'
		WHERE
			idac.is_active = '1'
		AND
			idac.is_deleted = '0'
		AND
			idac.vacant_date != null
	)DATA;
$BODY$;

--function get list filter vacant not is null and execunting_unit
CREATE OR REPLACE FUNCTION employee_data.get_idac_codes_filter_vacant_date_not_null_exec_unit_list(
	param_execunting_unit_id INTEGER[]
)
RETURNS json
LANGUAGE 'sql'
COST 100.0

AS $BODY$
	SELECT ARRAY_TO_JSON(ARRAY_AGG(ROW_TO_JSON(DATA)))
	FROM (
		SELECT
			idac.id,
			idac.code,
			idac.execunting_unit_id,
			exec.description as execunting_unit
		FROM
			employee_data.idac_codes idac
			INNER JOIN
				employee_data.execunting_unit exec ON
					exec.id = idac.execunting_unit_id
				AND
					exec.is_active = '1'
				AND
					exec.is_deleted = '0'
		WHERE
			idac.is_active = '1'
		AND
			idac.is_deleted = '0'
		AND
			idac.vacant_date IS NOT NULL
		AND
			idac.execunting_unit_id = ANY(param_execunting_unit_id)
	)DATA;
$BODY$;

--function get list filter vacant is null and execunting_unit
CREATE OR REPLACE FUNCTION employee_data.get_idac_codes_filter_vacant_date_null_exec_unit_list(
	param_execunting_unit_id INTEGER
)
RETURNS json
LANGUAGE 'sql'
COST 100.0

AS $BODY$
	SELECT ARRAY_TO_JSON(ARRAY_AGG(ROW_TO_JSON(DATA)))
	FROM (
		SELECT
			idac.id,
			idac.code,
			idac.execunting_unit_id
		FROM
			employee_data.idac_codes idac
			INNER JOIN
				employee_data.execunting_unit exec ON
					exec.id = idac.execunting_unit_id
				AND
					exec.is_active = '1'
				AND
					exec.is_deleted = '0'
		WHERE
			idac.is_active = '1'
		AND
			idac.is_deleted = '0'
		AND
			idac.vacant_date = null
		AND
			idac.execunting_unit_id = param_execunting_unit_id
	)DATA;
$BODY$;

--function get list filter vacant not is null and execunting_unit
CREATE OR REPLACE FUNCTION employee_data.get_idac_codes_filter_vacant_date_not_null_exec_unit_list(
	param_execunting_unit_id INTEGER
)
RETURNS json
LANGUAGE 'sql'
COST 100.0

AS $BODY$
	SELECT ARRAY_TO_JSON(ARRAY_AGG(ROW_TO_JSON(DATA)))
	FROM (
		SELECT
			idac.id,
			idac.code,
			idac.execunting_unit_id
		FROM
			employee_data.idac_codes idac
			INNER JOIN
				employee_data.execunting_unit exec ON
					exec.id = idac.execunting_unit_id
				AND
					exec.is_active = '1'
				AND
					exec.is_deleted = '0'
		WHERE
			idac.is_active = '1'
		AND
			idac.is_deleted = '0'
		AND
			idac.vacant_date != null
		AND
			idac.execunting_unit_id = param_execunting_unit_id
	)DATA;
$BODY$;

--function get list filter  execunting_unit
CREATE OR REPLACE FUNCTION employee_data.get_idac_codes_filter_exec_unit_list(
	param_execunting_unit_id INTEGER
)
RETURNS json
LANGUAGE 'sql'
COST 100.0

AS $BODY$
	SELECT ARRAY_TO_JSON(ARRAY_AGG(ROW_TO_JSON(DATA)))
	FROM (
		SELECT
			idac.id,
			idac.code,
			idac.execunting_unit_id
		FROM
			employee_data.idac_codes idac
			INNER JOIN
				employee_data.execunting_unit exec ON
					exec.id = idac.execunting_unit_id
				AND
					exec.is_active = '1'
				AND
					exec.is_deleted = '0'
		WHERE
			idac.is_active = '1'
		AND
			idac.is_deleted = '0'
		AND
			idac.execunting_unit_id = param_execunting_unit_id
	)DATA;
$BODY$;

--function get
CREATE OR REPLACE FUNCTION employee_data.get_idac_code(
	param_id INTEGER,
	param_execunting_unit_id INTEGER
)
RETURNS json
LANGUAGE 'sql'
COST 100.0

AS $BODY$
	SELECT ARRAY_TO_JSON(ARRAY_AGG(ROW_TO_JSON(DATA)))
	FROM (
		SELECT
			idac.id,
			idac.code,
			idac.execunting_unit_id
		FROM
			employee_data.idac_codes idac
			INNER JOIN
				employee_data.execunting_unit exec ON
					exec.id = idac.execunting_unit_id
				AND
					exec.is_active = '1'
				AND
					exec.is_deleted = '0'
		WHERE
			idac.is_active = '1'
		AND
			idac.is_deleted = '0'
		AND
			idac.execunting_unit_id = param_execunting_unit_id
		AND
			idac.id = param_id
	)DATA;
$BODY$;

--function get by code
CREATE OR REPLACE FUNCTION employee_data.get_idac_code_search(
	param_idac_code VARCHAR,
	param_execunting_unit_id INTEGER
)
RETURNS json
LANGUAGE 'sql'
COST 100.0

AS $BODY$
	SELECT ARRAY_TO_JSON(ARRAY_AGG(ROW_TO_JSON(DATA)))
	FROM (
		SELECT
			idac.id,
			idac.code,
			idac.execunting_unit_id
		FROM
			employee_data.idac_codes idac
			INNER JOIN
				employee_data.execunting_unit exec ON
					exec.id = idac.execunting_unit_id
				AND
					exec.is_active = '1'
				AND
					exec.is_deleted = '0'
		WHERE
			idac.is_active = '1'
		AND
			idac.is_deleted = '0'
		AND
			idac.execunting_unit_id = param_execunting_unit_id
		AND
			idac.code = param_idac_code
	)DATA;
$BODY$;

-- function update all columns
CREATE OR REPLACE FUNCTION employee_data.idac_codes_update_all_columns(
	param_id INTEGER,
	param_idac_code VARCHAR,
	param_execunting_unit_id INTEGER,
	param_vacant_date DATE,
	param_is_active BIT,
	param_is_deleted BIT,
	param_user_id BIGINT
)
RETURNS BIT
LANGUAGE plpgsql VOLATILE
COST 100.0
AS $udf$
	DECLARE
    	local_is_successful BIT := '0';
  	BEGIN
  		UPDATE employee_data.idac_codes SET
  			code = param_idac_code,
  			execunting_unit_id = param_execunting_unit_id,
  			vacant_date = param_vacant_date,
  			is_active = param_is_active,
  			is_deleted = param_is_deleted,
  			last_modified_by = param_user_id,
  			last_modified_date = CLOCK_TIMESTAMP()
  		WHERE
  			id = param_id;

  		SELECT idac_codes_insert_history INTO local_is_successful FROM employe_data.idac_codes_insert_history(
  			param_idac_id := param_id,
  			param_change_type := 'UPDATE all_columns',
      		param_change_description := 'UPDATE value of all columns'
  		);

  		RETURN local_is_successful;
  	END;
$udf$;

-- function update vacant_date
CREATE OR REPLACE FUNCTION employee_data.idac_codes_update_vacant_date(
	param_id INTEGER,
	param_idac_code INTEGER,
	param_vacant_date DATE,
	param_user_id BIGINT
)
RETURNS BIT
LANGUAGE plpgsql VOLATILE
COST 100.0
AS $udf$
	DECLARE
    	local_is_successful BIT := '0';
  	BEGIN
  		UPDATE employee_data.idac_codes SET
  			vacant_date = param_vacant_date,
  			last_modified_by = param_user_id,
  			last_modified_date = CLOCK_TIMESTAMP()
  		WHERE
  			id = param_id
  		AND
  			code = param_idac_code;

  		SELECT idac_codes_insert_history INTO local_is_successful FROM employe_data.idac_codes_insert_history(
  			param_idac_id := param_id,
  			param_change_type := 'UPDATE vacant_date',
      		param_change_description := 'UPDATE value of vacant_date'
  		);

  		RETURN local_is_successful;
  	END;
$udf$;


-- function update is_active
CREATE OR REPLACE FUNCTION employee_data.idac_codes_update_is_active(
	param_id INTEGER,
	param_idac_code INTEGER,
	param_is_active BIT,
	param_user_id BIGINT
)
RETURNS BIT
LANGUAGE plpgsql VOLATILE
COST 100.0
AS $udf$
	DECLARE
    	local_is_successful BIT := '0';
  	BEGIN
  		UPDATE employee_data.idac_codes SET
  			is_active = param_is_active,
  			last_modified_by = param_user_id,
  			last_modified_date = CLOCK_TIMESTAMP()
  		WHERE
  			id = param_id
  		AND
  			code = param_idac_code;

  		SELECT idac_codes_insert_history INTO local_is_successful FROM employe_data.idac_codes_insert_history(
  			param_idac_id := param_id,
  			param_change_type := 'UPDATE is_active',
      		param_change_description := 'UPDATE value of is_active'
  		);

  		RETURN local_is_successful;
  	END;
$udf$;

-- function update is_active
CREATE OR REPLACE FUNCTION employee_data.idac_codes_update_is_deleted(
	param_id INTEGER,
	param_idac_code INTEGER,
	param_is_deleted BIT,
	param_user_id BIGINT
)
RETURNS BIT
LANGUAGE plpgsql VOLATILE
COST 100.0
AS $udf$
	DECLARE
    	local_is_successful BIT := '0';
  	BEGIN
  		UPDATE employee_data.idac_codes SET
  			is_deleted = param_is_deleted,
  			last_modified_by = param_user_id,
  			last_modified_date = CLOCK_TIMESTAMP()
  		WHERE
  			id = param_id
  		AND
  			code = param_idac_code;

  		SELECT idac_codes_insert_history INTO local_is_successful FROM employe_data.idac_codes_insert_history(
  			param_idac_id := param_id,
  			param_change_type := 'UPDATE is_deleted',
      		param_change_description := 'UPDATE value of is_deleted'
  		);

  		RETURN local_is_successful;
  	END;
$udf$;

-- functions of employee_idac_code
-- function of insert
CREATE OR REPLACE FUNCTION employee_data.employee_idac_code_insert(
	param_employee_id INTEGER,
	param_idac_code_id INTEGER,
	param_user_id BIGINT
)
RETURNS BIT
LANGUAGE plpgsql VOLATILE
COST 100.0
AS $udf$
	DECLARE
		local_is_successful BIT := '0';
		local_employee_idac_code BIGINT;
	BEGIN
		IF EXISTS(
			SELECT
				empidac.employee_id
			FROM
				employee_data.employee_idac_code empidac
			WHERE
				empidac.employee_id = param_employee_id
			AND
				empidac.is_deleted = '0'
			AND
				empidac.is_active = '1'
		)
		THEN
			RETURN local_is_successful;
		ELSE
			INSERT INTO employee_data.employee_idac_code(
				employee_id,
				idac_code_id,
				is_active,
				is_deleted,
				last_modified_by,
				last_modified_date
			)
			VALUES(
				param_employee_id,
				param_idac_code_id,
				'1',
				'0',
				param_user_id,
				CLOCK_TIMESTAMP()
			)
			RETURNING id
			INTO STRICT local_employee_idac_code;

			SELECT employee_idac_code_insert_history INTO local_is_successful FROM employee_data.employee_idac_code_insert_history(
				param_employee_idac_id := local_employee_idac_code,
				param_change_type := 'FIRST INSERT',
				param_change_description := 'FIRST INSERT'
			);


			RETURN local_is_successful;
		END IF;
	END;
$udf$;

-- function of insert of log
CREATE OR REPLACE FUNCTION employee_data.employee_idac_code_insert_history(
param_employee_idac_id BIGINT,
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
		INSERT INTO employee_data.employee_idac_code_history(
			employee_idac_code_id,
			employee_id,
			idac_code_id,
			is_active,
			is_deleted,
			last_modified_by,
			last_modified_date,
			change_type,
			change_description
		)
		SELECT
			id,
			employee_id,
			idac_code_id,
			is_active,
			is_deleted,
			last_modified_by,
			last_modified_date,
			param_change_type,
			param_change_description
		FROM
			employee_data.employee_idac_code empidac
		WHERE
			empidac.id = param_employee_idac_id
		ORDER BY
			empidac.last_modified_date
		DESC
		LIMIT 1;
		local_is_successful :='1';
   		RETURN local_is_successful;
  	END;
$udf$;

-- function get list
CREATE OR REPLACE FUNCTION employee_data.get_employee_idac_code_list()
RETURNS json
LANGUAGE 'sql'
COST 100.0

AS $BODY$
	SELECT ARRAY_TO_JSON(ARRAY_AGG(ROW_TO_JSON(DATA)))
	FROM (
		SELECT
			empidac.id,
			emp.first_name,
			emp.surname,
			idac.code
		FROM
			employee_data.employee_idac_code empidac
			LEFT OUTER JOIN  employee_data.employees  emp ON
				empidac.employee_id = emp.id
			AND
				emp.is_active = '1'
			AND
				emp.is_deleted = '0'
			LEFT OUTER JOIN employee_data.idac_codes idac ON
				empidac.idac_code_id = idac.id
			AND
				idac.is_active = '1'
			AND
				idac.is_deleted = '0'
		WHERE
			empidac.is_active = '1'
		AND
			empidac.is_deleted = '0'
	)DATA;
$BODY$;

--function get filter by employee
CREATE OR REPLACE FUNCTION employee_data.get_employee_idac_code_filter_empl_search(
	param_employee_id INTEGER
)
RETURNS json
LANGUAGE 'sql'
COST 100.0

AS $BODY$
	SELECT ARRAY_TO_JSON(ARRAY_AGG(ROW_TO_JSON(DATA)))
	FROM (
		SELECT
			empidac.id,
			emp.first_name,
			emp.surname,
			idac.code
		FROM
			employee_data.employee_idac_code empidac
			LEFT OUTER JOIN  employee_data.employees  emp ON
				empidac.employee_id = emp.id
			AND
				emp.is_active = '1'
			AND
				emp.is_deleted = '0'
			LEFT OUTER JOIN employee_data.idac_codes idac ON
				empidac.idac_code_id = idac.id
			AND
				idac.is_active = '1'
			AND
				idac.is_deleted = '0'
		WHERE
			empidac.is_active = '1'
		AND
			empidac.is_deleted = '0'
		AND
			empidac.employee_id = param_employee_id
	)DATA;
$BODY$;

--function get filter by idac
CREATE OR REPLACE FUNCTION employee_data.get_employee_idac_code_filter_idac_search(
	param_idac_id INTEGER
)
RETURNS json
LANGUAGE 'sql'
COST 100.0

AS $BODY$
	SELECT ARRAY_TO_JSON(ARRAY_AGG(ROW_TO_JSON(DATA)))
	FROM (
		SELECT
			empidac.id,
			emp.first_name,
			emp.surname,
			idac.code
		FROM
			employee_data.employee_idac_code empidac
			LEFT OUTER JOIN  employee_data.employees  emp ON
				empidac.employee_id = emp.id
			AND
				emp.is_active = '1'
			AND
				emp.is_deleted = '0'
			LEFT OUTER JOIN employee_data.idac_codes idac ON
				empidac.idac_code_id = idac.id
			AND
				idac.is_active = '1'
			AND
				idac.is_deleted = '0'
		WHERE
			empidac.is_active = '1'
		AND
			empidac.is_deleted = '0'
		AND
			empidac.idac_code_id = param_idac_id
	)DATA;
$BODY$;


-- function get one
CREATE OR REPLACE FUNCTION employee_data.get_employee_idac_code_search(
	param_id INTEGER
)
RETURNS json
LANGUAGE 'sql'
COST 100.0

AS $BODY$
	SELECT ARRAY_TO_JSON(ARRAY_AGG(ROW_TO_JSON(DATA)))
	FROM (
		SELECT
			empidac.id,
			emp.first_name,
			emp.surname,
			idac.code
		FROM
			employee_data.employee_idac_code empidac
			LEFT OUTER JOIN  employee_data.employees  emp ON
				empidac.employee_id = emp.id
			AND
				emp.is_active = '1'
			AND
				emp.is_deleted = '0'
			LEFT OUTER JOIN employee_data.idac_codes idac ON
				empidac.idac_code_id = idac.id
			AND
				idac.is_active = '1'
			AND
				idac.is_deleted = '0'
		WHERE
			empidac.is_active = '1'
		AND
			empidac.is_deleted = '0'
		AND
			empidac.id = param_id
	)DATA;
$BODY$;


-- function update all columns
CREATE OR REPLACE FUNCTION employee_data.employee_idac_code_udpate_all_columns(
	param_id INTEGER,
	param_employee_id INTEGER,
	param_idac_id INTEGER,
	param_is_active BIT,
	param_is_deleted BIT,
	param_user_id INTEGER
)
RETURNS BIT
LANGUAGE plpgsql VOLATILE
COST 100.0
AS $udf$
	DECLARE
		local_is_successful BIT := '0';
	BEGIN
		UPDATE employee_data.employee_idac_code SET
			idac_code_id = param_idac_id,
			is_active = param_is_active,
			is_deleted = param_is_deleted,
			last_modified_by = param_user_id,
			last_modified_date = CLOCK_TIMESTAMP()
		WHERE
			id = param_id
		AND
			employee_id = param_employee_id;


		SELECT employee_idac_code_insert_history INTO local_is_successful FROM employee_data.employee_idac_code_insert_history(
			param_employee_idac_id := param_id,
			param_change_type := 'UPDATE all_columns',
      		param_change_description := 'UPDATE value of all columns'
		);

		RETURN local_is_successful;
	END;
$udf$;

-- function update is_active
CREATE OR REPLACE FUNCTION employee_data.employee_idac_code_udpate_is_active(
	param_id INTEGER,
	param_employee_id INTEGER,
	param_idac_id INTEGER,
	param_user_id INTEGER
)
RETURNS BIT
LANGUAGE plpgsql VOLATILE
COST 100.0
AS $udf$
	DECLARE
		local_is_successful BIT := '0';
	BEGIN
		UPDATE employee_data.employee_idac_code SET
			idac_code_id = param_idac_id,
			last_modified_by = param_user_id,
			last_modified_date = CLOCK_TIMESTAMP()
		WHERE
			id = param_id
		AND
			employee_id = param_employee_id;


		SELECT employee_idac_code_insert_history INTO local_is_successful FROM employee_data.employee_idac_code_insert_history(
			param_employee_idac_id := param_id,
			param_change_type := 'UPDATE idac_code',
      		param_change_description := 'UPDATE value of idac_code'
		);

		RETURN local_is_successful;
	END;
$udf$;

-- function update idac_code
CREATE OR REPLACE FUNCTION employee_data.employee_idac_code_udpate_idac_code(
	param_id INTEGER,
	param_employee_id INTEGER,
	param_is_active BIT,
	param_user_id INTEGER
)
RETURNS BIT
LANGUAGE plpgsql VOLATILE
COST 100.0
AS $udf$
	DECLARE
		local_is_successful BIT := '0';
	BEGIN
		UPDATE employee_data.employee_idac_code SET
			is_active = param_is_active,
			last_modified_by = param_user_id,
			last_modified_date = CLOCK_TIMESTAMP()
		WHERE
			id = param_id
		AND
			employee_id = param_employee_id;


		SELECT employee_idac_code_insert_history INTO local_is_successful FROM employee_data.employee_idac_code_insert_history(
			param_employee_idac_id := param_id,
			param_change_type := 'UPDATE is_active',
      		param_change_description := 'UPDATE value of is_deleted'
		);

		RETURN local_is_successful;
	END;
$udf$;

-- function update is deleted
CREATE OR REPLACE FUNCTION employee_data.employee_idac_code_udpate_is_deleted(
	param_id INTEGER,
	param_employee_id INTEGER,
	param_is_deleted BIT,
	param_user_id INTEGER
)
RETURNS BIT
LANGUAGE plpgsql VOLATILE
COST 100.0
AS $udf$
	DECLARE
		local_is_successful BIT := '0';
	BEGIN
		UPDATE employee_data.employee_idac_code SET
			is_deleted = param_is_deleted,
			last_modified_by = param_user_id,
			last_modified_date = CLOCK_TIMESTAMP()
		WHERE
			id = param_id
		AND
			employee_id = param_employee_id;


		SELECT employee_idac_code_insert_history INTO local_is_successful FROM employee_data.employee_idac_code_insert_history(
			param_employee_idac_id := param_id,
			param_change_type := 'UPDATE is_deleted',
      		param_change_description := 'UPDATE value of is_deleted'
		);

		RETURN local_is_successful;
	END;
$udf$;


-- funtion of employee
--function of insert employee
CREATE OR REPLACE FUNCTION employee_data.employee_insert(
	param_nacionality_id integer ,
 	param_documentation_id integer ,
 	param_identification VARCHAR,
  	param_first_name VARCHAR,
  	param_second_name VARCHAR,
  	param_surname VARCHAR,
 	param_second_surname VARCHAR,
	param_birth_date date ,
	param_gender_id integer ,
	param_email VARCHAR,
	param_school_id integer,
	param_institute_id integer,
	param_cordination_id integer,
	param_departament_id integer,
	param_chair_id integer,
	param_mobile_phone_number VARCHAR,
	param_local_phone_number VARCHAR,
	param_user_id bigint
 )

 RETURNS INTEGER
LANGUAGE plpgsql VOLATILE
COST 100.0
AS $udf$

	DECLARE
		local_is_successful BIT := '0';
		local_employee_id BIGINT;
	BEGIN
	if EXISTS
	(
		SELECT *
		FROM
			employee_data.employees emp
		WHERE
			nacionality_id = param_nacionality_id
		AND
			identification = param_identification
	)
	THEN
		RETURN local_is_successful::INTEGER;
	ELSE
		INSERT INTO employee_data.employees(
	   		nacionality_id,
     		documentation_id,
      		identification,
       		first_name,
	       	second_name,
	        surname,
	        second_surname,
	        birth_date,
	        gender_id,
            email,
            school_id,
            institute_id,
            cordination_id,
            departament_id,
            chair_id,
            mobile_phone_number,
            local_phone_number,
            is_active,
            is_deleted,
            last_modified_by,
            last_modified_date
		)
		VALUES(
			param_nacionality_id,
  			param_documentation_id,
	 		param_identification,
		  	param_first_name,
		  	param_second_name,
		  	param_surname,
		   	param_second_surname,
		    param_birth_date,
		    param_gender_id,
		    param_email,
  			param_school_id,
  			param_institute_id,
			param_cordination_id,
			param_departament_id,
			param_chair_id,
			param_mobile_phone_number,
			param_local_phone_number,
			'0',
			'0',
			param_user_id,
			CLOCK_TIMESTAMP()
		)
		RETURNING id
		INTO STRICT local_employee_id;

		SELECT employee_insert_history into local_is_successful FROM employee_data.employee_insert_history(
      		param_employee_id := local_employee_id,
      		param_change_type := 'FIRST INSERT',
      		param_change_description := 'FIRST INSERT'
      	);
				IF local_is_successful = '1' THEN
					RETURN local_employee_id;
				ELSE
					RETURN local_is_successful::INTEGER;
				END IF;
    	END IF;
    END;
$udf$;

--function of insert log
CREATE OR REPLACE FUNCTION employee_data.employee_insert_history(
	param_employee_id BIGINT,
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
	  	INSERT INTO employee_data.employees_history
	  	(
	  		employee_id,
		    nacionality_id,
		    documentation_id,
		    identification,
		    first_name,
		    second_name,
		    surname,
	        second_surname,
	        birth_date,
	        gender_id,
	        email,
	        state_id,
	        municipality_id,
	        parish_id,
            ubication,
            address,
            housing_type,
	        housing_identifier,
	        apartament,
	        school_id,
	        institute_id,
            cordination_id,
	        departament_id,
            chair_id,
	        mobile_phone_number,
            local_phone_number,
	        ingress_id,
	        income_type_id,
	        admission_date,
	        last_updated_date,
	        retirement_date,
	        is_active,
	        is_deleted,
	        last_modified_by,
	        last_modified_date,
	        change_type,
			change_description
	  	)
	  	SELECT
			id,
	        nacionality_id,
	    	documentation_id,
	    	identification,
	        first_name,
	        second_name,
	        surname,
	        second_surname,
	        birth_date,
	        gender_id,
	        email,
            state_id,
            municipality_id,
            parish_id,
            ubication,
            address,
            housing_type,
	        housing_identifier,
            apartament,
            school_id,
            institute_id,
            cordination_id,
            departament_id,
            chair_id,
            mobile_phone_number,
            local_phone_number,
            ingress_id,
            income_type_id,
            admission_date,
            last_updated_date,
            retirement_date,
            is_active,
            is_deleted,
            last_modified_by,
            last_modified_date,
            param_change_type,
            param_change_description
		FROM
			employee_data.employees ep
		WHERE
			ep.id = param_employee_id
		ORDER BY
			ep.last_modified_date
		DESC
		LIMIT 1;

		local_is_successful := '1';
	    RETURN local_is_successful;
	  END;
$udf$;

-- function get list
CREATE OR REPLACE FUNCTION form_data.get_employees_list(
	param_school_id INTEGER,
	param_institute_id INTEGER,
	param_coordination_id INTEGER
)
RETURNS json
LANGUAGE 'sql'
COST 100.0

AS $BODY$
	SELECT ARRAY_TO_JSON(ARRAY_AGG(ROW_TO_JSON(DATA)))
	FROM(
		SELECT
			emp.id,
			emp.first_name||' '||emp.surname as name,
			emp.identification,
			exe.description as execunting_unit,
			id.code idac_code,
			ded.description as dedication_type,
			emp.admission_date
		FROM
			employee_data.employees emp
		INNER JOIN
			employee_data.employee_idac_code emid
		ON
					(
							emp.school_id = param_school_id
						OR
							emp.institute_id = param_institute_id
						OR
							emp.cordination_id = param_coordination_id
					)
			AND
					emp.is_deleted = '0'
			AND
					emp.is_active = '1'
			AND
					emp.retirement_date IS NULL
			AND
					emid.employee_id = emp.id
			AND
					emid.is_deleted = '0'
			AND
					emid.is_active = '1'
			INNER JOIN
				employee_data.idac_codes id
			ON
						id.id = emid.idac_code_id
				AND
						id.is_deleted = '0'
				AND
						id.is_active = '1'
			INNER JOIN
				employee_data.execunting_unit exe
			ON
						exe.id = id.execunting_unit_id
				AND
						exe.is_deleted = '0'
				AND
						exe.is_active = '1'
		INNER JOIN
			employee_data.employee_salaries emsal
		ON
				emsal.employee_id = emp.id
			AND
				emsal.is_deleted = '0'
 		INNER JOIN
			employee_data.salaries sal
		ON
				sal.id = emsal.salary_id
			AND
				sal.is_active = '1'
			AND
				sal.is_deleted = '0'
	INNER JOIN
		employee_data.dedication_types ded
	ON
				ded.id = sal.dedication_type_id
		AND
				ded.is_deleted = '0'
		AND
				ded.is_active = '1'
	)DATA;
$BODY$;

-- function update by form movent per
CREATE OR REPLACE FUNCTION employee_data.employee_update_for_movement_personal(
	param_employee_id INTEGER,
	param_state_id INTEGER,
	param_municipality_id INTEGER,
	param_parish_id INTEGER,
	param_ubication VARCHAR,
	param_addres VARCHAR,
	param_housing_type VARCHAR,
	param_housing_identifier VARCHAR,
	param_apartament VARCHAR,
	param_ingress_id INTEGER,
	param_income_type_id INTEGER,
	param_user_id BIGINT
)
RETURNS BIT
LANGUAGE plpgsql VOLATILE
COST 100.0
AS $udf$
	DECLARE
		local_is_successful BIT := '0';
	BEGIN
		UPDATE employee_data.employees SET
			state_id = param_state_id,
			municipality_id = param_municipality_id,
			parish_id = param_parish_id,
			ubication = param_ubication,
			address = param_addres,
			housing_type = param_housing_type,
			housing_identifier = param_housing_identifier,
			apartament = param_apartament,
			ingress_id = param_ingress_id,
			income_type_id = param_income_type_id,
			last_modified_by = param_user_id,
			last_modified_date = CLOCK_TIMESTAMP()
		WHERE
			id = param_employee_id;

		SELECT employee_insert_history into local_is_successful FROM employee_data.employee_insert_history(
			param_employee_id := param_user_id,
			param_change_type := 'Update for form movement personal',
			param_change_description := 'Update value for form movement personal'
		);

		RETURN local_is_successful;
	END;
$udf$;
