## Input variable definitions

variable "app_name" {
  default = "metallb"
}

variable "namespace" {
  default = "metallb-system"
}

variable "repo_name" {
  default = "rancher-partner-charts"
}

variable "chart_name" {
  default = "metallb"
}

variable "chart_version" {
  default = "0.13.10"
}

variable "project_id" {
  default = ""
}

variable "cluster_id" {
  default = ""
}
