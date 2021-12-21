resource "local_file" "app_add" {
  content = <<EOF
#!/usr/bin/env bash
set -exu
docker run -it --rm \
    --network=${local.network_id} \
    --entrypoint /usr/src/app/jsonrpc-app \
    jsonrpc-gw \
    --redis-host ${var.redis.host} \
    add \
    --name ${var.workspace} \
    --url ${var.proxy_url}
EOF

  filename = "./bin/app-add.sh"
  file_permission = "0777"
}
