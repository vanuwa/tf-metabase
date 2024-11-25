resource "docker_image" "postgres" {
  name         = var.postgres_image
  keep_locally = false
}

resource "docker_container" "postgres" {
  image    = docker_image.postgres.image_id
  name     = "tf-mb-postgres"
  hostname = "postgres"

  env = [
    "POSTGRES_DB=metabaseappdb",
    "POSTGRES_USER=metabase",
    "POSTGRES_PASSWORD=my-secret-password123"
  ]

  volumes {
    volume_name    = "tf-postgres-data"
    container_path = "/var/lib/postgresql/data"
  }

  networks_advanced {
    name = docker_network.tf-mb-network.name
  }
}
