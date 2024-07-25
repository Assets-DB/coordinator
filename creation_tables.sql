DROP TYPE IF EXISTS "gender_options";
CREATE TYPE "gender_options" AS ENUM (
  'm',
  'f',
  'M',
  'F'
);


-----------------------------------------------------------------------------------------------
-- CLIENT
-----------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS "client" CASCADE;
CREATE TABLE "client" (
    "client_id"     INTEGER generated ALWAYS as IDENTITY PRIMARY KEY,
    "client_fk"     INTEGER         REFERENCES "client"(client_id),
    "mongo_id"      TEXT            NOT NULL UNIQUE,
    "name"          VARCHAR(100)    NOT NULL,
    "last_name"     VARCHAR(100)    NOT NULL,
    "profile"       VARCHAR(100) 	NOT NULL UNIQUE,
    "deleted_at"    TIMESTAMP,
    "created_at"    TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at"    TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP
);


-----------------------------------------------------------------------------------------------
-- COMPAÑY
-----------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS "company" CASCADE;
CREATE TABLE "company" (
  "company_id" 	INTEGER generated ALWAYS as IDENTITY PRIMARY KEY,
  "client_fk"   INTEGER 		  NOT NULL REFERENCES "client"(client_id),
  "name" 		VARCHAR(100) 	  NOT NULL,
  "cuit" 		VARCHAR(20),
  "note" 		TEXT,
  "updated_by"  INTEGER 		  NOT NULL REFERENCES "client"(client_id),
  "deleted_at"  TIMESTAMP,
  "created_at" 	TIMESTAMP 		  NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updated_at" 	TIMESTAMP 		  NOT NULL DEFAULT CURRENT_TIMESTAMP
);


-----------------------------------------------------------------------------------------------
-- PATIENT
-----------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS "patient" CASCADE;
CREATE TABLE "patient" (
    "patient_id"            INTEGER generated ALWAYS as IDENTITY PRIMARY KEY,
    "client_fk"             INTEGER         NOT NULL REFERENCES "client"(client_id),
    "company_fk"            INTEGER         NOT NULL REFERENCES company(company_id),
    "name"                  VARCHAR(100)    NOT NULL,
    "last_name"             VARCHAR(100)    NOT NULL,
    "healthcare_provider"   VARCHAR(100),
    "gender"                gender_options  NOT NULL,
    "age"                   SMALLINT,
    "phone"                 VARCHAR(30),
    "note"                  TEXT,
    "updated_by"            INTEGER 		NOT NULL REFERENCES "client"(client_id),
    "deleted_at"            TIMESTAMP,
    "created_at"            TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at"            TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CHECK(age >= 0 AND age <= 85)

);


-----------------------------------------------------------------------------------------------
-- TREATMENT
-----------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS "treatment" CASCADE;
CREATE TABLE "treatment" (
  "treatment_id" 	INTEGER generated ALWAYS as IDENTITY PRIMARY KEY,
  "client_fk" 		INTEGER         NOT NULL REFERENCES "client"(client_id),
  "name"            VARCHAR(100)    NOT NULL,
  "abbreviation" 	VARCHAR(10) 	NOT NULL,
  "description" 	TEXT,
  "updated_by"      INTEGER 		NOT NULL REFERENCES "client"(client_id),
  "deleted_at"      TIMESTAMP,
  "created_at" 		TIMESTAMP 		NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updated_at" 		TIMESTAMP 		NOT NULL DEFAULT CURRENT_TIMESTAMP
);


-----------------------------------------------------------------------------------------------
-- COMPANY_HAS_TREATMENT
-----------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS "company_has_treatment" CASCADE;
CREATE TABLE "company_has_treatment" (
    "client_fk"     INTEGER         NOT NULL REFERENCES "client"(client_id),
    "company_fk"    INTEGER         NOT NULL REFERENCES company(company_id),
    "treatment_fk"  INTEGER         NOT NULL REFERENCES treatment(treatment_id),
    "value"         DECIMAL(7,2)    NOT NULL,
    "updated_by"    INTEGER 		NOT NULL REFERENCES "client"(client_id),
    "created_at"    TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at"    TIMESTAMP 		NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY ("client_fk", "company_fk", "treatment_fk"),

    CHECK ("value" >= 0)
);


-----------------------------------------------------------------------------------------------
-- TREATMENT_HAS_PROFESSIONAL
-----------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS "treatment_has_professional" CASCADE;
CREATE TABLE "treatment_has_professional" (
    "client_fk"         INTEGER         NOT NULL REFERENCES "client"(client_id),
    "professional_fk"   INTEGER         NOT NULL,
    "company_fk"        INTEGER         NOT NULL REFERENCES company(company_id),
    "treatment_fk"      INTEGER         NOT NULL REFERENCES treatment(treatment_id),
    "value"             DECIMAL(7,2)    NOT NULL,
    "updated_by"        INTEGER 		NOT NULL REFERENCES "client"(client_id),
    "created_at"        TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at"        TIMESTAMP 		NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY ("client_fk", "professional_fk", "company_fk", "treatment_fk"),

    CHECK ("value" >= 0)
);