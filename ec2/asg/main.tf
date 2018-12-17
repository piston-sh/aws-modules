resource "aws_launch_configuration" "launch_configuration" {
  name_prefix          = "${var.cluster_name}-${var.instance_group}-"
  image_id             = "${var.ami}"
  instance_type        = "${var.instance_type}"
  user_data            = "${var.user_data}"
  iam_instance_profile = "${aws_iam_instance_profile.instance_profile.id}"
  key_name             = "${var.ssh_key_name}"

  security_groups = ["${concat(list(aws_security_group.security_group_common.id), var.security_group_ids)}"]

  associate_public_ip_address = "${var.associate_public_ip}"

  root_block_device = {
    volume_size = "${var.volume_size}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

locals {
  default_tags = [
    {
      key                 = "cluster"
      value               = "${var.cluster_name}"
      propagate_at_launch = true
    },
    {
      key                 = "instance-group"
      value               = "${var.instance_group}"
      propagate_at_launch = true
    }
  ]
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

  tags = ["${concat(
    var.custom_tags,
    local.default_tags,
  )}"]
}
