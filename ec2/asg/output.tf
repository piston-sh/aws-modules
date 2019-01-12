output "security_group_id" {
  value = "${aws_security_group.security_group_common.id}"
}

output "asg_id" {
  value = "${aws_autoscaling_group.asg.id}"
}
