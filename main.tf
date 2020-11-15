# Configure the Docker provider
provider "docker" {
  host = "unix:///var/run/docker.sock"
}

# Create docker network "nginxweb"
resource "docker_network" "nginxweb" {
  name = "nginxweb"
}

# Use nginx docker image als resource without deleting it afterwards
resource "docker_image" "nginx" {
  name = "nginx"
  keep_locally = true
}

# Create hello1 docker container 
resource "docker_container" "hello1" {
  image = docker_image.nginx.latest
  name = "hello1"
  volumes {
    host_path = "${abspath(path.module)}/hello1"
    container_path = "/usr/share/nginx/html"
    read_only = true
  }
  ports {
    internal = "80"
  }
  network_mode = "nginxweb"
} 

# Create hello2 docker container
resource "docker_container" "hello2" {
  image = docker_image.nginx.latest
  name = "hello2"
  volumes {
    host_path = "${abspath(path.module)}/hello2"
    container_path = "/usr/share/nginx/html"
    read_only = true
  }
  ports {
    internal = "80"
  }
  network_mode = "nginxweb"
}

# Create nginx loadbalancer container to output at port 500 SSL
resource "docker_container" "nginxlb" {
  image = docker_image.nginx.latest
  name = "nginxlb"
  volumes {
    host_path = "${abspath(path.module)}/nginx"
    container_path = "/etc/nginx"
    read_only = true
  }
  network_mode = "nginxweb"
  ports {
    internal = "80"
    external = "80"
    protocol = "tcp"
    ip = "0.0.0.0"
  }
  ports {
    internal = "443"
    external = "500"
    protocol = "tcp"
    ip = "0.0.0.0"
  }
}