DROP TABLE IF EXISTS public.movilidadinterdepartamental;

DROP TABLE IF EXISTS public.departamento;

DROP TABLE IF EXISTS public.provincia;

-- TABLAS DEFINITIVAS
CREATE TABLE provincia (
    id integer NOT NULL ,
    categoria varchar(255),
    centroide_lat double precision,
    centroide_lon double precision,
    fuente varchar(255),
    iso_id varchar(255),
    iso_nombre varchar(255),
    nombre varchar(255),
    nombre_completo varchar(255),

    PRIMARY KEY (id)
);

CREATE TABLE departamento (
    id integer NOT NULL,
    categoria varchar(255),
    centroide_lat double precision,
    centroide_lon double precision,
    fuente varchar(255),
    iso_id varchar(255),
    iso_nombre varchar(255),
    nombre varchar(255),
    nombre_completo varchar(255),
    provincia_id integer,
    provincia_nombre varchar(255),

    PRIMARY KEY (id),
    constraint fk_provincia_id foreign key (provincia_id) references provincia(id),
    constraint fk_provincia_nombre foreign key (provincia_nombre) references provincia(nombre)
);

CREATE TABLE movilidadinterdepartamental (
    id integer NOT NULL,
    categoria varchar(255),
    centroide_lat double precision,
    centroide_lon double precision,
    fuente varchar(255),
    origen_id integer,
    origen_nombre varchar(255),
    destino_id integer,
    destino_nombre varchar(255),
    valor double precision,

    PRIMARY KEY (id),
    constraint fk_origen_id foreign key (origen_id) references departamento(id),
    constraint fk_destino_id foreign key (destino_id) references departamento(id),
    constraint fk_origen_nombre foreign key (origen_nombre) references departamento(nombre),
    constraint fk_destino_nombre foreign key (destino_nombre) references departamento(nombre)
);

-- TABLAS TEMPORALES
CREATE TEMPORARY TABLE temp_provincia (
    id integer,
    categoria varchar(255),
    centroide_lat double precision,
    centroide_lon double precision,
    fuente varchar(255),
    iso_id varchar(255),
    iso_nombre varchar(255),
    nombre varchar(255),
    nombre_completo varchar(255)
);

CREATE TEMPORARY TABLE temp_departamento (
    id integer,
    categoria varchar(255),
    centroide_lat double precision,
    centroide_lon double precision,
    fuente varchar(255),
    iso_id varchar(255),
    iso_nombre varchar(255),
    nombre varchar(255),
    nombre_completo varchar(255),
    provincia_id integer,
    provincia_nombre varchar(255)
);

CREATE TEMPORARY TABLE temp_movilidadinterdepartamental (
    id integer,
    categoria varchar(255),
    centroide_lat double precision,
    centroide_lon double precision,
    fuente varchar(255),
    origen_id integer,
    origen_nombre varchar(255),
    destino_id integer,
    destino_nombre varchar(255),
    valor double precision
);

COPY provincias_temp
FROM '/datos/provincias.csv' DELIMITER ',' CSV HEADER;

INSERT INTO
    public.provincia (
        id,
        categoria,
        centroide_lat,
        centroide_lon,
        fuente,
        iso_id,
        iso_nombre,
        nombre,
        nombre_completo
    )
SELECT
    id::INTEGER,
    categoria,
    centroide_lat,
    centroide_lon,
    fuente,
    iso_id,
    iso_nombre,
    nombre,
    nombre_completo
FROM provincias_temp;

COPY departamentos_temp
FROM '/datos/departamentos.csv' DELIMITER ',' CSV HEADER;

INSERT INTO
    public.departamento (
        id,
        categoria,
        centroide_lat,
        centroide_lon,
        fuente,
        iso_id,
        iso_nombre,
        nombre,
        nombre_completo,
        provincia_id,
        provincia_nombre
    )
SELECT
    id::INTEGER,
    categoria,
    centroide_lat,
    centroide_lon,
    fuente,
    iso_id,
    iso_nombre,
    nombre,
    nombre_completo,
    provincia_id::INTEGER,
    provincia_nombre
FROM departamentos_temp;

COPY movilidadinterdepartamental_temp
FROM '/datos/movilidadinterdepartamental.csv' DELIMITER ',' CSV HEADER;

INSERT INTO
    public.movilidadinterdepartamental (
        id,
        categoria,
        centroide_lat,
        centroide_lon,
        fuente,
        origen_id,
        origen_nombre,
        destino_id,
        destino_nombre,
        valor
    )
SELECT
    id::INTEGER,
    categoria,
    centroide_lat,
    centroide_lon,
    fuente,
    origen_id::INTEGER,
    origen_nombre,
    destino_id::INTEGER,
    destino_nombre,
    valor::DOUBLE PRECISION
FROM movilidadinterdepartamental_temp;
