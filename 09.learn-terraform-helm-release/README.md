# A Release is an instance of a chart running in a Kubernetes cluster

- [A Release is an instance of a chart running in a Kubernetes cluster](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release)

- [provider helm](https://registry.terraform.io/providers/hashicorp/helm/latest)
  - [source](https://github.com/hashicorp/terraform-provider-helm)


## Initialize your configuration

- Initialize the Terraform configuration.

```sh
terraform init
terraform init -upgrade

export TF_VAR_kube_config_path="${KUBE_CONFIG_PATH}"
echo "TF_VAR_kube_config_path=${TF_VAR_kube_config_path}"

terraform validate
```

## Apply

```sh
terraform plan
terraform apply -auto-approve
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
