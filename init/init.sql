-- ================================================
-- ELIMINACIÓN DE TABLAS SI EXISTEN
-- ================================================
DROP TABLE IF EXISTS public.movilidadinterdepartamental;
DROP TABLE IF EXISTS public.movilidadinterdepartamental_tmp;
DROP TABLE IF EXISTS public.departamento;
DROP TABLE IF EXISTS public.provincia;

-- ================================================
-- CREACIÓN DE TABLAS
-- ================================================

-- 1. Tabla 'provincia'
CREATE TABLE provincia (
    id integer NOT NULL,
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

-- 2. Tabla 'departamento'
CREATE TABLE departamento (
    id integer NOT NULL,
    categoria varchar(255),
    centroide_lat double precision,
    centroide_lon double precision,
    fuente varchar(255),
    nombre varchar(255),
    nombre_completo varchar(255),
    provincia_id integer,
    provincia_interseccion varchar(255),
    provincia_nombre varchar(255),
    PRIMARY KEY (id),
    CONSTRAINT fk_provincia_id FOREIGN KEY (provincia_id) REFERENCES provincia(id)
);

-- 3. Tabla definitiva 'movilidadinterdepartamental' con claves foráneas
CREATE TABLE movilidadinterdepartamental (
    provincia_origen_id integer,
    provincia_origen_nombre varchar(255),
    departamento_origen_id integer,
    departamento_origen_nombre varchar(255),
    provincia_destino_id integer,
    provincia_destino_nombre varchar(255),
    departamento_destino_id integer,
    departamento_destino_nombre varchar(255),
    migrantes integer,
    CONSTRAINT fk_departamento_origen_id FOREIGN KEY (departamento_origen_id) REFERENCES departamento(id),
    CONSTRAINT fk_departamento_destino_id FOREIGN KEY (departamento_destino_id) REFERENCES departamento(id),
    CONSTRAINT fk_provincia_origen_id FOREIGN KEY (provincia_origen_id) REFERENCES provincia(id),
    CONSTRAINT fk_provincia_destino_id FOREIGN KEY (provincia_destino_id) REFERENCES provincia(id)
);

-- 4. Tabla temporal sin restricciones
CREATE TABLE movilidadinterdepartamental_tmp (
    provincia_origen_id integer,
    provincia_origen_nombre varchar(255),
    departamento_origen_id integer,
    departamento_origen_nombre varchar(255),
    provincia_destino_id integer,
    provincia_destino_nombre varchar(255),
    departamento_destino_id integer,
    departamento_destino_nombre varchar(255),
    migrantes integer
);

-- ================================================
-- CARGA DE DATOS DESDE ARCHIVOS CSV
-- ================================================

-- 1. Provincias
COPY provincia(
    categoria,
    centroide_lat,
    centroide_lon,
    fuente,
    id,
    iso_id,
    iso_nombre,
    nombre,
    nombre_completo
)
FROM '/datos/provincias.csv' DELIMITER ',' CSV HEADER;

-- 2. Departamentos
COPY departamento(
    categoria,
    centroide_lat,
    centroide_lon,
    fuente,
    id,
    nombre,
    nombre_completo,
    provincia_id,
    provincia_interseccion,
    provincia_nombre
)
FROM '/datos/departamentos.csv' DELIMITER ',' CSV HEADER;

-- 3. Movilidad - carga temporal (sin restricciones)
COPY movilidadinterdepartamental_tmp(
    provincia_origen_id,
    provincia_origen_nombre,
    departamento_origen_id,
    departamento_origen_nombre,
    provincia_destino_id,
    provincia_destino_nombre,
    departamento_destino_id,
    departamento_destino_nombre,
    migrantes
)
FROM '/datos/movilidadinterdepartamental.csv' DELIMITER ',' CSV HEADER;




INSERT INTO movilidadinterdepartamental (
    provincia_origen_id,
    provincia_origen_nombre,
    departamento_origen_id,
    departamento_origen_nombre,
    provincia_destino_id,
    provincia_destino_nombre,
    departamento_destino_id,
    departamento_destino_nombre,
    migrantes
)
SELECT *
FROM movilidadinterdepartamental_tmp
WHERE 
    provincia_origen_id IN (SELECT id FROM provincia) AND
    provincia_destino_id IN (SELECT id FROM provincia) AND
    departamento_origen_id IN (SELECT id FROM departamento) AND
    departamento_destino_id IN (SELECT id FROM departamento);