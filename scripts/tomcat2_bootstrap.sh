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

# Query MySQL Database
rm -rf /tmp/query_db.sql
echo 'use ocidb;' | sudo tee -a /tmp/query_db.sql
#echo 'select * from ocitable;' | sudo tee -a /tmp/query_db.sql
echo 'select * from todos;' | sudo tee -a /tmp/query_db.sql

mysqlsh --user ${db_user_name} --password=${db_user_password} --host ${db_server_ip_address} --file /tmp/query_db.sql --sqlc

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
sleep 20

service firewalld stop
systemctl disable firewalld




