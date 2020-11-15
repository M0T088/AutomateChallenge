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
  image = docker_image.hello.v1
  name = "hello1"
  ports {
    internal = "80"
  }
  network_mode = "nginxweb"
} 

# Create hello2 docker container 
resource "docker_container" "hello2" {
  image = docker_image.hello.v2
  name = "hello2"
  ports {
    internal = "80"
  }
  network_mode = "nginxweb"
}

# Create hello2 docker container 
resource "docker_container" "nginxlb" {
  image = docker_image.nginxloadbalancer.latest
  name = "nginxlb"
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
  network_mode = "nginxweb"
} 