variable "cluster_name" {}
variable "rest_api_id" {}
variable "http_method" {}
variable "resource_path" {}
variable "s3_bucket_id" {}

# TODO; test if we can merge these into one value
variable "s3_bucket_arn" {}

variable "s3_bucket_key" {
  default = "rest_function.zip"
}

variable "function_name" {
  default = "rest_function"
}

variable "handler" {
  default = "main"
}

variable "runtime" {
  default = "go1.x"
}

variable "function_timeout" {
  default = 300
}
