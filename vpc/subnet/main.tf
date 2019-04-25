resource "aws_subnet" "subnet" {
  count             = length(var.cidr_blocks)
  vpc_id            = var.vpc_id
  cidr_block        = element(var.cidr_blocks, count.index)
  availability_zone = element(var.availability_zones, count.index % length(var.availability_zones))

  tags = {
    Name = var.name
  }
}

resource "aws_route_table" "route_table" {
  count  = length(var.cidr_blocks)
  vpc_id = var.vpc_id

  tags = {
    Name = var.name
  }
}

resource "aws_route_table_association" "route_table_association" {
  count          = length(var.cidr_blocks)
  subnet_id      = aws_subnet.subnet[count.index].id
  route_table_id = aws_route_table.route_table[count.index].id
}
