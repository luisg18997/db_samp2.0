-- functions of states

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
		);
		local_is_successful :='1';
    	RETURN local_is_successful;
    END;
$udf$;

-- funciton of list
CREATE OR REPLACE FUNCTION employee_data.get_states_list()
RETURNS SETOF json
LANGUAGE 'sql'
COST 100.0
VOLATILE ROWS 1000.0
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
RETURNS SETOF json
LANGUAGE 'sql'
COST 100.0
VOLATILE ROWS 1000.0
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
      	local_is_successful := '1';
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
      	local_is_successful := '1';
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
      	local_is_successful := '1';
    	RETURN local_is_successful;
  	END;
$udf$;

-- functions of municipalitys

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
	BEGIN
		INSERT INTO employee_data.municipalitys(
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
		);
		local_is_successful :='1';
    	RETURN local_is_successful;
    END;
$udf$;

-- funciton of list
CREATE OR REPLACE FUNCTION employee_data.get_municipalitys_list(
	param_state_id INTEGER
)
RETURNS SETOF json
LANGUAGE 'sql'
COST 100.0
VOLATILE ROWS 1000.0
AS $BODY$
	SELECT ARRAY_TO_JSON(ARRAY_AGG(ROW_TO_JSON(DATA)))
	FROM (
		SELECT
			mun.id,
			mun.name as municipality
		FROM
			employee_data.municipalitys mun
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
RETURNS SETOF json
LANGUAGE 'sql'
COST 100.0
VOLATILE ROWS 1000.0
AS $BODY$
	SELECT ARRAY_TO_JSON(ARRAY_AGG(ROW_TO_JSON(DATA)))
	FROM (
		SELECT
			mun.id,
			mun.name as municipality
		FROM
			employee_data.municipalitys mun
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
      	local_is_successful := '1';
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
  		UPDATE employee_data.municipalitys SET
  			is_active = param_is_active,
  			last_modified_by = param_user_id,
      		last_modified_date = CLOCK_TIMESTAMP()
      	WHERE
      		id = param_id
      	AND
      		state_id = param_state_id;
      	local_is_successful := '1';
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
  		UPDATE employee_data.municipalitys SET
  			is_deleted = param_is_deleted,
  			last_modified_by = param_user_id,
      		last_modified_date = CLOCK_TIMESTAMP()
      	WHERE
      		id = param_id
      	AND
      		state_id = param_state_id;
      	local_is_successful := '1';
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
		);
		local_is_successful :='1';
    	RETURN local_is_successful;
    END;
$udf$;

-- funciton of list
CREATE OR REPLACE FUNCTION employee_data.get_parish_list(
	param_municipality_id INTEGER
)
RETURNS SETOF json
LANGUAGE 'sql'
COST 100.0
VOLATILE ROWS 1000.0
AS $BODY$
	SELECT ARRAY_TO_JSON(ARRAY_AGG(ROW_TO_JSON(DATA)))
	FROM (
		SELECT
			par.id,
			par.name as parish
		FROM
			employee_data.parish par
		INNER JOIN 
			employee_data.municipalitys mun
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
RETURNS SETOF json
LANGUAGE 'sql'
COST 100.0
VOLATILE ROWS 1000.0
AS $BODY$
	SELECT ARRAY_TO_JSON(ARRAY_AGG(ROW_TO_JSON(DATA)))
	FROM (
		SELECT
			par.id,
			par.name as parish
		FROM
			employee_data.parish par
		INNER JOIN 
			employee_data.municipalitys mun
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
      	local_is_successful := '1';
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
      	local_is_successful := '1';
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
      	local_is_successful := '1';
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
		);
		local_is_successful :='1';
    	RETURN local_is_successful;
    END;
$udf$;

-- funciton of list
CREATE OR REPLACE FUNCTION employee_data.get_ingress_list()
RETURNS SETOF json
LANGUAGE 'sql'
COST 100.0
VOLATILE ROWS 1000.0
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
RETURNS SETOF json
LANGUAGE 'sql'
COST 100.0
VOLATILE ROWS 1000.0
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
      	local_is_successful := '1';
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
      	local_is_successful := '1';
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
      	local_is_successful := '1';
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
		);
		local_is_successful :='1';
    	RETURN local_is_successful;
    END;
$udf$;

-- funciton of list
CREATE OR REPLACE FUNCTION employee_data.get_income_type_list()
RETURNS SETOF json
LANGUAGE 'sql'
COST 100.0
VOLATILE ROWS 1000.0
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
RETURNS SETOF json
LANGUAGE 'sql'
COST 100.0
VOLATILE ROWS 1000.0
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
      	local_is_successful := '1';
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
      	local_is_successful := '1';
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
      	local_is_successful := '1';
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
			);
			local_is_successful := '1';
    		RETURN local_is_successful;
    	END IF;
  	END;
