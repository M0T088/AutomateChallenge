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
                sleep(3)
                sh '''
                docker rm hello -f
                docker rmi nginxhello:0.0.1
                '''
            }
        }
        stage("Build a docker-compose nginx webserver") {
            steps {
                sh '''
				docker rm hello1 -f
				docker rm hello2 -f
                cp /var/jenkins_home/localhost.pem ${WORKSPACE}/nginx/localhost.pem
                cp /var/jenkins_home/localhost-key.pem ${WORKSPACE}/nginx/localhost-key.pem
                docker-compose up -d --build
                curl -k https://challenge.westeurope.cloudapp.azure.com | sed -e 's/<[^>]*>//g'
                curl -k https://challenge.westeurope.cloudapp.azure.com | sed -e 's/<[^>]*>//g'
                '''
                sleep(4)
                sh 'docker-compose down'
            }
        }
        stage("Build an ansible nginx webserver") {
            steps {
                sh '''
                ansible-playbook nginx.yml
                curl -k https://challenge.westeurope.cloudapp.azure.com | sed -e 's/<[^>]*>//g'
                curl -k https://challenge.westeurope.cloudapp.azure.com| sed -e 's/<[^>]*>//g'
                '''
                sleep(4)
                sh 'ansible-playbook remove.yml'
            }
        }
        stage("Build a terraform nginx webserver") {
            steps {
                sh '''
                terraform init
                terraform apply -auto-approve=true
                curl -k https://challenge.westeurope.cloudapp.azure.com | sed -e 's/<[^>]*>//g'
                curl -k https://challenge.westeurope.cloudapp.azure.com | sed -e 's/<[^>]*>//g'
                '''
                sleep(5)
                sh '''
                terraform destroy -auto-approve=true
                rm -rf localhost.pem
                rm -rf localhost-key.pem
                '''
            }
        }
    }
}