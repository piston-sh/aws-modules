resource "aws_security_group_rule" "allow_tcp_port_inbound" {
  count       = var.tcp_enabled ? 1 : 0
  type        = "ingress"
  from_port   = var.port
  to_port     = var.port
  protocol    = "tcp"
  cidr_blocks = var.inbound_cidr_blocks
  security_group_id = var.security_group_id
}

resource "aws_security_group_rule" "allow_udp_port_inbound" {
  count       = var.udp_enabled ? 1 : 0
  type        = "ingress"
  from_port   = var.port
  to_port     = var.port
  protocol    = "udp"
  cidr_blocks = var.inbound_cidr_blocks
  security_group_id = var.security_group_id
}