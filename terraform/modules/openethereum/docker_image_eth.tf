resource "docker_image" "eth" {
  name         = var.engine == "openethereum" ? "openethereum/openethereum": "ethereum/client-go"
  keep_locally = true
}