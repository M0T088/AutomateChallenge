#! /bin/bash

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update

# install docker community edition
apt-cache policy docker-ce
sudo apt-get install -y docker-ce

# full permissions
sudo chmod 777 /var/run/docker.sock

# pull custom jenkins image
docker pull moto88/jenanssh:0.0.5

# run jenkins container
docker run --name jenkins -v /var/run/docker.sock:/var/run/docker.sock --group-add=$(stat -c %g /var/run/docker.sock) -v jenkins_home:/var/jenkins_home -v /usr/bin/docker:/usr/bin/docker -p 8080:8080 -d moto88/jenanssh:0.0.5