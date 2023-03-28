## Input variable definitions

variable "kube_config_path" {
  type        = string
  description = "kube config path"
}

variable "chart_version" {
  default = "20.0.2"
}

variable "namespace" {
  default = "prometheus"
}

variable "storageClass" {
  default = "openebs-hostpath"
}

variable "service_nodePort" {
  default = 30111
}
