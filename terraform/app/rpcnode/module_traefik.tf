module "traefik" {
  source = "../../modules/traefik"

  network_params = module.network.params
  https = var.https
  trusted_ips = var.trusted_ips
  hosted_zones = {
      for name, z in var.hosted_zones : name => {
            name = z.name
            host = z.host
            local_port = z.local_port
      }
  }
  # geoip_url = module.geoip.url
}
