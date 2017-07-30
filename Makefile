####################
#  DOCKER NETWORK  #
####################

NETWORK_NAME=jenkins

network-create:
	docker network create $(NETWORK_NAME)

####################
#  JENKINS MASTER  #
####################

MASTER_NAME=jenkins-master
MASTER_CONTAINER_NAME=jenkins-master
TIMEZONE=UTC

master-run:
	docker run -d --name $(MASTER_CONTAINER_NAME) -p 8080:8080 -p 50000:5000 -e JAVA_OPTS=-Dorg.apache.commons.jelly.tags.fmt.timeZone=$(TIMEZONE) -P jenkins
	docker network connect $(NETWORK_NAME) $(MASTER_CONTAINER_NAME)


##################
#  JENKINS NODE  #
##################

NODE_IMAGE_NAME=jenkins-node
NODE_CONTAINER_NAME=jenkins-node

node-build:
	docker build -t $(NODE_IMAGE_NAME):latest node

node-run: node-build
	docker run -d --name $(NODE_CONTAINER_NAME) --init -P $(NODE_IMAGE_NAME)
	docker network connect $(NETWORK_NAME) $(NODE_CONTAINER_NAME)

node-get-pivate-key:
	@docker cp `docker inspect jenkins-node | jq -r .[0].Id`:/home/jenkins/.ssh/id_rsa jenkins.pem
	@chmod 600 jenkins.pem

node-ssh: node-get-pivate-key
	@ssh -i jenkins.pem -p `docker inspect jenkins-node | jq -r '.[0].NetworkSettings.Ports."22/tcp"[].HostPort'` jenkins@localhost
	@unlink jenkins.pem