$udf$;

-- function get list
CREATE OR REPLACE FUNCTION employee_data.get_category_types_list()
RETURNS SETOF json
LANGUAGE 'sql'
COST 100.0
VOLATILE ROWS 1000.0
AS $BODY$
	SELECT ARRAY_TO_JSON(ARRAY_AGG(ROW_TO_JSON(DATA)))
	FROM (
		SELECT
			cat.id,
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
RETURNS SETOF json
LANGUAGE 'sql'
COST 100.0
VOLATILE ROWS 1000.0
AS $BODY$
	SELECT ARRAY_TO_JSON(ARRAY_AGG(ROW_TO_JSON(DATA)))
	FROM (
		SELECT
			cat.id,
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
  			is_active = param_is_active,
  			is_deleted = param_is_deleted,
  			last_modified_by = param_user_id,
      		last_modified_date = CLOCK_TIMESTAMP()
      	WHERE
      		id = param_id;
      	local_is_successful := '1';
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
      	local_is_successful := '1';
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
      	local_is_successful := '1';
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
			);
			local_is_successful := '1';
    		RETURN local_is_successful;
    	END IF;
  	END;
$udf$;

-- function get list
CREATE OR REPLACE FUNCTION employee_data.get_dedication_types_list()
RETURNS SETOF json
LANGUAGE 'sql'
COST 100.0
VOLATILE ROWS 1000.0
AS $BODY$
	SELECT ARRAY_TO_JSON(ARRAY_AGG(ROW_TO_JSON(DATA)))
	FROM (
		SELECT
			ded.id,
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
RETURNS SETOF json
LANGUAGE 'sql'
COST 100.0
VOLATILE ROWS 1000.0
AS $BODY$
	SELECT ARRAY_TO_JSON(ARRAY_AGG(ROW_TO_JSON(DATA)))
	FROM (
		SELECT
			ded.id,
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
  			is_active = param_is_active,
  			is_deleted = param_is_deleted,
  			last_modified_by = param_user_id,
      		last_modified_date = CLOCK_TIMESTAMP()
      	WHERE
      		id = param_id;
      	local_is_successful := '1';
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
      	local_is_successful := '1';
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
      	local_is_successful := '1';
    	RETURN local_is_successful;
  	END;
$udf$;

-- functions of execunting unit

--function of insert
CREATE OR REPLACE FUNCTION employee_data.execunting_unit_insert(
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
			);
			local_is_successful := '1';
    		RETURN local_is_successful;
    	END IF;
  	END;
$udf$;

-- function get list
CREATE OR REPLACE FUNCTION employee_data.get_execunting_unit_list()
RETURNS SETOF json
LANGUAGE 'sql'
COST 100.0
VOLATILE ROWS 1000.0
AS $BODY$
	SELECT ARRAY_TO_JSON(ARRAY_AGG(ROW_TO_JSON(DATA)))
	FROM (
		SELECT
			exec.id,
			exec.description as execunting_unit
		FROM
			employee_data.execunting_unit exec
		WHERE
			exec.is_active = '1'
		AND 
			exec.is_deleted = '0'
	)DATA;
$BODY$;

--function get one data
CREATE OR REPLACE FUNCTION employee_data.get_execunting_unit(
	param_id INTEGER
)
RETURNS SETOF json
LANGUAGE 'sql'
COST 100.0
VOLATILE ROWS 1000.0
AS $BODY$
	SELECT ARRAY_TO_JSON(ARRAY_AGG(ROW_TO_JSON(DATA)))
	FROM (
		SELECT
			exec.id,
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
  			is_active = param_is_active,
  			is_deleted = param_is_deleted,
  			last_modified_by = param_user_id,
      		last_modified_date = CLOCK_TIMESTAMP()
      	WHERE
      		id = param_id;
      	local_is_successful := '1';
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
      	local_is_successful := '1';
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
      	local_is_successful := '1';
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
		);
		local_is_successful :='1';
    	RETURN local_is_successful;
    END;
$udf$;