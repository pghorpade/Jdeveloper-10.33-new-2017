CREATE SEQUENCE id_seq 
    START WITH  1
    INCREMENT BY  1
    NOCACHE
    NOCYCLE;


CREATE TABLE jobs (
    id INT,
    appid VARCHAR2(256),
    description VARCHAR2(2000),
    classname VARCHAR2(128),
    state INT,
    loglevel VARCHAR2(64),
    threshold INT,
    retry INT,
    lasttimeout VARCHAR2(24),
    data LONG RAW,
    CONSTRAINT id_pk PRIMARY KEY (id));

CREATE INDEX jobs_appid_ix on jobs(appid);
CREATE INDEX jobs_id_ix on jobs(id,appid);
CREATE INDEX description_ix on jobs(description,appid);
CREATE INDEX state_ix on jobs(state,appid);
CREATE INDEX description_state_ix on jobs(description,state,appid);


CREATE TABLE listeners (
    id CONSTRAINT id_fk REFERENCES jobs(id),
    classname VARCHAR2(2000),
    CONSTRAINT id_class_pk PRIMARY KEY (id,classname));

CREATE INDEX listeners_id_ix on listeners(id);


CREATE TABLE blackouts (
    name VARCHAR2(2000),
    appid VARCHAR2(256),
    data LONG RAW,
    CONSTRAINT name_pk PRIMARY KEY (name, appid));

CREATE INDEX blackouts_appid_ix on blackouts(appid);
