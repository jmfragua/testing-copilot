#!/bin/bash

# Obtener el nombre del proyecto del parámetro o usar un valor por defecto
PROJECT_NAME=${1:-MinimalApiProject}

# Validar que se proporcione un nombre
if [ -z "$PROJECT_NAME" ]; then
    echo "Uso: $0 <nombre-del-proyecto>"
    echo "Ejemplo: $0 MiAPI"
    exit 1
fi

echo "=== Generando proyecto: $PROJECT_NAME ==="
echo ""

# Crea un proyecto de minimal api de .net
echo "Creando proyecto de minimal api de .net..."
dotnet new web -n $PROJECT_NAME

# Crea un proyecto de pruebas para el proyecto de minimal api de .net
echo "Creando proyecto de pruebas para el proyecto de minimal api de .net..."
dotnet new xunit -n ${PROJECT_NAME}.Tests

# Asocia los dos proyectos  
echo "Asociando los proyectos..."
dotnet add ${PROJECT_NAME}.Tests reference $PROJECT_NAME

# Crea un archivo de solución
echo "Creando archivo de solución..."
dotnet new sln -n ${PROJECT_NAME}Solution
# Agrega ambos proyectos a la solución
echo "Agregando proyectos a la solución..."
dotnet sln ${PROJECT_NAME}Solution.sln add ${PROJECT_NAME}/${PROJECT_NAME}.csproj
dotnet sln ${PROJECT_NAME}Solution.sln add ${PROJECT_NAME}.Tests/${PROJECT_NAME}.Tests

# Agrega los paquetes necesarios para el proyecto de  test de minimal api de .net
echo "Agregando paquetes necesarios para el proyecto de pruebas..."
dotnet add ${PROJECT_NAME}.Tests/${PROJECT_NAME}.Tests.csproj package Microsoft.EntityFrameworkCore.InMemory
dotnet add ${PROJECT_NAME}.Tests/${PROJECT_NAME}.Tests.csproj package Microsoft.EntityFrameworkCore.Design

# Agrega un archivo de Docker en el proyecto de minimal api de .net
echo "Agregando archivo de Docker en el proyecto de minimal api de .net..."
cat <<EOL > ${PROJECT_NAME}/Dockerfile
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EOL

echo "Archivo de Docker creado"
echo ""
echo "=== Proyecto $PROJECT_NAME creado exitosamente ==="




