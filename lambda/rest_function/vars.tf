variable "cluster_name" {}
variable "rest_api_execution_arn" {}
variable "s3_bucket_id" {}

# TODO; test if we can merge these into one value
variable "s3_bucket_arn" {}

variable "method_function_map" {
  type = "map"
}

variable "method_env_map" {
  type    = "map"

  default = {
    "GET" = {
      "PROVISIONER" = "terraform"
    }
    "POST" = {
      "PROVISIONER" = "terraform"
    }
    "PUT" = {
      "PROVISIONER" = "terraform"
    }
    "DELETE" = {
      "PROVISIONER" = "terraform"
    }
  }
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

variable "environment_variables" {
  type    = "map"
  default = {}
}
