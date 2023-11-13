#!/bin/bash
USERID=$(id -u)
REPO="bootcamp-devops-2023"
PROYECTO="app-295devops-travel"
NEW_ORDER="index.php index.html index.cgi index.pl index.xhtml index.htm"
FILEPATH="/etc/apache2/mods-enabled/dir.conf"
DIR="ejercicio1"
#colores
LRED='\033[1;31m'
LGREEN='\033[1;32m'
NC='\033[0m'
LBLUE='\033[0;34m'
LYELLOW='\033[1;33m'

function stage1() {
	if [ "${USERID}" -ne 0 ]; then
		echo -e "\n${LRED}Correr con usuario ROOT${NC}"
    	exit
	fi

    echo "===============Actualizando Sistema======================"
    apt-get update
    echo -e "\n${LGREEN}El Servidor se encuentra Actualizado ...${NC}"
    echo "====================================="

    echo "===============Instalando Git ==========================="
    if dpkg -s git > /dev/null 2>&1; then
        echo -e "\n${LBLUE}Git se encuentra instalado ...${NC}"
    else
        echo -e "\n${LYELLOW}Instalando Git ...${NC}"
        apt install git -y
    fi
    echo "====================================="

    #apache [WEB]
    echo "===============Instalando Apache ========================"
    if dpkg -s apache2 > /dev/null 2>&1; then
        echo -e "\n${LBLUE}Apache2 se encuentra instalado ...${NC}"
    else    
        echo -e "\n\e[92mInstalando Apache2 ...\033[0m\n"
        apt install -y apache2
        apt install -y php libapache2-mod-php php-mysql
    fi
    echo "====================================="
    

    echo "===============Instalando MariaDB ======================="
    if dpkg -s mariadb-server > /dev/null 2>&1; then
        echo -e "\n${LBLUE}MariaDB se encuentra instalado ...${NC}"
    else    
        echo -e "\n${LYELLOW}instalando MARIA DB ...${NC}"
        apt install -y mariadb-server
    fi
    echo "====================================="

    echo "===============Instalando Curl ==========================="
    if dpkg -s curl > /dev/null 2>&1; then
        echo -e "\n${LBLUE}CURL se encuentra instalado ...${NC}"
    else
        echo -e "\n${LYELLOW}Instalando Curl ...${NC}"
        apt install curl -y
    fi
    echo "====================================="
}

function check_package() {
    echo "===============Verificando Git ==========================="
    if git --version > /dev/null 2>&1; then
        echo -e "\n${LBLUE}Git se encuentra activo ...${NC}"
    else
        echo -e "\n${LYELLOW}Git NO se encuentra activo ...${NC}"
    fi
    echo "====================================="

    echo "===============Verificando PHP ==========================="
    if php --version > /dev/null 2>&1; then
        echo -e "\n${LBLUE}PHP se encuentra activo ...${NC}"
    else
        echo -e "\n${LYELLOW}PHP NO se encuentra activo ...${NC}"
    fi
    echo "====================================="

    #apache [WEB]
    echo "===============Verificando Apache ========================"
    if [ $(systemctl status apache2 | grep "active (running)" | wc -l) -eq 1 ]; then
        echo -e "\n${LBLUE}Apache2 se encuentra activo ...${NC}"
    else    
        echo -e "\n${LRED}Apache2 NO se encuentra activo ...${NC}"
    fi
    echo "====================================="
    

    echo "===============Verificando MariaDB ======================="
	if [ $(systemctl status mariadb | grep "active (running)" | wc -l) -eq 1 ]; then
        echo -e "\n${LBLUE}MariaDB se encuentra activo ...${NC}"
    else    
        echo -e "\n${LRED}MariaDB NO se encuentra activo ...${NC}"
    fi
    echo "====================================="

    echo "===============Verificando Curl ==========================="
    if curl --version > /dev/null 2>&1; then
        echo -e "\n${LBLUE}CURL se encuentra activo ...${NC}"
    else
        echo -e "\n${LRED}CURL NO se encuentra activo ...${NC}"
    fi
    echo "====================================="
}

