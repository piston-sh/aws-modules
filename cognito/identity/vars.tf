variable "name" {}
variable "identity_pool_name" {}
variable "identity_pool_provider" {}
variable "lambda_s3_bucket" {}
variable "lambda_s3_key" {}

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
