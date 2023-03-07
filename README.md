# terraform-exercise

## linux 에 terraform 설치

- [참고](https://developer.hashicorp.com/terraform/tutorials/docker-get-started/install-cli)

```sh
OS=`uname | tr A-Z a-z`
ARCH=`uname -m | sed -E 's/^(aarch64|aarch64_be|armv6l|armv7l|armv8b|armv8l)$$/arm64/g' | sed -E 's/^x86_64$$/amd64/g'`
TF_VER=`curl -s "https://api.github.com/repos/hashicorp/terraform/releases/latest" | grep '"tag_name":' | sed -E 's/.*"v([^"]+)".*/\1/'`
TF_FILE="terraform_${TF_VER}_${OS}_${ARCH}.zip"
curl -LO https://releases.hashicorp.com/terraform/${TF_VER}/${TF_FILE}
unzip ${TF_FILE} -d /usr/local/bin
terraform -version
```

- 예제

```sh
git clone https://github.com/hashicorp/learn-terraform-init 01.learn-terraform-init
git clone https://github.com/hashicorp/learn-terraform-plan 02.learn-terraform-plan
git clone https://github.com/hashicorp/learn-terraform-apply 03.learn-terraform-apply
```
