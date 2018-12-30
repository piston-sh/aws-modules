variable "rest_api_id" {}
variable "resource_id" {}

variable "http_method" {
  type    = "list"
  default = ["GET"]
}
