.PHONY: up

up:
	./run.sh

down:
	docker kill apache1
	docker kill apache2
	docker kill apache3
	docker rm apache1
	docker rm apache2
	docker rm apache3
	docker kill express1
	docker kill express2
	docker kill express3
	docker rm express1
	docker rm express2
	docker rm express3
	docker kill nginx
	docker rm nginx
