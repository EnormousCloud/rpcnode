variable redis {
    type = object({
        host = string
        port = number
        username = string
        password = string
        db = number
        tls = string
    })
}