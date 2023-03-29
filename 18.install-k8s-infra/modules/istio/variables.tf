## Input variable definitions

variable "kube_config_path" {
  type        = string
  description = "kube config path"
}

variable "chart_version" {
  default = "1.17.1"
}

variable "namespace" {
  default = "istio-system"
}
