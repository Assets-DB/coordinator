# Diagrama de Entidad-Relación (DER)
![alt text](./der/coordinator_der.png)

# Estructura de la Base de Datos

## Tabla "client"

### Estructura
La tabla "client" tiene la siguiente estructura:

| Columna       | Tipo                | Restricciones                     |
|---------------|---------------------|-----------------------------------|
| `client_id`   | **PRIMARY KEY**     |                                   |
| `client_fk`   | **FOREIGN KEY**     | REFERENCES "client"(client_id)    |
| `name`        | **VARCHAR(100)**    | NOT NULL                          |
| `last_name`   | **VARCHAR(100)**    | NOT NULL                          |
| `profile`     | **VARCHAR(100)**    | NOT NULL UNIQUE                   |
| `phone`       | **VARCHAR(30)**     |                                   |
| `email`       | **VARCHAR(255)**    |                                   |
| `password`    | **VARCHAR(255)**    | NOT NULL                          |
| `gender`      | **gender_options**  | NOT NULL                          |
| `user_type`   | **user_types[]**    | NOT NULL                          |
| `deleted_at`  | **TIMESTAMP**       |                                   |
| `created_at`  | **TIMESTAMP**       | NOT NULL DEFAULT CURRENT_TI       |
| `updated_at`  | **TIMESTAMP**       | NOT NULL DEFAULT CURRENT_TI       |

| Índice Único                                                            |
|-------------------------------------------------------------------------|
| `UNIQUE INDEX ((CASE WHEN email IS NOT NULL THEN email END))`           |
| `UNIQUE INDEX ((CASE WHEN phone IS NOT NULL THEN phone END))`           |

### Descripción
[COMPLETAR_DESCRIPCION]

***

## Tabla "company"

### Estructura
La tabla "company" tiene la siguiente estructura:

| Columna        | Tipo              | Restricciones                                    |
|----------------|-------------------|--------------------------------------------------|
| `company_id`   | **PRIMARY KEY**   |                                                  |
| `client_fk`    | **FOREIGN KEY**   | NOT NULL REFERENCES client(client_id)            |
| `name`         | **VARCHAR(100)**  | NOT NULL                                         |
| `cuit`         | **VARCHAR(20)**   |                                                  |
| `note`         | **TEXT**          |                                                  |
| `updated_by`   | **FOREIGN KEY**   | NOT NULL REFERENCES client(client_id)            |
| `deleted_at`   | **TIMESTAMP**     |                                                  |
| `created_at`   | **TIMESTAMP**     | NOT NULL DEFAULT CURRENT_TIMESTAMP               |
| `updated_at`   | **TIMESTAMP**     | NOT NULL DEFAULT CURRENT_TIMESTAMP               |

### Descripción
[COMPLETAR_DESCRIPCION]

***

## Tabla "patient"

### Estructura
La tabla "patient" tiene la siguiente estructura:

| Columna              | Tipo                  | Restricciones                              |
|----------------------|-----------------------|--------------------------------------------|
| `patient_id`         | **PRIMARY KEY**       |                                            |
| `client_fk`          | **FOREIGN KEY**       | NOT NULL REFERENCES client(client_id)      |
| `company_fk`         | **FOREIGN KEY**       | NOT NULL REFERENCES company(company_id)    |
| `name`               | **VARCHAR(100)**      | NOT NULL                                   |
| `last_name`          | **VARCHAR(100)**      | NOT NULL                                   |
| `healthcare_provider`| **VARCHAR(100)**      |                                            |
| `gender`             | **gender_options**    | NOT NULL                                   |
| `age`                | **SMALLINT**          |                                            |
| `phone`              | **VARCHAR(30)**       |                                            |
| `note`               | **TEXT**              |                                            |
| `updated_by`         | **FOREIGN KEY**       | NOT NULL REFERENCES client(client_id)      |
| `deleted_at`         | **TIMESTAMP**         |                                            |
| `created_at`         | **TIMESTAMP**         | NOT NULL DEFAULT CURRENT_TIMESTAMP         |
| `updated_at`         | **TIMESTAMP**         | NOT NULL DEFAULT CURRENT_TIMESTAMP         |

