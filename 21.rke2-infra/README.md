# Control Rancher2 and install k8s infra packages

- [Rancher2 Provider](https://registry.terraform.io/providers/terraform-provider-openstack/openstack/latest)
  - [source](https://github.com/rancher/terraform-provider-rancher2)


## Initialize your configuration

- Initialize the Terraform configuration.

```sh
terraform init
terraform init -upgrade

terraform fmt -recursive && terraform validate
```

## Apply

```sh
export TF_VAR_rancher2_api_endpoint=${RKE2_ENDPOINT}
export TF_VAR_rancher2_access_key=${RKE2_ACCESS_KEY}
export TF_VAR_rancher2_secret_key=${RKE2_SECRET_KEY}

terraform plan
terraform apply -auto-approve

# redis-cluster 만 재설치
terraform destroy -auto-approve -target module.redis-cluster.rancher2_app_v2.redis-cluster
terraform apply -auto-approve -target module.redis-cluster.rancher2_app_v2.redis-cluster
```

## test

```sh
terraform show
terraform state list
```

## Destroy

```sh
terraform destroy -auto-approve
```

