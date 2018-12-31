variable "root_domain" {}
variable "bucket_name" {}
variable "acm_certificate_arn" {}

variable "subdomain" {
  default = ""
}

variable "comment" {
  default = ""
}

variable "enable_route53" {
  default = true
}
