module "ropsten" {
    source = "../../app/rpcnode"
    project = "enormous"
    workspace = "ropsten"
    chain = "ropsten"
    bootnodes = "enode://6332792c4a00e3e4ee0926ed89e0d27ef985424d97b6a45bf0f23e51f0dcb5e66b875777506458aea7af6f9e4ffb69f43f3778ee73c81ed9d34c51c4b16b0b0f@52.232.243.152:30303,enode://94c15d1b9e2fe7ce56e458b9a3b672ef11894ddedd0c6f247e0f1d3487f52b66208fb4aeb8179fce6e3a749ea93ed147c37976d67af557508d199d9594c35f09@192.81.208.223:30303"
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
