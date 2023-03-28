## Input variable definitions
variable "private_key" {
  type = string
}

variable "master_vm_count" {
  type = number
}

variable "master_ips" {
  type = list(string)
}

