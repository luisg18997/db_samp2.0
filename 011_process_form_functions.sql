-- functions of process_movement_personal_form

--function of insert process_movement_personal_form
CREATE OR REPLACE FUNCTION process_form.process_movement_personal_form_insert(
	param_movement_personal_form_id INTEGER,
	param_ubication_id INTEGER,
	param_user_id BIGINT
)
RETURNS BIT
LANGUAGE plpgsql VOLATILE
COST 100.0
AS $udf$
	DECLARE
		local_is_successful BIT := '0';
		local_process_movement_personal_form_id BIGINT;
	BEGIN
		INSERT INTO process_form.process_movement_personal_form(
            movement_personal_form_id,
            date_made,
            ubication_id,
            status_process_form_id,
            is_active,
            is_deleted,
            last_modified_by,
            last_modified_date
        )
    	VALUES (
    	   	param_movement_personal_form_id,
	   			CLOCK_TIMESTAMP(),
	   			param_ubication_id,
	   	    1,
          '1',
					'0',
					param_user_id,
					CLOCK_TIMESTAMP()
			)
			RETURNING id
      	INTO STRICT local_process_movement_personal_form_id;

      	SELECT process_movement_personal_form_insert_history into local_is_successful FROM process_form.process_movement_personal_form_insert_history(
      		param_process_movement_personal_form_id := local_process_movement_personal_form_id,
      		param_change_type := 'FIRST INSERT',
      		param_change_description := 'FIRST INSERT'
      	);

    	RETURN local_is_successful;
    END;
$udf$;

