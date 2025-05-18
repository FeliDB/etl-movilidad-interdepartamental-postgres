@echo off
docker ps -a --format "{{.Names}}" | findstr /i "etl-movilidad-interdepartamental-postgres" >nul

IF %ERRORLEVEL% EQU 0 (
    echo Contenedor encontrado. Eliminando...
    docker rm -f etl-movilidad-interdepartamental-postgres
) ELSE (
    echo Contenedor no encontrado.
)

echo Iniciando docker-compose...
docker-compose up --build
