# Manage Kubernetes Resources via Terraform

- [Manage Kubernetes Resources via Terraform](https://developer.hashicorp.com/terraform/tutorials/kubernetes/kubernetes-provider?in=terraform%2Fkubernetes)

- [provider kubernetes](https://registry.terraform.io/providers/hashicorp/kubernetes/latest)
  - [source](https://github.com/kreuzwerker/terraform-provider-docker)


## Initialize your configuration

- Initialize the Terraform configuration.

```sh
terraform init
terraform init -upgrade
terraform validate
```

## Apply

```sh
export TF_VAR_kube_config_path="${KUBE_CONFIG_PATH}"
echo "TF_VAR_kube_config_path=${TF_VAR_kube_config_path}"
export TF_VAR_nginx_node_port=${NGINX_NODE_PORT}
echo "TF_VAR_nginx_node_port=${TF_VAR_nginx_node_port}"

terraform plan
terraform apply -auto-approve
```

## test

```sh
curl http://${KUBE_MASTER_IP}:${NGINX_NODE_PORT}

terraform show
terraform state list
```

## Destroy

```sh
terraform destroy -auto-approve
```
