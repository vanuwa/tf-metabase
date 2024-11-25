variable "metabase_image" {
  type        = string
  default     = "metabase/metabase:v0.51.2"
  description = "Metabase Docker image"
}

variable "postgres_image" {
  type        = string
  default     = "postgres:17"
  description = "PostgreSQL Docker image"
}

variable "mongo_image" {
  type        = string
  default     = "mongo:8"
  description = "MongoDB Docker image"
}

variable "mariadb_image" {
  type        = string
  default     = "mariadb:11"
  description = "MariaDB Docker image"
}
