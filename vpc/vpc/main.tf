resource "aws_vpc" "vpc" {
  cidr_block           = "${var.cidr_block}"
  enable_dns_hostnames = false
  enable_dns_support   = true

  tags = {
    name = "${var.name}"
  }
}
