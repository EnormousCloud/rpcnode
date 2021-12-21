resource "docker_container" "eth" {
  image = docker_image.eth.latest
  name  = local.hostname
  restart = "always"

  command = local.command

  log_opts = {
    "max-file" = "3"
    "max-size" = "100m"
  }

  dynamic ports {
      for_each = local.ports
      content {
          internal = ports.value.internal
          external = ports.value.external
          protocol = ports.value.protocol
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
    value = "eth"
  }
  
  volumes {
    volume_name = docker_volume.storage.name
    read_only = false
    container_path = var.engine == "openethereum" ? "/home/openethereum/.local/share" : "/root"
  }
}

