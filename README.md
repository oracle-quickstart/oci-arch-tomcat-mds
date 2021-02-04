# Apache Tomcat with MySQL on ARM

This is an example application that shows a simple Java web-app running on Apache Tomcat using MySQL. Both Tomcat as well as the MySQL instance are running on ARM based compute instances.  

## How to Run this application

To run this application, simply start the MySQL and Tomcat docker containers using the commands below. The web application is mounted on to the Tomcat container, which deploys the application on startup. The database initialization scripts are similarly mounted on to the MySQL container as well, which creates the required database objects. 

- Start the database (run from where you cloned this repository)
```
docker run --rm -d -p3306:3306 \
-e MYSQL_ROOT_PASSWORD=todo-application \
-e MYSQL_DATABASE=demo \
-e MYSQL_USER=todo-user \
-e MYSQL_PASSWORD=todo-pass \
--name todo-mysql \
-v $(pwd)/src/main/sql:/docker-entrypoint-initdb.d \
mysql:latest
```    
