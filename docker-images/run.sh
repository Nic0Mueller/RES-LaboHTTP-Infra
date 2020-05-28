	docker run -d --name apache1 res/apache
	docker run -d --name apache2 res/apache
	docker run -d --name apache3 res/apache
  docker run -d --name express1 res/express
	docker run -d --name express2 res/express
	docker run -d --name express3 res/express

	sed 's/srv1/'$(docker inspect apache1 | grep -i ipaddr | tail -1 | cut -d'"' -f4)'/g' nginx-image/default.conf.template > nginx-image/default.conf
	sed -i 's/srv2/'$(docker inspect apache2 | grep -i ipaddr | tail -1 | cut -d'"' -f4)'/g' nginx-image/default.conf
	sed -i 's/srv3/'$(docker inspect apache3 | grep -i ipaddr | tail -1 | cut -d'"' -f4)'/g' nginx-image/default.conf

  sed -i 's/srvnode1/'$(docker inspect express1 | grep -i ipaddr | tail -1 | cut -d'"' -f4)'/g' nginx-image/default.conf
	sed -i 's/srvnode2/'$(docker inspect express2 | grep -i ipaddr | tail -1 | cut -d'"' -f4)'/g' nginx-image/default.conf
	sed -i 's/srvnode3/'$(docker inspect express3 | grep -i ipaddr | tail -1 | cut -d'"' -f4)'/g' nginx-image/default.conf

  echo '======='
  cat nginx-image/default.conf
  echo '======='


	docker build --tag res/nginx nginx-image/
	docker run -d --name nginx res/nginx

	echo 'nginx server adress :'
  docker inspect nginx | grep -i ipaddr | tail -1 | cut -d'"' -f4