#!/bin/bash

echo "Actualizamos ubuntu"
apt-get update
echo -e "\n\n\n\n\n"

echo "Instalamos MySQL"
apt-get install -y python-mysqldb mysql-server
echo -e "\n\n\n\n\n"

echo "Permitimos cualquier conexión" 
sed -i 's/bind-address/#bind-address/' /etc/mysql/mysql.conf.d/mysqld.cnf 
echo -e "\n\n\n\n\n"

echo "Lanzamos el servicio de MySQL"
service mysql start
echo -e "\n\n\n\n\n"

echo "Configuramos la BD"
mysql -e "CREATE USER 'luis'@'%' IDENTIFIED BY 'luis'"
mysql -e "GRANT ALL PRIVILEGES ON *.* TO 'luis'@'%' WITH GRANT OPTION"
mysql -e "CREATE DATABASE ccsa"
echo -e "\n\n\n\n\n"
