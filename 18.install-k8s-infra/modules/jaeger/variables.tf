## Input variable definitions

variable "kube_config_path" {
  type        = string
  description = "kube config path"
}

variable "chart_version" {
  default = "0.69.1"
}

variable "namespace" {
  default = "jaeger"
}

variable "service_nodePort" {
  default = 32500
}