### Descripción
[COMPLETAR_DESCRIPCION]

***

## Tabla "treatment"

### Estructura
La tabla "treatment" tiene la siguiente estructura:

| Columna         | Tipo              | Restricciones                                  |
|-----------------|-------------------|------------------------------------------------|
| `treatment_id`  | **PRIMARY KEY**   |                                                |
| `client_fk`     | **FOREIGN KEY**   | NOT NULL REFERENCES client(client_id)          |
| `name`          | **VARCHAR(100)**  | NOT NULL                                       |
| `abbreviation`  | **VARCHAR(10)**   | NOT NULL                                       |
| `description`   | **TEXT**          |                                                |
| `updated_by`    | **FOREIGN KEY**   | NOT NULL REFERENCES client(client_id)          |
| `deleted_at`    | **TIMESTAMP**     |                                                |
| `created_at`    | **TIMESTAMP**     | NOT NULL DEFAULT CURRENT_TIMESTAMP             |
| `updated_at`    | **TIMESTAMP**     | NOT NULL DEFAULT CURRENT_TIMESTAMP             |

### Descripción
[COMPLETAR_DESCRIPCION]

***

## Tabla "company_has_treatment"

### Estructura
La tabla "company_has_treatment" tiene la siguiente estructura:

| Llave Compuesta                                                                   |
|-----------------------------------------------------------------------------------|
| `PRIMARY KEY ("client_fk", "company_fk", "treatment_fk")`                         |

| Columna           | Tipo                   | Restricciones                                |
|-------------------|------------------------|----------------------------------------------|
| `client_fk`       | **FOREIGN KEY**        | NOT NULL REFERENCES client(client_id)        |
| `company_fk`      | **FOREIGN KEY**        | NOT NULL REFERENCES company(company_id)      |
| `treatment_fk`    | **FOREIGN KEY**        | NOT NULL REFERENCES treatment(treatment_id)  |
| `value`           | **DECIMAL(7,2)**       | NOT NULL                                     |
| `updated_by`      | **FOREIGN KEY**        | NOT NULL REFERENCES client(client_id)        |
| `created_at`      | **TIMESTAMP**          | NOT NULL DEFAULT CURRENT_TIMESTAMP           |
| `updated_at`      | **TIMESTAMP**          | NOT NULL DEFAULT CURRENT_TIMESTAMP           |

### Descripción
[COMPLETAR_DESCRIPCION]

***

## Tabla "treatment_has_professional"

### Estructura
La tabla "treatment_has_professional" tiene la siguiente estructura:

| Llave Compuesta                                                                 |
|---------------------------------------------------------------------------------|
| `PRIMARY KEY ("clien_fk", "professional_fk", "company_fk", "treatment_fk"`      |

| Columna           | Tipo                    | Restricciones                                     |
|-------------------|-------------------------|---------------------------------------------------|
| `client_fk`       | **FOREIGN KEY**         | NOT NULL REFERENCES client(client_id)             |
| `professional_fk` | **FOREIGN KEY**         | NOT NULL                                          |
| `company_fk`      | **FOREIGN KEY**         | NOT NULL REFERENCES company(company_id)           |
| `treatment_fk`    | **FOREIGN KEY**         | NOT NULL REFERENCES treatment(treatment_id)       |
| `value`           | **DECIMAL(7,2)**        | NOT NULL                                          |
| `updated_by`      | **FOREIGN KEY**         | NOT NULL REFERENCES client(client_id)             |
| `created_at`      | **TIMESTAMP**           | NOT NULL DEFAULT CURRENT_TIMESTAMP                |
| `updated_at`      | **TIMESTAMP**           | NOT NULL DEFAULT CURRENT_TIMESTAMP                |

### Descripción
[COMPLETAR_DESCRIPCION]