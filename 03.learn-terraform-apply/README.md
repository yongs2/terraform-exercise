# Apply Terraform Configuration

This repo is a companion repo to the [Apply Terraform Configuration tutorial](https://developer.hashicorp.com/terraform/tutorials/cli/apply).

- [provider docker](https://registry.terraform.io/providers/kreuzwerker/docker/latest)
  - [source](https://github.com/kreuzwerker/terraform-provider-docker)

- [provider random](https://registry.terraform.io/providers/hashicorp/random/latest)
  - [source](https://github.com/hashicorp/terraform-provider-random)

- [provider time](https://registry.terraform.io/providers/hashicorp/time/latest)
  - [source](https://github.com/hashicorp/terraform-provider-time)

## Initialize your configuration

- Initialize the Terraform configuration.

```sh
terraform init
terraform init -upgrade
terraform validate
```

## Apply

```sh
terraform plan
terraform apply -auto-approve
```

## test

```sh
curl $(terraform output -json nginx_hosts | jq -r '.[0].host')
curl $(terraform output -json nginx_hosts | jq -r '.[1].host')
curl $(terraform output -json nginx_hosts | jq -r '.[2].host')
curl $(terraform output -json nginx_hosts | jq -r '.[3].host')
terraform show
terraform state list
```

## Destroy

```sh
terraform destroy -auto-approve
```
