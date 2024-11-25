resource "docker_image" "metabase" {
  name         = var.metabase_image
  keep_locally = false
}

resource "docker_container" "metabase" {
  image = docker_image.metabase.image_id
  name  = "tf-metabase"

  ports {
    internal = 3000
    external = 3000
  }

  env = [
    "MB_DB_TYPE=postgres",
    "MB_DB_DBNAME=metabaseappdb",
    "MB_DB_PORT=5432",
    "MB_DB_USER=metabase",
    "MB_DB_PASS=my-secret-password123",
    "MB_DB_HOST=postgres",
    "MB_DB_FILE=/metabase-data/metabase.db"
  ]

  volumes {
    volume_name    = "tf-metabase-random"
    container_path = "/dev/random"
    host_path      = "/dev/urandom"
    read_only      = true
  }

  volumes {
    volume_name    = "tf-metabase-data"
    container_path = "/metabase-data"
  }

  healthcheck {
    test     = ["curl", "--fail", "-I", "--innodb_initialized", "http://localhost:3000/api/health || exit 1"]
    interval = "15s"
    retries  = 5
    timeout  = "5s"
  }

  networks_advanced {
    name = docker_network.tf-mb-network.name
  }
}
