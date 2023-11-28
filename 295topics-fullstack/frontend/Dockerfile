FROM node:20.9.0-alpine
WORKDIR /app
LABEL org.opencontainers.image.description="frontend-topics"\
      org.opencontainers.image.authors="Erick"
ENV API_URI "http://backend-topics-app:5000/api/topics"
COPY package.json /app
RUN npm install
COPY . /app
EXPOSE 3000
CMD [ "npm", "start" ]