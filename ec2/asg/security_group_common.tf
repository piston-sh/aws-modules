resource "aws_security_group" "security_group_common" {
  name_prefix = "${var.cluster_name}-${var.instance_group}-common-"
  vpc_id      = var.vpc_id

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    cluster        = var.cluster_name
    instance_group = var.instance_group
  }
}

resource "aws_security_group_rule" "allow_all_outbound" {
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.security_group_common.id
}

resource "aws_security_group_rule" "allow_ssh_inbound" {
  count       = length(var.allowed_ssh_cidr_blocks) >= 1 ? 1 : 0
  type        = "ingress"
  from_port   = "22"
  to_port     = "22"
  protocol    = "tcp"
  cidr_blocks = var.allowed_ssh_cidr_blocks

  security_group_id = aws_security_group.security_group_common.id
}

resource "aws_security_group_rule" "allow_ssh_inbound_ipv6" {
  count            = length(var.allowed_ssh_ipv6_cidr_blocks) >= 1 ? 1 : 0
  type             = "ingress"
  from_port        = "22"
  to_port          = "22"
  protocol         = "tcp"
  ipv6_cidr_blocks = var.allowed_ssh_ipv6_cidr_blocks

  security_group_id = aws_security_group.security_group_common.id
}

resource "aws_security_group_rule" "allow_ssh_inbound_from_security_group_ids" {
  count                    = length(var.allowed_ssh_security_group_ids)
  type                     = "ingress"
  from_port                = "22"
  to_port                  = "22"
  protocol                 = "tcp"
  source_security_group_id = var.allowed_ssh_security_group_ids[count.index]

  security_group_id = aws_security_group.security_group_common.id
}

resource "aws_security_group_rule" "allow_https_inbound" {
  type        = "ingress"
  from_port   = "443"
  to_port     = "443"
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.security_group_common.id
}

resource "aws_security_group_rule" "allow_prometheus_inbound" {
  type        = "ingress"
  from_port   = "9100"
  to_port     = "9100"
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.security_group_common.id
}
