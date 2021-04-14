#!/bin/bash

# Install Java JDK & Tomcat
yum install -y jdk

useradd tomcat

mkdir /u01
wget -O /u01/apache-tomcat-${tomcat_version}.zip https://archive.apache.org/dist/tomcat/tomcat-${tomcat_major_release}/v${tomcat_version}/bin/apache-tomcat-${tomcat_version}.zip
unzip /u01/apache-tomcat-${tomcat_version}.zip -d /u01/
chown -R tomcat:tomcat /u01

# MySQL Shell
yum install -y https://dev.mysql.com/get/mysql80-community-release-el7-3.noarch.rpm
yum install -y mysql-shell

# Install of mysql-connector-java
yum install -y mysql-connector-java

export tomcat_host='${tomcat_host}'

if [[ $tomcat_host == "tomcat-server-0" ]]; then
	rm -rf /tmp/create_db.sql
	echo 'create database ocidb;' | sudo tee -a /tmp/create_db.sql
	echo 'use ocidb;' | sudo tee -a /tmp/create_db.sql
	echo 'GRANT ALL ON ocidb.* TO admin@"%";' | sudo tee -a /tmp/create_db.sql
	echo 'CREATE TABLE todos (id bigint(20) NOT NULL AUTO_INCREMENT, title varchar(255) DEFAULT NULL, description varchar(255) DEFAULT NULL, is_done bit(1) NOT NULL, PRIMARY KEY (id)) AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci; ' | sudo tee -a /tmp/create_db.sql
	echo 'select * from todos;'
	mysqlsh --user ${db_user_name} --password=${db_user_password} --host ${db_server_ip_address} --file /tmp/create_db.sql --sqlc
else
	rm -rf /tmp/query_db.sql
	echo 'use ocidb;' | sudo tee -a /tmp/query_db.sql
	echo 'select * from todos;' | sudo tee -a /tmp/query_db.sql
	mysqlsh --user ${db_user_name} --password=${db_user_password} --host ${db_server_ip_address} --file /tmp/query_db.sql --sqlc
fi

# Prepare application and Tomcat
cp /home/opc/context.xml /u01/apache-tomcat-${tomcat_version}/conf/context.xml
cp /usr/share/java/mysql-connector-java.jar /u01/apache-tomcat-${tomcat_version}/lib/

# Start Tomcat
setsebool -P tomcat_can_network_connect_db 1
chmod +x /u01/apache-tomcat-${tomcat_version}/bin/*.sh
sudo -u tomcat nohup /u01/apache-tomcat-${tomcat_version}/bin/startup.sh &

# Download TODOAPP and deploy in Tomcat
wget -O /home/opc/todoapp.war https://github.com/oracle-quickstart/oci-arch-tomcat-mds/releases/latest/download/todoapp.war
chown opc:opc /home/opc/todoapp.war
cp /home/opc/todoapp.war /u01/apache-tomcat-${tomcat_version}/webapps

# Adding Tomcat as systemd service
cp /home/opc/tomcat.service /etc/systemd/system/
chown root:root /etc/systemd/system/tomcat.service
cat /etc/systemd/system/tomcat.service
systemctl daemon-reload
systemctl enable tomcat
systemctl start tomcat
sleep 20
ps -ef | grep tomcat
systemctl status tomcat --no-pager

# Stop and disable firewalld 
service firewalld stop
systemctl disable firewalld






