# Contenedor de origen
FROM ubuntu:latest
LABEL version="1.0" MAINTAINER="Luis Gallego <lgaq94@gmail.com>"

# Directorio de trabajo
WORKDIR /

# Copiamos el script de instalación de MySQL
COPY installMySQL.sh ./

# Damos permisos al script
RUN chmod 777 installMySQL.sh

# Ejecutamos
RUN ./installMySQL.sh

VOLUME ["/var/lib/mysql"]

# Dejamos ejecutandose mysql
CMD ["mysqld_safe"]

# Abrimos el puerto de MySQL
EXPOSE 3306
