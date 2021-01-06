variable "name" {}
variable "vpc_cidr" {}

variable "public_subnet_cidrs" {
  type = list(string)
}

variable "private_subnet_cidrs" {
  type = list(string)
}

variable "availability_zones" {
  type = list(string)
}

variable "destination_cidr_block" {
  default = "0.0.0.0/0"
}

variable "nat_gateway_enabled" {
  default = true
}

variable "use_nat_instance" {
  default = false
}

variable "instance_type" {
  default = "t3.nano"
}

variable "instance_ami_id" {
  default = ""
}

variable "ssh_key_name" {
  default = ""
}
