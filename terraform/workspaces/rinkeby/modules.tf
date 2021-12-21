module "rinkeby" {
    source = "../../app/rpcnode"
    project = "enormous"
    workspace = "rinkeby"
    chain = "rinkeby"
    engine = "geth" 
    https = 1

    hosted_zones = {
        "default" = {
            name = "default"
            host = "rinkeby.enormous.cloud"
            local_port = 4080
        }
        "traefik" = {
            name = "traefik"
            host = "rinkeby.kovan.enormous.cloud"
            local_port = 4081
        }
    }
    trusted_ips = ["0.0.0.0/32"]
    volume_exchange = "${path.cwd}/exchange"
}
