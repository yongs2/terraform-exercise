## Input variable definitions

variable "kube_config_path" {
  type        = string
  description = "kube config path"
}

# openebs
variable "openebs" {
  type = object({
    chart_version = string
    namespace     = string
  })
  default = {
    chart_version = "3.5.0"
    namespace     = "openebs"
  }
}

# prometheus
variable "prometheus" {
  type = object({
    chart_version    = string
    namespace        = string
    storageClass     = string
    service_nodePort = number
  })
  default = {
    chart_version    = "20.0.2"
    namespace        = "prometheus"
    storageClass     = "openebs-hostpath"
    service_nodePort = 30111
  }
}

# grafana
variable "grafana" {
  type = object({
    chart_version    = string
    namespace        = string
    service_nodePort = number
  })
  default = {
    chart_version    = "6.52.4"
    namespace        = "prometheus"
    service_nodePort = 30697
  }
}

# istio
variable "istio" {
  type = object({
    chart_version = string
    namespace     = string
  })
  default = {
    chart_version = "1.17.1"
    namespace     = "istio-system"
  }
}

# jaeger
variable "jaeger" {
  type = object({
    chart_version    = string
    namespace        = string
    service_nodePort = number
  })
  default = {
    chart_version    = "0.69.1"
    namespace        = "jaeger"
    service_nodePort = 32500
  }
}
