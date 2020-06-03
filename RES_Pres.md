# RES Présentation qui tue sa mère

Expliquer que nous faisons pas de port forwarding car nos containers ne sont pas dans la VM Docker

## 1) HTTP serveur statique avec apache

> Nico le bobo

```bash
git checkout step1-static-http
```

- Montrer Dockerfile ?
- Montrer contenu de `content/` ?
- expliquer les différence
  - php:7.4-apache
  - autre thème bootstrap
- Démo (se placer dans `docker-image/`) :

```bash
#build de l'image
docker build -t res/apache_php apache-php-image

#run background
docker run -d --name apache-static res/apache_php

#récupérer adresse IP (normalement si seul container = 172.17.0.2)
docker inspect apache-static | grep -i ipaddress

#test telnet ou dans browser
telnet 172.17.0.2 80
GET / HTTP/1.0
```



## 2) HTTP serveur dynamique avec express (node)

> Nico le bobo

```bash
git checkout part2-dynamic-http
```



- Montrer Dockerfile ?
- Montrer le contenu de `src/index.js` ?
- Démo (se placer dans `docker-image/`) :

```bash
#build de l'image
docker build -t res/express express-image

#run background
docker run -d --name express-dynamic res/express

#récupérer adresse IP (normalement si seul container = 172.17.0.2)
docker inspect express-dynamic | grep -i ipaddress

#test telnet ou dans browser
telnet 172.17.0.2 3000
GET / HTTP/1.0
```





## 5) Reverse proxy avec apache (configuration dynamique)

> toto sur son bato

```
git checkout part3-reverse-proxy
```

- montrer Dockerfile de `apache-reverse-proxy/`

- montrer conf/sites-available

  ```
  cat conf/sites-available/001-reverse-proxy.conf
  ```

```bash
#depuis racine du git
#build images
docker build -t res/apache-static docker-images/apache-php-image/
docker build -t res/express-dynamic docker-images/express-image/
docker build -t res/apache-rp docker-images/apache-reverse-proxy/

#lance 2 containers
docker run -d php:7.4-apache
docker run -d php:7.4-apache

#run containers in this order important !
docker run -d --name apache-static res/apache-static
docker run -d --name express-dynamic res/express-dynamic

#IP APACHE STATIC
docker inspect apache-static | grep -i ipaddress

#IP EXPRESS DYNAMIC
docker inspect express-dynamic | grep -i ipaddress


docker run -d -e STATIC_APP=172.17.0.x:80 -e DYNAMIC_APP=172.17.0.x:3000 --name apache-rp res/apache-rp

#IP APACHE RP
docker inspect apache-rp | grep -i ipaddress

#test browser
```



## Load Balancer

> Brice de nice