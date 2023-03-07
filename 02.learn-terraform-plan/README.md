# Create a Terraform Plan

This repo is a companion repo to the [Create a Terraform Plan](https://developer.hashicorp.com/terraform/tutorials/cli/plan) tutorial.
It contains Terraform configuration you can use to learn how Terraform generates an execution plan.

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

## Create a plan

```sh
terraform plan -out tfplan
terraform show -json tfplan | jq > tfplan.json
```

- Review a plan

```sh
jq '.terraform_version, .format_version' tfplan.json
```

- Review plan configuration 

```sh
jq '.configuration.provider_config' tfplan.json
jq '.configuration.root_module.resources' tfplan.json
jq '.configuration.root_module.module_calls' tfplan.json
jq '.configuration.root_module.resources[0].expressions.image.references' tfplan.json
```

- Review planned resource changes

```sh
jq '.resource_changes[] | select( .address == "docker_image.nginx")' tfplan.json
```

- Review planned values

```sh
jq '.planned_values' tfplan.json
jq '.planned_values.root_module.child_modules' tfplan.json
```

## Apply

```sh
terraform apply tfplan
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
