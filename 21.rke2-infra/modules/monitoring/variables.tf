## Input variable definitions

variable "app_name" {
  default = "rancher-monitoring"
}

variable "namespace" {
  default = "cattle-monitoring-system"
}

variable "repo_name" {
  default = "rancher-charts"
}

variable "chart_name" {
  default = "rancher-monitoring"
}

variable "chart_version" {
  default = "102.0.1+up40.1.2"
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
