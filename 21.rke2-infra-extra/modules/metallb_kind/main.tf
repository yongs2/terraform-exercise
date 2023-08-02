# kubectl apply -f ipaddresspool.yaml
resource "kubernetes_manifest" "ipaddresspool" {
  manifest = {
    "apiVersion" = "metallb.io/v1beta1"
    "kind"       = "IPAddressPool"
    "metadata" = {
      "name"      = var.pool_name
      "namespace" = var.namespace
    }
    "spec" = {
      "addresses" = [
        var.external_ip_ranges
      ]
    }
  }
}

# kubectl apply -f L2Advertisement.yaml
resource "kubernetes_manifest" "L2Advertisement" {
  manifest = {
    "apiVersion" = "metallb.io/v1beta1"
    "kind"       = "L2Advertisement"
    "metadata" = {
      "name"      = var.l2adver_name
      "namespace" = var.namespace
    }
    "spec" = {
      "ipAddressPools" = [
        var.pool_name
      ]
    }
  }
}
