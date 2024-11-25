resource "docker_image" "mariadb" {
  name         = var.mariadb_image
  keep_locally = false
}

resource "docker_container" "mariadb" {
  image    = docker_image.mariadb.image_id
  name     = "tf-mariadb"
  hostname = "mariadb-fms"

  ports {
    internal = 3306
    external = 3306
  }

  env = [
    "MARIADB_ROOT_PASSWORD=secret",
    "MARIADB_DATABASE=adops"
  ]

  volumes {
    volume_name    = "tf-mariadb-volume"
    container_path = "/docker-entrypoint-initdb.d/"
  }

  upload {
    file   = "/docker-entrypoint-initdb.d/init.sql"
    source = "/tmp/data.sql"
  }

  healthcheck {
    test         = ["CMD", "healthcheck.sh", "--connect", "--innodb_initialized"]
    interval     = "10s"
    retries      = 50
    start_period = "10s"
    timeout      = "5s"
  }

  networks_advanced {
    name = docker_network.tf-mb-network.name
  }
}
