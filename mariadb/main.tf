terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
  }
}

provider "docker" {}

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

  env = [
    "MARIADB_ROOT_PASSWORD=secret",
    "MARIADB_DATABASE=project"
  ]

  volumes {
    volume_name    = "tf-mariadb-volume"
    container_path = "/docker-entrypoint-initdb.d/"
    host_path      = "/Users/ivan/workspace/sandbox/tf-metabase/mariadb/initdb.d/"
  }

  upload {
    file   = "/docker-entrypoint-initdb.d/init.sql"
    source = "/Users/ivan/workspace/sandbox/tf-metabase/mariadb/initdb.d/data.sql"
  }

  healthcheck {
    test         = ["CMD", "healthcheck.sh", "--connect", "--innodb_initialized"]
    interval     = "10s"
    retries      = 50
    start_period = "10s"
    timeout      = "5s"
  }
}
