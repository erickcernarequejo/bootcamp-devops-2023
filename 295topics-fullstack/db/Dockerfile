FROM mongo

# Exponer el puerto en el que MongoDB escucha por defecto
EXPOSE 27017

# Copiar scripts de inicialización a la carpeta de scripts de Docker
COPY mongo-init.js /docker-entrypoint-initdb.d/*.js