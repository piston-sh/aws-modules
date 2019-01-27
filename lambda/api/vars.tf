variable "root_domain" {}
variable "cluster_name" {}
variable "group_name" {}
variable "rest_api_id" {}
variable "rest_api_resource_id" {}
variable "path_part" {}

variable "rest_api_execution_arn" {
  default = ""
}

variable "s3_bucket_id" {
  default = ""
}

variable "s3_bucket_arn" {
  default = ""
}

variable "custom_policy_arn" {
  default = ""
}

variable "root_resource_id" {
  default = ""
}

variable "cognito_authorizer_id" {
  default = ""
}

variable "method_function_map" {
  type    = "map"
  default = {}
}

variable "method_env_map" {
  type = "map"

  default = {
    "GET" = {
      "EMPTY_VARIABLE" = "default_override_me"
    }

    "POST" = {
      "EMPTY_VARIABLE" = "default_override_me"
    }

    "PUT" = {
      "EMPTY_VARIABLE" = "default_override_me"
    }

    "DELETE" = {
      "EMPTY_VARIABLE" = "default_override_me"
    }
  }
}

variable "get_request_params" {
  type    = "list"
  default = []
}

variable "post_request_params" {
  type    = "list"
  default = []
}

variable "put_request_params" {
  type    = "list"
  default = []
}

variable "delete_request_params" {
  type    = "list"
  default = []
}

variable "get_request_template" {
  default = "{}"
}

variable "post_request_template" {
  default = "{}"
}

variable "put_request_template" {
  default = "{}"
}

variable "delete_request_template" {
  default = "{}"
}
