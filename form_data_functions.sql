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

-- function of movement_types_annex_types
-- function of insert
CREATE OR REPLACE FUNCTION form_data.movement_types_annex_type_insert(
	param_annex_type_id INTEGER,
	param_movement_type_id INTEGER,
	param_user_id INTEGER
)
RETURNS BIT
LANGUAGE plpgsql VOLATILE
COST 100.0
AS $udf$
	DECLARE
		local_is_successful BIT := '0';
		local_annex_type_for_movement_type_id BIGINT;
	BEGIN
		IF EXISTS(
			SELECT
				movannex.annex_type_id,
				movannex.movement_type_id
			FROM
				form_data.movement_types_annex_types movannex
			WHERE
				movannex.is_active = '1'
			AND
				movannex.is_deleted = '0'
			AND
				movannex.annex_type_id = param_annex_type_id
			AND
				movannex.movement_type_id = param_movement_type_id
		)
		THEN
			RETURN local_is_successful;
		ELSE
			INSERT INTO form_data.movement_types_annex_types(
				annex_type_id,
				movement_type_id,
				is_active,
				is_deleted,
				last_modified_by,
				last_modified_date
			)
			VALUES(
				param_annex_type_id,
				param_movement_type_id,
				'1',
				'0',
				param_user_id,
				CLOCK_TIMESTAMP()
			)
			RETURNING id
			INTO STRICT local_annex_type_for_movement_type_id;

			SELECT movement_types_annex_type_insert_hstory INTO local_is_successful FROM form_data.movement_types_annex_type_insert_hstory(
				param_annex_for_movement_type_id := local_annex_type_for_movement_type_id,
				param_change_type := 'FIRST INSERT',
      			param_change_description := 'FIRST INSERT'
			);

			RETURN local_is_successful;
		END IF;
	END;
$udf$;

