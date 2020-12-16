#!/bin/bash

# Install Java JDK
yum install -y jdk

# Install Tomcat
yum install -y tomcat
yum install -y tomcat-webapps 
yum install -y tomcat-admin-webapps

# Start Tomcat
systemctl start tomcat
systemctl status tomcat
systemctl enable tomcat

service firewalld stop
systemctl disable firewalld
