-- Hospital Database Design. Generated SQL queries from the ERD

BEGIN;


CREATE TABLE IF NOT EXISTS public.affiliated_with
(
    physician integer,
    department integer,
    primaryaffiliation boolean
);

CREATE TABLE IF NOT EXISTS public.appointment
(
    appointment_id integer,
    patient integer,
    prepnurse integer,
    physician integer,
    start_dt_time timestamp without time zone,
    end_dt_time timestamp without time zone,
    examinationroom integer
);

CREATE TABLE IF NOT EXISTS public.block
(
    floor integer NOT NULL,
    code integer NOT NULL,
    PRIMARY KEY (floor, code)
);

CREATE TABLE IF NOT EXISTS public.department
(
    dept_id integer NOT NULL,
    name character varying(100),
    head integer,
    PRIMARY KEY (dept_id)
);

CREATE TABLE IF NOT EXISTS public.medication
(
    code integer,
    name character varying(100),
    brand character varying(100),
    description character varying(500)
);

CREATE TABLE IF NOT EXISTS public.nurse
(
    emp_id integer NOT NULL,
    name character varying(100),
    "position" character varying(100),
    registered boolean,
    ssn integer,
    PRIMARY KEY (emp_id)
);

CREATE TABLE IF NOT EXISTS public.on_call
(
    nurse integer,
    blockfloor integer NOT NULL,
    blockcode integer NOT NULL,
    oncallstart date NOT NULL,
    oncallend date NOT NULL
);

CREATE TABLE IF NOT EXISTS public.patient
(
    ssn integer NOT NULL,
    name character varying(100),
    address character varying(500),
    phone character varying(20),
    insuranceid integer,
    pcp integer,
    PRIMARY KEY (ssn)
);

CREATE TABLE IF NOT EXISTS public.physician
(
    employeeid integer NOT NULL,
    name character varying(100) NOT NULL,
    designation character varying(100),
    ssn integer,
    PRIMARY KEY (employeeid)
);

CREATE TABLE IF NOT EXISTS public.prescribes
(
    physician integer,
    patient integer,
    medication integer,
    date timestamp without time zone,
    appointment integer,
    dose character varying(10)
);

CREATE TABLE IF NOT EXISTS public.procedure
(
    code integer NOT NULL,
    name character varying(200),
    cost double precision,
    PRIMARY KEY (code)
);

CREATE TABLE IF NOT EXISTS public.room
(
    roomno integer,
    roomtype character varying(50),
    blockfloor integer NOT NULL,
    blockcode integer NOT NULL,
    unavailable boolean
);

CREATE TABLE IF NOT EXISTS public.stay
(
    stayid integer NOT NULL,
    patient integer,
    room integer,
    start_time timestamp without time zone NOT NULL,
    end_time timestamp without time zone NOT NULL,
    PRIMARY KEY (stayid)
);

CREATE TABLE IF NOT EXISTS public.trained_in
(
    physician integer,
    treatment integer,
    certificationdate date,
    certificationexpires date
);

CREATE TABLE IF NOT EXISTS public.undergoes
(
    patient integer,
    procedure integer,
    stay integer,
    date timestamp without time zone NOT NULL,
    physician integer,
    assistingnurse integer
);

ALTER TABLE public.affiliated_with
    ADD FOREIGN KEY (department)
    REFERENCES public.department (dept_id)
    NOT VALID;


ALTER TABLE public.affiliated_with
    ADD FOREIGN KEY (physician)
    REFERENCES public.physician (employeeid)
    NOT VALID;


ALTER TABLE public.appointment
    ADD FOREIGN KEY (patient)
    REFERENCES public.patient (ssn)
    NOT VALID;


ALTER TABLE public.appointment
    ADD FOREIGN KEY (physician)
    REFERENCES public.physician (employeeid)
    NOT VALID;


ALTER TABLE public.appointment
    ADD FOREIGN KEY (prepnurse)
    REFERENCES public.nurse (emp_id)
    NOT VALID;


ALTER TABLE public.department
    ADD FOREIGN KEY (head)
    REFERENCES public.physician (employeeid)
    NOT VALID;


ALTER TABLE public.on_call
    ADD FOREIGN KEY (blockcode)
    REFERENCES public.block (code)
    NOT VALID;


ALTER TABLE public.on_call
    ADD FOREIGN KEY (nurse)
    REFERENCES public.nurse (emp_id)
    NOT VALID;


ALTER TABLE public.patient
    ADD FOREIGN KEY (pcp)
    REFERENCES public.physician (employeeid)
    NOT VALID;


ALTER TABLE public.prescribes
    ADD FOREIGN KEY (appointment)
    REFERENCES public.appointment (appointment_id)
    NOT VALID;


ALTER TABLE public.prescribes
    ADD FOREIGN KEY (medication)
    REFERENCES public.medication (code)
    NOT VALID;


ALTER TABLE public.prescribes
    ADD FOREIGN KEY (patient)
    REFERENCES public.patient (ssn)
    NOT VALID;


ALTER TABLE public.prescribes
    ADD FOREIGN KEY (physician)
    REFERENCES public.physician (employeeid)
    NOT VALID;


ALTER TABLE public.room
    ADD FOREIGN KEY (blockcode)
    REFERENCES public.block (code)
    NOT VALID;


ALTER TABLE public.stay
    ADD FOREIGN KEY (patient)
    REFERENCES public.patient (ssn)
    NOT VALID;


ALTER TABLE public.stay
    ADD FOREIGN KEY (room)
    REFERENCES public.room (roomno)
    NOT VALID;


ALTER TABLE public.trained_in
    ADD FOREIGN KEY (physician)
    REFERENCES public.physician (employeeid)
    NOT VALID;


ALTER TABLE public.trained_in
    ADD FOREIGN KEY (treatment)
    REFERENCES public.procedure (code)
    NOT VALID;


ALTER TABLE public.undergoes
    ADD FOREIGN KEY (assistingnurse)
    REFERENCES public.nurse (emp_id)
    NOT VALID;


ALTER TABLE public.undergoes
    ADD FOREIGN KEY (patient)
    REFERENCES public.patient (ssn)
    NOT VALID;


ALTER TABLE public.undergoes
    ADD FOREIGN KEY (physician)
    REFERENCES public.physician (employeeid)
    NOT VALID;


ALTER TABLE public.undergoes
    ADD FOREIGN KEY (procedure)
    REFERENCES public.procedure (code)
    NOT VALID;


ALTER TABLE public.undergoes
    ADD FOREIGN KEY (stay)
    REFERENCES public.stay (stayid)
    NOT VALID;

END;