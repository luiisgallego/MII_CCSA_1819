#!/bin/bash

################################################################
################ ----- VARIABLES GLOBALES ----- ################
################################################################
# Definimos variables generales
nombreGrupoRecursos="P1_CCSA"
localizacion="uksouth"
# Owncloud
dnsNameOwncloud="ccsa-owncloud"
nombreContainerOwncloud="owncloud"
imagenDockerOwncloud="owncloud"
# MYSQL
dnsNameMysql="ccsa-mysql"
nombreContainerMysql="mysql"
imagenDockerMysql="luiisgallego/mysql_ccsa"
# LDAP
dnsNameLdap="ccsa-ldap"
nombreContainerLdap="ldap"
imagenDockerLdap="osixia/openldap"
####################################################################
################ ----- FIN VARIABLES GLOBALES ----- ################
####################################################################

########################################################
################ ----- DEPLOY ALL ----- ################
########################################################
echo "--------------------------------------"
echo "---- Opciones disponibles -----"
echo "1 - Construir imagen MySQL y subir a DockerHUB."
echo "2 - Desplegar contenedores en Azure."
echo "3 - Construir y desplegar."
echo "4 - Enviar info (usuarios) a LDAP."
echo "5 - Comprobar usuarios LDAP."
echo "6 - Entrar al contenedor mysql - azure."
echo "7 - Eliminar contenedores de Azure."
echo "Introduzca número de opción elegida: "
read opcion
echo "--------------------------------------"
echo "--------------------------------------"

if [ "$opcion" -eq 1 ] || [ "$opcion" -eq 3 ]; then

    echo "---- Comenzamos ejecución -----"
    echo -e "\n\n\n\n\n"

    ### 1- Construir imagen MySQL y subir a DockerHUB
    echo "----- Construimos imagen UBUNTU --- MYSQL.... -----"
    echo "Construimos contenedor:"
    docker build -t luiisgallego/ubuntu_mysql .
    echo "Creamos tag para push:"
    docker tag luiisgallego/ubuntu_mysql luiisgallego/mysql_ccsa
    echo "Subimos imagen a DockerHub:"
    docker push luiisgallego/mysql_ccsa
    echo "----- Imagen Ubuntu-MySql construida correctamente.... -----"
    echo -e "\n\n\n\n\n"

fi

if [ "$opcion" -eq 2 ] || [ "$opcion" -eq 3 ]; then

    # Creamos el grupo de recursos en función de la localizacion
    echo "Creamos grupo de recursos...."
    az group create --name $nombreGrupoRecursos --location $localizacion 
    echo "Grupo de recursos creado."

    echo "Creamos CONTAINER OWNCLOUD...."
    az container create \
        --resource-group $nombreGrupoRecursos \
        --dns-name-label $dnsNameOwncloud \
        --name $nombreContainerOwncloud \
        --image $imagenDockerOwncloud \
        --ports 80

    echo "Creado CONTAINER OWNCLOUD...."
    echo -e "\n\n\n\n\n"

    echo "Creamos CONTAINER MYSQL...."
    az container create \
        --resource-group $nombreGrupoRecursos \
        --dns-name-label $dnsNameMysql \
        --name $nombreContainerMysql \
        --image $imagenDockerMysql \
        --ports 3306

    echo "Creado CONTAINER MYSQL...."

    echo "Creamos CONTAINER LDAP...."
    az container create \
        --resource-group $nombreGrupoRecursos \
        --dns-name-label $dnsNameLdap \
        --name $nombreContainerLdap \
        --image $imagenDockerLdap \
        --ports 389

    echo "Creado CONTAINER LDAP...."

fi

if [ "$opcion" -eq 4 ]; then

    echo "Inserta IP contenedor LDAP: "
    read IP

    ldapadd -H ldap://$IP -x -D cn=admin,dc=example,dc=org -w admin -c -f ou_ldap.ldif
    ldapadd -H ldap://$IP -x -D cn=admin,dc=example,dc=org -w admin -c -f usuario_ldap.ldif   

fi

if [ "$opcion" -eq 5 ]; then

    echo "Inserta IP contenedor LDAP: "
    read IP_2

    ldapsearch -x -H ldap://$IP_2 -b dc=example,dc=org -D "cn=admin,dc=example,dc=org" -w admin

fi

if [ "$opcion" -eq 6 ]; then 
    az container exec --resource-group P1_CCSA --name mysql --exec-command "/bin/bash"
fi

if [ "$opcion" -eq 7 ]; then 
    az group delete --name $nombreGrupoRecursos
fi

############################################################
################ ----- FIN DEPLOY ALL ----- ################
############################################################