--function of insert log process_movement_personal_form
CREATE OR REPLACE FUNCTION process_form.process_movement_personal_form_insert_history(
	param_process_movement_personal_form_id BIGINT,
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
		INSERT INTO process_form.process_movement_personal_form_history(
	        process_movement_personal_form_id,
	        movement_personal_form_id,
	        date_made,
	        ubication_id,
					observation,
	        status_process_form_id,
	        is_active,
	        is_deleted,
	        last_modified_by,
	        last_modified_date,
	        change_type,
	        change_description
	  	)
	  	SELECT
  		 	id,
            movement_personal_form_id,
            date_made,
            ubication_id,
						observation,
            status_process_form_id,
            is_active,
            is_deleted,
            last_modified_by,
            last_modified_date,
            param_change_type,
			param_change_description
		FROM
			process_form.process_movement_personal_form pf
		WHERE
			pf.id = param_process_movement_personal_form_id
		ORDER BY
			pf.last_modified_date
		DESC
		LIMIT 1;

		local_is_successful := '1';
	    RETURN local_is_successful;
	  END;
	$udf$;


-- funciton of list process_movement_personal_form
CREATE OR REPLACE FUNCTION process_form.get_process_movement_personal_form_list()
RETURNS json
LANGUAGE 'sql'
COST 100.0

AS $BODY$
	SELECT ARRAY_TO_JSON(ARRAY_AGG(ROW_TO_JSON(DATA)))
	FROM (
		SELECT
			id,
            movement_personal_form_id,
            date_made,
            ubication_id,
            status_process_form_id
		FROM
			process_form.process_movement_personal_form pf
		WHERE
			pf.is_active = '1'
		AND
			pf.is_deleted = '0'
	)DATA;
$BODY$;

--function get one data process_movement_personal_form
CREATE OR REPLACE FUNCTION process_form.get_process_movement_personal_form(
	param_movement_personal_form_id INTEGER
)
RETURNS json
LANGUAGE 'sql'
COST 100.0

AS $BODY$
	SELECT ARRAY_TO_JSON(ARRAY_AGG(ROW_TO_JSON(DATA)))
	FROM (
		SELECT
 			 pf.id,
	         pf.movement_personal_form_id,
	         pf.date_made,
	         pf.ubication_id,
	         pf.status_process_form_id

		FROM
			process_form.process_movement_personal_form pf
		WHERE
			pf.movement_personal_form_id = param_movement_personal_form_id
		AND
			pf.is_active = '1'
		AND
			pf.is_deleted = '0'
	)DATA;
$BODY$;

-- function update all columns process_movement_personal_form
CREATE OR REPLACE FUNCTION process_form.process_movement_personal_form_update_all_columns(
	param_id INTEGER,
	param_user_id BIGINT,
	param_movement_personal_form_id INTEGER,
	param_ubication_id INTEGER,
	param_observation TEXT,
	param_status_process_form_id INTEGER,
	param_is_active BIT,
	param_is_deleted BIT
)
RETURNS BIT
LANGUAGE plpgsql VOLATILE
COST 100.0
AS $udf$
	DECLARE
    	local_is_successful BIT := '0';
			updated_rows INTEGER := 0;
  	BEGIN
  		UPDATE process_form.process_movement_personal_form SET
          movement_personal_form_id = param_movement_personal_form_id,
          date_made = CLOCK_TIMESTAMP(),
          ubication_id = param_ubication_id,
					observation=param_observation,
          status_process_form_id = param_status_process_form_id,
          is_active = param_is_active,
		    	is_deleted = param_is_deleted,
  		    last_modified_by = param_user_id,
      		last_modified_date = CLOCK_TIMESTAMP()
      	WHERE
      		id = param_id;
				GET DIAGNOSTICS updated_rows = ROW_COUNT;

				IF updated_rows != 0 THEN
    			SELECT process_movement_personal_form_insert_history into local_is_successful FROM process_form.process_movement_personal_form_insert_history(
	      		param_process_movement_personal_form_id := param_id,
	      		param_change_type := 'UPDATE all_columns',
	      		param_change_description := 'UPDATE value of all columns'
	      	);
				END IF;

    	RETURN local_is_successful;
  	END;
$udf$;

-- function update is active process_movement_personal_form
CREATE OR REPLACE FUNCTION process_form.process_movement_personal_form_update_is_active(
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
			updated_rows INTEGER := 0;
  	BEGIN
  		UPDATE process_form.process_movement_personal_form SET
  			is_active = param_is_active,
  			last_modified_by = param_user_id,
      	last_modified_date = CLOCK_TIMESTAMP()
    	WHERE
    		id = param_id;
			GET DIAGNOSTICS updated_rows = ROW_COUNT;

			IF updated_rows != 0 THEN
    		SELECT process_movement_personal_form_insert_history into local_is_successful FROM process_form.process_movement_personal_form_insert_history(
      		param_process_movement_personal_form_id := param_id,
      		param_change_type := 'UPDATE is_active',
      		param_change_description := 'UPDATE value of is_active'
      	);
			END IF;

    	RETURN local_is_successful;
  	END;
$udf$;

-- function update is deleted process_movement_personal_form
CREATE OR REPLACE FUNCTION process_form.process_movement_personal_form_update_is_deleted(
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
			updated_rows INTEGER := 0;
  	BEGIN
  		UPDATE process_form.process_movement_personal_form SET
  			is_deleted = param_is_deleted,
  			last_modified_by = param_user_id,
    		last_modified_date = CLOCK_TIMESTAMP()
    	WHERE
    		id = param_id;
			GET DIAGNOSTICS updated_rows = ROW_COUNT;

			IF updated_rows != 0 THEN
    		SELECT process_movement_personal_form_insert_history into local_is_successful FROM process_form.process_movement_personal_form_insert_history(
      		param_process_movement_personal_form_id := param_id,
      		param_change_type := 'UPDATE is_deleted',
      		param_change_description := 'UPDATE value of is_deleted'
      	);
			END IF;

    	RETURN local_is_successful;
  	END;
$udf$;

	-- functions of process_official_form

--function of insert process_official_form
CREATE OR REPLACE FUNCTION process_form.process_official_form_insert(
	param_official_form_id INTEGER,
	param_ubication_id INTEGER,
	param_user_id BIGINT

)
RETURNS BIT
LANGUAGE plpgsql VOLATILE
COST 100.0
AS $udf$
	DECLARE
		local_is_successful BIT := '0';
		local_process_official_form_id BIGINT;
	BEGIN

INSERT INTO process_form.process_official_form(
             official_form_id,
             date_made,
             ubication_id,
             status_process_form_id,
             is_active,
             is_deleted,
             last_modified_by,
             last_modified_date
                )
    VALUES (
    	     param_official_form_id,
	   		 	CLOCK_TIMESTAMP(),
	   		 param_ubication_id,
	   	     1,
            '1',
			'0',
			param_user_id,
			CLOCK_TIMESTAMP()
		)
		RETURNING id
      	INTO STRICT local_process_official_form_id;

      	SELECT process_official_form_insert_history into local_is_successful FROM process_form.process_official_form_insert_history(
      		param_process_official_form_id := local_process_official_form_id,
      		param_change_type := 'FIRST INSERT',
      		param_change_description := 'FIRST INSERT'
      	);

    	RETURN local_is_successful;
    END;
$udf$;

	--function of insert log process_official_form
	CREATE OR REPLACE FUNCTION process_form.process_official_form_insert_history(
	  param_process_official_form_id BIGINT,
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
		INSERT INTO process_form.process_official_form_history(
            process_official_form_id,
            official_form_id,
            date_made,
            ubication_id,
						observation,
            status_process_form_id,
            is_active,
            is_deleted,
            last_modified_by,
            last_modified_date,
            change_type,
            change_description
	  	)
	  	SELECT
  		 	id,
            official_form_id,
            date_made,
            ubication_id,
						observation,
            status_process_form_id,
            is_active,
            is_deleted,
            last_modified_by,
            last_modified_date,
            param_change_type,
		   	param_change_description
		FROM
			process_form.process_official_form pf
		WHERE
			pf.id = param_process_official_form_id
		ORDER BY
			pf.last_modified_date
		DESC
		LIMIT 1;

		local_is_successful := '1';
	    RETURN local_is_successful;
	  END;
	$udf$;

-- funciton of list official_form
CREATE OR REPLACE FUNCTION process_form.get_process_official_form_list()
RETURNS json
LANGUAGE 'sql'
COST 100.0

AS $BODY$
	SELECT ARRAY_TO_JSON(ARRAY_AGG(ROW_TO_JSON(DATA)))
	FROM (
		SELECT
			id,
         	official_form_id,
         	date_made,
         	ubication_id,
         	status_process_form_id
		FROM
			process_form.process_official_form pf
		WHERE
			pf.is_active = '1'
		AND
			pf.is_deleted = '0'
	)DATA;
$BODY$;


--function get one data process_official_form
CREATE OR REPLACE FUNCTION process_form.get_process_official_form(
	param_official_form_id INTEGER
)
RETURNS json
LANGUAGE 'sql'
COST 100.0

AS $BODY$
	SELECT ARRAY_TO_JSON(ARRAY_AGG(ROW_TO_JSON(DATA)))
	FROM (
		SELECT
 			pf.id,
	        pf.official_form_id,
	        pf.date_made,
	        pf.ubication_id,
	        pf.status_process_form_id

		FROM
			process_form.process_official_form pf
		WHERE
			pf.official_form_id = param_official_form_id
		AND
			pf.is_active = '1'
		AND
			pf.is_deleted = '0'
	)DATA;
$BODY$;

-- function update all columns process_official_form
CREATE OR REPLACE FUNCTION process_form.process_official_form_update_all_columns(
	param_id INTEGER,
	param_user_id BIGINT,
	param_official_form_id INTEGER,
	param_ubication_id INTEGER,
	param_observation TEXT,
	param_status_process_form_id INTEGER,
	param_is_active BIT,
	param_is_deleted BIT
)
RETURNS BIT
LANGUAGE plpgsql VOLATILE
COST 100.0
AS $udf$
	DECLARE
    	local_is_successful BIT := '0';
			updated_rows INTEGER := 0;
  	BEGIN
  		UPDATE process_form.process_official_form SET
         official_form_id = param_official_form_id,
		    date_made = CLOCK_TIMESTAMP(),
		    ubication_id = param_ubication_id,
				observation=param_observation,
		    status_process_form_id = param_status_process_form_id,
		    is_active = param_is_active,
	    	is_deleted = param_is_deleted,
	    	last_modified_by = param_user_id,
		    last_modified_date = CLOCK_TIMESTAMP()
      WHERE
      	id = param_id;
			GET DIAGNOSTICS updated_rows = ROW_COUNT;

			IF updated_rows != 0 THEN
    		SELECT process_official_form_insert_history into local_is_successful FROM process_form.process_official_form_insert_history(
      		param_process_official_form_id := param_id,
      		param_change_type := 'UPDATE all_columns',
      		param_change_description := 'UPDATE value of all columns'
      	);
			END IF;

    	RETURN local_is_successful;
  	END;
$udf$;

-- function update is active process_official_form
CREATE OR REPLACE FUNCTION process_form.process_official_form_update_is_active(
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
			updated_rows INTEGER := 0;
  	BEGIN
  		UPDATE process_form.process_official_form SET
  			is_active = param_is_active,
  			last_modified_by = param_user_id,
    		last_modified_date = CLOCK_TIMESTAMP()
    	WHERE
      		id = param_id;
			GET DIAGNOSTICS updated_rows = ROW_COUNT;

			IF updated_rows != 0 THEN
    		SELECT process_official_form_insert_history into local_is_successful FROM process_form.process_official_form_insert_history(
      		param_process_official_form_id := param_id,
      		param_change_type := 'UPDATE is_active',
      		param_change_description := 'UPDATE value of is_active'
      	);
			END IF;

    	RETURN local_is_successful;
  	END;
$udf$;

-- function update is deleted process_official_form
CREATE OR REPLACE FUNCTION process_form.process_official_form_update_is_deleted(
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
			updated_rows INTEGER := 0;
  	BEGIN
  		UPDATE process_form.process_official_form SET
  		is_deleted = param_is_deleted,
  			last_modified_by = param_user_id,
      		last_modified_date = CLOCK_TIMESTAMP()
      	WHERE
      		id = param_id;
			GET DIAGNOSTICS updated_rows = ROW_COUNT;

			IF updated_rows != 0 THEN
	    	SELECT process_official_form_insert_history into local_is_successful FROM process_form.process_official_form_insert_history(
      		param_process_official_form_id := param_id,
      		param_change_type := 'UPDATE is_deleted',
      		param_change_description := 'UPDATE value of is_deleted'
      	);
			END IF;

    	RETURN local_is_successful;
  	END;
$udf$;

--function of status_process_form
--function of insert status_process_form
CREATE OR REPLACE FUNCTION process_form.status_process_form_insert(
	param_description VARCHAR,
	param_user_id BIGINT

)
RETURNS BIT
LANGUAGE plpgsql VOLATILE
COST 100.0
AS $udf$
	DECLARE
		local_is_successful BIT := '0';
		local_status_process_form_id BIGINT;
	BEGIN
		INSERT INTO process_form.status_process_form(
		 	description,
	     	is_active,
	        is_deleted,
	        last_modified_by,
	        last_modified_date
	    )
    	VALUES (
    	    param_description,
            '1',
			'0',
			param_user_id,
			CLOCK_TIMESTAMP()
		)
		RETURNING id
      	INTO STRICT local_status_process_form_id;

      	SELECT status_process_form_insert_history into local_is_successful FROM process_form.status_process_form_insert_history(
      		param_status_process_form_id := local_status_process_form_id,
      		param_change_type := 'FIRST INSERT',
      		param_change_description := 'FIRST INSERT'
      	);

    	RETURN local_is_successful;
    END;
$udf$;

--function of insert log status_process_form
CREATE OR REPLACE FUNCTION process_form.status_process_form_insert_history(
    param_status_process_form_id BIGINT,
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
		INSERT INTO process_form.status_process_form_history(
			status_process_form_id,
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
			process_form.status_process_form pf
		WHERE
			pf.id = param_status_process_form_id
		ORDER BY
			pf.last_modified_date
		DESC
		LIMIT 1;

			local_is_successful := '1';
	    RETURN local_is_successful;
	  END;
	$udf$;

-- funciton of list status_process_form
CREATE OR REPLACE FUNCTION process_form.get_status_process_form_list()
RETURNS json
LANGUAGE 'sql'
COST 100.0

AS $BODY$
	SELECT ARRAY_TO_JSON(ARRAY_AGG(ROW_TO_JSON(DATA)))
	FROM (
		SELECT
		 	id,
        	description
		FROM
			process_form.status_process_form pf
		WHERE
			pf.is_active = '1'
		AND
			pf.is_deleted = '0'
	)DATA;
$BODY$;

--function get one data status_process_form
CREATE OR REPLACE FUNCTION process_form.get_status_process_form(
	param_id INTEGER
)
RETURNS json
LANGUAGE 'sql'
COST 100.0

AS $BODY$
	SELECT ARRAY_TO_JSON(ARRAY_AGG(ROW_TO_JSON(DATA)))
	FROM (
		SELECT
 			 pf.id,
	         pf.description

		FROM
			process_form.status_process_form pf
		WHERE
			pf.id = param_id
		AND
			pf.is_active = '1'
		AND
			pf.is_deleted = '0'
	)DATA;
$BODY$;

-- function update all columns status_process_form
CREATE OR REPLACE FUNCTION process_form.status_process_form_update_all_columns(
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
			updated_rows INTEGER := 0;
  	BEGIN
  		UPDATE process_form.status_process_form SET
  			description = param_description,
  			is_active = param_is_active,
  			is_deleted = param_is_deleted,
  			last_modified_by = param_user_id,
      		last_modified_date = CLOCK_TIMESTAMP()
      	WHERE
      		id = param_id;
			GET DIAGNOSTICS updated_rows = ROW_COUNT;

			IF updated_rows != 0 THEN
    		SELECT status_process_form_insert_history into local_is_successful FROM process_form.status_process_form_insert_history(
      		param_status_process_form_id := param_id,
      		param_change_type := 'UPDATE all_columns',
      		param_change_description := 'UPDATE value of all columns'
      	);
			END IF;

    	RETURN local_is_successful;
  	END;
$udf$;

-- function update is active status_process_form
CREATE OR REPLACE FUNCTION process_form.status_process_form_update_is_active(
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
			updated_rows INTEGER := 0;
  	BEGIN
  		UPDATE process_form.status_process_form SET
  			is_active = param_is_active,
  			last_modified_by = param_user_id,
      		last_modified_date = CLOCK_TIMESTAMP()
      	WHERE
      		id = param_id;
			GET DIAGNOSTICS updated_rows = ROW_COUNT;

			IF updated_rows != 0 THEN
    		SELECT status_process_form_insert_history into local_is_successful FROM process_form.status_process_form_insert_history(
      		param_status_process_form_id := param_id,
      		param_change_type := 'UPDATE is_active',
      		param_change_description := 'UPDATE value of is_active'
      	);
			END IF;

    	RETURN local_is_successful;
  	END;
$udf$;

-- function update is deleted status_process_form
CREATE OR REPLACE FUNCTION process_form.status_process_form_update_is_deleted(
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
			updated_rows INTEGER := 0;
  	BEGIN
  		UPDATE process_form.status_process_form SET
  			is_deleted = param_is_deleted,
  			last_modified_by = param_user_id,
      		last_modified_date = CLOCK_TIMESTAMP()
      	WHERE
      		id = param_id;
			GET DIAGNOSTICS updated_rows = ROW_COUNT;

			IF updated_rows != 0 THEN
 				SELECT status_process_form_insert_history into local_is_successful FROM process_form.status_process_form_insert_history(
      		param_status_process_form_id := param_id,
      		param_change_type := 'UPDATE is_deleted',
      		param_change_description := 'UPDATE value of is_deleted'
      	);
			END IF;

    	RETURN local_is_successful;
  	END;
$udf$;
