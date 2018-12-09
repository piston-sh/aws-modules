# TODO; split into separate security groups
resource "aws_security_group" "security_group_serf" {
  name_prefix = "${var.cluster_name}-${var.instance_group}-serf-"
  vpc_id      = "${var.vpc_id}"

  lifecycle {
    create_before_destroy = true
  }

  tags {
    cluster        = "${var.cluster_name}"
    instance_group = "${var.instance_group}"
  }
}

resource "aws_security_group_rule" "allow_serf_lan_tcp_inbound" {
  count       = "${length(var.allowed_inbound_cidr_blocks) >= 1 ? 1 : 0}"
  type        = "ingress"
  from_port   = "${var.serf_lan_port}"
  to_port     = "${var.serf_lan_port}"
  protocol    = "tcp"
  cidr_blocks = ["${var.allowed_inbound_cidr_blocks}"]

  security_group_id = "${aws_security_group.security_group_serf.id}"
}

resource "aws_security_group_rule" "allow_serf_lan_udp_inbound" {
  count       = "${length(var.allowed_inbound_cidr_blocks) >= 1 ? 1 : 0}"
  type        = "ingress"
  from_port   = "${var.serf_lan_port}"
  to_port     = "${var.serf_lan_port}"
  protocol    = "udp"
  cidr_blocks = ["${var.allowed_inbound_cidr_blocks}"]

  security_group_id = "${aws_security_group.security_group_serf.id}"
}

resource "aws_security_group_rule" "allow_serf_lan_tcp_inbound_from_security_group_ids" {
  count                    = "${var.allowed_inbound_security_group_count}"
  type                     = "ingress"
  from_port                = "${var.serf_lan_port}"
  to_port                  = "${var.serf_lan_port}"
  protocol                 = "tcp"
  source_security_group_id = "${element(var.allowed_inbound_security_group_ids, count.index)}"

  security_group_id = "${aws_security_group.security_group_serf.id}"
}

resource "aws_security_group_rule" "allow_serf_lan_udp_inbound_from_security_group_ids" {
  count                    = "${var.allowed_inbound_security_group_count}"
  type                     = "ingress"
  from_port                = "${var.serf_lan_port}"
  to_port                  = "${var.serf_lan_port}"
  protocol                 = "udp"
  source_security_group_id = "${element(var.allowed_inbound_security_group_ids, count.index)}"

  security_group_id = "${aws_security_group.security_group_serf.id}"
}

# Similar to the *_inbound_from_security_group_ids rules, allow inbound from ourself

resource "aws_security_group_rule" "allow_serf_lan_tcp_inbound_from_self" {
  type      = "ingress"
  from_port = "${var.serf_lan_port}"
  to_port   = "${var.serf_lan_port}"
  protocol  = "tcp"
  self      = true

  security_group_id = "${aws_security_group.security_group_serf.id}"
}

resource "aws_security_group_rule" "allow_serf_lan_udp_inbound_from_self" {
  type      = "ingress"
  from_port = "${var.serf_lan_port}"
  to_port   = "${var.serf_lan_port}"
  protocol  = "udp"
  self      = true

  security_group_id = "${aws_security_group.security_group_serf.id}"
}

resource "aws_security_group_rule" "allow_serf_wan_tcp_inbound" {
  count       = "${length(var.allowed_inbound_cidr_blocks) >= 1 ? 1 : 0}"
  type        = "ingress"
  from_port   = "${var.serf_wan_port}"
  to_port     = "${var.serf_wan_port}"
  protocol    = "tcp"
  cidr_blocks = ["${var.allowed_inbound_cidr_blocks}"]

  security_group_id = "${aws_security_group.security_group_serf.id}"
}

resource "aws_security_group_rule" "allow_serf_wan_udp_inbound" {
  count       = "${length(var.allowed_inbound_cidr_blocks) >= 1 ? 1 : 0}"
  type        = "ingress"
  from_port   = "${var.serf_wan_port}"
  to_port     = "${var.serf_wan_port}"
  protocol    = "udp"
  cidr_blocks = ["${var.allowed_inbound_cidr_blocks}"]

  security_group_id = "${aws_security_group.security_group_serf.id}"
}

resource "aws_security_group_rule" "allow_serf_wan_tcp_inbound_from_security_group_ids" {
  count                    = "${var.allowed_inbound_security_group_count}"
  type                     = "ingress"
  from_port                = "${var.serf_wan_port}"
  to_port                  = "${var.serf_wan_port}"
  protocol                 = "tcp"
  source_security_group_id = "${element(var.allowed_inbound_security_group_ids, count.index)}"

  security_group_id = "${aws_security_group.security_group_serf.id}"
}

resource "aws_security_group_rule" "allow_serf_wan_udp_inbound_from_security_group_ids" {
  count                    = "${var.allowed_inbound_security_group_count}"
  type                     = "ingress"
  from_port                = "${var.serf_wan_port}"
  to_port                  = "${var.serf_wan_port}"
  protocol                 = "udp"
  source_security_group_id = "${element(var.allowed_inbound_security_group_ids, count.index)}"

  security_group_id = "${aws_security_group.security_group_serf.id}"
}

# Similar to the *_inbound_from_security_group_ids rules, allow inbound from ourself

resource "aws_security_group_rule" "allow_serf_wan_tcp_inbound_from_self" {
  type      = "ingress"
  from_port = "${var.serf_wan_port}"
  to_port   = "${var.serf_wan_port}"
  protocol  = "tcp"
  self      = true

  security_group_id = "${aws_security_group.security_group_serf.id}"
}

resource "aws_security_group_rule" "allow_serf_wan_udp_inbound_from_self" {
  type      = "ingress"
  from_port = "${var.serf_wan_port}"
  to_port   = "${var.serf_wan_port}"
  protocol  = "udp"
  self      = true

  security_group_id = "${aws_security_group.security_group_serf.id}"
}
