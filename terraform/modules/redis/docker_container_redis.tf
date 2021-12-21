resource "docker_container" "redis" {
  image = docker_image.redis.latest
  name  = local.hostname
  restart = "always"

  command = ["redis-server", "--appendonly", "yes"]

  log_opts = {
    "max-file" = "3"
    "max-size" = "100m"
  }

  dynamic ports {
      for_each = local.ports
      content {
          internal = ports.value.internal
          external = ports.value.external
      }
  }
  
  networks_advanced {
    name  = local.network_id
  }
  
  labels {
    label = "project"
    value = local.project
  }

  labels {
    label = "host"
    value = local.hostname
  }

  labels {
    label = "role"
    value = "redis"
  }
  
  volumes {
    volume_name = docker_volume.storage.name
    container_path = "/data"
  }
}

