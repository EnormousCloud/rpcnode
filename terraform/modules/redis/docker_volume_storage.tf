resource "docker_volume" storage {
  name = "${local.project}-redis-storage-${local.postfix}"
}
