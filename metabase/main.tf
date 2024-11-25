terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
  }
}

provider "docker" {}

resource "docker_network" "tf-mb-network" {
  name   = "tf-mb-network"
  driver = "bridge"
}
