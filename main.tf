# Configure the Docker provider
provider "docker" {
  host = "unix:///var/run/docker.sock"
}

resource "docker_network" "nginxweb" {
  name = "nginxweb"
}

resource "docker_image" "nginx" {
  name = "nginx"
  keep_locally = true
}

resource "docker_container" "hello1" {
  image = docker_image.nginx.latest
  name = "hello1"
  volumes {
    host_path = "${abspath(path.root)}/hello1"
    container_path = "/usr/share/nginx/html"
    read_only = true
  }
  network_mode = "nginxweb"
} 

resource "docker_container" "hello2" {
  image = docker_image.nginx.latest
  name = "hello2"
  volumes {
    host_path = "${abspath(path.root)}/hello2"
    container_path = "/usr/share/nginx/html"
    read_only = true
  }
  network_mode = "nginxweb"
} 

resource "docker_container" "nginxlb" {
  image = docker_image.nginx.latest
  name = "nginxlb"
  volumes {
    host_path = "${abspath(path.root)}/nginx"
    container_path = "/etc/nginx"
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