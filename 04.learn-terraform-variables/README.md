# Define Input Variables

- [docker-variables](https://developer.hashicorp.com/terraform/tutorials/docker-get-started/docker-variables)

- [provider docker](https://registry.terraform.io/providers/kreuzwerker/docker/latest)
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
terraform plan
terraform apply -auto-approve -var "container_name=YetAnotherName"
docker ps -a
terraform output
```

## test

```sh
curl $(terraform output -json nginx_hosts | jq -r '.host')
terraform show
terraform state list
```

## Destroy

```sh
terraform destroy -auto-approve
```
