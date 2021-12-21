locals {
    network_id = var.network_params.network_id
    project = var.network_params.project
    postfix = var.network_params.postfix

    hostname = "redis-${var.network_params.postfix}"
    ports = []
}