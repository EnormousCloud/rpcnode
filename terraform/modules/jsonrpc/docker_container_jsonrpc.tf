resource "docker_container" "jsonrpc" {
  image = docker_image.jsonrpc.latest
  name  = local.hostname
  restart = "always"

  log_opts = {
    "max-file" = "3"
    "max-size" = "100m"
  }

  env = local.env

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

  networks_advanced {
      name  = local.zone.network_public_id
  }
  
  labels {
    label = "project"
    value = local.project
  }

  labels {
    label = "host"
    value = local.host
  }

  labels {
    label = "role"
    value = "jsonrpc"
  }

  dynamic labels {
      for_each = local.labels
      content {
          label = labels.value.label
          value = labels.value.value
      }
  }
  
}

