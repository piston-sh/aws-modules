variable "cluster_name" {}
variable "rest_api_execution_arn" {}
variable "s3_bucket_id" {}

# TODO; test if we can merge these into one value
variable "s3_bucket_arn" {}

variable "function_key_map" {
  type = "map"
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
