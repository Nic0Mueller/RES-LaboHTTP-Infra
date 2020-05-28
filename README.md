# RES-LaboHTTP-Infra
### 28.05.2020

## Denis Bourqui, Nicolas Müller, Thomas Rieder

# TODO for each part

 \1. la liste des étapes réalisées pour arriver à vos fins
  \2. les changements que vous avez dû opérer par rapport aux webcasts
  \3. des explications supplémentaires qui vous paraissent importantes (Dockerfile, variables d'environnement, et tout ce qui peut vous paraître utile)
  \4. la marche à suivre pour exécuter la step sur notre machine

# Introduction

In this lab, we'll get across different steps to build a web infrastructure. Every member of our group is running Manjaro Linux with a native docker running on it. This means our solution is a bit different than the one shown in the videos. We don't need to do port forwarding to access the containers that we start.

# Part 1: Static HTTP server with apache httpd

### 1: List of tasks to do the step

- Create this repo
- Find a apache httpd server Docker image
- Find a nice looking Bootstrap and adapt it by adding informations about us
- Build the Docker Image from the one found and add our content in it 
- Connect to it from a browser and see everything working

### 2: Changes between this lab and the video

- We didn't use the same Bootstrap as is the video
- We didn't have to do the port forwarding when starting the container, we could connect directly with the IP address from the container.

### 3: Additional informations

There is no more information needed for this part.

### 4: To test on your machine

Like said in the introduction, these steps are for Linux Manjaro. These should work on every Linux system.

```bash
git clone https://github.com/Nic0Mueller/RES-LaboHTTP-Infra.git
cd RES-LaboHTTP-Infra
git checkout step1-static-http
docker build -t res/apache_php .
docker run -d res/apache_php
docker ps
# find the name of your container and use it in the <NAME> file
docker inspect <NAME> | grep -i "ipaddress"
# Connect to the ip address found on default port 80 from a browser
```



