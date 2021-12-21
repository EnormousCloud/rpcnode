output "params" {
  value = ({
    network_id = docker_network.internal.id,
    postfix = var.postfix,
    project = var.project,
    workspace = var.workspace,
    # env = var.env
    labels = [{
      label = "project"
      value = var.project
    }],
  })
}
