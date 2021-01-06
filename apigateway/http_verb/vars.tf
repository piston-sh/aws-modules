variable "rest_api_id" {}
variable "resource_id" {}
variable "lambda_arn" {}

variable "http_method" {
  default = "GET"
}

variable "enabled" {
  default = true
}

variable "cognito_authorizer_id" {
  default = ""
}

variable "response_codes" {
  type    = list(string)
  default = ["200", "400", "403", "500"]
}

variable "method_request_parameters" {
  type    = "map"
  default = {}
}

variable "integration_request_parameters" {
  type    = "map"
  default = {}
}

variable "json_request_template" {
  default = "{}"
}
