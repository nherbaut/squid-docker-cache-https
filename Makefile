DOCKER_IMAGE_ROOT:=nherbaut
COUNTRY:=FR
STATE:=Nouvelle Aquitaine
LOCATION:=Bordeaux
ORGANISATION:=nextnet.top
UNIT:=web
COMMON_NAME:=Nicolas Herbaut
.PHONY:= all init clean-cache cert build stop run

all: build init run

bootstrap:
	sudo mkdir -p squid-cache
	sudo mkdir -p squid-certs
	sudo rm -rf squid-cache/*
	sudo rm -rf squid-certs/*

init: stop clean-cache cert

clean-cache:
	sudo rm -rf ./squid-cache/*
	sudo docker run -p 1080:1080 -v "${PWD}/squid-certs:/etc/squid/ssl_cert" -v "${PWD}/squid-cache:/var/spool/squid" -v "${PWD}/squid.conf:/etc/squid/squid.conf:ro" -ti $(DOCKER_IMAGE_ROOT)/squid sh -c "chown squid:squid /var/spool/squid && squid  squid  -f /etc/squid/squid.conf --foreground -z"	

cert:
	sudo rm -fr squid-certs/* 
	sudo docker run  -v "${PWD}/squid-certs:/etc/squid/ssl_cert" $(DOCKER_IMAGE_ROOT)/squid sh -c 'openssl req -new -newkey rsa:2048 -sha256 -days 365 -nodes -x509 -extensions v3_ca -subj "/C=$(COUNTRY)/ST=$(STATE)/L=$(LOCATION)/O=$(ORGANISATION)/OU=$(UNIT)/CN=$(COMMON_NAME)" -keyout /etc/squid/ssl_cert/myCA.pem  -out /etc/squid/ssl_cert/myCA.pem && openssl x509 -in /etc/squid/ssl_cert/myCA.pem -outform DER -out /etc/squid/ssl_cert/myCA.der'

build:
	sudo docker build . -t $(DOCKER_IMAGE_ROOT)/squid

run: stop 
	docker run -p 1080:1080 --name squid -v "${PWD}/squid-certs:/etc/squid/ssl_cert" -v "${PWD}/squid-cache:/var/spool/squid" -v "${PWD}/squid.conf:/etc/squid/squid.conf:ro" -ti $(DOCKER_IMAGE_ROOT)/squid sh -c "chown squid:squid /var/spool/squid && squid  -f /etc/squid/squid.conf --foreground -s -d 5"

stop:
	sudo docker rm -f squid|true

	
