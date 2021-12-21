resource "docker_container" traefik {
    name = local.hostname
    image = docker_image.traefik.latest
    restart = "always"

    dynamic ports {
        for_each = local.ports
        content {
            internal = ports.value.internal
            external = ports.value.external
        }
    }

    dynamic labels {
        for_each = local.labels_container
        content {
            label = labels.value.label
            value = labels.value.value
        }
    }

    command = local.command
    env = local.env
    log_opts = {
        "max-file" = "3"
        "max-size" = "100m"
    }
    
    networks_advanced {
        name  = docker_network.public.id
    }

    volumes {
        volume_name = docker_volume.certificates.name
        read_only = false
        container_path = "/certificates"
    }
    mounts {
        source = "/var/run/docker.sock"
        target = "/var/run/docker.sock"
        type      = "bind"
        read_only = true
    }
}
