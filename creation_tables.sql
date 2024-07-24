DROP TYPE IF EXISTS "user_types";
CREATE TYPE "user_types" AS ENUM (
  'client',
  'clientAdmin'
);

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
    "gender"        gender_options  NOT NULL,
    "deleted_at"    TIMESTAMP,
    "created_at"    TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at"    TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP

    -- Verifica que el registro tenga al menos el phone o el email
    CHECK (email IS NOT NULL OR phone IS NOT NULL)
    -- Valida formato
    CHECK (email <> '')
    -- CHECK (phone ~ '^(?:(?:00)?549?)?0?(?:11|[2368]\d)(?:(?=\d{0,2}15)\d{2})??\d{8}$' OR phone IS NULL)
);

DROP INDEX IF EXISTS unique_email_exclude_empty;
CREATE UNIQUE INDEX unique_email_exclude_empty ON "client" ((CASE WHEN email IS NOT NULL THEN email END));

DROP INDEX IF EXISTS unique_phone_exclude_empty;
CREATE UNIQUE INDEX unique_phone_exclude_empty ON "client" ((CASE WHEN phone IS NOT NULL THEN phone END));


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

    -- CHECK (phone ~ '^(?:(?:00)?549?)?0?(?:11|[2368]\d)(?:(?=\d{0,2}15)\d{2})??\d{8}$')

    /*
    Toma como opcionales:
    el prefijo internacional (54)
    el prefijo internacional para celulares (9)
    el prefijo de acceso a interurbanas (0)
    el prefijo local para celulares (15)
    Es obligatorio:
    el código de área (11, 2xx, 2xxx, 3xx, 3xxx, 6xx y 8xx)
    (no toma como válido un número local sin código de área como 4444-0000)
    */
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