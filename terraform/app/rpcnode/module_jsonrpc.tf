module "jsonrpc" {
  source = "../../modules/jsonrpc"

  network_params = module.network.params
  redis = module.redis.params
  zone = module.traefik.zone["default"]
  workspace = var.workspace
  proxy_url = module.openethereum.url
}

