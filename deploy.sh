#!/bin/bash

#colores
LGREEN='\033[1;32m'
NC='\033[0m'

# Definir variables
DOCKER_USERNAME="REEMPLAZAR POR USUARIO DOCKER HUB"
DOCKER_PASSWORD="REEMPLAZAR POR CLAVE DOCKER HUB"
DOCKER_IMAGE_NAME_WEB="295words-docker-web-words"
DOCKER_IMAGE_NAME_API="295words-docker-api"
DOCKER_REPO_API="docker.io/${DOCKER_USERNAME}/${DOCKER_IMAGE_NAME_API}"
DOCKER_REPO_WEB="docker.io/${DOCKER_USERNAME}/${DOCKER_IMAGE_NAME_WEB}"
REPO="bootcamp-devops-2023"
DIR="bootcamp-devops-2023"
BRANCH="ejercicio2-dockeriza"

    echo "=============== Git Clone ======================="
    if [ -d "$DIR" ]; then
		echo -e "\n${LBLUE}La carpeta $repo existe ...${NC}"
        sleep 1
        cd $DIR
		git pull origin $BRANCH
	else
		git clone -b $BRANCH https://github.com/erickcernarequejo/$REPO.git
		cd $DIR
	fi

    echo -e "\n${LGREEN}Construir la imagen Docker ...${NC}"
    VERSION=$(git describe --tags --abbrev=0)
    cd 295words-docker
    docker build -t ${DOCKER_IMAGE_NAME_API} ./api
    docker build -t ${DOCKER_IMAGE_NAME_WEB} ./web

    echo -e "\n${LGREEN}Etiquetar la imagen con la versión ...${NC}"
    docker tag ${DOCKER_IMAGE_NAME_API} ${DOCKER_REPO_API}:${VERSION}
    docker tag ${DOCKER_IMAGE_NAME_WEB} ${DOCKER_REPO_WEB}:${VERSION}

    echo -e "\n${LGREEN}Iniciar sesión en Docker Hub ...${NC}" 
    echo "${DOCKER_PASSWORD}" | docker login --username "${DOCKER_USERNAME}" --password-stdin

    echo -e "\n${LGREEN}Subir la imagen a Docker Hub ...${NC}"
    docker push ${DOCKER_REPO_API}:${VERSION}
    docker push ${DOCKER_REPO_WEB}:${VERSION}

    echo -e "\n${LGREEN}Detener y eliminar contenedores existentes ...${NC}"
    docker-compose down

    export IMAGE_VERSION=${VERSION}

    echo -e "\n${LGREEN}Iniciar contenedores con la nueva versión ...${NC}"
    docker-compose up