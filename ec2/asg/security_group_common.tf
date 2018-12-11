resource "aws_security_group" "security_group_common" {
  name_prefix = "${var.cluster_name}-${var.instance_group}-common-"
  vpc_id      = "${var.vpc_id}"

  lifecycle {
    create_before_destroy = true
  }

  tags {
    cluster        = "${var.cluster_name}"
    instance_group = "${var.instance_group}"
  }
}

resource "aws_security_group_rule" "allow_all_outbound" {
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = "${aws_security_group.security_group_common.id}"
}

resource "aws_security_group_rule" "allow_ssh_inbound" {
  count       = "${length(var.allowed_ssh_cidr_blocks) >= 1 ? 1 : 0}"
  type        = "ingress"
  from_port   = "22"
  to_port     = "22"
  protocol    = "tcp"
  cidr_blocks = ["${var.allowed_ssh_cidr_blocks}"]

  security_group_id = "${aws_security_group.security_group_common.id}"
}

resource "aws_security_group_rule" "allow_ssh_inbound_from_security_group_ids" {
  count                    = "${length(var.allowed_ssh_security_group_ids)}"
  type                     = "ingress"
  from_port                = "22"
  to_port                  = "22"
  protocol                 = "tcp"
  source_security_group_id = "${element(var.allowed_ssh_security_group_ids, count.index)}"

  security_group_id = "${aws_security_group.security_group_common.id}"
}

resource "aws_security_group_rule" "allow_https_inbound" {
  type      = "ingress"
  from_port = "443"
  to_port   = "443"
  protocol  = "tcp"

  // Amazon eu-west-2 CIDR blocks
  cidr_blocks = [
    "3.8.0.0/14",
    "18.130.0.0/16",
    "18.175.0.0/16",
    "35.176.0.0/15",
    "35.176.92.32/29",
    "35.178.0.0/15",
    "52.56.0.0/16",
    "52.56.127.0/25",
    "52.92.88.0/22",
    "52.93.138.252/32",
    "52.93.138.253/32",
    "52.93.139.252/32",
    "52.93.139.253/32",
    "52.94.15.0/24",
    "52.94.32.0/20",
    "52.94.48.0/20",
    "52.94.112.0/22",
    "52.94.198.144/28",
    "52.94.248.192/28",
    "52.95.148.0/23",
    "52.95.150.0/24",
    "52.95.239.0/24",
    "52.95.253.0/24",
    "52.144.209.0/24",
    "52.144.211.0/24",
    "54.239.0.240/28",
    "54.239.100.0/23",
    "99.82.169.0/24",
  ]

  security_group_id = "${aws_security_group.security_group_common.id}"
}
