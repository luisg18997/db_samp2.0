-- function of roles
-- function of insert
CREATE OR REPLACE FUNCTION user_data.roles_insert(
    param_description VARCHAR,
    param_user_id INTEGER
)
RETURNS BIT 
LANGUAGE plpgsql VOLATILE
COST 100.0
AS $udf$
  DECLARE
      local_is_successful BIT := '0';
      local_roles_id BIGINT;
    BEGIN
        IF EXISTS
        (
            SELECT
                rl.description
            FROM
                user_data.roles rl
            WHERE
                rl.description = param_description
            AND
                rl.is_active =  '1'
            AND
                rl.is_deleted = '0'
        )
        THEN
            RETURN local_is_successful;
        ELSE
            INSERT INTO user_data.roles (
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
            INTO STRICT local_roles_id;

            SELECT roles_insert_history INTO local_is_successful FROM user_data.roles_insert_history(
                param_role_id := local_roles_id,
                param_change_type := 'FIRST INSERT',
                param_change_description := 'FIRST INSERT'
            );

            RETURN local_is_successful;
        END IF;
    END;
$udf$;

-- function insert log
CREATE OR REPLACE FUNCTION user_data.roles_insert_history(
    param_role_id BIGINT,
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
        INSERT INTO user_data.roles_history(
            role_id,
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
            user_data.roles rl
        WHERE
            rl.id = param_role_id
        ORDER BY
            rl.last_modified_date
        DESC
        LIMIT 1;

        local_is_successful := '1';

        RETURN local_is_successful;
    END;
$udf$;


-- function of ubications
-- function of insert
CREATE OR REPLACE FUNCTION user_data.ubication_insert(
    param_name VARCHAR,
    param_user_id INTEGER
)
RETURNS BIT 
LANGUAGE plpgsql VOLATILE
COST 100.0
AS $udf$
  DECLARE
      local_is_successful BIT := '0';
      local_ubication_id BIGINT;
    BEGIN
        IF EXISTS
        (
            SELECT
                ub.name
            FROM
                user_data.ubications ub
            WHERE
                ub.name = param_name
            AND
                ub.is_active =  '1'
            AND
                ub.is_deleted = '0'
        )
        THEN
            RETURN local_is_successful;
        ELSE
            INSERT INTO user_data.ubications (
                name,
                is_active,
                is_deleted,
                last_modified_by,
                last_modified_date
            )
            VALUES (
                param_name,
                '1',
                '0',
                param_user_id,
                CLOCK_TIMESTAMP()
            )
            RETURNING id
            INTO STRICT local_ubication_id;

            SELECT ubication_insert_history INTO local_is_successful FROM user_data.ubication_insert_history(
                param_ubication_id := local_ubication_id,
                param_change_type := 'FIRST INSERT',
                param_change_description := 'FIRST INSERT'
            );

            RETURN local_is_successful;
        END IF;
    END;
$udf$;

-- function insert log
CREATE OR REPLACE FUNCTION user_data.ubication_insert_history(
    param_ubication_id BIGINT,
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
        INSERT INTO user_data.ubications_history(
            ubication_id,
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
            user_data.ubications ub
        WHERE
            ub.id = param_ubication_id
        ORDER BY
            ub.last_modified_date
        DESC
        LIMIT 1;

        local_is_successful := '1';

        RETURN local_is_successful;
    END;
$udf$;



-- function of security_questions
-- function of insert
CREATE OR REPLACE FUNCTION user_data.security_question_insert(
    param_description VARCHAR,
    param_user_id INTEGER
)
RETURNS BIT 
LANGUAGE plpgsql VOLATILE
COST 100.0
AS $udf$
  DECLARE
      local_is_successful BIT := '0';
      local_question_id BIGINT;
    BEGIN
        IF EXISTS
        (
            SELECT
                qt.description
            FROM
                user_data.security_questions qt
            WHERE
                qt.description = param_description
            AND
                qt.is_active =  '1'
            AND
                qt.is_deleted = '0'
        )
        THEN
            RETURN local_is_successful;
        ELSE
            INSERT INTO user_data.security_questions (
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
            INTO STRICT local_question_id;

            SELECT security_question_insert_history INTO local_is_successful FROM user_data.security_question_insert_history(
                param_question_id := local_question_id,
                param_change_type := 'FIRST INSERT',
                param_change_description := 'FIRST INSERT'
            );

            RETURN local_is_successful;
        END IF;
    END;
$udf$;

-- function insert log
CREATE OR REPLACE FUNCTION user_data.security_question_insert_history(
    param_question_id BIGINT,
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
        INSERT INTO user_data.security_questions_history(
            security_question_id,
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
            user_data.security_questions qt
        WHERE
            qt.id = param_question_id
        ORDER BY
            qt.last_modified_date
        DESC
        LIMIT 1;

        local_is_successful := '1';

        RETURN local_is_successful;
    END;
$udf$;



-- functions of users
-- function of insert a me
CREATE OR REPLACE FUNCTION user_data.user_insert(
	param_name VARCHAR,
	param_surname VARCHAR,
	param_email VARCHAR,
	param_password VARCHAR,
	param_ubication_id INTEGER,
    param_ubication_user_id INTEGER
)
RETURNS BIT 
LANGUAGE plpgsql VOLATILE
COST 100.0
AS $udf$
  DECLARE
	  local_is_successful BIT := '0';
      local_user_id BIGINT;
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
            AND
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
    			0,
    			CLOCK_TIMESTAMP(),
    			CLOCK_TIMESTAMP()
    		)
            RETURNING id
            INTO STRICT local_user_id;

            SELECT user_insert_history INTO local_is_successful FROM user_data.user_insert_history(
                param_user_id := local_user_id,
                param_change_type := 'FIRST INSERT',
                param_change_description := 'FIRST INSERT'
            );

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
    param_ubication_user_id INTEGER,
    param_role_user_id INTEGER,
	param_user_id INTEGER
)
RETURNS BIT 
LANGUAGE plpgsql VOLATILE
COST 100.0
AS $udf$
  DECLARE
	  local_is_successful BIT := '0';
      local_user_id BIGINT;
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
            AND
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
    			last_modified_by,is_active,
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
    		)
            RETURNING id
            INTO STRICT local_user_id;

            SELECT user_insert_history INTO local_is_successful FROM user_data.user_insert_history(
                param_user_id := local_user_id,
                param_change_type := 'FIRST INSERT BY ADMIN',
                param_change_description := 'FIRST INSERT BY ADMIN'
            );

    		RETURN local_is_successful;
    	END IF;
    END;
$udf$;

-- function of insert log
CREATE OR REPLACE FUNCTION user_data.user_insert_history(
    param_user_id BIGINT,
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
        INSERT INTO user_data.users_history(
            user_id,
            name,
            surname,
            email,
            password,
            ubication_id,
            school_id,
            institute_id,
            coordination_id,
            is_active,
            is_deleted,
            last_modified_by,
            user_create_date,
            last_modified_date,
            change_type,
            change_description
        )
        SELECT
            id,
            name,
            surname,
            email,
            password,
            ubication_id,
            school_id,
            institute_id,
            coordination_id,
            is_active,
            is_deleted,
            last_modified_by,
            user_create_date,
            last_modified_date,
            param_change_type,
            param_change_description
        FROM
            user_data.users 
        WHERE
            id = param_user_id
        ORDER BY
            last_modified_date
        DESC
        LIMIT 1;

        local_is_successful := '1';

        RETURN local_is_successful;
    END;
$udf$;