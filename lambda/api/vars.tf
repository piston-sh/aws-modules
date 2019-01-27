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

variable "method_request_params_map" {
  type = "map"

  default = {
    "GET"    = {}
    "POST"   = {}
    "PUT"    = {}
    "DELETE" = {}
  }
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
