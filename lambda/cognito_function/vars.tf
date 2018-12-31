variable "cognito_name" {}
variable "name" {}
variable "s3_bucket_id" {}
variable "s3_bucket_key" {}

variable "handler" {
  default = "main"
}

variable "runtime" {
  default = "go1.x"
}

variable "function_timeout" {
  default = 300
}
