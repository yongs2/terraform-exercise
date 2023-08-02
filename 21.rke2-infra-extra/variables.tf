## Input variable definitions
variable "external_ip_ranges" {
  default = "192.168.5.64-192.168.5.66"
}

variable "kube_config_path" {
  default = "/tmp/rke2-dev.kubeconfig"
}
