# Deploy Applications with the Helm Provider

- [Deploy Applications with the Helm Provider](https://registry.terraform.io/providers/hashicorp/helm/latest/docs#example-usage)

- [provider helm](https://registry.terraform.io/providers/hashicorp/helm/latest)
  - [source](https://github.com/hashicorp/terraform-provider-helm)


## Initialize your configuration

- Initialize the Terraform configuration.

```sh
terraform init
terraform init -upgrade

export TF_VAR_kube_config_path="${KUBE_CONFIG_PATH}"
echo "TF_VAR_kube_config_path=${TF_VAR_kube_config_path}"
export TF_VAR_registry="{\"url\"=\"${REGISTRY_URL}\",\"username\"=\"${REGISTRY_USER}\",\"password\"=\"${REGISTRY_PASS}\"}"
echo "TF_VAR_registry=${TF_VAR_registry}"

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
