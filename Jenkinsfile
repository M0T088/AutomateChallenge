pipeline {
    agent any
    stages {
        stage("Build a nginx docker webserver port 80") {
            steps {
                sh '''
                docker build -t nginxhello:0.0.1 .
                docker run --name hello -d -p 80:80 nginxhello:0.0.1
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
                cp /var/jenkins_home/localhost.pem ${WORKSPACE}/localhost.pem
                cp /var/jenkins_home/localhost-key.pem ${WORKSPACE}/localhost-key.pem
                docker-compose up -d --build
                '''
                sleep(15)
                sh 'docker-compose down'
            }
        }
    }
}