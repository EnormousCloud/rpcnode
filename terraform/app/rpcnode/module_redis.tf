module "redis" {
  source = "../../modules/redis"

  network_params = module.network.params
}