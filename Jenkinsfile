pipeline {
    agent any
    stages {
        stage("Build a nginx docker webserver port 80") {
            steps {
                sh '''
                docker build -t nginxhello:0.0.1 .
                docker run --name hello -d -p 80:80 nginxhello:0.0.1
				curl -s challenge.westeurope.cloudapp.azure.com | sed -e 's/<[^>]*>//g'
                '''
                sleep(6)
                sh '''
                docker rm hello -f
                docker rmi nginxhello:0.0.1
                '''
            }
        }
        stage("Build a docker-compose nginx webserver") {
            steps {
                sh '''
                cp /var/jenkins_home/nginxcert.pem ${WORKSPACE}/nginx/nginxcert.pem
                cp /var/jenkins_home/nginxkey.pem ${WORKSPACE}/nginx/nginxkey.pem
                docker-compose up -d --build
                curl -k https://challenge.westeurope.cloudapp.azure.com:500 | sed -e 's/<[^>]*>//g'
                curl -k https://challenge.westeurope.cloudapp.azure.com:500 | sed -e 's/<[^>]*>//g'
                '''
                sleep(8)
                sh 'docker-compose down'
            }
        }
        stage("Build an ansible nginx webserver") {
            steps {
                sh '''
                ansible-playbook nginx.yml
                curl -k https://challenge.westeurope.cloudapp.azure.com:500 | sed -e 's/<[^>]*>//g'
                curl -k https://challenge.westeurope.cloudapp.azure.com:500 | sed -e 's/<[^>]*>//g'
                '''
                sleep(8)
                sh 'ansible-playbook remove.yml'
            }
        }
        stage("Build a terraform nginx webserver") {
            steps {
                sh '''
                terraform init
                terraform apply -auto-approve=true
                curl http://challenge.westeurope.cloudapp.azure.com:8081 | sed -e 's/<[^>]*>//g'
                curl http://challenge.westeurope.cloudapp.azure.com:8082 | sed -e 's/<[^>]*>//g'
                '''
                sleep(9)
                sh '''
                terraform destroy -auto-approve=true
                rm -rf nginxcert.pem
                rm -rf nginxkey.pem
                '''
            }
        }
    }
}