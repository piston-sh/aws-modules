variable "name" {}
variable "vpc_id" {}
variable "target_port" {}
variable "target_asg_id" {}
variable "target_security_group_id" {}
variable "acm_certificate_arn" {}

variable "subnet_ids" {
  type = "list"
}

variable "health_check_path" {
  default = "/"
}

variable "health_check_matcher" {
  default = "200"
}

variable "allowed_inbound_cidr_blocks" {
  type    = "list"
  default = []
}
