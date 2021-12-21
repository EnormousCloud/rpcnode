variable network_params {
    type = object({
        network_id = string
        postfix = string
        project = string
        labels = list(object({
            label = string
            value = string
        }))
    })
}
