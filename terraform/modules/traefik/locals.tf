locals {
    project = var.network_params.project
    postfix = var.network_params.postfix
    network_internal_id = var.network_params.network_id

    shortname = "api"
    hostname = "traefik-${local.postfix}"
    entrypoint = var.https == 1 ? "https" : "traefik"
    host = var.https == 1 ? "${var.hosted_zones["traefik"].host}" : "localhost"

    middlewares = "trusted"
}

locals {
    ports_localhost = [
        for z in var.hosted_zones : {
            internal = z.local_port
            external = z.local_port
        }
    ]
    ports_multihost = [{
        internal = 80
        external = 80
    },{
        internal = 443
        external = 443
    }]
    ports = var.https == 1 ? local.ports_multihost: local.ports_localhost
}

locals {
    labels_all_zones = [
        {
            label = "traefik.enable"
            value = "true"
        }, {
            label = "traefik.docker.network"
            value = docker_network.public.name
        }, {
            label = "traefik.constraint-label"
            value = docker_network.public.name
        }
    ]
}

locals {
    zone = {
        for name, z in var.hosted_zones : name => {
            "network_internal_id" = local.network_internal_id
            "network_public_id" = docker_network.public.id
            "network_public_name" = docker_network.public.name
            "postfix" = local.postfix
            "project" = local.project
            "name" = z.name
            "host" = var.https == 1 ? z.host : "localhost"
            "entrypoint" = var.https == 1 ? "https" : z.name
            "local_port" = z.local_port
            "https" = var.https
            "labels" = local.labels_all_zones
        }
    }

    labels_service = [
        {
             label = "traefik.http.routers.${local.shortname}.rule"
             value = "Host(`${local.host}`)"
        },
        {
             label = "traefik.http.routers.${local.shortname}.entrypoints"
             value = local.zone["traefik"].entrypoint
        },
        {
             label = "traefik.http.routers.${local.shortname}.service"
             value = "api@internal"
        },
        {
             label = "traefik.http.routers.${local.shortname}.tls"
             value = "true"
        },
        {
             label = "traefik.http.routers.${local.shortname}.tls.certresolver"
             value = "le"
        },
	{
             label = "traefik.http.routers.${local.shortname}.middlewares"
             value = local.middlewares
        }
    ]

    labels_middleware_compress = [
        {
	        label = "traefik.http.middlewares.compress.compress"
            value = "true"
        }
    ]

    labels_middleware_trusted = [
        {
	        label = "traefik.http.middlewares.trusted.ipwhitelist.sourcerange"
            value = join(", ", var.trusted_ips)
        }
    ]

    # labels_middleware_geo = [
    #     {
    #          label = "traefik.http.middlewares.geo.forwardauth.address"
    #          value = var.geoip_url
    #     },
    #     {
    #          label = "traefik.http.middlewares.geo.forwardauth.trustForwardHeader"
    #          value = "true"
    #     },
    #     {
    #          label = "traefik.http.middlewares.geo.forwardauth.authResponseHeaders"
    #          value = "X-Real-Ip, X-Country-Code, X-Country-EN-Name, X-City-EN-Name, X-Location-Lat, X-Location-Lon"
    #     }
    # ]

}

locals {
    labels_container = concat(
        var.network_params.labels,
        local.zone["traefik"].labels,
        local.labels_service,
        local.labels_middleware_trusted,
        local.labels_middleware_compress,
        # var.geoip_url == "" ? [] : local.labels_middleware_geo,
    )
    entrypoints_localhost = flatten([
        for name, z in var.hosted_zones : [
            "--entrypoints.${z.name}.address=:${z.local_port}",
            # "--metrics.prometheus.entrypoint=${z.name}",
        ]
    ])
    entrypoints_multihost = [
        "--entrypoints.http.address=:80",
        "--entrypoints.https.address=:443",
        "--entrypoints.http.http.redirections.entrypoint.to=https",
        "--entrypoints.http.http.redirections.entrypoint.scheme=https",
        "--entrypoints.http.http.redirections.entrypoint.permanent=true",
        # "--metrics.prometheus.entrypoint=http",
        # "--metrics.prometheus.entrypoint=https",
    ]

    entrypoints = var.https == 1 ? local.entrypoints_multihost: local.entrypoints_localhost

    tracing = [ 
        "--tracing=false",
        // "--tracing.jaeger.samplingServerURL=http://localhost:5778/sampling",
        // "--tracing.jaeger.samplingType=const",
        // "--tracing.jaeger.samplingParam=1.0"
        // "--tracing.jaeger.localAgentHostPort=127.0.0.1:6831",
        // "--tracing.jaeger.propagation=jaeger"
        // "--tracing.jaeger.traceContextHeaderName=uber-trace-id",
        //"--tracing.jaeger.collector.endpoint=http://localhost:14268/api/traces?format=jaeger.thrift",
        // "--tracing.jaeger.collector.user=my-user",
        // "--tracing.jaeger.collector.password=my-password",
    ]
}

locals {
    env = [
        "LOGSPOUT=ignore",
    ]

    command = compact(concat(
        local.entrypoints,
        local.tracing,
        var.https == 1 ? [
            "--certificatesresolvers.le.acme.email=${var.admin_email}",
            "--certificatesresolvers.le.acme.storage=/certificates/acme.json",
            "--certificatesresolvers.le.acme.tlschallenge=true",
        ] : [
            "--api.insecure=true",
            "--log.level=DEBUG",
            # "--metrics.prometheus.addentrypointslabels=true"
        ], 
        [
            "--providers.docker",
            "--providers.docker.constraints=Label(`traefik.constraint-label`, `${docker_network.public.name}`)",
            "--providers.docker.exposedbydefault=false",
            "--accesslog=true",
            "--accesslog.bufferingsize=10",
            "--api=true",
            "--api.debug=true",
            "--api.dashboard=true",
            "--log",
            "--log.format=json",
        ])
    )
}
