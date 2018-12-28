variable "table_name" {}

variable "primary_key" {
  default = "id"
}

variable "primary_key_type" {
  default = "S"
}

variable "read_capacity" {
  default = 5
}

variable "write_capacity" {
  default = 5
}
