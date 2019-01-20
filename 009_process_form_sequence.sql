CREATE SCHEMA process_form;

  CREATE SEQUENCE process_form.process_movement_personal_form_seq
    START WITH 1
    INCREMENT BY 1
    MINVALUE 0
    NO MAXVALUE
    CACHE 1;

  CREATE SEQUENCE process_form.process_official_form_seq
    START WITH 1
    INCREMENT BY 1
    MINVALUE 0
    NO MAXVALUE
    CACHE 1;

  CREATE SEQUENCE process_form.status_process_form_seq
    START WITH 1
    INCREMENT BY 1
    MINVALUE 0
    NO MAXVALUE
    CACHE 1;

-- seq history
  CREATE SEQUENCE process_form.process_movement_personal_form_history_seq
    START WITH 1
    INCREMENT BY 1
    MINVALUE 0
    NO MAXVALUE
    CACHE 1;

  CREATE SEQUENCE process_form.process_official_form_history_seq
    START WITH 1
    INCREMENT BY 1
    MINVALUE 0
    NO MAXVALUE
    CACHE 1;

  CREATE SEQUENCE process_form.status_process_form_history_seq
    START WITH 1
    INCREMENT BY 1
    MINVALUE 0
    NO MAXVALUE
    CACHE 1;
