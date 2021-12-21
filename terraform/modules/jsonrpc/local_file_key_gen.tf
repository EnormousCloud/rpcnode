resource "local_file" "key_gen" {
  content = <<EOF
#!/usr/bin/env bash
set -exu
docker run -it --rm \
    --network=${local.network_id} \
    --entrypoint /usr/src/app/jsonrpc-key \
    jsonrpc-gw \
    --redis-host ${var.redis.host} \
    gen \
    --app ${var.workspace} 
EOF

  filename = "./bin/key-gen.sh"
  file_permission = "0777"
}
