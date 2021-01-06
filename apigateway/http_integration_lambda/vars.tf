variable "rest_api_id" {}
variable "resource_id" {}
variable "http_method" {}
variable "lambda_arn" {}

variable "enabled" {
  default = true
}

variable "auth_enabled" {
  default = false
}

variable "custom_request_parameters" {
  type    = map
  default = {}
}

variable "json_request_template" {
  default = "{}"
}
