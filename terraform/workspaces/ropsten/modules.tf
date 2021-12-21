module "ropsten" {
    source = "../../app/rpcnode"
    project = "enormous"
    workspace = "ropsten"
    chain = "ropsten"
    # engine = "geth" 
    https = 1

    hosted_zones = {
        "default" = {
            name = "default"
            host = "ropsten.enormous.cloud"
            local_port = 4080
        }
        "traefik" = {
            name = "traefik"
            host = "traefik.ropsten.enormous.cloud"
            local_port = 4081
        }
    }
    trusted_ips = ["77.87.40.167"]
    volume_exchange = "${path.cwd}/exchange"
}
