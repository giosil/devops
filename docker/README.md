# Docker Cheat Sheet

## Check local Docker installation

`docker info`

http://localhost:2375/info

## Check local Kubernetes installation

`kubectl cluster-info`

https://localhost:6443/

https://kubernetes.docker.internal:6443/

## Create a Docker image

- `docker build -t <image_name> .` this will create a Docker image named <image_name>

## Run locally on Docker

- `docker run --name=<container_name> -p 8080:8080 -d <image_name>` - To run image creating container named <container_name> (-d = detach)
- `docker run --rm -it --name=<container_name> -p 8080:8080 -d <image_name>` - To run image creating container named <container_name> (-rm = remove, -i = interactive, -t = tty)
- `docker run -v <host_directory>:<container_directory> --name=<container_name> -p 8080:8080 -d <image_name>` - To run image with volume
- `docker run -e APP_PROFILE=test --name=<container_name> -p 8080:8080 -d <image_name>` - To run image with environment variables
- `docker rename <container_name> <new_container_name>` - To rename the container
- `docker ps` - To see the running container
- `docker ps -a -q -f name=<container_name> -f status=running` - To see all (-a) the ids/names (-q) of running container by <container_name>
- `docker ps -a -q -f ancestor=<image_name> -f status=running` - To see all (-a) the ids/names (-q) of running container by <image_name>
- `docker top <container_name>` - To display the running processes of the container
- `docker stats <container_name>` - To display a live stream of the container resource usage statistics
- `docker stop <container_name>` - To stop the running container
- `docker stop $(docker ps -a -q -f ancestor=<image_name> -f status=running)` - To stop the running container by image name (Linux)
- `docker stop @(docker ps -a -q -f ancestor=<image_name> -f status=running)` - To stop the running container by image name (Windows)
- `docker kill <container_name>` - To send KILL signal to the running container
- `docker ps -a` - To see all containers
- `docker rm <container_name>` - To remove the container
- `docker inspect <container_name>` - To view info of the container
- `docker image inspect <image_name>` - To view info of the image
- `docker logs <container_name>` - To view stdout / stderr of the container
- `docker logs --follow <container_name>` - To follow stdout / stderr of the container
- `docker attach <container_name>` - To connect to the container CTRL+P CTRL+Q to exit
- `docker exec -it <container_name> bash` - Other mode to connect to the container CTRL+Z to exit
- `docker exec <container_name> /bin/rm -fr /usr/local/tomcat/logs/*.*` - Execute a command on continer 
- `docker exec <container_name> -u 0 /bin/rm -fr /usr/local/tomcat/logs/*.*` - Execute a command on continer as Root
- `docker cp <container_name>:/usr/local/tomcat/logs "%USERPROFILE%"\Desktop` - To copy log folder from container to host
- `docker images` - To see the list of images
- `docker image ls` - Other mode to see the list of images
- `docker rmi <image_name>` - To remove an image
- `docker image prune` - To remove all unused images
- `docker commit <container_name> <image_name>:<tag>` - To create a new image from a container’s changes
- `docker push <image_name>:<tag>` - To upload an image to Docker Hub (https://hub.docker.com/)
- `docker pull <image_name>:<tag>` - To get an image from Docker Hub (https://hub.docker.com/)
- `docker save <image_name> -o <file_name>.tar` - Save one or more images to a tar archive
- `docker import <file_name>.tar` - Import the contents from a tarball to create a filesystem image
- `docker run -v <path_host>:<path_container> <image_name>` - To run image creating container with a volume
- `docker volume create --name <name_vol> -o type=none -o o=bind -o device=<path_host>` - To create a volume mapped with an host path
- `docker network create <network_name>` - To create a network
- `docker run --name <container_name> --network <network_name> [--alias <alias>] -d <image_name>` - To run image creating container with a network

### Samples

- `docker build -t giosil/wxdsb:1.0.0 .` - To create giosil/wxdsb image
- `docker run -p 8080:8080 --name=wxdsb -d giosil/wxdsb:1.0.0` - To run image *giosil/wxdsb* creating container named *wxdsb*
- `docker logs -f wxdsb` - Fetch and follow the logs of *wxdsb* container
- `docker inspect wxdsb` - To inspect a running *wxdsb* container
- `docker exec -it wxdsb sh` - Open a shell inside a running container *wxdsb* container
- `docker cp ext.tar wxdsb:/usr/local/tomcat/lib` - Copy *ext.tar* in */usr/local/tomcat/lib*  folder of running *wxdsb* container
- `docker exec -w /usr/local/tomcat/lib wxdsb /bin/tar -xvf /usr/local/tomcat/lib/ext.tar` - Extract tar content on running *wxdsb* container
- `docker exec wxdsb /bin/rm -fr /usr/local/tomcat/lib/ext.tar` - Remove tar on running *wxdsb* container
- `docker commit wxdsb giosil/wxdsb:1.1.0` - To create new version of *giosil/wxdsb* image from the *wxdsb* container
- `docker tag giosil/wxdsb:1.1.0 giosil/wxdsb:latest` - To add tag *latest* to *giosil/wxdsb:1.1.0* image
- `docker login dockerhub.dew.org` - To access to another registry the first time before push
- `docker login -u giosil` - To access to Docker Hub the first time before push
- `docker push giosil/wxdsb` - To upload *giosil/wxdsb* to Docker Hub (https://hub.docker.com/)
- `docker pull giosil/wxdsb` - To get *giosil/wxdsb* from Docker Hub (https://hub.docker.com/)

## Docker-compose

Sample of docker-compose.yml:

```yaml
services:
  wxdsb:
    build: .
    ports:
      - "8080:8080"
```

Run container:

`docker compose up -d`

or

`docker-compose up -d`

Stop container:

`docker compose stop`

Stop and remove container (and network):

`docker compose down`

## Uninstall WSL on Windows

To list distros:

`wsl -l -v`

To remove a distro:

`wsl --unregister Ubuntu`

To uninstall WSL:

`wsl --uninstall`

## Install WSL on Windows

You must first enable the "Windows Subsystem for Linux" optional feature before installing any Linux distributions on Windows.

Execute Deployment Image Servicing and Management (dism.exe):

`dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart`

Before installing WSL 2, you must enable the Virtual Machine Platform optional feature.

`dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart`

The Linux kernel update package installs the most recent version of the WSL 2 Linux kernel

`wsl.exe --install` 

or 

`wsl.exe --update`

Open PowerShell and run this command to set WSL 2 as the default version when installing a new Linux distribution:

`wsl --set-default-version 2`

Install your Linux distribution of choice

Open the Microsoft Store and select your favorite Linux distribution.

## Optimize Virtual hard disks on Windows 10 (Hyper-V)

- Shutdown Docker Desktop
- `Optimize-VHD -Path "C:\Users\Public\Documents\Hyper-V\Virtual hard disks\DockerDesktop.vhdx" -Mode Full`
- Start Docker Desktop

## Optimize Virtual hard disks on Windows 10 (WSL 2 based engine)

- Shutdown Docker Desktop
- wsl --shutdown
- diskpart
	- select vdisk file="C:\Users\giorgio.silvestris\AppData\Local\Docker\wsl\disk\docker_data.vhdx"
	- attach vdisk readonly
	- compact vdisk
	- detach vdisk
	- exit
- Start Docker Desktop
- \\\\wsl$           (to view data)
- \\\\wsl.localhost  (alterative path)
- \\\\wsl.localhost\docker-desktop\mnt\docker-desktop-disk\data\docker\containers
- \\\\wsl.localhost\docker-desktop\mnt\docker-desktop-disk\data\docker\volumes
