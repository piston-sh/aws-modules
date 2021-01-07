resource "aws_security_group" "security_group" {
    name_prefix = "${var.prefix}-"
    vpc_id      = var.vpc_id

    lifecycle {
        create_before_destroy = true
    }

    tags = {
        provisioner = "terraform"
        identifier = var.identifier
    }
}

resource "aws_security_group_rule" "allow_all_outbound" {
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.security_group.id
}

module "security_group_inbound_rules" {
  source = "./security_group_inbound_rules"
  for_each = var.port_mappings
  security_group_id = aws_security_group.security_group.id
  port = each.key
  tcp_enabled = each.value.tcp_enabled
  udp_enabled = each.value.udp_enabled
}