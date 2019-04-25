# TODO; split into separate security groups
resource "aws_security_group" "security_group" {
  name_prefix = "${var.name}-alb-"
  vpc_id      = "${var.vpc_id}"

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    cluster = "${var.name}"
  }
}

resource "aws_security_group_rule" "allow_https_inbound" {
  type        = "ingress"
  from_port   = "443"
  to_port     = "443"
  protocol    = "tcp"
  cidr_blocks = ["${var.allowed_inbound_cidr_blocks}"]

  security_group_id = "${aws_security_group.security_group.id}"
}

resource "aws_security_group_rule" "allow_https_inbound_from_self" {
  type      = "ingress"
  from_port = "443"
  to_port   = "443"
  protocol  = "tcp"
  self      = true

  security_group_id = "${aws_security_group.security_group.id}"
}

resource "aws_security_group_rule" "allow_target_lb_inbound" {
  type                     = "ingress"
  from_port                = "${var.target_port}"
  to_port                  = "${var.target_port}"
  protocol                 = "tcp"
  source_security_group_id = "${aws_security_group.security_group.id}"

  security_group_id = "${var.target_security_group_id}"
}

resource "aws_security_group_rule" "allow_all_outbound" {
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = "${aws_security_group.security_group.id}"
}
