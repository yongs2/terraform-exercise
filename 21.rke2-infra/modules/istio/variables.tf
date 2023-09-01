## Input variable definitions

variable "app_name" {
  default = "istio"
}

variable "namespace" {
  default = "istio-system"
}

variable "repo_name" {
  default = "rancher-charts"
}

variable "chart_name" {
  default = "rancher-istio"
}

variable "chart_version" {
  default = "102.2.0+up1.17.2"
}

variable "project_id" {
  default = ""
}

variable "cluster_id" {
  default = ""
}

variable "external_ip_ranges" {
  default = ""
}
