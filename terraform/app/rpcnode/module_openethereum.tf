module "openethereum" {
  source = "../../modules/openethereum"

  network_params = module.network.params
  chain = var.chain
  engine = var.engine
}

