# Apache Tomcat with MySQL on ARM

This is an example application that shows a simple Java web-app running on Apache Tomcat using MySQL. Both Tomcat as well as the MySQL instance are running on ARM based compute instances.  

### Prerequisites

The only prerequisites to run this example are :
- An OCI A1 compute instance that you can SSH in to
- Traffic on port `8080` should be allowed. [Documentation]()
  
## How to run this example

To run this application, simply build the application using the included maven `pom.xml` and start the MySQL and Tomcat docker containers using the commands below. 

### Install container tools

Oracle Linux 8 uses Podman to run and manage containers. Podman is a daemonless container engine for developing, managing, and running Open Container Initiative (OCI) containers and container images on your Linux System. Podman provides a Docker-compatible command line front end that can simply alias the Docker cli, `alias docker=podman`.

Install the `container-tools` module that pulls in all the tools required to work with containers.

```
sudo dnf module install container-tools:ol8
sudo dnf install git
```

Open the port we are going to expose for the application.

```
sudo firewall-cmd --permanent --zone=public --add-port=8080/tcp
```

Set SELinux to be in **permissive** mode so that `podman` can easily interact with the host. 
> This is not recommended for production use. However, setting up SELinux policies for containers are outside the scope of this tutorial. Please refer to the Oracle Linux 8  documentation for further details.
```
sudo setenforce 0
```

### Clone the source code

To get started, SSH in to your compute instance and clone the repository. 

```
git clone <final github URL>
cd todo-application
```



### Building the web application

Java web applications are packaged as web-application archives, or `.war` files. These are `zip` files with additional metadata that describe the application to a servlet container like Apache Tomcat. In this example, we use the java build tool Apache Maven, to build the `.war` file for our application.  To build the application run the following command :
(make sure you are running the command from where the source files were cloned to)
```
podman run -it --rm --name todo-build \
    -v "$(pwd)":/usr/src:z \
    -w /usr/src \
    maven:3.3-jdk-8 mvn clean install
```
This will create a `target` directory and the `.war` file inside it. 

### Running the application on the A1 compute shapes

The application uses the Apache Tomcat servlet container and the MySQL database. Both Tomcat and the MySQL database support the ARM64v8 architecture, that the OCI A1 Compute uses.

First we create a pod using podman
```
podman pod create --name todo-app
```

Then we bring up the database container in the pod

```
podman run --pod todo-app -d \
-e MYSQL_ROOT_PASSWORD=pass \
-e MYSQL_DATABASE=demo \
-e MYSQL_USER=todo-user \
-e MYSQL_PASSWORD=todo-pass \
--name todo-mysql \
-v "$(pwd)"/src/main/sql:/docker-entrypoint-initdb.d:z \
mysql:latest
```

For the MySQL database, we provide the database initialization scripts to the container which creates the required database users and tables at startup. Please refer to the [documentation](https://hub.docker.com/_/mysql) for further options including how to export and back up data. 

Next we deploy the application we previously built as a `.war` file with an Apache Tomcat server. 
```
podman run --pod tomcat \
--name todo-tomcat \
-v "$(pwd)"/target/todo.war:/usr/local/tomcat/webapps/todo.war:z \
tomcat:9
```

We provide the database connect information and the application to the Apache Tomcat container. The database connection information is passed in as environment variables, in-line with [12-factor](https://www.12factor.net/) application practices and the application `.war` file is provided as a mount. 

Tomcat deploys the application on startup and the port-mapping to the host makes the application available over the public IP address for the compute instance.

Finally, we can point our browser at the public IP address of the compute instance and we shall be able to see the application. 

### Debugging and Troubleshooting

Podman containers can be inspected just like Docker containers (you can even alias `podman` as `docker`). Here are some common ways and commands to introspect the containers :

- `podman ps -pa` - shows running and exited containers along with the pods they  belong to. 
- `podman logs -f todo-mysql` - tails the output from the specified container (`todo-mysql` in this example). Press `Ctrl+c` to exit.