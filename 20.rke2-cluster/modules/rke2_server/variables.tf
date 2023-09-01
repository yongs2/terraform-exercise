## Input variable definitions

variable "cluster_name" {
  default = "rke2-dev"
}

variable "private_key" {
  type = string
}

variable "instance_prefix" {
  default = "rke2-instance"
}

variable "vm_count" {
  type = number
}

variable "fixed_ip_v4" {
  type = list(string)
}

variable "private_container_registries" {
  description = "private_container_registries"
  type = list(object({
    name                 = string
    endpoint             = string
    username             = string
    password             = string
    insecure_skip_verify = bool
  }))
  default = []
}

variable "kube_config_path" {
  default = ""
}