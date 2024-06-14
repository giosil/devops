# Nginx

Test project.

## Build Typescript App

npm run build

## Build docker image

docker build -t nginx-site-img .

## Run docker container

docker run --name nginx-site -p 8088:80 -d nginx-site-img
