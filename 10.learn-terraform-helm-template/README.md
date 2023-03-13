# Render chart templates locally

- [Render chart templates locally](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/data-sources/template)

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
rm -Rf ./templates/
```
