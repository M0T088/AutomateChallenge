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
                curl http://hello:80
                docker rm hello -f
                docker rmi nginxhello:0.0.1
                '''
            }
        }
    }
}