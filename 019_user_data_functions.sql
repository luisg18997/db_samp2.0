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

-- function of get list
CREATE OR REPLACE FUNCTION user_data.get_roles_list()
RETURNS json
LANGUAGE 'sql'
COST 100.0

AS $BODY$
    SELECT ARRAY_TO_JSON(ARRAY_AGG(ROW_TO_JSON(DATA)))
    FROM (
        SELECT
            rl.id,
            rl.description
        FROM
            user_data.roles rl
        WHERE
            rl.is_active = '1'
        AND
            rl.is_deleted = '0'
    )DATA;
$BODY$;

-- function of get
CREATE OR REPLACE FUNCTION user_data.get_rol_search(
    param_id INTEGER
)
RETURNS json
LANGUAGE 'sql'
COST 100.0

AS $BODY$
    SELECT ARRAY_TO_JSON(ARRAY_AGG(ROW_TO_JSON(DATA)))
    FROM (
        SELECT
            rl.id,
            rl.description
        FROM
            user_data.roles rl
        WHERE
            rl.is_active = '1'
        AND
            rl.is_deleted = '0'
        AND
            rl.id = param_id
    )DATA;
$BODY$;

-- function update all columns
CREATE OR REPLACE FUNCTION user_data.rol_update_all_columns(
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
        UPDATE user_data.roles SET
            description = param_description,
            is_active = param_is_active,
            is_deleted = param_is_deleted,
            last_modified_by = param_user_id,
            last_modified_date = CLOCK_TIMESTAMP()
        WHERE
            id = param_id;

        SELECT roles_insert_history INTO local_is_successful FROM user_data.roles_insert_history(
            param_role_id := param_id,
            param_change_type := 'UPDATE all_columns',
            param_change_description := 'UPDATE value of all columns'
        );

        RETURN local_is_successful;
    END;
$udf$;

-- function update is_active
CREATE OR REPLACE FUNCTION user_data.rol_update_is_active(
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
        UPDATE user_data.roles SET
            is_active = param_is_active,
            last_modified_by = param_user_id,
            last_modified_date = CLOCK_TIMESTAMP()
        WHERE
            id = param_id;

        SELECT roles_insert_history INTO local_is_successful FROM user_data.roles_insert_history(
            param_role_id := param_id,
            param_change_type := 'UPDATE is_active',
            param_change_description := 'UPDATE value of is_active'
        );

        RETURN local_is_successful;
    END;
$udf$;

-- function update is_active
CREATE OR REPLACE FUNCTION user_data.rol_update_is_deleted(
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
        UPDATE user_data.roles SET
            is_deleted = param_is_deleted,
            last_modified_by = param_user_id,
            last_modified_date = CLOCK_TIMESTAMP()
        WHERE
            id = param_id;

        SELECT roles_insert_history INTO local_is_successful FROM user_data.roles_insert_history(
            param_role_id := param_id,
            param_change_type := 'UPDATE is_deleted',
            param_change_description := 'UPDATE value of is_deleted'
        );

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

-- function of get list
CREATE OR REPLACE FUNCTION user_data.get_ubications_list()
RETURNS json
LANGUAGE 'sql'
COST 100.0

AS $BODY$
    SELECT ARRAY_TO_JSON(ARRAY_AGG(ROW_TO_JSON(DATA)))
    FROM (
        SELECT
            ub.id,
            ub.name
        FROM
            user_data.ubications ub
        WHERE
            ub.is_active = '1'
        AND
            ub.is_deleted = '0'
    )DATA;
$BODY$;

-- function of get
CREATE OR REPLACE FUNCTION user_data.get_ubication_search(
    param_id INTEGER
)
RETURNS json
LANGUAGE 'sql'
COST 100.0

AS $BODY$
    SELECT ARRAY_TO_JSON(ARRAY_AGG(ROW_TO_JSON(DATA)))
    FROM (
        SELECT
            ub.id,
            ub.name
        FROM
            user_data.ubications ub
        WHERE
            ub.is_active = '1'
        AND
            ub.is_deleted = '0'
        AND
            ub.id = param_id
    )DATA;
$BODY$;

-- function update all columns
CREATE OR REPLACE FUNCTION user_data.ubication_update_all_columns(
    param_id INTEGER,
    param_name VARCHAR,
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
        UPDATE user_data.ubications SET
            name = param_name,
            is_active = param_is_active,
            is_deleted = param_is_deleted,
            last_modified_by = param_user_id,
            last_modified_date = CLOCK_TIMESTAMP()
        WHERE
            id = param_id;

        SELECT ubication_insert_history INTO local_is_successful FROM user_data.ubication_insert_history(
            param_ubication_id := param_id,
            param_change_type := 'UPDATE all_columns',
            param_change_description := 'UPDATE value of all columns'
        );

        RETURN local_is_successful;
    END;
$udf$;

-- function update is_active
CREATE OR REPLACE FUNCTION user_data.ubication_update_is_active(
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
        UPDATE user_data.ubications SET
            is_active = param_is_active,
            last_modified_by = param_user_id,
            last_modified_date = CLOCK_TIMESTAMP()
        WHERE
            id = param_id;

        SELECT ubication_insert_history INTO local_is_successful FROM user_data.ubication_insert_history(
            param_ubication_id := param_id,
            param_change_type := 'UPDATE is_active',
            param_change_description := 'UPDATE value of is_active'
        );

        RETURN local_is_successful;
    END;
$udf$;

-- function update is_active
CREATE OR REPLACE FUNCTION user_data.ubication_update_is_deleted(
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
        UPDATE user_data.ubications SET
            is_deleted = param_is_deleted,
            last_modified_by = param_user_id,
            last_modified_date = CLOCK_TIMESTAMP()
        WHERE
            id = param_id;

        SELECT ubication_insert_history INTO local_is_successful FROM user_data.ubication_insert_history(
            param_ubication_id := param_id,
            param_change_type := 'UPDATE is_deleted',
            param_change_description := 'UPDATE value of is_deleted'
        );

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

-- function of get list
CREATE OR REPLACE FUNCTION user_data.get_security_questions_list()
RETURNS json
LANGUAGE 'sql'
COST 100.0

AS $BODY$
    SELECT ARRAY_TO_JSON(ARRAY_AGG(ROW_TO_JSON(DATA)))
    FROM (
        SELECT
            qt.id,
            qt.description
        FROM
            user_data.security_questions qt
        WHERE
            qt.is_active = '1'
        AND
            qt.is_deleted = '0'
    )DATA;
$BODY$;

-- function of get
CREATE OR REPLACE FUNCTION user_data.get_security_question_search(
    param_id INTEGER
)
RETURNS json
LANGUAGE 'sql'
COST 100.0

AS $BODY$
    SELECT ARRAY_TO_JSON(ARRAY_AGG(ROW_TO_JSON(DATA)))
    FROM (
        SELECT
            qt.id,
            qt.description
        FROM
            user_data.security_questions qt
        WHERE
            qt.is_active = '1'
        AND
            qt.is_deleted = '0'
        AND
            qt.id = param_id
    )DATA;
$BODY$;

-- function update all columns
CREATE OR REPLACE FUNCTION user_data.security_question_update_all_columns(
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
        UPDATE user_data.security_questions SET
            description = param_description,
            is_active = param_is_active,
            is_deleted = param_is_deleted,
            last_modified_by = param_user_id,
            last_modified_date = CLOCK_TIMESTAMP()
        WHERE
            id = param_id;

        SELECT security_question_insert_history INTO local_is_successful FROM user_data.security_question_insert_history(
            param_question_id := param_id,
            param_change_type := 'UPDATE all_columns',
            param_change_description := 'UPDATE value of all columns'
        );

        RETURN local_is_successful;
    END;
$udf$;

-- function update is_active
CREATE OR REPLACE FUNCTION user_data.security_question_update_is_active(
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
        UPDATE user_data.security_questions SET
            is_active = param_is_active,
            last_modified_by = param_user_id,
            last_modified_date = CLOCK_TIMESTAMP()
        WHERE
            id = param_id;

        SELECT security_question_insert_history INTO local_is_successful FROM user_data.security_question_insert_history(
            param_question_id := param_id,
            param_change_type := 'UPDATE is_active',
            param_change_description := 'UPDATE value of is_active'
        );

        RETURN local_is_successful;
    END;
$udf$;

-- function update is_active
CREATE OR REPLACE FUNCTION user_data.security_question_update_is_deleted(
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
        UPDATE user_data.security_questions SET
            is_deleted = param_is_deleted,
            last_modified_by = param_user_id,
            last_modified_date = CLOCK_TIMESTAMP()
        WHERE
            id = param_id;

        SELECT security_question_insert_history INTO local_is_successful FROM user_data.security_question_insert_history(
            param_question_id := param_id,
            param_change_type := 'UPDATE is_deleted',
            param_change_description := 'UPDATE value of is_deleted'
        );

        RETURN local_is_successful;
    END;
$udf$;

-- function of user_roles
-- function of insert with rol
CREATE OR REPLACE FUNCTION user_data.user_roles_with_rol_insert(
    param_user_role_id INTEGER,
    param_role_id INTEGER,
    param_user_id INTEGER
)
RETURNS BIT
LANGUAGE plpgsql VOLATILE
COST 100.0
AS $udf$
  DECLARE
      local_is_successful BIT := '0';
      local_user_role_id BIGINT;
    BEGIN
        IF EXISTS
        (
            SELECT
                usrol.user_id
            FROM
                user_data.user_roles usrol
            WHERE
                usrol.role_id = param_role_id
            AND
                usrol.user_id = param_user_role_id
        )
        THEN
            RETURN local_is_successful;
        ELSE
            INSERT INTO user_data.user_roles(
                user_id,
                role_id,
                is_active,
                is_deleted,
                last_modified_by,
                last_modified_date
            )
            VALUES(
                param_user_role_id,
                param_role_id,
                '1',
                '0',
                param_user_id,
                CLOCK_TIMESTAMP()
            )
            RETURNING id
            INTO STRICT local_user_role_id;

            SELECT user_roles_insert_history INTO local_is_successful FROM user_data.user_roles_insert_history(
                param_user_role_id := local_user_role_id,
                param_change_type := 'FIRST INSERT',
                param_change_description := 'FIRST INSERT WITH ROLE'
            );

            RETURN local_is_successful;
        END IF;
    END;
$udf$;

-- function of insert
CREATE OR REPLACE FUNCTION user_data.user_roles_without_rol_insert(
    param_user_role_id INTEGER,
    param_user_id INTEGER
)
RETURNS BIT
LANGUAGE plpgsql VOLATILE
COST 100.0
AS $udf$
  DECLARE
      local_is_successful BIT := '0';
      local_user_role_id BIGINT;
    BEGIN
        IF EXISTS
        (
            SELECT
                usrol.user_id
            FROM
                user_data.user_roles usrol
            WHERE
                usrol.user_id = param_user_role_id
        )
        THEN
            RETURN local_is_successful;
        ELSE
            INSERT INTO user_data.user_roles(
                user_id,
                is_active,
                is_deleted,
                last_modified_by,
                last_modified_date
            )
            VALUES(
                param_user_role_id,
                '0',
                '0',
                param_user_id,
                CLOCK_TIMESTAMP()
            )
            RETURNING id
            INTO STRICT local_user_role_id;

            SELECT user_roles_insert_history INTO local_is_successful FROM user_data.user_roles_insert_history(
                param_user_role_id := local_user_role_id,
                param_change_type := 'FIRST INSERT',
                param_change_description := 'FIRST INSERT WITHOUT ROLE'
            );

            RETURN local_is_successful;
        END IF;
    END;
$udf$;

-- function of insert log
CREATE OR REPLACE FUNCTION user_data.user_roles_insert_history(
    param_user_role_id BIGINT,
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
        INSERT INTO user_data.user_roles_history(
            user_role_id,
            user_id,
            role_id,
            is_active,
            is_deleted,
            last_modified_by,
            last_modified_date,
            change_type,
            change_description
        )
        SELECT
            id,
            user_id,
            role_id,
            is_active,
            is_deleted,
            last_modified_by,
            last_modified_date,
            param_change_type,
            param_change_description
        FROM
            user_data.user_roles usrol
        WHERE
            usrol.id = param_user_role_id
        ORDER BY
            usrol.last_modified_date
        DESC
        LIMIT 1;

        local_is_successful := '1';

        RETURN local_is_successful;
    END;
$udf$;

-- function of get list
CREATE OR REPLACE FUNCTION user_data.get_user_role_list()
RETURNS json
LANGUAGE 'sql'
COST 100.0

AS $BODY$
    SELECT ARRAY_TO_JSON(ARRAY_AGG(ROW_TO_JSON(DATA)))
    FROM (
        SELECT
            usrol.id,
            usr.name,
            rol.description
        FROM
            user_data.user_roles usrol
            LEFT OUTER JOIN user_data.users usr ON
                usrol.user_id = usr.id
            AND
                usr.is_active = '1'
            AND
                usr.is_deleted = '0'
            LEFT OUTER JOIN user_data.roles rol
            ON
                rol.id = usrol.role_id
            AND
                rol.is_active = '1'
            AND
                rol.is_deleted = '0'
        WHERE
            usrol.is_active = '1'
        AND
            usrol.is_deleted = '0'
    )DATA;
$BODY$;

-- function of get list filter rol
CREATE OR REPLACE FUNCTION user_data.get_user_role_filter_rol_list(
param_role_id INTEGER
)
RETURNS json
LANGUAGE 'sql'
COST 100.0

AS $BODY$
    SELECT ARRAY_TO_JSON(ARRAY_AGG(ROW_TO_JSON(DATA)))
    FROM (
        SELECT
            usrol.id,
            usr.name,
            rol.description
        FROM
            user_data.user_roles usrol
            LEFT OUTER JOIN user_data.users usr
            ON
                usr.id = usrol.user_id
            AND
                usr.is_active = '1'
            AND
                usr.is_deleted = '0'
            LEFT OUTER JOIN user_data.roles rol
            ON
                rol.id = usrol.role_id
            AND
                rol.is_active = '1'
            AND
                rol.is_deleted = '0'
        WHERE
            usrol.is_active = '1'
        AND
            usrol.is_deleted = '0'
        AND
            usrol.role_id = param_role_id
    )DATA;
$BODY$;

-- function of get search
CREATE OR REPLACE FUNCTION user_data.get_user_role_search(
param_id INTEGER
)
RETURNS json
LANGUAGE 'sql'
COST 100.0

AS $BODY$
    SELECT ARRAY_TO_JSON(ARRAY_AGG(ROW_TO_JSON(DATA)))
    FROM (
        SELECT
            usrol.id,
            usr.name,
            rol.description
        FROM
            user_data.user_roles usrol
            LEFT OUTER JOIN user_data.users usr
            ON
                usr.id = usrol.user_id
            AND
                usr.is_active = '1'
            AND
                usr.is_deleted = '0'
            LEFT OUTER JOIN user_data.roles rol
            ON
                rol.id = usrol.role_id
            AND
                rol.is_active = '1'
            AND
                rol.is_deleted = '0'
        WHERE
            usrol.is_active = '1'
        AND
            usrol.is_deleted = '0'
        AND
            usrol.id = param_id
    )DATA;
$BODY$;

-- function of get search
CREATE OR REPLACE FUNCTION user_data.get_user_role_user_search(
param_user_id INTEGER
)
RETURNS json
LANGUAGE 'sql'
COST 100.0

AS $BODY$
    SELECT ARRAY_TO_JSON(ARRAY_AGG(ROW_TO_JSON(DATA)))
    FROM (
        SELECT
            usrol.id,
            usr.name,
            rol.description
        FROM
            user_data.user_roles usrol
            LEFT OUTER JOIN user_data.users usr
            ON
                usr.id = usrol.user_id
            AND
                usr.is_active = '1'
            AND
                usr.is_deleted = '0'
            LEFT OUTER JOIN user_data.roles rol
            ON
                rol.id = usrol.role_id
            AND
                rol.is_active = '1'
            AND
                rol.is_deleted = '0'
        WHERE
            usrol.is_active = '1'
        AND
            usrol.is_deleted = '0'
        AND
            usrol.user_id = param_user_id
    )DATA;
$BODY$;

-- function of update all columns
CREATE OR REPLACE FUNCTION user_data.user_rol_update_all_columns(
param_id INTEGER,
param_user_role_id INTEGER,
param_role_id INTEGER,
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
        UPDATE user_data.user_roles SET
            user_id = param_user_role_id,
            role_id = param_role_id,
            is_active = param_is_active,
            is_deleted = param_is_deleted,
            last_modified_by = param_user_id,
            last_modified_date = CLOCK_TIMESTAMP()
        WHERE
            id = param_id;

        SELECT user_roles_insert_history INTO local_is_successful FROM user_data.user_roles_insert_history(
            param_user_role_id := param_id,
            param_change_type := 'UPDATE all_columns',
            param_change_description := 'UPDATE value of all columns'
        );

        RETURN local_is_successful;
    END;
$udf$;

-- function of update role_id
CREATE OR REPLACE FUNCTION user_data.user_rol_update_role(
param_id INTEGER,
param_user_role_id INTEGER,
param_role_id INTEGER,
param_user_id INTEGER
)
RETURNS BIT
LANGUAGE plpgsql VOLATILE
COST 100.0
AS $udf$
  DECLARE
        local_is_successful BIT := '0';
    BEGIN
        UPDATE user_data.user_roles SET
            role_id = param_role_id,
            last_modified_by = param_user_id,
            last_modified_date = CLOCK_TIMESTAMP()
        WHERE
            id = param_id
        AND
            user_id = param_user_role_id;

        SELECT user_roles_insert_history INTO local_is_successful FROM user_data.user_roles_insert_history(
                param_user_role_id := param_id,
                param_change_type := 'UPDATE role_id',
                param_change_description := 'UPDATE value role_id'
        );

        RETURN local_is_successful;
    END;
$udf$;

-- function of update is_active
CREATE OR REPLACE FUNCTION user_data.user_rol_update_role_is_active(
param_id INTEGER,
param_user_role_id INTEGER,
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
        UPDATE user_data.user_roles SET
            is_active = param_is_active,
            last_modified_by = param_user_id,
            last_modified_date = CLOCK_TIMESTAMP()
        WHERE
            id = param_id
        AND
            user_id = param_user_role_id;

        SELECT user_roles_insert_history INTO local_is_successful FROM user_data.user_roles_insert_history(
                param_user_role_id := param_id,
                param_change_type := 'UPDATE is_active',
                param_change_description := 'UPDATE value is_active'
        );

        RETURN local_is_successful;
    END;
$udf$;

-- function of update is_deleted
CREATE OR REPLACE FUNCTION user_data.user_rol_update_is_deleted(
param_id INTEGER,
param_user_role_id INTEGER,
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
        UPDATE user_data.user_roles SET
            is_deleted = param_is_deleted,
            last_modified_by = param_user_id,
            last_modified_date = CLOCK_TIMESTAMP()
        WHERE
            id = param_id
        AND
            user_id = param_user_role_id;

        SELECT user_roles_insert_history INTO local_is_successful FROM user_data.user_roles_insert_history(
                param_user_role_id := param_id,
                param_change_type := 'UPDATE is_deleted',
                param_change_description := 'UPDATE value is_deleted'
        );

        RETURN local_is_successful;
    END;
$udf$;


-- functions of  security_answers
-- function of insert
CREATE OR REPLACE FUNCTION user_data.security_answer_insert(
    param_answer_user_id INTEGER,
    param_user_id INTEGER
)
RETURNS BIT
LANGUAGE plpgsql VOLATILE
COST 100.0
AS $udf$
    DECLARE
        local_is_successful BIT := '0';
        local_security_answer_id BIGINT;
    BEGIN
        IF EXISTS(
            SELECT
                ans.user_id
            FROM
                user_data.security_answers ans
            WHERE
                ans.user_id = param_answer_user_id
            AND
                (
                    ans.is_active = '1'
                OR
                    ans.is_active = '0'
                )
            AND
                ans.is_deleted = '0'
            )
        THEN
            RETURN local_is_successful;
        ELSE
            INSERT INTO user_data.security_answers(
                user_id,
                is_active,
                is_deleted,
                last_modified_by,
                last_modified_date
            )
            VALUES(
                param_answer_user_id,
                '0',
                '0',
                param_user_id,
                CLOCK_TIMESTAMP()
            )
            RETURNING id
            INTO STRICT local_security_answer_id;

            SELECT security_answer_insert_history INTO local_is_successful FROM user_data.security_answer_insert_history(
                param_security_answer_id := local_security_answer_id,
                param_change_type := 'FIRST INSERT',
                param_change_description := 'FIRST INSERT'
            );

            RETURN local_is_successful;

        END IF;
    END;
$udf$;

-- function of insert log
CREATE OR REPLACE FUNCTION user_data.security_answer_insert_history(
    param_security_answer_id BIGINT,
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
        INSERT INTO user_data.security_answers_history(
            security_answer_id,
            user_id,
            question_id,
            answer,
            is_active,
            is_deleted,
            last_modified_by,
            last_modified_date,
            change_type,
            change_description
        )
        SELECT
            id,
            user_id,
            question_id,
            answer,
            is_active,
            is_deleted,
            last_modified_by,
            last_modified_date,
            param_change_type,
            param_change_description
        FROM
            user_data.security_answers ans
        WHERE
            ans.id = param_security_answer_id
        ORDER BY
            last_modified_date
        DESC
        LIMIT 1;

        local_is_successful := '1';

        RETURN local_is_successful;

    END;
$udf$;


-- function of list
CREATE OR REPLACE FUNCTION user_data.get_security_answer_list()
RETURNS json
LANGUAGE 'sql'
COST 100.0

AS $BODY$
    SELECT ARRAY_TO_JSON(ARRAY_AGG(ROW_TO_JSON(DATA)))
    FROM (
        SELECT
            ans.id,
            usr.name,
            qt.description
        FROM
            user_data.security_answers ans
            LEFT OUTER JOIN
                user_data.users usr ON
                    usr.id = ans.user_id
                AND
                    usr.is_active = '1'
                AND
                    usr.is_deleted = '0'
            LEFT OUTER JOIN
                user_data.security_questions qt ON
                    qt.id = ans.question_id
                AND
                    qt.is_active = '1'
                AND
                    qt.is_deleted = '0'
        WHERE
            ans.is_active = '1'
        AND
            ans.is_deleted = '0'
    )DATA;
$BODY$;

-- function of list filter question
CREATE OR REPLACE FUNCTION user_data.get_security_answer_filter_question_list(
    param_question_id INTEGER
)
RETURNS json
LANGUAGE 'sql'
COST 100.0

AS $BODY$
    SELECT ARRAY_TO_JSON(ARRAY_AGG(ROW_TO_JSON(DATA)))
    FROM (
        SELECT
            ans.id,
            usr.name,
            qt.description
        FROM
            user_data.security_answers ans
            LEFT OUTER JOIN
                user_data.users usr ON
                    usr.id = ans.user_id
                AND
                    usr.is_active = '1'
                AND
                    usr.is_deleted = '0'
            LEFT OUTER JOIN
                user_data.security_questions qt ON
                    qt.id = ans.question_id
                AND
                    qt.is_active = '1'
                AND
                    qt.is_deleted = '0'
        WHERE
            ans.is_active = '1'
        AND
            ans.is_deleted = '0'
        AND
            ans.question_id = param_question_id
    )DATA;
$BODY$;

-- function of  search filter user
CREATE OR REPLACE FUNCTION user_data.get_security_answer_filter_user_search(
    param_user_id INTEGER
)
RETURNS json
LANGUAGE 'sql'
COST 100.0

AS $BODY$
    SELECT ARRAY_TO_JSON(ARRAY_AGG(ROW_TO_JSON(DATA)))
    FROM (
        SELECT
            ans.id,
            usr.name,
            qt.description
        FROM
            user_data.security_answers ans
            LEFT OUTER JOIN
                user_data.users usr ON
                    usr.id = ans.user_id
                AND
                    usr.is_active = '1'
                AND
                    usr.is_deleted = '0'
            LEFT OUTER JOIN
                user_data.security_questions qt ON
                    qt.id = ans.question_id
                AND
                    qt.is_active = '1'
                AND
                    qt.is_deleted = '0'
        WHERE
            ans.is_active = '1'
        AND
            ans.is_deleted = '0'
        AND
            ans.user_id = param_user_id
    )DATA;
$BODY$;

-- function of  search
CREATE OR REPLACE FUNCTION user_data.get_security_answer_search(
    param_id INTEGER
)
RETURNS json
LANGUAGE 'sql'
COST 100.0

AS $BODY$
    SELECT ARRAY_TO_JSON(ARRAY_AGG(ROW_TO_JSON(DATA)))
    FROM (
        SELECT
            ans.id,
            usr.name,
            qt.description
        FROM
            user_data.security_answers ans
            LEFT OUTER JOIN
                user_data.users usr ON
                    usr.id = ans.user_id
                AND
                    usr.is_active = '1'
                AND
                    usr.is_deleted = '0'
            LEFT OUTER JOIN
                user_data.security_questions qt ON
                    qt.id = ans.question_id
                AND
                    qt.is_active = '1'
                AND
                    qt.is_deleted = '0'
        WHERE
            ans.is_active = '1'
        AND
            ans.is_deleted = '0'
        AND
            ans.id = param_id
    )DATA;
$BODY$;

-- function of update all columns
CREATE OR REPLACE FUNCTION user_data.security_answer_update_all_columns(
    param_id INTEGER,
    param_answer_user_id INTEGER,
    param_question_id  INTEGER,
    param_answer VARCHAR,
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
        UPDATE user_data.security_answers SET
            user_id = param_answer_user_id,
            question_id = param_question_id,
            answer = param_answer,
            is_active = param_is_active,
            is_deleted = param_is_deleted,
            last_modified_by = param_user_id,
            last_modified_date = CLOCK_TIMESTAMP()
        WHERE
            id = param_id;

        SELECT security_answer_insert_history INTO local_is_successful FROM user_data.security_answer_insert_history(
            param_security_answer_id := param_id,
            param_change_type := 'UPDATE all_columns',
            param_change_description := 'UPDATE value of all columns'
        );

        RETURN local_is_successful;
    END;
$udf$;

-- function of update all columns
CREATE OR REPLACE FUNCTION user_data.security_answer_update_answer(
    param_id INTEGER,
    param_answer_user_id INTEGER,
    param_question_id  INTEGER,
    param_answer VARCHAR,
    param_user_id INTEGER
)
RETURNS BIT
LANGUAGE plpgsql VOLATILE
COST 100.0
AS $udf$
    DECLARE
        local_is_successful BIT := '0';
    BEGIN
        UPDATE user_data.security_answers SET
            question_id = param_question_id,
            answer = param_answer,
            is_active = '1',
            last_modified_by = param_user_id,
            last_modified_date = CLOCK_TIMESTAMP()
        WHERE
            id = param_id
        AND
            user_id = param_answer_user_id;

        SELECT security_answer_insert_history INTO local_is_successful FROM user_data.security_answer_insert_history(
            param_security_answer_id := param_id,
            param_change_type := 'UPDATE answer',
            param_change_description := 'UPDATE value of answer'
        );

        RETURN local_is_successful;
    END;
$udf$;

-- function of update all columns
CREATE OR REPLACE FUNCTION user_data.security_answer_update_is_active(
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
        UPDATE user_data.security_answers SET
            is_active = param_is_active,
            last_modified_by = param_user_id,
            last_modified_date = CLOCK_TIMESTAMP()
        WHERE
            id = param_id;

        SELECT security_answer_insert_history INTO local_is_successful FROM user_data.security_answer_insert_history(
            param_security_answer_id := param_id,
            param_change_type := 'UPDATE is_active',
            param_change_description := 'UPDATE value of is_active'
        );

        RETURN local_is_successful;
    END;
$udf$;

-- function of update all columns
CREATE OR REPLACE FUNCTION user_data.security_answer_update_is_deleted(
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
        UPDATE user_data.security_answers SET
            is_deleted = param_is_deleted,
            last_modified_by = param_user_id,
            last_modified_date = CLOCK_TIMESTAMP()
        WHERE
            id = param_id;

        SELECT security_answer_insert_history INTO local_is_successful FROM user_data.security_answer_insert_history(
            param_security_answer_id := param_id,
            param_change_type := 'UPDATE is_deleted',
            param_change_description := 'UPDATE value of is_deleted'
        );

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
  param_school_id INTEGER,
  param_institute_id INTEGER,
  param_coordination_id INTEGER
)
RETURNS BIT
LANGUAGE plpgsql VOLATILE
COST 100.0
AS $udf$
  DECLARE
	  local_is_successful BIT := '0';
      local_user_id INTEGER;
      param_user_id INTEGER := 0;
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
          school_id,
          institute_id,
          coordination_id,
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
          param_ubication_id,
          param_school_id,
          param_institute_id,
          param_coordination_id,
    			'0',
    			'0',
    			param_user_id,
    			CLOCK_TIMESTAMP(),
    			CLOCK_TIMESTAMP()
    		)
            RETURNING id
            INTO STRICT local_user_id;

            PERFORM user_data.user_roles_without_rol_insert(local_user_id, local_user_id);

            PERFORM user_data.security_answer_insert(local_user_id, local_user_id);

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
  param_role_user_id INTEGER,
	param_user_id INTEGER,
  param_school_id INTEGER,
  param_institute_id INTEGER,
  param_coordination_id INTEGER
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
          school_id,
          institute_id,
          coordination_id,
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
          param_ubication_id,
          param_school_id,
          param_institute_id,
          param_coordination_id,
    			'1',
    			'0',
    			param_user_id,
    			CLOCK_TIMESTAMP(),
    			CLOCK_TIMESTAMP()
    		)
            RETURNING id
            INTO STRICT local_user_id;

            PERFORM user_data.user_roles_with_rol_insert(local_user_id, param_role_id, param_user_id);

            PERFORM user_data.security_answer_insert(local_user_id, param_user_id);

            SELECT user_insert_history INTO local_is_successful FROM user_data.user_insert_history(
                param_user_id := local_user_id,
                param_change_type := 'FIRST INSERT',
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

CREATE OR REPLACE FUNCTION user_data.login_user(
  param_email VARCHAR
)
RETURNS json
LANGUAGE 'sql'
COST 100.0

AS $BODY$
    SELECT ROW_TO_JSON(DATA)
    FROM (
      SELECT
        usr.id,
        usr.name||' '||usr.surname as name,
        usr.email,
        json_build_object('id',usr.ubication_id,'description', ub.name) as ubication,
        usr.password,
        usr.is_active,
        usr.is_deleted,
        json_build_object('id',usrol.role_id, 'description', COALESCE(rol.description,'')) as rol,
        usr.school_id,
        usr.institute_id,
        usr.coordination_id,
        exe.description as ubication_user,
        json_build_object('id', COALESCE(ans.question_id, 0),'description',  qt.description)  as question,
        json_build_object('id',ans.id,'description', COALESCE(ans.answer,'')) as answer
      FROM
        user_data.users usr
      INNER JOIN
          user_data.user_roles  usrol
      ON
              usr.email = param_email
          AND
              usrol.user_id = usr.id
          AND
              usrol.is_deleted = '0'
       LEFT OUTER JOIN
              user_data.roles rol
          ON
                  rol.id = usrol.role_id
              AND
                  rol.is_active = '1'
              AND
                  rol.is_deleted = '0'
      INNER JOIN
  	user_data.ubications ub
      ON
  	ub.id = usr.ubication_id
  	AND
              ub.is_active = '1'
          AND
              ub.is_deleted = '0'
      LEFT OUTER JOIN
  	   faculty_data.schools schl
      ON
            schl.id = usr.school_id
           AND schl.is_active = '1'
                  AND schl.is_deleted = '0'
        LEFT OUTER JOIN
  	faculty_data.institutes inst
          ON
              inst.id = usr.institute_id
             AND inst.is_active = '1'
                  AND inst.is_deleted = '0'
         LEFT OUTER JOIN
  	faculty_data.coordinations cord
          ON
              cord.id = usr.coordination_id
             AND cord.is_active = '1'
                  AND cord.is_deleted = '0'
        INNER JOIN
					employee_data.execunting_unit exe
				ON
							 (
                  exe.code = schl.code
                OR
                  exe.code = inst.code
                OR
                  exe.code = cord.code
               )
					AND
							exe.is_deleted = '0'
					AND
							exe.is_active = '1'
          INNER JOIN
          user_data.security_answers ans
      ON
              ans.user_id = usr.id
          AND
              ans.is_deleted = '0'
          LEFT OUTER JOIN
              user_data.security_questions qt
          ON
                  qt.id = ans.question_id
              AND
                  qt.is_active = '1'
              AND
                  qt.is_deleted = '0'
    )DATA;
$BODY$;

CREATE OR REPLACE FUNCTION user_data.get_user_validate_list()
RETURNS json
LANGUAGE 'sql'
COST 100.0
AS $BODY$
  SELECT ARRAY_TO_JSON(ARRAY_AGG(ROW_TO_JSON(DATA)))
  FROM (
      SELECT
        us.id,
        us.name||' '||us.surname as name,
        us.email,
        json_build_object('id',us.ubication_id,'description', ub.name) as ubication,
        us.is_active,
        us.is_deleted,
        usrol.id as user_role_id
      FROM
        user_data.users us
      INNER JOIN
	       user_data.ubications ub
	    ON
            us.is_active = '0'
        AND
            us.is_deleted = '0'
        AND
            us.ubication_id = ub.id
        AND
            ub.is_active = '1'
        AND
            ub.is_deleted = '0'
      INNER JOIN
          user_data.user_roles usrol
      ON
          usrol.user_id = us.id
        AND
          usrol.is_active = '1'
        AND
          usrol.is_deleted = '0'
    )DATA;
$BODY$;

CREATE OR REPLACE FUNCTION user_data.get_user_list()
RETURNS json
LANGUAGE 'sql'
COST 100.0
AS $BODY$
  SELECT ARRAY_TO_JSON(ARRAY_AGG(ROW_TO_JSON(DATA)))
  FROM (
      SELECT
        us.id,
        us.name||' '||us.surname as name,
        us.email,
        json_build_object('id',us.ubication_id,'description', ub.name) as ubication,
        json_build_object('id',usrol.role_id, 'description', rol.description) as rol,
        us.is_active,
        us.is_deleted,
        usrol.id as user_role_id
      FROM
        user_data.users us
      INNER JOIN
	       user_data.ubications ub
	    ON
            us.is_active = '1'
        AND
            us.is_deleted = '0'
        AND
            us.ubication_id = ub.id
        AND
            ub.is_active = '1'
        AND
            ub.is_deleted = '0'
        INNER JOIN
            user_data.user_roles usrol
        ON
            usrol.user_id = us.id
          AND
            usrol.is_active = '1'
          AND
            usrol.is_deleted = '0'
          INNER JOIN
            user_data.roles rol
          ON
              usrol.role_id = rol.id
            AND
             rol.is_active = '0'
            AND
              rol.is_deleted = '0'
    )DATA;
$BODY$;

-- get user
CREATE OR REPLACE FUNCTION user_data.get_user(
  param_id INTEGER
)
RETURNS json
LANGUAGE 'sql'
COST 100.0
AS $BODY$
SELECT ROW_TO_JSON(DATA)
FROM (
  SELECT
    usr.id,
    usr.name||' '||usr.surname as name,
    usr.email,
    json_build_object('id',usr.ubication_id,'description', ub.name) as ubication,
    usr.password,
    usr.is_active,
    usr.is_deleted,
    json_build_object('id',usrol.role_id, 'description', COALESCE(rol.description,'')) as rol,
    usr.school_id,
    usr.institute_id,
    usr.coordination_id,
    exe.description as ubication_user
  FROM
    user_data.users usr
  INNER JOIN
      user_data.user_roles  usrol
  ON
          usr.id = param_id
      AND
          usrol.user_id = usr.id
   LEFT OUTER JOIN
          user_data.roles rol
      ON
          rol.id = usrol.role_id
  INNER JOIN
    user_data.ubications ub
  ON
    ub.id = usr.ubication_id
    AND
          ub.is_active = '1'
      AND
          ub.is_deleted = '0'
  LEFT OUTER JOIN
   faculty_data.schools schl
  ON
        schl.id = usr.school_id
       AND schl.is_active = '1'
              AND schl.is_deleted = '0'
    LEFT OUTER JOIN
faculty_data.institutes inst
      ON
          inst.id = usr.institute_id
         AND inst.is_active = '1'
              AND inst.is_deleted = '0'
     LEFT OUTER JOIN
faculty_data.coordinations cord
      ON
          cord.id = usr.coordination_id
         AND cord.is_active = '1'
              AND cord.is_deleted = '0'
    INNER JOIN
      employee_data.execunting_unit exe
    ON
           (
              exe.code = schl.code
            OR
              exe.code = inst.code
            OR
              exe.code = cord.code
           )
      AND
          exe.is_deleted = '0'
      AND
          exe.is_active = '1'
)DATA;
$BODY$;

-- update user Validate
CREATE OR REPLACE FUNCTION user_data.user_update_by_validate(
  param_id INTEGER,
  param_role_user_id INTEGER,
  param_role_id INTEGER,
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
      local_security_answer_id BIGINT;
  BEGIN
    UPDATE user_data.users SET
      is_active = param_is_active,
      is_deleted = param_is_deleted,
      last_modified_by = param_user_id,
      last_modified_date = CLOCK_TIMESTAMP()
    WHERE
      id = param_id;

    PERFORM  user_data.user_rol_update_role_is_active(param_role_user_id, param_id, param_is_active, param_user_id);

    iF(param_is_deleted = '1' AND param_role_id = 0)
    THEN
      PERFORM user_data.user_rol_update_is_deleted(param_role_user_id, param_id, param_is_deleted, param_user_id);
    ELSE
      PERFORM user_data.user_rol_update_role(param_role_user_id,param_id, param_role_id, param_user_id);
    END IF;

    IF (param_is_active = '0' AND  param_is_deleted = '1')
    THEN
      UPDATE user_data.security_answers SET
        is_active = param_is_active,
        is_deleted = param_is_deleted,
        last_modified_by = param_user_id,
        last_modified_date = CLOCK_TIMESTAMP()
      WHERE
        user_id = param_id
        RETURNING id
        INTO STRICT local_security_answer_id;

      PERFORM user_data.security_answer_insert_history(
      param_security_answer_id := local_security_answer_id,
      param_change_type := 'UPDATE is_deleted',
      param_change_description := 'UPDATE value of is_deleted');
    END IF;

    SELECT user_insert_history INTO local_is_successful FROM user_data.user_insert_history(
        param_user_id := param_id,
        param_change_type := 'UPDATE IS VALIDATE',
        param_change_description := 'UPDATE VALUE IS VALIDATE'
    );

    RETURN local_is_successful;
    END;
$udf$;
