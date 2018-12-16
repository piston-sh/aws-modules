output "aws_eip_ids" {
  value = ["${aws_eip.instance_public_ip.*.id}"]
}

output "public_ips" {
  value = ["${aws_eip.instance_public_ip.*.public_ip}"]
}
