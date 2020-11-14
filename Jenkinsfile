pipeline {
    agent any
    stages {
        stage("Build a nginx docker webserver port 80") {
            steps {
                sh '''
				docker rm hello -f
                docker build -t nginxhello:0.0.1 .
                docker run --name hello -d -p 80:80 nginxhello:0.0.1
				curl http://40.113.153.104:80
                '''
                sleep(2)
                sh '''
                docker rm hello -f
                docker rmi nginxhello:0.0.1
                '''
            }
        }
        stage("Build a docker-compose nginx webserver") {
            steps {
                sh '''
                cp /var/jenkins_home/localhost.pem ${WORKSPACE}/nginx/localhost.pem
                cp /var/jenkins_home/localhost-key.pem ${WORKSPACE}/nginx/localhost-key.pem
                docker-compose up -d --build
                '''
                sleep(15)
                sh 'docker-compose down'
            }
        }
        stage("Build an ansible nginx webserver") {
            steps {
                sh 'ansible-playbook nginx.yml'
                sleep(15)
                sh 'ansible-playbook remove.yml'
            }
        }
        stage("Build a terraform nginx webserver") {
            steps {
                sh '''
                terraform init
                terraform apply -auto-approve=true
                '''
                sleep(15)
                sh '''
                terraform destroy -auto-approve=true
                rm -rf localhost.pem
                rm -rf localhost-key.pem
                '''
            }
        }
    }
}