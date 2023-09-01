## Input variable definitions

variable "image" {
  default = "ubuntu-20.04.5"
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

variable "subnet_name" {
  default = "management"
}

variable "fixed_ip_v4" {
  default = "192.168.5.48"
}

variable "allowed_address_pairs" {
  type = list(string)
  default = [
    "192.168.5.59",
    "192.168.5.60",
    "192.168.5.63",
    "192.168.5.64",
    "192.168.5.65"
  ]
}
