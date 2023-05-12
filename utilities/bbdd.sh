#!/bin/bash

MYSQL_HOST="localhost"
DB_NAME="rogue_ap"

# Crear la base de datos y las tablas
SQL="
CREATE USER 'fakeap'@'localhost' IDENTIFIED BY 'password';

GRANT SELECT, INSERT, UPDATE, DELETE ON *.* TO 'fakeap'@'localhost' IDENTIFIED BY 'password' 
WITH MAX_QUERIES_PER_HOUR 0
MAX_CONNECTIONS_PER_HOUR 0
MAX_UPDATES_PER_HOUR 0
MAX_USER_CONNECTIONS 0;

DROP DATABASE IF EXISTS $DB_NAME;
CREATE DATABASE $DB_NAME;
USE $DB_NAME;

CREATE TABLE credenciales (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    email VARCHAR(50) NOT NULL,
    password VARCHAR(255) NOT NULL
);
"

# Conexión a MySQL y ejecución de las sentencias SQL
mysql -h $MYSQL_HOST -e "$SQL"

echo $YELLOW
echo "Base de datos con nombre '$DB_NAME' creada "
