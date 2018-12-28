variable "rest_api_id" {}
variable "resource_id" {}

variable "http_methods" {
  type = "list"
}

variable "lambda_arns" {
  type = "list"
}
