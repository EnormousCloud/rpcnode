module "rinkeby" {
    source = "../../app/rpcnode"
    project = "enormous"
    workspace = "rinkeby"
    chain = "rinkeby"
    #    engine = "geth" 
    https = 1
    bootnodes = "enode://a24ac7c5484ef4ed0c5eb2d36620ba4e4aa13b8c84684e1b4aab0cebea2ae45cb4d375b77eab56516d34bfbd3c1a833fc51296ff084b770b94fb9028c4d25ccf@52.169.42.101:30303"

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
