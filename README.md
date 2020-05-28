# RES-LaboHTTP-Infra
### 28.05.2020

## Denis Bourqui, Nicolas Müller, Thomas Rieder

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

- We didn't use the same Bootstrap as is the video.
- We didn't have to do the port forwarding when starting the container, we could connect directly with the IP address from the container.
- We used newer php image for Docker base image. We used `php:7.4-apache`.

### 3: Additional informations

There is no more information needed for this part.

### 4: To test on your machine

Like said in the introduction, these steps are for Linux Manjaro. These should work on every Linux system.

```bash
git clone https://github.com/Nic0Mueller/RES-LaboHTTP-Infra.git
cd RES-LaboHTTP-Infra
git checkout step1-static-http
cd docker-images/apache-php-image/
docker build -t res/apache_php .
docker run -d res/apache_php
docker ps
# find the name of your container and use it in the <NAME> file
docker inspect <NAME> | grep -i "ipaddress"
# Connect to the ip address found on default port 80 from a browser
```

# Part 2: Dynamic HTTP server with express.js

### 1: List of tasks to do the step

- Create a new branch.
- Create a new folder in `docker_images` named `express`.
- Find a node image for Docker.
- Write a script which returns a JSON containing juicy informations on GET requests.
- Build the image and copy the node sources on the image.
- Start a container and test it from a browser on port 3000.
- Test it with Postman too.

### 2: Changes between this lab and the video

- We used a newer version of node for the Docker image. We used `node:14.1.0`.
- We generate a list of animals all having their custom names instead of people.

### 3: Additional informations

`docker-images/express-image/src/node_modules/` were excluded from the git.

We use `Express.js` for this part.

### 4: To test on your machine

Like said in the introduction, these steps are for Linux Manjaro. These should work on every Linux system. You must have node installed (for npm) and have a native docker running on your system.

```bash
git clone https://github.com/Nic0Mueller/RES-LaboHTTP-Infra.git
cd RES-LaboHTTP-Infra
git checkout part2-dynamic-http
cd docker-images/express-image/src
npm install
cd ..
docker build -t res/express .
docker run -d res/express
docker ps
# find the name of your container and use it in the <NAME> file
docker inspect <NAME> | grep -i "ipaddress"
# Connect to the ip address found on port 3000 from a browser or via Postman to test it
```



# Step 3: Reverse proxy with apache (static configuration)

### Same-origin policy

The **same-origin policy** only authorize request coming from the same origin. In this Lab, we use the domain `demo.res.ch`, which mean that only request from this domain will be allowed.

### 1: List of tasks to do this step

- Start two containers (httpd + node)
- Grab their IP address
- Create a new Docker image for the reverse proxy
- Configure the reverse proxy routing
- Test

### 2: Changes between this lab and the video

- For the apache static and reverse proxy server, we use the `php:7.4-apache` base image.

### 3: Additional informations

- In this part, the RP server use a static routing configuration so it's important to start the container in the next order (to get the correct IP routing) :

  1. apache-php-image (172.17.0.2:80)

  2. express-image (172.17.0.3:3000)

  3. apache-reverse-proxy (172.17.0.4:80)

- To avoid using a DNS, we have to add

  ```
  172.17.0.4	demo.res.ch
  ```

  in `/etc/hosts` file.

- if you don't have this IPs, you have to change it in `apache-reverse-proxy/conf/sites-available/001-reverse-proxy.conf` and rebuild the RP image.

- The RP will be redirect requests from `demo.res.ch:80` to `apache-php-image`

- The RP will be redirect requests from `demo.res.ch:80/api/students` to `express-image`

### 4: To test on your machine

```bash
git clone https://github.com/Nic0Mueller/RES-LaboHTTP-Infra.git
cd RES-LaboHTTP-Infra
git checkout part3-reverse-proxy

#install node dependencies
cd docker-images/express-image/src
npm install
cd ../../..

#build images
docker build -t res/apache-static docker-images/apache-php-image/
docker build -t res/express-dynamic docker-images/express-image/
docker build -t res/apache-rp docker-images/apache-reverse-proxy/

#run containers in this order important !
docker run -d res/apache-static
docker run -d res/express-dynamic
docker run -d res/apache-rp

#test routing
telnet 172.17.0.4 80

#get static content
GET / HTTP/1.0
Host: demo.res.ch

#get dynamic content
GET /api/students/ HTTP/1.0
Host: demo.res.ch

#It's possible to test it in a web browser too
```



# Part 4 : AJAX requests with JQuery

### 1: List of tasks to do this step

- Update the images to install vim
- Start the 3 containers in the correct order (same as Part 3)
- Log into the static http container
- Create our own JavaScript script
- Use JQuery to do an AJAX request
- Use JQuery to update DOM element

### 2: Changes between this lab and the video

- Our JavaScript script does the same things as the video but it is a little different
- We have added class `skills` on the DOM element that we want to modify.

### 3: Additional informations

- The configuration is the same as the Part 3
- Your `/etc/hosts` file must to be modified as in Part 3

### 4: To test on your machine

```bash
git clone https://github.com/Nic0Mueller/RES-LaboHTTP-Infra.git
cd RES-LaboHTTP-Infra
git checkout part4-ajax-jquery

#install node dependencies
cd docker-images/express-image/src
npm install
cd ../../..

#build images
docker build -t res/apache-static docker-images/apache-php-image/
docker build -t res/express-dynamic docker-images/express-image/
docker build -t res/apache-rp docker-images/apache-reverse-proxy/

#run containers in this order important !
docker run -d res/apache-static
docker run -d res/express-dynamic
docker run -d res/apache-rp

#You can test in your web browser with http://demo.res.ch
```



# Part 5: Dynamic reverse proxy configuration

### 1: List of tasks to do this step

- Pass environment variables when starting a Docker container `-e`
- Add a setup phase in the RP Dockerfile (change CMD and invoke a script)
- Use PHP to create a template for the RP configuration file
- Inject environment variables in the configuration file

### 2: Changes between this lab and the video

- We use `php:7.4-apache` as base image so our `apache2-foreground` script is different

### 3: Additional informations

- after this step we can run our containers in any order, which mean we need to get the static and dynamic container IP with `docker inspect` to pass the IP as an environment variable when running the RP container.
- `STATIC_APP` name of environment variable to pass the `IP:PORT` of the static container
- `DYNAMIC_APP` name of environment variable to pass the `IP:PORT` of the dynamic container

### 4: To test on your machine

```bash
git clone https://github.com/Nic0Mueller/RES-LaboHTTP-Infra.git
cd RES-LaboHTTP-Infra
git checkout part5-dynamic-configuration

#install node dependencies
cd docker-images/express-image/src
npm install
cd ../../..

#build images
docker build -t res/apache-static docker-images/apache-php-image/
docker build -t res/express-dynamic docker-images/express-image/
docker build -t res/apache-rp docker-images/apache-reverse-proxy/

#run static and dynamic containers in any order
#you can also run any other containers here
docker run -d --name dynamic-app res/express-dynamic
docker run -d --name static-app res/apache-static

#get the IP address of the needed containers

docker inspect static-app | grep -i ipaddress
#example: static app get 172.17.0.5

docker inspect dynamic-app | grep -i ipaddress
#example: dynamic app get 172.17.0.8

#run RP container with this two environment variables
docker run -d -e STATIC_APP=172.17.0.5:80 -e DYNAMIC_APP=172.17.0.8:3000 res/apache-rp

#You can test in your web browser with http://demo.res.ch
```

