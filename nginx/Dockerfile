FROM nginx:latest
COPY conf/default.conf /etc/nginx/conf.d/default.conf
COPY /var/jenkins_home/localhost.pem /etc/nginx/localhost.pem
COPY /var/jenkins_home/localhost-key.pem /etc/nginx/localhost-key.pem