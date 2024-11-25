resource "docker_image" "mongo" {
  name         = var.mongo_image
  keep_locally = false
}

resource "docker_container" "mongo" {
  image    = docker_image.mongo.image_id
  name     = "tf-mb-mongo"
  hostname = "mongo"

  volumes {
    volume_name    = "tf-mongo-data"
    container_path = "/data/db"
  }

  networks_advanced {
    name = docker_network.tf-mb-network.name
  }

  ports {
    internal = 27017
    external = 27017
  }
}
