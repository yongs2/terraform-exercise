## Input variable definitions

variable "image" {
  type = string
}

variable "private_key" {
  type = string
}

# openstack availability zone list
variable "availability_zone_name" {
  default = "server2"
}

# openstack network list
variable "network_name" {
  type = string
}

variable "flavor_id" {
  type = string
}

variable "key_pair" {
  type = string
}

variable "master_ips" {
  type = string
}

variable "worker_ips" {
  type = string
}

variable "http_proxy" {
  default = ""
}

variable "fixed_ip_v4" {
  type = string
}

variable "metallb_ip_range" {
  type = string
}

variable "kubespray_version" {
  type = string
}