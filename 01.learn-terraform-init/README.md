# Initialize a Terraform Working Directory

This is a companion repository to the ["Initialize a Terraform Working Directory"](https://developer.hashicorp.com/terraform/tutorials/cli/init) tutorial.

- [provider docker](https://registry.terraform.io/providers/kreuzwerker/docker/latest)
  - [source](https://github.com/kreuzwerker/terraform-provider-docker)

- [provider random](https://registry.terraform.io/providers/hashicorp/random/latest)
  - [source](https://github.com/hashicorp/terraform-provider-random)

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
docker ps -a | grep "hello-"
curl -v http://localhost:8000
curl -v http://localhost:8001
```

## Destroy

```sh
terraform destroy -auto-approve
```
