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
variable "network" {
  type = object({
    name = string
  })
  default = {
    name = "management"
  }
}

variable "instance_prefix" {
  default = "kube-node"
}

variable "master_vm_count" {
  type    = number
  default = 1
}

variable "worker_vm_count" {
  type    = number
  default = 0
}

variable "http_proxy" {
  default = ""
}

variable "fixed_ip_v4" {
  type = list(string)
  default = [
    "192.168.5.48", // k8s-master-001
    "192.168.5.59", // k8s-master-002
    "192.168.5.60", // k8s-master-003
    "192.168.5.63", // k8s-worker-001
    "192.168.5.64", // k8s-worker-002
    "192.168.5.65", // k8s-worker-003
    "192.168.5.66", // ansible
    # "192.168.5.77", // metallb_ip_range
    # "192.168.5.78", // metallb_ip_range
    # "192.168.5.79", // metallb_ip_range
  ]
}

variable "metallb_ip_range" {
  type = string
  default = "192.168.5.77-192.168.5.79"
}