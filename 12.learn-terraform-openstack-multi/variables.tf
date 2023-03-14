## Input variable definitions

variable "image" {
  default = "ubuntu-20.04.5"
}

# openstack flavor list
# m1.small m2g-d20g-1c
# m1.medium m4g-d40g-1c
variable "flavor" {
  default = "m1.small"
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

variable "instance_count" {
  default = 2
}

variable "instance_prefix" {
  default = "kube-node"
}
