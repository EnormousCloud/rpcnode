module "goerli" {
    source = "../../app/rpcnode"
    project = "enormous"
    workspace = "goerli"
    chain = "goerli"
    engine = "geth" // goerli doesn't work with parity for some reason
    https = 1

    hosted_zones = {
        "default" = {
            name = "default"
            host = "goerli.enormous.cloud"
            local_port = 4080
        }
        "traefik" = {
            name = "traefik"
            host = "traefik.goerli.enormous.cloud"
            local_port = 4081
        }
    }
    trusted_ips = ["0.0.0.0/32"]
    volume_exchange = "${path.cwd}/exchange"
}
