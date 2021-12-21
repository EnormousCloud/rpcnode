resource "docker_image" traefik {
    name = "traefik:v2.3.4"
    keep_locally = true
}