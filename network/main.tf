module "vpc" {
  source = "../vpc"

  name       = "${var.name}"
  cidr_block = "${var.vpc_cidr}"
}

module "public_subnet" {
  source = "../subnet"

  name               = "${var.name}"
  vpc_id             = "${module.vpc.vpc_id}"
  cidr_blocks        = "${var.public_subnet_cidrs}"
  availability_zones = "${var.availability_zones}"
}

resource "aws_route" "public_gateway_route" {
  count                  = "${length(var.public_subnet_cidrs)}"
  route_table_id         = "${element(module.public_subnet.route_table_ids, count.index)}"
  gateway_id             = "${module.vpc.gateway_id}"
  destination_cidr_block = "${var.destination_cidr_block}"
}

module "private_subnet" {
  source = "../subnet"

  name               = "${var.name}"
  vpc_id             = "${module.vpc.vpc_id}"
  cidr_blocks        = "${var.private_subnet_cidrs}"
  availability_zones = "${var.availability_zones}"
}
