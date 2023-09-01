## Input variable definitions

variable "rancher2_api_endpoint" {
  default = ""
}

variable "rancher2_access_key" {
  default = ""
}

variable "rancher2_secret_key" {
  default = ""
}

variable "master_ip_v4" {
  default = "192.168.5.59" // rke2-dev-001
}

variable "external_ip_ranges" {
  default = "192.168.5.64-192.168.5.66"
}

variable "rke2_dev" {
  default = "rke2-dev"
}

variable "kube_config_path" {
  default = "/tmp/rke2-dev.kubeconfig"
}
