## Input variable definitions

variable "app_name" {
  default = "redis"
}

variable "namespace" {
  default = "redis"
}

variable "repo_name" {
  default = "bitnami"
}

variable "chart_name" {
  default = "redis-cluster"
}

variable "chart_version" {
  default = "8.6.9"
}

variable "project_id" {
  default = ""
}

variable "cluster_id" {
  default = ""
}

variable "storage_class" {
  default = ""
}
