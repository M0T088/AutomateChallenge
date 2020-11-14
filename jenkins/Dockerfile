FROM jenkins/jenkins:jdk11
USER root

RUN apt-get update && apt-get install -y && \
  
  # Installation von wget
  apt-get install -y wget && \
  
  # sshpass ist notwendig für ssh Befehle in Ansible
  apt-get install sshpass && \
  
  # Installation von Python 3.7 und dem Pip Modul
  apt-get install python3-pip -y && \
  
  # Installation von Terraform via wget
  wget https://releases.hashicorp.com/terraform/0.13.5/terraform_0.13.5_linux_amd64.zip && \
  unzip ./terraform_0.13.5_linux_amd64.zip -d /usr/local/bin/ && \
  rm terraform_0.13.5_linux_amd64.zip && \
  
  # Ansible Installation in der aktuellsten Version
  pip3 install ansible --upgrade && \
  
  # Docker SDK inkl. Docker CLI für Docker commands innerhalb von Jenkins
  pip3 install docker && \
  
  # Docker-compose
  pip3 install docker-compose && \
  
  # lxml ist relevant für die Ansible Galaxy Collection, um z.B. ein .war file von Nexus zu ziehen und zu deployen
  pip3 install lxml && \
  
  # Angesprochene Ansible Plugins, die Ansible um zahlreiche Befehle z.B. für Maven erweitern
  ansible-galaxy collection install community.general && \
  
  # Optionales Modul für Azure & Ansible, Funktion noch nicht getestet
  ansible-galaxy install Azure.azure_preview_modules && \
  pip3 install -r ~/.ansible/roles/Azure.azure_preview_modules/files/requirements-azure.txt && \
  
  # Letztes Update aller Pakete
  apt-get upgrade -y && \
  apt-get update

# Ansible Configuration Datei wird hinzugefügt - Mit dieser können verschiedene Warnings beispielsweise ausgeschaltet werden
COPY ansible/ansible.cfg etc/ansible/ansible.cfg

USER jenkins

ENV JENKINS_USER admin
ENV JENKINS_PASS admin
ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false
COPY default-user.groovy /usr/share/jenkins/ref/init.groovy.d/
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt

