## Input variable definitions

variable "image" {
  default = "Rocky-8-GenericCloud-8.7"
}

variable "ssh_key_file" {
  default = "~/.ssh/id_rsa"
}

# openstack availability zone list
variable "availability_zone_name" {
  default = "server2"
}

# openstack network list
variable "network_name" {
  default = "management"
}

variable "instance_prefix" {
  default = "kube-node"
}

variable "fixed_ip_v4" {
  default = "192.168.5.48"
}

variable "snapshot" {
  default = "rocky-8-kubernetes-8.7-snapshot"
}
