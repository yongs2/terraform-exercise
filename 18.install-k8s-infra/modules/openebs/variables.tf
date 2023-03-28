## Input variable definitions

variable "kube_config_path" {
  type        = string
  description = "kube config path"
}

variable "chart_version" {
  default = "3.5.0"
}

variable "namespace" {
  default = "openebs"
}
