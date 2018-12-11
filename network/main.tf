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

module "private_subnet" {
  source = "../subnet"

  name               = "${var.name}"
  vpc_id             = "${module.vpc.vpc_id}"
  cidr_blocks        = "${var.private_subnet_cidrs}"
  availability_zones = "${var.availability_zones}"
}

resource "aws_internet_gateway" "gateway" {
  vpc_id = "${module.vpc.vpc_id}"

  tags {
    name = "${var.name}"
  }
}

resource "aws_route" "public_gateway_route" {
  count                  = "${length(var.public_subnet_cidrs)}"
  route_table_id         = "${element(module.public_subnet.route_table_ids, count.index)}"
  gateway_id             = "${aws_internet_gateway.gateway.id}"
  destination_cidr_block = "${var.destination_cidr_block}"
}

resource "aws_eip" "nat_eip" {
  count = "${length(var.private_subnet_cidrs)}"
  vpc   = true

  depends_on = [
    "aws_internet_gateway.gateway",
  ]
}

resource "aws_nat_gateway" "private_nat" {
  count         = "${length(var.private_subnet_cidrs)}"
  allocation_id = "${element(aws_eip.nat_eip.*.id, count.index)}"
  subnet_id     = "${element(module.public_subnet.subnet_ids, count.index)}"

  depends_on = [
    "aws_internet_gateway.gateway",
  ]
}

resource "aws_route" "private_nat_route" {
  count                  = "${length(var.private_subnet_cidrs)}"
  route_table_id         = "${element(module.private_subnet.route_table_ids, count.index)}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${aws_nat_gateway.private_nat.id}"
}
