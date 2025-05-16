
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