# Run Apache Tomcat with MySQL on OCI

This example shows how to run a simple Java web app on Apache Tomcat using MySQL. Both Tomcat and the MySQL instance are running on compute instances from Oracle Cloud Infrastructure.

### Prerequisites

To run this example, you need to have an Oracle Cloud Infrastructure compute instance that you can [access by using SSH](https://docs.oracle.com/en-us/iaas/Content/Compute/Tasks/managingkeypairs.htm#one).  
Also, [allow traffic](https://docs.oracle.com/en-us/iaas/Content/Network/Concepts/securitylists.htm#working) on port 8080.
  
## How to run this example

To run this application, first prepare a compute instance with a few required packages, such as container tools and `git`. Then, clone the repository and build the application by using the included Maven `pom.xml`. Lastly, start the MySQL and Tomcat docker containers by using the container tools.

### Install container tools

Oracle Linux 8 uses Podman to run and manage containers. Podman is a daemonless container engine for developing, managing, and running Open Container Initiative containers and container images on your Linux system. Podman provides a Docker-compatible command line front end that can alias the Docker CLI: `alias docker=podman`.

1. Install the `container-tools` module that pulls in all the tools required to work with containers.
    ```
    sudo dnf module install container-tools:ol8
    sudo dnf install git
    ```

2. Open the port to expose for the application. 
    ```
    sudo firewall-cmd --permanent --zone=public --add-port=8080/tcp
    sudo firewall-cmd --reload
    ```

3. Set SELinux to be in permissive mode so that Podman can easily interact with the host.
> **Note**: This is not recommended for production use. However, setting up SELinux policies for containers are outside the scope of this tutorial. For details, see the Oracle Linux 8 documentation.
    ```
    sudo setenforce 0
    ```

### Clone the source code

To get started, SSH in to your compute instance and clone the repository. 

```
git clone <final github URL>
cd todo-application
```



### Build the web application

Java web applications are packaged as web application archives, or WAR files. WAR files are zip files with metadata that describes the application to a servlet container like Tomcat. This example uses Apache Maven to build the WAR file for the application. 
To build the application, run the following command. Be sure to run the command from the location where the source files were cloned to.

```
podman run -it --rm --name todo-build \
    -v "$(pwd)":/usr/src:z \
    -w /usr/src \
    maven:3.3-jdk-8 mvn clean install
```
This command creates a `target` directory and the WAR file inside it. Note that we aren’t installing Maven but instead running the build tooling inside the container. 

### Run the application on OCI

The application uses the Tomcat servlet container and the MySQL database.

1. Create a pod using Podman.
    ```
    podman pod create --name todo-app -p 8080:8080
    ```

2. Start the database container in the pod.

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

    For the MySQL database, the database initialization scripts are provided to the container, which creates the required database users and tables at startup. For more options, including how to export and back up data, see the [documentation](https://hub.docker.com/_/mysql).


3. Deploy the application that you built as a WAR file with a Tomcat server.
    ```
    podman run --pod todo-app \
    --name todo-tomcat \
    -v "$(pwd)"/target/todo.war:/usr/local/tomcat/webapps/todo.war:z \
    tomcat:9
    ```

    The database connect information and the application are provided to the Apache Tomcat container. The database connection information is provided as environment variables, in line with [12 factor](https://www.12factor.net/) application practices, and the application WAR file is provided as a mount.

    Tomcat deploys the application on startup, and the port mapping to the host makes the application available over the public IP address for the compute instance.


4. Enter the public IP address of the compute instance in a browser. You should be able to see the application.

### Debugging and Troubleshooting

Podman containers can be inspected just like Docker containers (you can even alias `podman` as `docker`). Here are some common commands for inspecting the containers:

- `podman ps -pa` - shows running and exited containers, and the pods they belong to. 
- `podman logs -f todo-mysql` - shows the output from the specified container (`todo-mysql` in this example). Press `Ctrl+c` to exit.