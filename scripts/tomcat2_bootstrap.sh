#!/bin/bash

# Install Java JDK
yum install -y jdk

# Install Tomcat
yum install -y tomcat
yum install -y tomcat-webapps 
yum install -y tomcat-admin-webapps
yum install -y yum install mysql-connector-java

# MySQL Shell
yum install -y https://dev.mysql.com/get/mysql80-community-release-el7-3.noarch.rpm
yum install -y mysql-shell

# Query MySQL Database
rm -rf /tmp/query_db.sql
echo 'use ocidb;' | sudo tee -a /tmp/query_db.sql
echo 'select * from ocitable;' | sudo tee -a /tmp/query_db.sql

mysqlsh --user ${db_user_name} --password=${db_user_password} --host ${db_server_ip_address} --file /tmp/query_db.sql --sqlc

# Prepare application and Tomcat
cp /home/opc/context.xml /etc/tomcat/context.xml
cp /usr/share/java/mysql-connector-java.jar /usr/share/tomcat/lib/
cp /home/opc/javaocidemo.war /usr/share/tomcat/webapps/

# Start Tomcat
systemctl start tomcat
systemctl status tomcat
systemctl enable tomcat

service firewalld stop
systemctl disable firewalld




