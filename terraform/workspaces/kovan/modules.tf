module "kovan" {
    source = "../../app/rpcnode"
    project = "enormous"
    workspace = "kovan"
    chain = "kovan"
    https = 1

    hosted_zones = {
        "default" = {
            name = "default"
            host = "kovan.enormous.cloud"
            local_port = 4080
        }
        "traefik" = {
            name = "traefik"
            host = "traefik.kovan.enormous.cloud"
            local_port = 4081
        }
    }
    trusted_ips = ["0.0.0.0/32"]
    volume_exchange = "${path.cwd}/exchange"
}
