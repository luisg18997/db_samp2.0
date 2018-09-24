-- functions movement_types 
-- function of insert
CREATE OR REPLACE FUNCTION form_data.movement_type_insert(
	param_description VARCHAR,
	param_user_id INTEGER
)
RETURNS BIT
LANGUAGE plpgsql VOLATILE
COST 100.0
AS $udf$
	DECLARE
		local_is_successful BIT := '0';
		local_movement_type_id BIGINT;
	BEGIN
		IF EXISTS(
			SELECT
				description
			FROM
				form_data.movement_types mov
			WHERE 
				mov.description = param_description

			AND
				mov.is_active = '1'
			AND
				mov.is_deleted = '0'
		)
		THEN
			RETURN local_is_successful;
		ELSE
			INSERT INTO form_data.movement_types(
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
      		INTO STRICT local_movement_type_id;

      		SELECT movement_type_insert_history INTO local_is_successful FROM form_data.movement_type_insert_history(
      			param_movement_type_id := local_movement_type_id,
      			param_change_type := 'FIRST INSERT',
      			param_change_description := 'FIRST INSERT'
      		);

      		RETURN local_is_successful;
      	END IF;
    END;
$udf$;

--function insert of log
CREATE OR REPLACE FUNCTION form_data.movement_type_insert_history(
	param_movement_type_id BIGINT,
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
		INSERT INTO form_data.movement_types_history(
			movement_type_id,
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
			form_data.movement_types mov
		WHERE
			mov.id = param_movement_type_id
		ORDER BY
			last_modified_date
		DESC
		LIMIT 1;

		local_is_successful := '1';

		RETURN local_is_successful;
	END;
$udf$;

-- function get list
CREATE OR REPLACE FUNCTION form_data.get_movement_types_list()
RETURNS json
LANGUAGE 'sql'
COST 100.0

AS $BODY$
	SELECT ARRAY_TO_JSON(ARRAY_AGG(ROW_TO_JSON(DATA)))
	FROM (
		SELECT
			mov.id,
			mov.description
		FROM
			form_data.movement_types  mov
		WHERE
			mov.is_active = '1'
		AND 
			mov.is_deleted = '0'
	)DATA;
$BODY$;

-- function get search
CREATE OR REPLACE FUNCTION form_data.get_movement_type_search(
	param_id INTEGER
)
RETURNS json
LANGUAGE 'sql'
COST 100.0

AS $BODY$
	SELECT ARRAY_TO_JSON(ARRAY_AGG(ROW_TO_JSON(DATA)))
	FROM (
		SELECT
			mov.id,
			mov.description
		FROM
			form_data.movement_types  mov
		WHERE
			mov.is_active = '1'
		AND 
			mov.is_deleted = '0'
		AND
			mov.id = param_id
	)DATA;
$BODY$;

-- function of update all columns
CREATE OR REPLACE FUNCTION form_data.movement_type_update_all_columns(
	param_id INTEGER,
	param_description VARCHAR,
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
		UPDATE form_data.movement_types SET
			description = param_description,
			is_active = param_is_active,
			is_deleted = param_is_deleted,
			last_modified_by = param_user_id,
			last_modified_date = CLOCK_TIMESTAMP()
		WHERE 
			id = param_id;

		SELECT movement_type_insert_history INTO local_is_successful FROM form_data.movement_type_insert_history(
			param_movement_type_id := param_id,
			param_change_type := 'UPDATE all_columns',
      		param_change_description := 'UPDATE value of all columns'
		);

		RETURN local_is_successful;
	END;
$udf$;

-- function of update is_active
CREATE OR REPLACE FUNCTION form_data.movement_type_update_is_active(
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
		UPDATE form_data.movement_types SET
			is_active = param_is_active,
			last_modified_by = param_user_id,
			last_modified_date = CLOCK_TIMESTAMP()
		WHERE 
			id = param_id;

		SELECT movement_type_insert_history INTO local_is_successful FROM form_data.movement_type_insert_history(
			param_movement_type_id := param_id,
			param_change_type := 'UPDATE is_active',
      		param_change_description := 'UPDATE value of is_active'
		);

		RETURN local_is_successful;
	END;
$udf$;


-- function of update is_deleted
CREATE OR REPLACE FUNCTION form_data.movement_type_update_is_deleted(
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
		UPDATE form_data.movement_types SET
			is_deleted = param_is_deleted,
			last_modified_by = param_user_id,
			last_modified_date = CLOCK_TIMESTAMP()
		WHERE 
			id = param_id;

		SELECT movement_type_insert_history INTO local_is_successful FROM form_data.movement_type_insert_history(
			param_movement_type_id := param_id,
			param_change_type := 'UPDATE is_deleted',
      		param_change_description := 'UPDATE value of is_deleted'
		);

		RETURN local_is_successful;
	END;
$udf$;

-- functions of accountant_types
-- function of insert
CREATE OR REPLACE FUNCTION form_data.accountant_type_insert(
	param_code BIGINT,
	param_description VARCHAR,
	param_user_id INTEGER
)
RETURNS BIT
LANGUAGE plpgsql VOLATILE
COST 100.0
AS $udf$
	DECLARE
		local_is_successful BIT := '0';
		local_accountant_type_id BIGINT;
	BEGIN
		IF EXISTS(
			SELECT
				code
			FROM
				form_data.accountant_types account
			WHERE 
				account.code = param_code

			AND
				account.is_active = '1'
			AND
				account.is_deleted = '0'
		)
		THEN
			RETURN local_is_successful;
		ELSE
			INSERT INTO form_data.accountant_types(
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
      		INTO STRICT local_accountant_type_id;

      		SELECT accountant_type_insert_history INTO local_is_successful FROM form_data.accountant_type_insert_history(
      			param_accountant_type_id := local_accountant_type_id,
      			param_change_type := 'FIRST INSERT',
      			param_change_description := 'FIRST INSERT'
      		);

      		RETURN local_is_successful;
      	END IF;
    END;
$udf$;

CREATE OR REPLACE FUNCTION form_data.accountant_type_insert_history(
	param_accountant_type_id BIGINT,
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
		INSERT INTO form_data.accountant_types_history(
			accountant_type_id,
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
			form_data.accountant_types account
		WHERE
			account.id = param_accountant_type_id
		ORDER BY
			last_modified_date
		DESC
		LIMIT 1;

		local_is_successful := '1';

		RETURN local_is_successful;
	END;
$udf$;

-- function get list
CREATE OR REPLACE FUNCTION form_data.get_accountant_types_list()
RETURNS json
LANGUAGE 'sql'
COST 100.0

AS $BODY$
	SELECT ARRAY_TO_JSON(ARRAY_AGG(ROW_TO_JSON(DATA)))
	FROM (
		SELECT
			account.id,
			account.code,
			account.description
		FROM
			form_data.accountant_types account
		WHERE 
			account.is_active = '1'
		AND
			account.is_deleted = '0'
	)DATA;
$BODY$;

-- function get search
CREATE OR REPLACE FUNCTION form_data.get_accountant_type_search(
param_id INTEGER
)
RETURNS json
LANGUAGE 'sql'
COST 100.0

AS $BODY$
	SELECT ARRAY_TO_JSON(ARRAY_AGG(ROW_TO_JSON(DATA)))
	FROM (
		SELECT
			account.id,
			account.code,
			account.description
		FROM
			form_data.accountant_types account
		WHERE 
			account.is_active = '1'
		AND
			account.is_deleted = '0'
		AND 
			account.id = param_id
	)DATA;
$BODY$;

-- function of update all columns
CREATE OR REPLACE FUNCTION form_data.accountant_type_update_all_columns(
	param_id INTEGER,
	param_code BIGINT,
	param_description VARCHAR,
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
		UPDATE form_data.accountant_types SET
			code = param_code,
			description = param_description,
			is_active = param_is_active,
			is_deleted = param_is_deleted,
			last_modified_by = param_user_id,
			last_modified_date = CLOCK_TIMESTAMP()
		WHERE 
			id = param_id;


		SELECT accountant_type_insert_history INTO local_is_successful FROM form_data.accountant_type_insert_history(
			param_accountant_type_id := param_id,
			param_change_type := 'UPDATE all_columns',
      		param_change_description := 'UPDATE value of all columns'
		);

		RETURN local_is_successful;
	END;
$udf$;

-- function of update is_active
CREATE OR REPLACE FUNCTION form_data.accountant_type_update_is_active(
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
		UPDATE form_data.accountant_types SET
			is_active = param_is_active,
			last_modified_by = param_user_id,
			last_modified_date = CLOCK_TIMESTAMP()
		WHERE 
			id = param_id;


		SELECT accountant_type_insert_history INTO local_is_successful FROM form_data.accountant_type_insert_history(
			param_accountant_type_id := param_id,
			param_change_type := 'UPDATE is_active',
      		param_change_description := 'UPDATE value of is_active'
		);

		RETURN local_is_successful;
	END;
$udf$;

-- function of update is_deleted
CREATE OR REPLACE FUNCTION form_data.accountant_type_update_is_deleted(
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
		UPDATE form_data.accountant_types SET
			is_deleted = param_is_deleted,
			last_modified_by = param_user_id,
			last_modified_date = CLOCK_TIMESTAMP()
		WHERE 
			id = param_id;


		SELECT accountant_type_insert_history INTO local_is_successful FROM form_data.accountant_type_insert_history(
			param_accountant_type_id := param_id,
			param_change_type := 'UPDATE is_deleted',
      		param_change_description := 'UPDATE value of is_deleted'
		);

		RETURN local_is_successful;
	END;
$udf$;

-- functions of program_types
CREATE OR REPLACE FUNCTION form_data.program_type_insert(
	param_code VARCHAR,
	param_description VARCHAR,
	param_user_id INTEGER
)
RETURNS BIT
LANGUAGE plpgsql VOLATILE
COST 100.0
AS $udf$
	DECLARE
		local_is_successful BIT := '0';
		local_program_type_id BIGINT;
	BEGIN
		IF EXISTS(
			SELECT
				prog.code
			FROM
				form_data.program_types prog
			WHERE 
				prog.code = param_code
			AND
				prog.is_deleted = '0'
			AND
				prog.is_active = '1'
		)
		THEN 
		RETURN local_is_successful;
		ELSE
			INSERT INTO form_data.program_types(
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
			INTO STRICT local_program_type_id;

			SELECT program_type_insert_history INTO local_is_successful FROM form_data.program_type_insert_history(
				param_program_type_id := local_program_type_id,
				param_change_type := 'FIRST INSERT',
      			param_change_description := 'FIRST INSERT'
			);

			RETURN local_is_successful;

		END IF;
	END;
$udf$;

-- function of insert log
CREATE OR REPLACE FUNCTION form_data.program_type_insert_history(
	param_program_type_id BIGINT,
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
		INSERT INTO form_data.program_types_history(
			progam_type_id,
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
			form_data.program_types prog
		WHERE 
			prog.id = param_program_type_id
		ORDER BY
			last_modified_date
		DESC
		LIMIT 1;

		local_is_successful := '1';
		RETURN local_is_successful;
	END;
$udf$;

CREATE OR REPLACE FUNCTION form_data.get_program_types_list()
RETURNS json
LANGUAGE 'sql'
COST 100.0

AS $BODY$
	SELECT ARRAY_TO_JSON(ARRAY_AGG(ROW_TO_JSON(DATA)))
	FROM (
		SELECT
			prog.id,
			prog.code
		FROM
			form_data.program_types  prog
		WHERE
			prog.is_active = '1'
		AND 
			prog.is_deleted = '0'
	)DATA;
$BODY$;

-- function get search
CREATE OR REPLACE FUNCTION form_data.get_program_type_search(
	param_id INTEGER
)
RETURNS json
LANGUAGE 'sql'
COST 100.0

AS $BODY$
	SELECT ARRAY_TO_JSON(ARRAY_AGG(ROW_TO_JSON(DATA)))
	FROM (
		SELECT
			prog.id,
			prog.code
		FROM
			form_data.program_types  prog
		WHERE
			prog.is_active = '1'
		AND 
			prog.is_deleted = '0'
		AND
			prog.id = param_id
	)DATA;
$BODY$;

-- function of update all columns
CREATE OR REPLACE FUNCTION form_data.program_type_update_all_columns(
	param_id INTEGER,
	param_code VARCHAR,
	param_description VARCHAR,
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
		UPDATE form_data.program_types SET
			code = param_code,
			description = param_description,
			is_active = param_is_active,
			is_deleted = param_is_deleted,
			last_modified_by = param_user_id,
			last_modified_date = CLOCK_TIMESTAMP()
		WHERE 
			id = param_id;

		SELECT program_type_insert_history INTO local_is_successful FROM form_data.program_type_insert_history(
			param_program_type_id := param_id,
			param_change_type := 'UPDATE all_columns',
      		param_change_description := 'UPDATE value of all columns'
		);

		RETURN local_is_successful;
	END;
$udf$;

-- function of update is_active
CREATE OR REPLACE FUNCTION form_data.program_type_update_is_active(
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
		UPDATE form_data.program_types SET
			is_active = param_is_active,
			last_modified_by = param_user_id,
			last_modified_date = CLOCK_TIMESTAMP()
		WHERE 
			id = param_id;

		SELECT program_type_insert_history INTO local_is_successful FROM form_data.program_type_insert_history(
			param_program_type_id := param_id,
			param_change_type := 'UPDATE is_active',
      		param_change_description := 'UPDATE value of is_active'
		);

		RETURN local_is_successful;
	END;
$udf$;


-- function of update is_deleted
CREATE OR REPLACE FUNCTION form_data.program_type_update_is_deleted(
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
		UPDATE form_data.program_types SET
			is_deleted = param_is_deleted,
			last_modified_by = param_user_id,
			last_modified_date = CLOCK_TIMESTAMP()
		WHERE 
			id = param_id;

		SELECT program_type_insert_history INTO local_is_successful FROM form_data.program_type_insert_history(
			param_program_type_id := param_id,
			param_change_type := 'UPDATE is_deleted',
      		param_change_description := 'UPDATE value of is_deleted'
		);

		RETURN local_is_successful;
	END;
$udf$;

-- function of annex type
-- function of insert
CREATE OR REPLACE FUNCTION form_data.annex_type_insert(
	param_description VARCHAR,
	param_user_id INTEGER
)
RETURNS BIT
LANGUAGE plpgsql VOLATILE
COST 100.0
AS $udf$
	DECLARE
		local_is_successful BIT := '0';
		local_annex_type_id BIGINT;
	BEGIN
		IF EXISTS(
			SELECT
				annex.description
			FROM
				form_data.annex_types annex
			WHERE 
				annex.description = param_description

			AND
				annex.is_active = '1'
			AND
				annex.is_deleted = '0'
		)
		THEN
			RETURN local_is_successful;
		ELSE
			INSERT INTO form_data.annex_types(
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
      		INTO STRICT local_annex_type_id;

      		SELECT annex_type_insert_history INTO local_is_successful FROM form_data.annex_type_insert_history(
      			param_annex_type_id := local_annex_type_id,
      			param_change_type := 'FIRST INSERT',
      			param_change_description := 'FIRST INSERT'
      		);

      		RETURN local_is_successful;
      	END IF;
    END;
$udf$;

--function insert of log
CREATE OR REPLACE FUNCTION form_data.annex_type_insert_history(
	param_annex_type_id BIGINT,
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
		INSERT INTO form_data.annex_types_history(
			annex_type_id,
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
			form_data.annex_types annex
		WHERE
			annex.id = param_annex_type_id
		ORDER BY
			annex.last_modified_date
		DESC
		LIMIT 1;

		local_is_successful := '1';

		RETURN local_is_successful;
	END;
$udf$;

-- function get list
CREATE OR REPLACE FUNCTION form_data.get_annex_types_list()
RETURNS json
LANGUAGE 'sql'
COST 100.0

AS $BODY$
	SELECT ARRAY_TO_JSON(ARRAY_AGG(ROW_TO_JSON(DATA)))
	FROM (
		SELECT
			annex.id,
			annex.description
		FROM
			form_data.annex_types  annex
		WHERE
			annex.is_active = '1'
		AND 
			annex.is_deleted = '0'
	)DATA;
$BODY$;

-- function get search
CREATE OR REPLACE FUNCTION form_data.get_movement_type_search(
	param_id INTEGER
)
RETURNS json
LANGUAGE 'sql'
COST 100.0

AS $BODY$
	SELECT ARRAY_TO_JSON(ARRAY_AGG(ROW_TO_JSON(DATA)))
	FROM (
		SELECT
			annex.id,
			annex.description
		FROM
			form_data.annex_types  annex
		WHERE
			annex.is_active = '1'
		AND 
			annex.is_deleted = '0'
		AND
			annex.id = param_id
	)DATA;
$BODY$;

-- function of update all columns
CREATE OR REPLACE FUNCTION form_data.annex_type_update_all_columns(
	param_id INTEGER,
	param_description VARCHAR,
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
		UPDATE form_data.annex_types SET
			description = param_description,
			is_active = param_is_active,
			is_deleted = param_is_deleted,
			last_modified_by = param_user_id,
			last_modified_date = CLOCK_TIMESTAMP()
		WHERE 
			id = param_id;

		SELECT annex_type_insert_history INTO local_is_successful FROM form_data.annex_type_insert_history(
			param_annex_type_id := param_id,
			param_change_type := 'UPDATE all_columns',
      		param_change_description := 'UPDATE value of all columns'
		);

		RETURN local_is_successful;
	END;
$udf$;

-- function of update is_active
CREATE OR REPLACE FUNCTION form_data.annex_type_update_is_active(
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
		UPDATE form_data.annex_types SET
			is_active = param_is_active,
			last_modified_by = param_user_id,
			last_modified_date = CLOCK_TIMESTAMP()
		WHERE 
			id = param_id;

		SELECT annex_type_insert_history INTO local_is_successful FROM form_data.annex_type_insert_history(
			param_annex_type_id := param_id,
			param_change_type := 'UPDATE is_active',
      		param_change_description := 'UPDATE value of is_active'
		);

		RETURN local_is_successful;
	END;
$udf$;


-- function of update is_deleted
CREATE OR REPLACE FUNCTION form_data.annex_type_update_is_deleted(
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
		UPDATE form_data.annex_types SET
			is_deleted = param_is_deleted,
			last_modified_by = param_user_id,
			last_modified_date = CLOCK_TIMESTAMP()
		WHERE 
			id = param_id;

		SELECT annex_type_insert_history INTO local_is_successful FROM form_data.annex_type_insert_history(
			param_annex_type_id := param_id,
			param_change_type := 'UPDATE is_deleted',
      		param_change_description := 'UPDATE value of is_deleted'
		);

		RETURN local_is_successful;
	END;
$udf$;