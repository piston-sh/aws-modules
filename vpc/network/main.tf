module "vpc" {
  source = "git@github.com:piston-sh/tf-aws-modules//vpc/vpc?ref=0.12"

  name       = var.name
  cidr_block = var.vpc_cidr
}

module "public_subnet" {
  source = "git@github.com:piston-sh/tf-aws-modules//vpc/subnet?ref=0.12"

  name               = "${var.name}-public"
  vpc_id             = module.vpc.vpc_id
  cidr_blocks        = var.public_subnet_cidrs
  availability_zones = var.availability_zones
}

module "private_subnet" {
  source = "git@github.com:piston-sh/tf-aws-modules//vpc/subnet?ref=0.12"

  name               = "${var.name}-private"
  vpc_id             = module.vpc.vpc_id
  cidr_blocks        = var.private_subnet_cidrs
  availability_zones = var.availability_zones
}

resource "aws_internet_gateway" "gateway" {
  vpc_id = module.vpc.vpc_id

  tags = {
    name = var.name
  }
}

resource "aws_route" "public_gateway_route" {
  count                  = length(var.public_subnet_cidrs)
  route_table_id         = element(module.public_subnet.route_table_ids, count.index)
  gateway_id             = aws_internet_gateway.gateway.id
  destination_cidr_block = var.destination_cidr_block
}

resource "aws_eip" "nat_eip" {
  count = var.nat_gateway_enabled && !var.use_nat_instance ? length(var.private_subnet_cidrs) : 0
  vpc   = true

  depends_on = [
    "aws_internet_gateway.gateway",
  ]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_nat_gateway" "private_nat" {
  count         = var.nat_gateway_enabled && !var.use_nat_instance ? length(var.private_subnet_cidrs) : 0
  allocation_id = element(aws_eip.nat_eip.*.id, count.index)

  // always route through the first public subnet
  subnet_id = module.public_subnet.subnet_ids[0]

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [
    "aws_internet_gateway.gateway",
  ]
}

resource "aws_route" "private_nat_route" {
  count                  = var.nat_gateway_enabled && !var.use_nat_instance ? length(var.private_subnet_cidrs) : 0
  route_table_id         = element(module.private_subnet.route_table_ids, count.index)
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.private_nat[0].id
}

resource "aws_security_group" "nat_security_group" {
  count       = var.nat_gateway_enabled && var.use_nat_instance ? 1 : 0
  name_prefix = "${var.name}-nat-sg-"
  description = "Allow NAT traffic"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "nat_instance" {
  count                       = var.nat_gateway_enabled && var.use_nat_instance ? 1 : 0
  ami                         = var.instance_ami_id
  instance_type               = var.instance_type
  source_dest_check           = false
  iam_instance_profile        = aws_iam_instance_profile.nat_profile[0].id
  key_name                    = var.ssh_key_name
  subnet_id                   = module.public_subnet.subnet_ids[0]
  vpc_security_group_ids      = aws_security_group.nat_security_group.*.id
  user_data                   = data.template_file.user_data[0].rendered
  associate_public_ip_address = true

  tags = {
    Name = "nat"
  }

  lifecycle {
    create_before_destroy = true
  }
}
data "template_file" "user_data" {
  template = file("${path.module}/templates/user-data.conf.tmpl")
  count    = var.nat_gateway_enabled && var.use_nat_instance ? 1 : 0

  vars = {
    name              = var.name
    mysubnet          = module.public_subnet.subnet_ids[0]
    vpc_cidr          = module.vpc.cidr_block
    awsnycast_deb_url = "https://github.com/bobtfish/AWSnycast/releases/download/v0.1.5/awsnycast_0.1.5-425_amd64.deb"
  }
}
