terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
  }
}

provider "docker" {}

resource "docker_image" "metabase" {
  name         = "metabase/metabase"
  keep_locally = false
}

resource "docker_container" "metabase" {
  image = docker_image.metabase.image_id
  name  = "tf-metabase"

  ports {
    internal = 3000
    external = 3000
  }
}

resource "docker_image" "mariadb" {
  name         = "mariadb:latest"
  keep_locally = false
}

resource "docker_container" "mariadb" {
  image = docker_image.mariadb.image_id
  name  = "tf-mariadb"

  ports {
    internal = 3306
    external = 3306
  }

  env = ["MARIADB_ROOT_PASSWORD=secret"]
}