-- function of insert log
CREATE OR REPLACE FUNCTION form_data.movement_types_annex_type_insert_hstory(
	param_annex_for_movement_type_id BIGINT,
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
		INSERT INTO form_data.movement_types_annex_types_history(
			movement_types_annex_type_id,
			annex_type_id,
			movement_type_id,
			is_active,
			is_deleted,
			last_modified_by,
			last_modified_date,
			change_type,
			change_description
		)
		SELECT
			id,
			annex_type_id,
			movement_type_id,
			is_active,
			is_deleted,
			last_modified_by,
			last_modified_date,
			param_change_type,
			param_change_description
		FROM
			form_data.movement_types_annex_types movannex
		WHERE
			movannex.id  = param_annex_for_movement_type_id
		ORDER BY
			movannex.last_modified_date
		DESC
		LIMIT 1;

		local_is_successful := '1';

		RETURN local_is_successful;
	END;
$udf$;

-- function of official_forms
-- function of insert
CREATE OR REPLACE FUNCTION form_data.official_forms_insert(
	param_code_form_ofice VARCHAR,
	param_user_id BIGINT
)
RETURNS INTEGER
LANGUAGE plpgsql VOLATILE
COST 100.0
AS $udf$
	DECLARE
		local_is_successful BIT := '0';
		local_emp_form_ofice_id BIGINT;
	BEGIN
		IF EXISTS(
			SELECT
				code_form
			FROM
				form_data.official_forms fo
			WHERE
				fo.code_form = param_code_form_ofice
			AND
				fo.is_active = '1'
			AND
				fo.is_deleted = '0'
		)
		THEN
			RETURN local_is_successful::INTEGER;
		ELSE
			INSERT INTO form_data.official_forms(
				code_form,
				registration_date,
				is_active,
				is_deleted,
				last_modified_by,
				last_modified_date
			)
			VALUES (
				param_code_form_ofice,
				CLOCK_TIMESTAMP(),
				'1',
				'0',
				param_user_id,
				CLOCK_TIMESTAMP()
			)
			RETURNING id
			INTO STRICT local_emp_form_ofice_id;


			SELECT official_forms_insert_history INTO local_is_successful FROM form_data.official_forms_insert_history(
				param_emp_form_ofice_id := local_emp_form_ofice_id,
				param_change_type := 'FIRST INSERT',
				param_change_description := 'FIRST INSERT'
			);

			IF local_is_successful = '1' THEN
				RETURN local_emp_form_ofice_id;
			ELSE
				RETURN local_is_successful::INTEGER;
			END IF;

		END IF;
	END;
$udf$;

-- function of insert log
CREATE OR REPLACE FUNCTION form_data.official_forms_insert_history(
	param_emp_form_ofice_id BIGINT,
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
		INSERT INTO form_data.official_forms_history(
			form_ofice_id,
			code_form,
			registration_date,
			approval_date,
			is_active,
			is_deleted,
			last_modified_by,
			last_modified_date,
			change_type,
			change_description
		)
		SELECT
			id,
			code_form,
			registration_date,
			approval_date,
			is_active,
			is_deleted,
			last_modified_by,
			last_modified_date,
			param_change_type,
			param_change_description
		FROM
			form_data.official_forms fo
		WHERE
			fo.id = param_emp_form_ofice_id
		ORDER BY
			fo.last_modified_date
		DESC
		LIMIT 1;

		local_is_successful := '1';

		RETURN local_is_successful;
	END;
$udf$;


-- function obtain code
CREATE OR REPLACE FUNCTION form_data.get_form_ofice_code(
	param_school_id INTEGER,
	param_institute_id INTEGER,
	param_coordination_id INTEGER
)
RETURNS json
LANGUAGE 'sql'
COST 100.0

AS $BODY$
	SELECT ROW_TO_JSON(DATA)
	FROM (
		SELECT
			fo.code_form
		FROM
			form_data.official_forms fo
		INNER JOIN
				form_data.employee_oficcial_mov_personal_forms fomp
				ON
					fomp.form_ofice_id = fo.id
				AND
			(
				fomp.school_id = param_school_id
			OR
				fomp.institute_id = param_institute_id
			OR
				fomp.coordination_id = param_coordination_id
			)
		ORDER BY
			fo.last_modified_date
		DESC
		LIMIT 1
	)DATA;
$BODY$;

-- function of movement_personal_forms
-- function of insert
CREATE OR REPLACE FUNCTION form_data.movement_personal_forms_insert(
	param_code_form_mov_per VARCHAR,
	param_user_id BIGINT
)
RETURNS INTEGER
LANGUAGE plpgsql VOLATILE
COST 100.0
AS $udf$
	DECLARE
		local_is_successful BIT := '0';
		local_emp_form_mov_per_id BIGINT;
	BEGIN
		IF EXISTS(
			SELECT
				code_form
			FROM
				form_data.movement_personal_forms fmp
			WHERE
				fmp.code_form = param_code_form_mov_per
			AND
				fmp.is_active = '1'
			AND
				fmp.is_deleted = '0'
		)
		THEN
			RETURN local_is_successful::INTEGER;
		ELSE
			INSERT INTO form_data.movement_personal_forms(
				code_form,
				registration_date,
				is_active,
				is_deleted,
				last_modified_by,
				last_modified_date
			)
			VALUES (
				param_code_form_mov_per,
				CLOCK_TIMESTAMP(),
				'1',
				'0',
				param_user_id,
				CLOCK_TIMESTAMP()
			)
			RETURNING id
			INTO STRICT local_emp_form_mov_per_id;


			SELECT movement_personal_forms_insert_history INTO local_is_successful FROM form_data.movement_personal_forms_insert_history(
				param_emp_form_mov_per_id := local_emp_form_mov_per_id,
				param_change_type := 'FIRST INSERT',
				param_change_description := 'FIRST INSERT'
			);

			IF local_is_successful = '1' THEN
				RETURN local_emp_form_mov_per_id;
			ELSE
				RETURN local_is_successful::INTEGER;
			END IF;

		END IF;
	END;
$udf$;

-- function of insert log
CREATE OR REPLACE FUNCTION form_data.movement_personal_forms_insert_history(
	param_emp_form_mov_per_id BIGINT,
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
		INSERT INTO form_data.movement_personal_forms_history(
			form_person_movement_id,
			code_form,
			accountant_type_id,
			progam_type_id,
			registration_date,
			approval_date,
			is_active,
			is_deleted,
			last_modified_by,
			last_modified_date,
			change_type,
			change_description
		)
		SELECT
			id,
			code_form,
			accountant_type_id,
			progam_type_id,
			registration_date,
			approval_date,
			is_active,
			is_deleted,
			last_modified_by,
			last_modified_date,
			param_change_type,
			param_change_description
		FROM
			form_data.movement_personal_forms fmp
		WHERE
			fmp.id = param_emp_form_mov_per_id
		ORDER BY
			fmp.last_modified_date
		DESC
		LIMIT 1;

		local_is_successful := '1';

		RETURN local_is_successful;
	END;
$udf$;


CREATE OR REPLACE FUNCTION form_data.get_form_mov_personal_code(
	param_school_id INTEGER,
	param_institute_id INTEGER,
	param_coordination_id INTEGER
)
RETURNS json
LANGUAGE 'sql'
COST 100.0

AS $BODY$
	SELECT ROW_TO_JSON(DATA)
	FROM (
		SELECT
			fmp.code_form
		FROM
			form_data.movement_personal_forms fmp
		INNER JOIN
			form_data.employee_oficcial_mov_personal_forms fomp
		ON
			(	fomp.school_id = param_school_id
			OR
				fomp.institute_id = param_institute_id
			OR
				fomp.coordination_id = param_coordination_id
			)
			AND
				fmp.id = fomp.form_person_movement_id
		ORDER BY
			fmp.last_modified_date
		DESC
		LIMIT 1
	)DATA;
$BODY$;

-- function get mov pers
CREATE OR REPLACE FUNCTION form_data.get_form_movement_personal(
	param_identification VARCHAR
)
RETURNS json
LANGUAGE 'sql'
COST 100.0
AS $BODY$
	SELECT ROW_TO_JSON(DATA)
	FROM (
		SELECT
			fomp.id,
			fomp.employee_id,
			emp.first_name,
			COALESCE(emp.second_name,'') as second_name,
			emp.surname,
			COALESCE(emp.second_surname,'') as second_surname,
			emp.nacionality_id,
			emp.identification,
			COALESCE(emp.state_id,0) as state_id,
			COALESCE(emp.municipality_id,0) as municipality_id,
			COALESCE(emp.parish_id,0) as parish_id,
			COALESCE(emp.ubication,'') as ubication,
			COALESCE(emp.address,'') as address,
			COALESCE(emp.housing_type,'') as housing_type,
			COALESCE(emp.housing_identifier,'') as housing_identifier,
			COALESCE(emp.apartament,'') as apartament,
			COALESCE(emp.departament_id,0) as departament_id,
			COALESCE(emp.parish_id,0) as parish_id,
			COALESCE(emp.ingress_id,0) as ingress_id,
			COALESCE(emp.income_type_id,0) as income_type_id,
			fomp.movement_type_id,
			fomp.start_date,
			fomp.finish_date,
			COALESCE(emidac.idac_code_id,0) as idac_code_id,
			COALESCE(idac.execunting_unit_id, 0) as execunting_unit_id,
			COALESCE(sal.dedication_type_id, fomp.dedication_id) as current_dedication,
			COALESCE(fomp.dedication_id, 0) as proposed_dedication,
			COALESCE(sal.category_type_id, 0) as category_type_id,
			COALESCE(emsal.salary_id, 0) as salary_id
		FROM
			form_data.employee_oficcial_mov_personal_forms fomp
		INNER JOIN
			employee_data.employees emp
		ON
				emp.identification = '25862920'
			AND
				 emp.id = fomp.employee_id
			AND
				emp.retirement_date IS NULL
			AND
				emp.is_deleted = '0'
			AND
				(
					fomp.school_id = emp.school_id
				OR
					fomp.institute_id = emp.institute_id
				OR
					fomp.coordination_id = emp.cordination_id
				)
			AND
				fomp.is_deleted = '0'
			AND
				fomp.form_person_movement_id IS NULL
			AND
				fomp.form_ofice_id IS NOT NULL
			INNER JOIN
				employee_data.employee_idac_code emidac
			ON
					emidac.employee_id = fomp.employee_id
				AND
					emidac.is_deleted = '0'
				INNER JOIN
					employee_data.idac_codes idac
				ON
						idac.id = emidac.idac_code_id
					AND
						idac.is_active = '1'
					AND
					 	idac.is_deleted = '0'
			LEFT OUTER JOIN
				employee_data.employee_salaries emsal
			ON
					emsal.employee_id = fomp.employee_id
				AND
					emsal.is_deleted = '0'
				 LEFT OUTER JOIN
					employee_data.salaries sal
				ON
						sal.id = emsal.salary_id
					AND
						sal.is_active = '1'
					AND
						sal.is_deleted = '0'
	)DATA;
$BODY$;


-- function of employee_oficcial_mov_personal_forms
-- function of insert
CREATE OR REPLACE FUNCTION form_data.employee_oficcial_mov_personal_form_insert(
	param_ofice_id BIGINT,
	param_employee_id BIGINT,
	param_dedication_id INTEGER,
	param_movement_type_id INTEGER,
	param_start_date DATE,
	param_finish_date DATE,
	param_school_id INTEGER,
	param_institute_id INTEGER,
	param_coordination_id INTEGER,
	param_user_id BIGINT

)
RETURNS BIT
LANGUAGE plpgsql VOLATILE
COST 100.0
AS $udf$
	DECLARE
		local_is_successful BIT := '0';
		local_emp_form_of_per_mov_id BIGINT;

	BEGIN
		IF EXISTS(
			SELECT
				form_ofice_id,
				employee_id,
				movement_type_id
			FROM
				form_data.employee_oficcial_mov_personal_forms fomp
			WHERE
				fomp.form_ofice_id = param_ofice_id
			AND
				fomp.employee_id = param_employee_id
			AND
				fomp.movement_type_id = param_movement_type_id
			AND
				fomp.is_active = '1'
			AND
				fomp.is_deleted = '0'
		)
		THEN
			RETURN local_is_successful;
		ELSE
			INSERT INTO form_data.employee_oficcial_mov_personal_forms(
				form_ofice_id,
				employee_id,
				dedication_id,
				movement_type_id,
				start_date,
				finish_date,
				school_id,
				institute_id,
				coordination_id,
				is_active,
				is_deleted,
				last_modified_by,
				last_modified_date
			)
			VALUES(
				param_ofice_id,
				param_employee_id,
				param_dedication_id,
				param_movement_type_id,
				param_start_date,
				param_finish_date,
				param_school_id,
				param_institute_id,
				param_coordination_id,
				'0',
				'0',
				param_user_id,
				CLOCK_TIMESTAMP()
			)
			RETURNING id
			INTO STRICT local_emp_form_of_per_mov_id;

			SELECT employee_oficcial_mov_personal_form_insert_history INTO local_is_successful FROM form_data.employee_oficcial_mov_personal_form_insert_history(
				param_emp_form_of_per_mov_id := local_emp_form_of_per_mov_id,
				param_change_type := 'FIRST INSERT',
				param_change_description := 'FIRST INSERT'
			);

			RETURN local_is_successful;

		END IF;
	ENd;
$udf$;

--function of insert log
CREATE OR REPLACE FUNCTION form_data.employee_oficcial_mov_personal_form_insert_history(
	param_emp_form_of_per_mov_id BIGINT,
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
		INSERT INTO form_data.employee_oficcial_mov_personal_forms_history(
			employee_form_ofice_form_person_movement_id,
			form_ofice_id,
			form_person_movement_id,
			employee_id,
			dedication_id,
			movement_type_id,
			start_date,
			finish_date,
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
			form_ofice_id,
			form_person_movement_id,
			employee_id,
			dedication_id,
			movement_type_id,
			start_date,
			finish_date,
			school_id,
			institute_id,
			is_active,
			is_deleted,
			last_modified_by,
			last_modified_date,
			param_change_type,
			param_change_description
			FROM
				form_data.employee_oficcial_mov_personal_forms fomp
			WHERE
				fomp.id = param_emp_form_of_per_mov_id
			ORDER BY
				fomp.last_modified_date
			DESC
			LIMIT 1;

			local_is_successful := '1';

			RETURN local_is_successful;
	END;
$udf$;


-- function update add data of movement per
CREATE OR REPLACE FUNCTION form_data.employee_oficcial_mov_personal_form_update_mov_per(
	param_id BIGINT,
	param_ofice_id BIGINT,
	param_movement_per_id BIGINT,
	param_user_id BIGINT
)
RETURNS BIT
LANGUAGE plpgsql VOLATILE
COST 100.0
AS $udf$
	DECLARE
		local_is_successful BIT := '0';
	BEGIN
		UPDATE form_data.employee_oficcial_mov_personal_forms SET
			form_person_movement_id = param_movement_per_id,
			is_active = '1',
			last_modified_by = param_user_id,
			last_modified_date = CLOCK_TIMESTAMP()
		WHERE
			id = param_id
		AND
			form_ofice_id = param_ofice_id;


		SELECT employee_oficcial_mov_personal_form_insert_history INTO local_is_successful FROM form_data.employee_oficcial_mov_personal_form_insert_history(
			param_emp_form_of_per_mov_id := local_emp_form_of_per_mov_id,
			param_change_type := 'UPDATE MOVEMENT PERSONAL',
			param_change_description := 'UPDATE value of MOVEMENT PERSONAL'
		);

		RETURN local_is_successful;
	END;
$udf$;


-- function of integrate insert form complete with employee and process
CREATE OR REPLACE FUNCTION form_data.employee_form_ofice_insert_complete(
	param_employee_json json,
	param_form_ofice_json json,
	param_user_id BIGINT
)
RETURNS BIT
LANGUAGE plpgsql VOLATILE
COST 100.0
AS $udf$
	DECLARE
		local_is_successful BIT := '0';
		local_employee_id BIGINT;
		local_form_ofice_id BIGINT;

	BEGIN
		IF (
			SELECT param_employee_json::TEXT
			LIKE '%employee_id%'
		) THEN
		local_employee_id := (param_employee_json->>'employee_id')::BIGINT;
		raise DEBUG 'exist local_employee_id %', local_employee_id;
		ELSE
		SELECT employee_insert INTO local_employee_id FROM employee_data.employee_insert(
			(param_employee_json->>'nacionality_id')::INTEGER,
			(param_employee_json->>'documentation_id')::INTEGER,
			param_employee_json->>'identification',
			param_employee_json->>'first_name',
			param_employee_json->>'second_name',
			param_employee_json->>'surname',
			param_employee_json->>'second_surname',
			(param_employee_json->>'birth_date')::DATE,
			(param_employee_json->>'gender_id')::INTEGER,
			param_employee_json->>'email',
			(param_employee_json->>'school_id')::INTEGER,
			(param_employee_json->>'institute_id')::INTEGER,
			(param_employee_json->>'coordination_id')::INTEGER,
			(param_employee_json->>'departament_id')::INTEGER,
			(param_employee_json->>'chair_id')::INTEGER,
			param_employee_json->>'mobile_phone_number',
			param_employee_json->>'local_phone_number',
			param_user_id
		);
		raise DEBUG 'insert local_employee_id %', local_employee_id;
		END IF;
		IF (SELECT param_employee_json::TEXT
			LIKE '%employee_idac_id%'
			)
		THEN
			PERFORM employee_data.employee_idac_code_udpate_idac_code(
				(param_employee_json->>'employee_idac_id')::INTEGER,
				local_employee_id::INTEGER,
				(param_employee_json->>'idac_id')::INTEGER,
				param_user_id
			);
			raise DEBUG 'exist idac %', (param_employee_json->>'idac_id')::INTEGER;
		ELSE
			PERFORM employee_data.employee_idac_code_insert(
				local_employee_id::INTEGER,
				(param_employee_json->>'idac_id')::INTEGER,
				param_user_id
			);
			raise DEBUG 'insert idac %', (param_employee_json->>'idac_id')::INTEGER;

			IF (param_form_ofice_json->>'code_form' != '' OR param_form_ofice_json->>'code_form' IS NOT NULL)
			THEN
				SELECT official_forms_insert INTO local_form_ofice_id FROM form_data.official_forms_insert(
					param_form_ofice_json->>'code_form',
					param_user_id
				);
				raise DEBUG 'insert ilocal_form_ofice_id %', local_form_ofice_id;

				IF (local_form_ofice_id != 0)
				THEN
					PERFORM form_data.employee_oficcial_mov_personal_form_insert(
						local_form_ofice_id,
						local_employee_id,
						(param_form_ofice_json->>'dedication_id')::INTEGER,
						(param_form_ofice_json->>'movement_type_id')::INTEGER,
						(param_form_ofice_json->>'start_date')::DATE,
						(param_form_ofice_json->>'finish_date')::DATE,
						(param_form_ofice_json->>'school_id')::INTEGER,
						(param_form_ofice_json->>'institute_id')::INTEGER,
						(param_form_ofice_json->>'coordination_id')::INTEGER,
						param_user_id
					);

					SELECT process_form_ofice_insert INTO local_is_successful FROM process_form.process_form_ofice_insert(
						local_form_ofice_id::INTEGER,
						param_user_id
					);
				END IF;
			END IF;
		END IF;
		RETURN local_is_successful;
	END;
$udf$;

-- function of insert form movement personal
CREATE OR REPLACE FUNCTION form_data.employee_form_movement_personal_insert_complete(
	param_employee_json json,
	param_form_mov_per_json json,
	param_user_id BIGINT
)
RETURNS BIT
LANGUAGE plpgsql VOLATILE
COST 100.0
AS $udf$
	DECLARE
		local_is_successful BIT := '0';
		local_emp_form_mov_per_id BIGINT;
	BEGIN
		PERFORM employee_data.employee_update_for_movement_personal(
			(param_employee_json->>'employee_id')::INTEGER,
			(param_employee_json->>'state_id')::INTEGER,
			(param_employee_json->>'municipality_id')::INTEGER,
			(param_employee_json->>'parish_id')::INTEGER,
			param_employee_json->>'ubication',
			param_employee_json->>'address',
			param_employee_json->>'housing_type',
			param_employee_json->>'housing_identifier',
			param_employee_json->>'apartament',
			(param_employee_json->>'ingress_id')::INTEGER,
			(param_employee_json->>'income_type_id')::INTEGER,
			param_user_id
		);
		IF (param_form_mov_per_json->>'code_form' != '' OR param_form_mov_per_json->>'code_form' IS NOT NULL)
		THEN
			SELECT movement_personal_forms_insert INTO local_emp_form_mov_per_id FROM form_data.movement_personal_forms_insert(
				param_form_mov_per_json->>'code_form',
				param_user_id
			);

			IF (SELECT param_employee_json::TEXT
			LIKE '%employee_salary_id%')
			THEN
				PERFORM employee_data.employee_salary_update_salary(
					(param_employee_json->>'employee_salary_id')::INTEGER,
					(param_employee_json->>'employee_id')::INTEGER,
					(param_employee_json->>'salary_id')::INTEGER,
					param_user_id
				);
			ELSE
				PERFORM employee_data.employee_salaries_insert(
					(param_employee_json->>'employee_id')::INTEGER,
					(param_employee_json->>'salary_id')::INTEGER,
					param_user_id
				);

				IF (local_emp_form_mov_per_id != 0)
				THEN
					PERFORM form_data.employee_oficcial_mov_personal_form_update_mov_per(
						(param_form_mov_per_json->>'employee_form_ofice_form_person_movement_id')::BIGINT,
						(param_form_mov_per_json->>'form_ofice_id')::BIGINT,
						local_emp_form_mov_per_id,
						param_user_id
					);

					SELECT process_form_movement_personal_insert INTO local_is_successful FROM process_form.process_form_movement_personal_insert(
						local_emp_form_mov_per_id::INTEGER,
						param_user_id
					);

				END IF;
			END IF;
		END IF;
		RETURN local_is_successful;
	END;
$udf$;

-- function of get list forms
CREATE OR REPLACE FUNCTION form_data.get_forms_list(
	param_ubication INTEGER,
	param_ubication_form INTEGER
)
RETURNS json
LANGUAGE 'sql'
COST 100.0
AS $BODY$
	SELECT ARRAY_TO_JSON(ARRAY_AGG(ROW_TO_JSON(DATA)))
	FROM (
		SELECT
			fomp.id,
			COALESCE(fo.code_form, fmp.code_form) as code_form,
			COALESCE(fo.registration_date, fmp.registration_date) as registration_date,
			mov.description as movement_type,
			exec.description as ubication
		FROM
			form_data.employee_oficcial_mov_personal_forms fomp
		LEFT OUTER JOIN
			form_data.official_forms fo
		ON
				fo.id = fomp.form_ofice_id
			AND
				fo.is_active = '1'
			AND
				fo.is_deleted = '0'
			AND
				fomp.is_deleted = '0'
			AND
				fo.approval_date IS NULL
		LEFT OUTER JOIN
			form_data.movement_personal_forms fmp
		ON
				fmp.id = fomp.form_person_movement_id
			AND
				fmp.is_active = '1'
			AND
				fmp.is_deleted = '0'
			AND
				fomp.is_deleted = '0'
			AND
				fmp.approval_date IS NULL

	)DATA;