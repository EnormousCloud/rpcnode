resource "docker_volume" storage {
  name = "${local.project}-eth-storage-${local.postfix}"
}
