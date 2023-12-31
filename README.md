
[![version](https://img.shields.io/badge/Ubuntu-20.04-brown)](https://semver.org)
[![version](https://img.shields.io/badge/NodeJS-20-green)](https://semver.org)
[![version](https://img.shields.io/badge/JAVA-11-green)](https://semver.org)
[![version](https://img.shields.io/badge/Posrgres-14-blue)](https://semver.org)
[![version](https://img.shields.io/badge/Redis-7-red)](https://semver.org)
[![version](https://img.shields.io/badge/MongoDB-7-green)](https://semver.org)
[![version](https://img.shields.io/badge/Tomcat-9.0.5-yellow)](https://semver.org)


# Class schedule
## Quick start ⚡
- [Application Diagram](#application-architecture-in-diagram)
- [For Developers](#instructions-for-developers-how-to-run-project-locally)
- [Run in Stage](#instructions-how-to-deploy-project-in-stage)
- [Run in Production](#instructions-how-to-deploy-project-in-production)
- [Partners](#partners-)

## General info
This repository contains a source code of the Class Schedule Project.

The main goal of the project is designing a website where the university or institute staff will be able to create, store and display their training schedules.

Link to the development version of the site: https://develop-softserve.herokuapp.com/

## Application Architecture in Diagram
![schedule_application_architecturE.png](screenshots%2Fschedule_application_architecturE.png)

------------------------------------------
# Instructions for Developers (how to run Project locally)
Assuming that all commands will be running in shell from working directory and [DockerCLI](https://docs.docker.com/engine/install/) is installed
## Clone repository locally from Git
In order to create a local copy of the project you need:
1. Download and install the last version of Git https://git-scm.com/downloads
2. Open a terminal and go to the directory where you want to clone the files. 
3. Run the following command. Git automatically creates a folder with the repository name and downloads the files there.
```shell
git clone https://github.com/DTG-cisco/devops-team-green-2 && cd devops-team-green/
```

### Creating Your .env File with variables
```dotenv
# Postgresql credentials 
PG_HOST=postgresql
PG_DB_NAME=schedule
PG_USER=schedule
PG_PASS=
PG_DUMP_FILE='backup/2023-09-07.dump' 


# Mongo credentials
MONGO_DB_NAME=schedules
MONGO_HOST=mongodb

# Redis credentials
REDIS_HOST=redis

# APP Ports
PG_PORT=5432
REDIS_PORT=6379
MONGO_PORT=27017
TOM_PORT=8080
```

### Export variables from .env 
```shell
source .env
```

### Create docker network
```shell
docker network create --driver bridge schedule_network
```

## Database PostgreSQL
1. Run this simple commands to Start version 14 of PostgreSQL in Docker container
```shell
docker volume create postgres-data
docker run -d --name $PG_HOST \
	--network schedule_network \
	-v postgres-data:/var/lib/postgresql/data \
	-e POSTGRES_PASSWORD=$PG_PASS \
	-e POSTGRES_DB=$PG_DB_NAME \
	-e POSTGRES_USER=$PG_USER \
	postgres:14-alpine
```
2. Restore PG data from file
```shell
docker cp $PG_DUMP_FILE $PG_HOST:/tmp/backup.dump
docker exec -it $PG_HOST psql -U $PG_USER -d $PG_DB_NAME -f /tmp/backup.dump
docker exec -it $PG_HOST psql -U $PG_USER -c "CREATE DATABASE $PG_DB_NAME_TEST WITH OWNER $PG_USER"
docker exec -it $PG_HOST psql -U $PG_USER -c "GRANT ALL PRIVILEGES ON DATABASE $PG_DB_NAME TO $PG_USER;"
docker exec -it $PG_HOST psql -U $PG_USER -c "GRANT ALL PRIVILEGES ON DATABASE $PG_DB_NAME_TEST TO $PG_USER;"
```

3. Configure connection url in `src/main/resources/hibernate.properties` and `src/test/resources/hibernate.properties` files:
```text
hibernate.connection.url=jdbc:postgresql://${PG_HOST}:${PG_PORT}/${PG_DB_NAME}
```

## Database MongoDB
1. Start Mondo DB latest version with env variables:
```shell
docker volume create mongo-data
docker run -d --network schedule_network \
   --name $MONGO_HOST \
   -v mongo-data:/data/db mongo:7.0-rc-jammy
```

## Database Redis
1. Start the latest version of Redis in Docker container   
```shell
docker run -d --network schedule_network \
   --name $REDIS_HOST redis:7-alpine
```
2. Configure connection url in `src/main/resources/cache.properties` file:
```text
redis.address = redis://${REDIS_HOST}:${REDIS_PORT}
```

## Starting backend server using IntelliJ IDEA and Tomcat
1. Download and install the Ultimate version of IntelliJ IDEA (alternatively you can use a trial or EAP version) https://www.jetbrains.com/idea/download
2. Download and install Tomcat 9.0.50 https://tomcat.apache.org/download-90.cgi
3. Start the IDE and open class_schedule.backend project from the folder where you previously download it.
4. Make sure Tomcat and TomEE Integration is checked (`File –>> Settings –>> Plugins`).
5. `Run –>> Edit Configurations…`
6. Clicks `+` icon, select `Tomcat Server –>> Local`
7. Clicks on “Server” tab, then press `Configure...` button and select the directory with Tomcat server
8. Clicks on “Deployment” tab, then press `+` icon to select an artifact to deploy, and select `Gradle:com.softserve:class_schedule.war`
9. Press OK to save the configuration
10. `Run –>> Run 'Tomcat 9.0.50'` to start the backend server


------------------------------------------
# Instructions how to deploy Project in Stage

## For deploying this application run this simple commands (on VM or Remote Server):
1. ### Clone repository
```shell
git clone https://github.com/DTG-cisco/devops-team-green-2 && cd devops-team-green/
```

2. Start Running Databases (Redis, PostgeSQL, Mongo) in Docker container, using same instruction, 
  from previous part [for Developers](#instructions-for-developers-how-to-run-project-locally)
3. Run TomCat App in Docker container
```shell
docker build -t schedule_app_img --progress plain --no-cache .
docker run -d --network schedule_network \
    --env-file .env \
    --name schedule_app \
    -p $TOM_PORT:8080 schedule_app_img
```


---------------------------------------------------------------------------------
# Instructions how to deploy Project in Production

## For deploying this application  run this simple commands (on VM or Remote Server):
### Clone repository
```shell
git clone https://github.com/DTG-cisco/devops-team-green-2 && cd devops-team-green/
```

### Run Docker compose file to start app
```shell
docker compose -f docker-compose.prod.yaml up -d
```
---------------------------------------
# Partners ❤️
## In the list, you can find collaborators, who was working in this project
- Developer Team:
   - Frontend team (incognito)
   - Backend team (incognito)
- Devops Team:
   - Vitaliy Kostyreva 
   - Vladyslav Ivanskiy(one day ill kms)
   - Valentyn Stratii
   - Liza Voievutska
   - Roman Hirnyak
