ifndef VERBOSE
	MAKEFLAGS += --no-print-directory
endif

default:


.out_docker:
# @todo check docker version
# @todo check docker-compose version
ifeq (, $(shell which docker))
	$(error "You must run this command outside the docker container")
endif


configure: .out_docker
	$(shell ./configure.sh)

reset_configuration: .out_docker
	rm -f ./.env

start: .out_docker configure
	@sudo docker-compose build --pull --parallel --quiet
	@make .up

.up: .out_docker
	@sudo docker-compose up \
	    --detach \
	    --remove-orphans \
	    --quiet-pull

stop: .out_docker
	@sudo docker-compose stop

remove: .out_docker
	@sudo docker-compose down --remove-orphans --volumes

restart: stop start

ps: .out_docker
	@sudo docker-compose ps



