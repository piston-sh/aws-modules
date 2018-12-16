output "aws_eip_ids" {
  value = ["${aws_eip.nameserver_eip.*.id}"]
}

output "public_ips" {
  value = ["${aws_eip.nameserver_eip.*.public_ip}"]
}

output "hostnames" {
  value = ["${aws_route53_record.nameserver_record.*.name}"]
}
