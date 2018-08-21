-- functions of users

-- function of inser a me

CREATE OR REPLACE FUNCTION user_data.user_insert(
	param_name VARCHAR,
	param_surname VARCHAR,
	param_email VARCHAR,
	param_password VARCHAR,
	param_ubication_id INTEGER,
	param_user_id INTEGER
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
			SELECT usr.email 
			FROM user_data.users usr
			WHERE 
				usr.email = param_email
			AND
				(
					usr.is_active = '1'
				OR
					usr.is_active = '0'
				)
				usr.is_deleted = '0'
		)
		THEN
			RETURN local_is_successful;
    	ELSE
    		INSERT INTO user_data.users(
    			name,
    			surname,
    			email,
    			password,
    			ubication_id,
    			is_active,
    			is_deleted,
    			last_modified_by,
    			user_create_date,
    			last_modified_date
    		)
    		VALUES(
    			param_name,
    			param_surname,
    			param_email,
    			param_password,
    			'0',
    			'0',
    			param_user_id,
    			CLOCK_TIMESTAMP(),
    			CLOCK_TIMESTAMP()
    		);
    		local_is_successful :='1';
    		RETURN local_is_successful;
    	END IF;
    END;
$udf$;

-- function insert for admin

CREATE OR REPLACE FUNCTION user_data.user_insert_for_a_admin(
	param_name VARCHAR,
	param_surname VARCHAR,
	param_email VARCHAR,
	param_password VARCHAR,
	param_ubication_id INTEGER,
	param_user_id INTEGER
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
			SELECT usr.email 
			FROM user_data.users usr
			WHERE 
				usr.email = param_email
			AND
				(
					usr.is_active = '1'
				OR
					usr.is_active = '0'
				)
				usr.is_deleted = '0'
		)
		THEN
			RETURN local_is_successful;
    	ELSE
    		INSERT INTO user_data.users(
    			name,
    			surname,
    			email,
    			password,
    			ubication_id,
    			is_active,
    			is_deleted,
    			last_modified_by,
    			user_create_date,
    			last_modified_date
    		)
    		VALUES(
    			param_name,
    			param_surname,
    			param_email,
    			param_password,
    			'1',
    			'0',
    			param_user_id,
    			CLOCK_TIMESTAMP(),
    			CLOCK_TIMESTAMP()
    		);
    		local_is_successful :='1';
    		RETURN local_is_successful;
    	END IF;
    END;
$udf$;