function stage2() {
    sed -i "s|DirectoryIndex .*|DirectoryIndex $NEW_ORDER|" $FILEPATH
    echo "=============== Restart WEB ======================="
    systemctl restart apache2
    echo "====================================="

    echo "=============== Git Clone ======================="
    if [ -d "$DIR" ]; then
		echo -e "\n${LBLUE}La carpeta $repo existe ...${NC}"
        sleep 1
        cd $DIR
		git pull origin master
	else
		git clone https://github.com/roxsross/$REPO.git $DIR
		cd $DIR
	fi
    git checkout clase2-linux-bash
    cd $PROYECTO

    sleep 2
    #### base de datos maria db ######

    echo "=============== BD ======================="
    sed -i 's/\$dbPassword = "";/\$dbPassword = "codepass";/g' config.php
    
    echo "===============Verificando BD ======================="
	if [ $(mysql -u root -e "SHOW DATABASES LIKE 'devopstravel';" | grep 'devopstravel') ]; then
        echo -e "\n${LBLUE}MariaDB se encuentra activo ...${NC}"
    else
        echo -e "\n${LBLUE}Configurando base de datos ...${NC}"
        ###Configuracion de la base de datos 
        mysql -e "
        CREATE DATABASE devopstravel;
        CREATE USER 'codeuser'@'localhost' IDENTIFIED BY 'codepass';
        GRANT ALL PRIVILEGES ON *.* TO 'codeuser'@'localhost';
        FLUSH PRIVILEGES;"
        #ejecutar script
        mysql < database/devopstravel.sql
    fi
    echo "====================================="
    
    echo "=============== Copiar Arvhivos ======================="
    cd ..
    cp -r $PROYECTO/* /var/www/html
    echo "====================================="

}

function stage3() {
	systemctl reload apache2
	sleep 1
	app_status=$(curl -s -o /dev/null -w "%{http_code}" http://localhost/index.php)

	if [ $app_status -eq 200 ]; then
		echo "La aplicacion esta activa"
	else
		echo "La aplicacion NO esta activa"
		exit 1
	fi
}

function stage4() {
    DISCORD="https://discord.com/api/webhooks/1169002249939329156/7MOorDwzym-yBUs3gp0k5q7HyA42M5eYjfjpZgEwmAx1vVVcLgnlSh4TmtqZqCtbupov"
    # Obtiene el nombre del repositorio
    REPO_NAME=$(basename $(git rev-parse --show-toplevel))
    # Obtiene la URL remota del repositorio
    REPO_URL=$(git remote get-url origin)
    WEB_URL="localhost"
    # Realiza una solicitud HTTP GET a la URL
    HTTP_STATUS=$(curl -Is "$WEB_URL" | head -n 1)

    # Verifica si la respuesta es 200 OK (puedes ajustar esto según tus necesidades)
    if [[ "$HTTP_STATUS" == *"200 OK"* ]]; then
    # Obtén información del repositorio
        DEPLOYMENT_INFO2="Despliegue del repositorio $REPO_NAME: "
        DEPLOYMENT_INFO="La página web $WEB_URL está en línea."
        COMMIT="Commit: $(git rev-parse --short HEAD)"
        AUTHOR="Autor: $(git log -1 --pretty=format:'%an')"
        DESCRIPTION="Descripción: $(git log -1 --pretty=format:'%s')"
    else
        DEPLOYMENT_INFO="La página web $WEB_URL no está en línea."
    fi

    # Obtén información del repositorio


    # Construye el mensaje
    MESSAGE="$DEPLOYMENT_INFO2\n$DEPLOYMENT_INFO\n$COMMIT\n$AUTHOR\n$REPO_URL\n$DESCRIPTION"

    # Envía el mensaje a Discord utilizando la API de Discord
    HTTP_CODE=$(curl -w "%{http_code}\n" -X POST -H "Content-Type: application/json" \
       -d '{
       "content": "'"${MESSAGE}"'"
       }' "$DISCORD")

	if [ $HTTP_CODE -eq 204 ]; then
		echo "La aplicacion esta activa"
	else
		echo "La aplicacion NO esta activa"
		exit 1
	fi
}

main() {
    echo -e "\n${LGREEN}STAGE 1: [Init] ...${NC}"
    stage1
    check_package
    sleep 1

    echo -e "\n${LGREEN}STAGE 2: [Build] ...${NC}"
    stage2
    sleep 2

    echo -e "\n${LGREEN}STAGE 3: [Deploy] ...${NC}"
    stage3
    sleep 3

    echo -e "\n${LGREEN}STAGE 4: [Notify] ...${NC}"
    stage4
}

main
