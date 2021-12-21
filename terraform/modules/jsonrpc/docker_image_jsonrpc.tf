resource "docker_image" "jsonrpc" {
  name         = "jsonrpc-gw:latest"
  keep_locally = true
}