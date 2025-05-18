
# Manipulacion ETL de Movilidad residencial interdepartamental en Argentina (Decenio 2012 - 2022)

## Resumen

En este tutorial vamos a ver cómo configurar una base de datos en __*PostgreSQL*__ para importar y trabajar con datos reales de **Movilidad Residencial Interdepartamental** en Argentina, específicamente del periodo 2012-2022. El archivo que vamos a usar es un archivo CSV que contiene información sobre los movimientos de personas entre distintos departamentos del país.

Además de la tabla de movilidad, vamos a importar otras dos tablas: una con los departamentos y otra con las provincias, ya que la información está relacionada entre sí mediante claves foráneas __*(FK)*__. Por ejemplo, cada registro de movilidad tiene un departamento de origen y un departamento de destino, y cada departamento pertenece a una provincia.

A lo largo del tutorial vamos a ir paso a paso: creando las tablas, configurando las relaciones, importando los datos desde el __*CSV*__ y verificando que todo haya salido bien.

Este trabajo es ideal si se empieza a practicar con bases de datos relacionales y se quiere trabajar con un caso real, con datos abiertos y relevantes.


## **Requisitos Previos**

Antes de comenzar, asegúrate de tener instalados los siguientes componentes:

- [Docker](https://www.docker.com/)
- [Docker Compose](https://docs.docker.com/compose/)
- Navegador web para acceder a Apache Superset y pgAdmin.




## Glosario

* __*CSV*__: Formato de archivo de texto que almacena datos en formato de tabla, donde cada línea representa una fila y los valores están separados por comas

* __*(FK)*__: _Foreign Key_, o _Clave Foránea_, es un atributo de una tabla que apunta hacia la _clave primaria_ (o identificadora) de otra tabla

* __*PostgreSQL*__: Sistema de gestión de bases de datos relacional orientado a objetos y de código abierto



# Procedimiento



## Paso 1. Importación del proyecto

Se debe clonar el repositorio con todo el proyecto ingresando en la consola:

```
git clone https://github.com/FeliDB/etl-movilidad-interdepartamental-postgres
```

Para cambiar al directorio raiz del proyecto:
```
git clone https://github.com/FeliDB/etl-movilidad-interdepartamental-postgres
```

### Estructura del proyecto

El proyecto, en el directorio raiz, contiene:


El archivo docker-compose.yml
```
version: '3.8'

services:
  postgres:
    image: postgres:15
    container_name: postgres-db
    restart: unless-stopped
    environment:
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: postgres
      POSTGRES_DB: movilidad
    ports:
      - "5432:5432"
    volumes:
      - ./datos:/datos
      - ./init:/docker-entrypoint-initdb.d

  pgadmin:
    image: dpage/pgadmin4
    container_name: pgadmin
    restart: unless-stopped
    environment:
      PGADMIN_DEFAULT_EMAIL: admin@admin.com
      PGADMIN_DEFAULT_PASSWORD: admin
    ports:
      - "8080:80"
    volumes:
      - pgadmin-data:/var/lib/pgadmin

  superset:
    build:
      context: ./superset
      dockerfile: Dockerfile
    container_name: superset
    restart: unless-stopped
    environment:
      SUPERSET_SECRET_KEY: 'thisISaSECRET_key'
      ADMIN_USERNAME: admin
      ADMIN_PASSWORD: admin
      ADMIN_FIRSTNAME: Superset
      ADMIN_LASTNAME: Admin
      ADMIN_EMAIL: admin@superset.com
    ports:
      - "8088:8088"
    volumes:
      - superset-data:/app/superset_home
    depends_on:
      - postgres
    command: >
      /bin/bash -c "
      superset db upgrade &&
      superset fab create-admin --username admin --firstname Superset --lastname Admin --email admin@superset.com --password admin &&
      superset init &&
      superset run -h 0.0.0.0 -p 8088
      "

volumes:
  pgadmin-data:
  superset-data:

```

Este archivo contiene la definicion de los servicios que se crearán dentro del contenedor:

+ __PostgreSQL__ (para la base de datos)
+ __pgAdmin__ (interfaz grafica para PostgreSQL)
+ __superSet__ (realizar consultas a la base de datos)





# Paso 2. Ingreso a la base de datos

La razon por la que hemos optado por utilizar __pgAdmin__ y __superSet__, es para evitar utilizar la linea de comandos para todas las consultas y analisis de datos. Dicho esto, vamos a proceder con el ingreso a la base de datos


Para ello, simplemente ejecutamos el archivo __init.sh__ (Unix) o __init.bat__ (Windows) para iniciar el servidor.

Luego de ejecutar el archivo, el servidor ya estará corriendo. Para acceder a los servicios de __pgAdmin__ y __superSet__, entramos a las siguientes direcciones web

+ http://localhost:8080 __(pgAdmin)__
+ http://localhost:8088 __(superSet)__


## Para el __pgAdmin__

Para poder conectar __pgAdmin__ a la base de datos creada, entramos al dominio anterior ingresado. Deberias ver algo asi:


![](./res/1.jpg)

En el campo de __Email Adress / Username__ ingresa:

```
admin@admin.com
```

En el campo de __Password__ ingresa:

```
admin
```

Si ingresaste correctamente esos datos, deberias poder ingresar a la pantalla principal del __pgAdmin__

Una vez alli, es hora de conectar la base de datos que se encuentra ejecutandose. 

* En el panel izquierdo, haz clic derecho sobre "Servers" → Register → Server...


* En el apartado de Name: lo que quieras, por ejemplo Movilidad_DB

* En la Pestaña "Connection": Host name/address: postgres (Es el nombre del servicio en docker-compose.yml)

* En el apartado de port: 5432

* En el apartado de Username: postgres

* En el apartado de Password: postgres

Si seguiste correctamente los pasos, ya deberias tener la base de datos conectada. Si quieres ver las tablas:

Vas a la izquierda en Servers, __Movilidad_DB__ > Databases > movilidad > Schemas > public > Tables

Y ahi veras todas las tablas de la base de datos


## Para el __superSet__

Para el __superSet__, el proceso es algo similar al anterior, deberás entrar al dominio en el anterior apartado, y una vez dentro, veras la siguiente pantalla:

![](./res/2.jpg)

En el campo de __USERNAME__ ingresa:

```
admin
```

En el campo de __PASSWORD__ ingresa:

```
admin
```

Si ingresaste correctamente los datos anteriores, deberias poder acceder a la pagina principal de Superset

Es hora de añadir nuestra base de datos para comenzar a hacer las consultas. Para ello:


__Settings__ > __Database Connections__ > __+ Database__ (boton azul) > __PostgreSQL__ > Bajamos hacia abajo de todo hacia el boton __Connect this database with a SQLAlchemy URI string instead__ > Ingresamos la siguiente URI:

```
postgresql+psycopg2://postgres:postgres@postgres:5432/movilidad
```

Una vez ingresado, ¡Listo! Ya podremos comenzar a realizar las consultas en nuestra base de datos