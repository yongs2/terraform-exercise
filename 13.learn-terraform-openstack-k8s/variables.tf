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

variable "instance_count" {
  default = 1

  validation {
    condition = var.instance_count > 0
    // 에러 메시지는 instance_count 가 1보다 작을 때 출력
    error_message = "This application requires at least one instance."
  }
}

variable "instance_prefix" {
  default = "kube-node"
}

variable "fixed_ip_v4" {
  type = list(string)
  default = [
    "192.168.5.48",
    "192.168.5.59",
    "192.168.5.60",
  ]

  validation {
    condition     = length(var.fixed_ip_v4) <= 3
    error_message = "This application requires at least one fixed_ip_v4."
  }
}
