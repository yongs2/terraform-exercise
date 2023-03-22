# Refer: https://docs.nhncloud.com/ko/Compute/Instance/ko/terraform-guide/
# Centos-7 으로 시작하는 이미지 중 최근 이미지 조회
data "openstack_images_image_v2" "centos7" {
  name_regex        = "CentOS-7[\\S]*"
  most_recent = true
}

# 같은 이름의 이미지 중 가장 오래된 이미지 조회
data "openstack_images_image_v2" "ubuntu" {
  name           = "ubuntu-20.04.5"
  sort_key       = "created_at"
  sort_direction = "asc"
  member_status  = "all"
}

output "centos7" {
  value = data.openstack_images_image_v2.centos7
}

output "ubuntu" {
  value = data.openstack_images_image_v2.ubuntu
}
