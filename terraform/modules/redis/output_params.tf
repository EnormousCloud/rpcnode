output "params" {
  value = ({
    host = local.hostname,
    port = 6379,
    username = "",
    password = "",
    db = 0,
    tls = "",
  })
}
