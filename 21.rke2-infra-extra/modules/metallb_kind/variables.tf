## Input variable definitions
variable "namespace" {
  default = "metallb-system"
}

variable "external_ip_ranges" {
  default = ""
}

variable "pool_name" {
  default = "loadbalanced"
}

variable "l2adver_name" {
  default = "l2adver"
}
