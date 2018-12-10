resource "aws_launch_configuration" "launch_configuration" {
  name_prefix          = "${var.cluster_name}-${var.instance_group}-"
  image_id             = "${var.ami}"
  instance_type        = "${var.instance_type}"
  user_data            = "${var.user_data}"
  iam_instance_profile = "${aws_iam_instance_profile.instance_profile.id}"
  key_name             = "${var.ssh_key_name}"

  security_groups = ["${concat(list(aws_security_group.security_group_common.id), var.security_group_ids)}"]

  associate_public_ip_address = "${var.associate_public_ip}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "asg" {
  name_prefix          = "${var.cluster_name}-${var.instance_group}-"
  max_size             = "${var.max_size}"
  min_size             = "${var.min_size}"
  desired_capacity     = "${var.desired_capacity}"
  force_delete         = true
  launch_configuration = "${aws_launch_configuration.launch_configuration.id}"
  default_cooldown     = 30

  availability_zones = ["${var.availability_zones}"]

  vpc_zone_identifier = [
    "${var.subnet_ids}",
  ]

  tag {
    key                 = "cluster"
    value               = "${var.cluster_name}"
    propagate_at_launch = true
  }

  tag {
    key                 = "instance-group"
    value               = "${var.instance_group}"
    propagate_at_launch = true
  }
}

resource "aws_vpc_endpoint" "ec2_endpoint" {
  vpc_id            = "${var.vpc_id}"
  service_name      = "com.amazonaws.${data.aws_region.current.name}.ec2"
  vpc_endpoint_type = "Interface"

  security_group_ids = [
    "${aws_security_group.security_group_common.id}",
  ]

  subnet_ids          = ["${var.subnet_ids}"]
}

resource "aws_vpc_endpoint_route_table_association" "ec2_endpoint_association" {
  count           = "${length(var.subnet_ids)}"
  route_table_id  = "${element(data.aws_route_table.route_table.*.route_table_id, count.index)}"
  vpc_endpoint_id = "${aws_vpc_endpoint.ec2_endpoint.id}"
}

data "aws_route_table" "route_table" {
  count     = "${length(var.subnet_ids)}"
  subnet_id = "${element(var.subnet_ids, count.index)}"
}

data "aws_region" "current" {}
