## Input variable definitions

variable "app_name" {
  default = "etcd"
}

variable "namespace" {
  default = "etcd"
}

variable "repo_name" {
  default = "bitnami"
}

variable "chart_name" {
  default = "etcd"
}

variable "chart_version" {
  default = "9.0.5"
}

variable "project_id" {
  default = ""
}

variable "cluster_id" {
  default = ""
}

variable "replica_count" {
  default = 3
}

variable "storage_class" {
  default = ""
}

variable "node_port" {
  default = 31359
}
