# Guía de Despliegue: Ecosistema MisEventos

### Tecnologías: Docker, FastAPI, React (Vite), PostgreSQL

### 1. Estructura del Proyecto Orquestador

Este proyecto utiliza un modelo de repositorio orquestador para gestionar múltiples repositorios de Git de forma independiente pero coordinada mediante Docker Compose.
- Archivos en la Raíz:
    * docker-compose.yml: Define los servicios y la red.
    * setup.sh: Script de automatización para clonado y configuración.
    * .env_example: Plantilla con las variables de entorno que se utilizaran para correr la aplicación
    * README.md: Instrucciones de uso.
    * .gitignore: Filtro para no subir el código de los hijos al repo padre.

### 2. Configuración de Docker Compose
El archivo docker-compose.yml está configurado para ser dinámico y seguro, utilizando variables de entorno para evitar credenciales expuestas.
```
services:
  db:
    image: postgres:16-alpine
    container_name: postgres_db
    restart: always
    environment:
      POSTGRES_USER: ${DB_USER}
      POSTGRES_PASSWORD: ${DB_PASSWORD}
      POSTGRES_DB: ${DB_NAME}
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data

  backend:
    build: 
      context: ./misEventos
    container_name: backend_app
    restart: always
    depends_on:
      - db
    environment:
      - DATABASE_URL=${DATABASE_URL}
      - SECRET_KEY=${SECRET_KEY}
      - ALGORITHM=${ALGORITHM}
      - ACCESS_TOKEN_EXPIRE_MINUTES=${ACCESS_TOKEN_EXPIRE_MINUTES}
    ports:
      - "8000:8000"

  frontend:
    build:
      context: ./front_miseventos
    container_name: frontend_app
    restart: always
    depends_on:
      - backend
    ports:
      - "5173:80"

volumes:
  postgres_data:
```

### 3. Automatización con setup.sh

* El script realiza las siguientes tareas críticas:
* Clonado: Descarga el código fuente de los repositorios independientes.
* Seguridad: Genera una SECRET_KEY aleatoria de 32 bytes usando OpenSSL.
* Validación: Valida que el archivo .env este en la raiz, con el cual se configuran las variables de entorno

### 4. Instrucciones de Uso (Quick Start)

Para desplegar el proyecto desde cero en cualquier máquina con Docker:
- Clonar el orquestador:
Bash
* git clone https://github.com/ruizdani301/eventos.git
* cd eventos

### Crear .env
 * Crea una archivo .env en la raiz del repositorio y copia la plantilla de ejemplo de .env_example.
 * Completa cada variable con los datos que tienes para la base de datos, y configuraciones personalizadas

#### Ejecutar el instalador:
- Bash
* chmod +x setup.sh
* ./setup.sh


Verificar servicios:
Frontend: http://127.0.0.1:5173
Backend (Swagger): http://127.0.0.1:8000/docs

### 5. Notas de Seguridad y Mantenimiento

Cookies: El sistema utiliza cookies HttpOnly y SameSite=Lax. En desarrollo, Secure está en False.
Volúmenes: Los datos de la DB persisten en postgres_data. Para borrarlos completamente, use docker compose down -v.
Git: Las carpetas miseventos-backend/ y miseventos-frontend/ son ignoradas por el orquestador para evitar conflictos de repositorios anidados.

