## Input variable definitions

// docker config.json 의 username 과 password 를 variable 로 선언
variable "registry_auth" {
  type = object({
    address  = string
    username = string
    password = string
  })
  description = "Docker registry auth"
}
