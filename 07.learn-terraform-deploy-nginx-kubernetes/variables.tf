## Input variable definitions

variable "kube_config_path" {
  type = string
  description = "kube config path"
}

variable "nginx_node_port" {
  type = number
  description = "nginx node port"
}
