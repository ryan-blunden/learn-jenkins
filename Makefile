####################
#  DOCKER NETWORK  #
####################

NETWORK_NAME=jenkins

network-create:
	--ignore-errors docker network create $(NETWORK_NAME)

####################
#  JENKINS MASTER  #
####################

MASTER_NAME=jenkins-master
MASTER_CONTAINER_NAME=jenkins-master
TIMEZONE=UTC

master-run: network-create
	docker run -d --name $(MASTER_CONTAINER_NAME) -p 8080:8080 -p 50000:5000 -e JAVA_OPTS=-Dorg.apache.commons.jelly.tags.fmt.timeZone=$(TIMEZONE) -P jenkins
	docker network connect $(NETWORK_NAME) $(MASTER_CONTAINER_NAME)


##################
#  JENKINS NODE  #
##################

NODE_IMAGE_NAME=jenkins-node
NODE_CONTAINER_NAME=jenkins-node

node-build:
	docker build -t $(NODE_IMAGE_NAME):latest node

node-run: node-build network-create
	docker run -d --name $(NODE_CONTAINER_NAME) --init -P $(NODE_IMAGE_NAME)
	docker network connect $(NETWORK_NAME) $(NODE_CONTAINER_NAME)

node-get-private-key:
	@docker exec `docker inspect jenkins-node | jq -r .[0].Id` cat /home/jenkins/.ssh/id_rsa	

node-ssh:
	@docker cp `docker inspect jenkins-node | jq -r .[0].Id`:/home/jenkins/.ssh/id_rsa ./jenkins.pem
	@chmod 600 jenkins.pem
	@ssh -i jenkins.pem -p `docker inspect jenkins-node | jq -r '.[0].NetworkSettings.Ports."22/tcp"[].HostPort'` jenkins@localhost
	@unlink jenkins.pem

node-ssh-root:
	docker exec -it jenkins-node bash
	
##############
#  DEV NODE  #
##############

DEV_IMAGE_NAME=dev-node
DEV_CONTAINER_NAME=dev-node

dev-node-build:
	docker build -t $(DEV_IMAGE_NAME):latest dev

dev-node-run: dev-node-build
	docker run -di \
		--name $(DEV_CONTAINER_NAME) \
		-v $(APP_PATH):/usr/src/app \
		-p 8081:8080 \
		$(DEV_IMAGE_NAME)

dev-node-terminal:
	docker exec -it $(DEV_CONTAINER_NAME) bash

dev-node-start:
	docker start $(DEV_CONTAINER_NAME)

dev-node-stop:
	docker stop $(DEV_CONTAINER_NAME)

dev-node-remove:
	docker rm -f $(DEV_CONTAINER_NAME)


###############
#  UTILITIES  #
###############

ssh-key:
	mkdir -p ~/.ssh && \
    chmod 700 ~/.ssh && \
    cd ~/.ssh && \
    ssh-keygen -t rsa -b 4096 -f id_rsa -N "" -C "dev@node" && \
    cat id_rsa.pub > authorized_keys && \
    chmod 600 authorized_keys
