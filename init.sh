#!/bin/bash

CONTAINER_NAME="etl-movilidad-interdepartamental-postgres"

# Verifica si el contenedor existe (en cualquier estado)
if docker ps -a --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
  echo "Eliminando el contenedor existente: $CONTAINER_NAME"
  docker rm -f "$CONTAINER_NAME"
else
  echo "No se encontró el contenedor '$CONTAINER_NAME'."
fi

# Ejecuta docker-compose
echo "Iniciando docker-compose up --build"
docker-compose up --build