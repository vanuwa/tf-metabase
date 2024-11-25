terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
  }
}

provider "docker" {}

resource "docker_image" "ubuntu" {
  name         = "ubuntu"
  keep_locally = false
}

resource "docker_container" "ubuntu" {
  image = docker_image.ubuntu.image_id
  name  = "tf-ubuntu"
  tty   = true

  mounts {
    type   = "bind"
    target = "/root/test"
    source = "/tmp/tf-metabase/sandbox/test"
  }
}
