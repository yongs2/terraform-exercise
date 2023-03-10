# Using and testing the ssh-protocol

- [ssh-protocol](https://github.com/kreuzwerker/terraform-provider-docker/blob/master/examples/ssh-protocol)

- [provider docker](https://registry.terraform.io/providers/kreuzwerker/docker/latest)
  - [source](https://github.com/kreuzwerker/terraform-provider-docker)


## Initialize your configuration

- client, create ssh key

```sh
ssh-keygen -t rsa
ls -al /root/.ssh/id_rsa.pub
cp /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys 
ssh-copy-id -i /root/.ssh/id_rsa.pub root@localhost:32822

# ssh connection test
ssh root@localhost -p 32822
export TF_VAR_pub_key="$(cat /root/.ssh/*.pub)"
```

- Initialize the Terraform configuration.

```sh
terraform init
terraform init -upgrade
terraform validate
```

## Apply

```sh
terraform plan

# Download the BusyBox image onto the remote host.
terraform apply -auto-approve -target docker_image.test

terraform apply -auto-approve -target docker_container.dind
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
