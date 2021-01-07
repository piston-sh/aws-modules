resource "aws_security_group" "security_group" {
    name_prefix = "${var.prefix}-"
    vpc_id      = var.vpc_id

    lifecycle {
        create_before_destroy = true
    }

    tags {
        provisioner = "terraform"
        identifier = var.identifier
    }
}

module "security_group_rules" {
  for_each = var.port_mappings
  source = "./security_group_rule"
  security_group_id = aws_security_group.security_group.id
  port = each.key
  tcp_enabled = each.value.tcp_enabled
  udp_enabled = each.value.udp_enabled
}