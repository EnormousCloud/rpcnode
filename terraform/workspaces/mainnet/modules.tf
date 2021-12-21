module "mainnet" {
    source = "../../app/rpcnode"
    project = "enormous"
    workspace = "mainnet"
    chain = "mainnet"
    https = 1

    hosted_zones = {
        "default" = {
            name = "default"
            host = "mainnet.enormous.cloud"
            local_port = 4080
        }
        "traefik" = {
            name = "traefik"
            host = "traefik.mainnet.enormous.cloud"
            local_port = 4081
        }
    }
    trusted_ips = ["77.87.40.167"]
    volume_exchange = "${path.cwd}/exchange"
}
