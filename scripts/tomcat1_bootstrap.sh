#!/bin/bash

# Install Java JDK
yum install -y jdk

# Install Tomcat
yum install -y tomcat
yum install -y tomcat-webapps 
yum install -y tomcat-admin-webapps

# MySQL Shell
yum install -y https://dev.mysql.com/get/mysql80-community-release-el7-3.noarch.rpm
yum install -y mysql-shell

# Install of mysql-connector-java
yum install -y mysql-connector-java

# Create MySQL Database
rm -rf /tmp/create_db.sql
echo 'create database ocidb;' | sudo tee -a /tmp/create_db.sql
echo 'use ocidb;' | sudo tee -a /tmp/create_db.sql
echo 'GRANT ALL ON ocidb.* TO admin@"%";' | sudo tee -a /tmp/create_db.sql
#echo 'create table ocitable (mytext varchar(2000));' | sudo tee -a /tmp/create_db.sql
#echo 'insert into ocitable values ("Hello World! Here is OCI MYSQL Service");' | sudo tee -a /tmp/create_db.sql
#echo 'commit;' | sudo tee -a /tmp/create_db.sql
#echo 'select * from ocitable;' | sudo tee -a /tmp/create_db.sql
echo 'CREATE TABLE todos (id bigint(20) NOT NULL AUTO_INCREMENT, title varchar(255) DEFAULT NULL, description varchar(255) DEFAULT NULL, is_done bit(1) NOT NULL, PRIMARY KEY (id)) AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci; ' | sudo tee -a /tmp/create_db.sql
echo 'select * from todos;'

mysqlsh --user ${db_user_name} --password=${db_user_password} --host ${db_server_ip_address} --file /tmp/create_db.sql --sqlc

# Prepare application and Tomcat
cp /home/opc/context.xml /etc/tomcat/context.xml
cp /usr/share/java/mysql-connector-java.jar /usr/share/tomcat/lib/

# Start Tomcat
setsebool -P tomcat_can_network_connect_db 1
systemctl start tomcat
systemctl status tomcat
systemctl enable tomcat
wget -O /home/opc/todoapp.war https://github.com/oracle-quickstart/oci-arch-tomcat-mds/releases/latest/download/todoapp.war
chown opc:opc /home/opc/todoapp.war
cp /home/opc/todoapp.war /usr/share/tomcat/webapps/
sleep 20

service firewalld stop
systemctl disable firewalld




