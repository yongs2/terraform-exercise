# Using and testing docker provider

- [provider](https://github.com/kreuzwerker/terraform-provider-docker/tree/master/examples/provider)

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
export TF_VAR_registry_auth="{\"address\"=\"${REGISTRY_ADDR}\",\"username\"=\"${REGISTRY_USER}\",\"password\"=\"${REGISTRY_PASS}\"}"
echo "TF_VAR_registry_auth=${TF_VAR_registry_auth}"

terraform plan
terraform apply -auto-approve
```

## test

```sh
rm /root/.ssh/known_hosts
ssh root@localhost -p 32822 uptime
docker ps -a

terraform show
terraform state list
```

## Destroy

```sh
terraform destroy -auto-approve
```
