# IV Edición Bootcamp DevOps by RoxsRoss Ejercicio 02

🔥🔥🔥🔥

---
DevOps es una práctica y cultura que se enfoca en la colaboración y comunicación estrecha entre los equipos de desarrollo de software (Dev) y operaciones (Ops) en una organización. El objetivo principal de DevOps es acortar el ciclo de desarrollo de software, permitir entregas de software más frecuentes y confiables, y mejorar la automatización de tareas relacionadas con la infraestructura y el despliegue.

**[295topics-fullstack](https://github.com/erickcernarequejo/bootcamp-devops-2023/tree/ejercicio2-dockeriza/295topics-fullstack)**

La aplicación "295topics-fullstack" consta de un frontend Node.js, un backend TypeScript y una base de datos MongoDB a la cual se accede utilizando la interfaz proporcionada por mongo-express. Tanto para el backend como para el frontend se ha creado sus imágenes docker correspondientes y han sido subidas a [dockerhub](https://hub.docker.com/repositories/erickcernarequejo)

- Para levantar los servicios con docker es necesario descargar el archivo docker-compose.yml que se encuentra en la raíz del proyecto, luego se debe abrir la terminal y ejecutar el comando:
  ```bash
  docker-compose up
  ```
  
- Para realizar mejoras en alguno de los 3 proyectos mencionados se debe clonar la carpeta completa, realizar la construcción de las imágenes de los proyectos y en el archivo docker-compose.yml en donde se define la "image" se actualiza por la nueva versión que se ha subido a dockerhub.

**[295words-docker](https://github.com/erickcernarequejo/bootcamp-devops-2023/tree/ejercicio2-dockeriza/295words-docker)**

La aplicación "295words-docker" consta de una API REST en Java, una aplicación web en Go y una base de datos PostgreSQL. Tanto para el backend como para el frontend se ha creado sus imágenes docker correspondientes y han sido subidas a [dockerhub](https://hub.docker.com/repositories/erickcernarequejo)

- En la raíz del repositorio se encuentra el archivo [deploy.sh](https://github.com/erickcernarequejo/bootcamp-devops-2023/blob/ejercicio2-dockeriza/deploy.sh) Este archivo tiene los pasos necesarios para levantar los servicios con docker, primero realiza la clonación de donde se encuentran los proyectos, construye las imágenes docker y las sube a dockerhub, de esta manera luego ejecuta internamente el comando docker-compose up para que los servicios estén disponibles. Para ejecutar el archivo es necesario abrir la terminal y ejecutar los siguientes comandos:
  
  ```bash
  chmod +x deploy.sh
  ./deploy.sh
  ```
