# set config of provider kubernetes
provider "kubernetes" {
  config_path = var.kube_config_path
}

# create namespace nginx
resource "kubernetes_namespace" "test" {
  metadata {
    name = "nginx"
  }
}

# create deployment nginx
resource "kubernetes_deployment" "test" {
  metadata {
    name      = "scalable-nginx-example"
    namespace = kubernetes_namespace.test.metadata.0.name
    labels = {
      App = "ScalableNginxExample"
    }
  }
  spec {
    replicas = 2
    selector {
      match_labels = {
        app = "ScalableNginxExample"
      }
    }
    template {
      metadata {
        labels = {
          app = "ScalableNginxExample"
        }
      }
      spec {
        container {
          image = "nginx"
          name  = "example"
          port {
            container_port = 80
          }

          resources {
            limits = {
              cpu    = "0.5"
              memory = "128Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "64Mi"
            }
          }
        }
      }
    }
  }
}

# create service nginx using node port
resource "kubernetes_service" "test" {
  metadata {
    name      = "nginx-example"
    namespace = kubernetes_namespace.test.metadata.0.name
  }
  spec {
    selector = {
      app = kubernetes_deployment.test.spec.0.template.0.metadata.0.labels.app
    }
    port {
      node_port   = var.nginx_node_port
      port        = 80
      target_port = 80
    }
    type = "NodePort"
  }
}
