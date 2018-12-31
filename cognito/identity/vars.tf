variable "name" {}
variable "identity_pool_name" {}

variable "identity_pool_provider" {
  default = ""
}

variable "allow_admin_create_user_only" {
  default = false
}

variable "password_min_length" {
  default = 8
}

variable "password_require_uppercase" {
  default = true
}

variable "password_require_lowercase" {
  default = true
}

variable "password_require_numbers" {
  default = true
}

variable "password_require_symbols" {
  default = false
}

variable "lambda_s3_bucket_id" {}
variable "lambda_s3_bucket_key" {}

variable "lambda_handler" {
  default = "main"
}

variable "lambda_runtime" {
  default = "go1.x"
}

variable "lambda_function_timeout" {
  default = 300
}
