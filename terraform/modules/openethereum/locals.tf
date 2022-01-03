locals {
    network_id = var.network_params.network_id
    project = var.network_params.project
    postfix = var.network_params.postfix

    hostname = "eth-${var.network_params.postfix}"
    ports = [
        {
            protocol = "tcp" 
            internal = 3000
            external = 3000
        },
        {
            protocol = "udp" 
            internal = 30303
            external = 30303
        },
        {
            protocol = "tcp" 
            internal = 30303
            external = 30303
        }
    ]
    snapshots = var.chain != "kovan"
    command = var.engine == "openethereum" ? concat([
        "--jsonrpc-interface", "all",
        "--jsonrpc-cors", "all",
        "--no-ws",
        "--no-secretstore",
        "--no-ipc",
        "--chain", var.chain
    ], 
        var.ancient ? [] : ["--no-ancient-blocks" ], 
        var.metrics ? [ "--metrics", "--metrics-interface", "all" ] : [],
        var.bootnodes == "" ? [] : ["--bootnodes", "${var.bootnodes}"], 
    ) : concat(
        var.chain == "mainnet" ? ["--mainnet"] : [],
        var.chain == "goerli" ? ["--goerli"] : [],
        var.chain == "rinkeby" ? ["--rinkeby"] : [],
        var.chain == "ropsten" ? ["--ropsten"] : [],
        var.chain == "kovan" ? ["--networkid", "42"] : [], 
        var.chain == "sepolia" ? ["--sepolia"] : [],
        var.bootnodes == "" ? [] : ["--bootnodes", "${var.bootnodes}"], 
        local.snapshots ? [] : ["--syncmode=snap"],
        [
            "--http", 
            "--http.addr", "0.0.0.0", 
            "--http.api", "eth,net,web3",
            "--http.vhosts", "*",
        ],
        var.metrics ? [ "--pprof" , "--metrics" ] : [],
    )
}
