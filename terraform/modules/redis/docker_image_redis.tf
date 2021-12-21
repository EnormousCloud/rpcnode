resource "docker_image" "redis" {
  name         = "redis"
  keep_locally = true
}