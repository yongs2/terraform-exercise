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

# openstack subnet list
variable "subnet" {
  type = object({
    name = string
  })
  default = {
    name = "management"
  }
}

variable "instance_prefix" {
  default = "kubespray"
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
    # "192.168.5.64", // k8s-worker-002
    # "192.168.5.65", // k8s-worker-003
    # "192.168.5.66", // ansible
    # "192.168.5.77", // metallb_ip_range
    # "192.168.5.78", // metallb_ip_range
    # "192.168.5.79", // metallb_ip_range
  ]
}

# The list of IP addresses to be used by metallb must also be set in the allowed_address_pairs of the openstack port.
variable "allowed_address_pairs" {
  type = list(string)
  default = [
    "192.168.5.64",
    "192.168.5.65",
    "192.168.5.66"
  ]
}

# Range of IP addresses to be used by metallb
variable "metallb_ip_range" {
  type    = string
  default = "192.168.5.64-192.168.5.66"
}

# KUBE_SPRAY_VER=`curl -s "https://api.github.com/repos/kubernetes-sigs/kubespray/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/'`
# echo "KUBE_SPRAY_VER=${KUBE_SPRAY_VER}"
variable "kubespray_version" {
  type    = string
  default = "v2.21.0"

  # kubespray tag / kuberntes version
  # master        / v1.26.3
  # v2.21.0       / v1.25.6
  # v2.19.1       / v1.23.7 / ansible-playbook -b -i nef-cluster/inventory.ini .kubespray/cluster.yml -e kube_version=v1.23.5 -e @nef-cluster/extra.ini -v
  # v2.19.0       / v1.23.7
  # v2.18.2       / v1.22.8
  # v2.18.1       / v1.22.8
  # v2.18.0       / v1.22.5
}

variable "output_dir" {
  type    = string
  default = "./"
}
