FROM node:20.9.0-alpine
WORKDIR /app

COPY package.json /app
RUN npm install
COPY . /app

EXPOSE ${PORT}

# Inicia la aplicación
CMD ["npm", "start"]