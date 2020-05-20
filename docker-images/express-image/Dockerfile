FROM node:14.1.0

RUN apt-get update && \
	apt-get install vim

COPY src/ /opt/app

CMD ["node", "/opt/app/index.js"]
