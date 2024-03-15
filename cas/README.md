# WDemo - CAS

## Build CAS 

Download CAS project from https://www.apereo.org/projects/cas and build war:

- `gradlew clean copyCasConfiguration build`

## Configuration

Copy configuration files in `cas` folder

## Build docker image

docker build -t cas .

## Run docker container

docker run -p 8444:8444 --name=cas -d cas