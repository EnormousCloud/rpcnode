locals {
    network_id = var.network_params.network_id
    project = var.network_params.project
    postfix = var.network_params.postfix
    zone = var.zone

    // external network:
    shortname = "jsonrpc"
    middleware_rewrite = "rpc-stripprefix"
    hostname = "${local.shortname}-${local.postfix}"
    entrypoint = var.zone.entrypoint
    route = local.shortname
    path = "/rpc/"
    service_port = 8000
    middlewares = "compress,${local.middleware_rewrite}"
    scheme = var.zone.https == 1 ? "https": "http"
    host = var.zone.https == 1 ? var.zone.host : "localhost"
    port = var.zone.https == 1 ? "" : ":${var.zone.local_port}"
    url = "${local.scheme}://${local.host}${local.port}"
}

locals {
    env = [
        "APPLICATION=${var.workspace}",
        "REDIS_HOST=${var.redis.host}",
        "REDIS_PORT=${var.redis.port}",
        "REDIS_USERNAME=${var.redis.username}",
        "REDIS_PASSWORD=${var.redis.password}",
        "REDIS_DB=${var.redis.db}",
        "REDIS_TTL=${var.redis.tls}",
    ]
    ports = []

    labels_https = [{
        label = "traefik.http.routers.${local.route}.entrypoints"
        value = "https"
    }, {
        label = "traefik.http.routers.${local.route}.tls"
        value = "true"
    }, {
        label = "traefik.http.routers.${local.route}.tls.certresolver"
        value = "le"
    }]
    labels_entrypoint = [
        {
            label = "traefik.http.routers.${local.route}.rule"
            value = "Host(`${local.host}`) && PathPrefix(`${local.path}`)"
        },
        {
            label = "traefik.http.routers.${local.route}.entrypoints"
            value = local.entrypoint
        }
    ]
    labels_service = [
        {
            label = "traefik.http.routers.${local.route}.service"
            value = "${local.shortname}@docker"
        },
        {
            label = "traefik.http.services.${local.shortname}.loadbalancer.server.port"
            value = local.service_port
        }
    ]
    labels_strip_prefix = [
         {
            label = "traefik.http.middlewares.${local.middleware_rewrite}.stripprefix.prefixes"
            value = local.path
        }
    ]

    labels = concat(
        var.network_params.labels,
        var.zone.labels,
        local.labels_entrypoint,
        local.labels_service,
        var.zone.https == 1 ? local.labels_https : [],
        local.labels_strip_prefix,
        [{
            label = "traefik.http.routers.${local.route}.middlewares"
            value = local.middlewares
        }, {
            label = "role"
            value = local.shortname
        }]
    )
}

