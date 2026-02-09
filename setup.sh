#!/bin/bash

REPO_BACK="https://github.com/ruizdani301/miseventos-backend.git"
REPO_FRONT="https://github.com/ruizdani301/miseventos-frontend.git"

echo "Iniciando configuración de MisEventos..."

# 1. Clonar repositorios
[ ! -d "miseventos-backend" ] && git clone $REPO_BACK
[ ! -d "miseventos-frontend" ] && git clone $REPO_FRONT

# 2. Verificar existencia del .env
if [ ! -f ".env" ]; then
    echo "ERROR: No se encontró el archivo .env en la raíz."
    echo "Por favor, copia el archivo .env.example a .env y configura tus credenciales."
    echo "Comando: cp .env.example .env"
    exit 1
fi

# 3. Levantar Docker
echo "🐳 Levantando contenedores con tu configuración manual..."
sudo docker compose up -d --build

echo "✨ ¡Listo! Backend y Frontend corriendo."