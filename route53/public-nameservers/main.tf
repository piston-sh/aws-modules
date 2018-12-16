resource "aws_eip" "nameserver_eip" {
  count = "${var.count}"
  vpc = true
}

resource "aws_route53_record" "nameserver_record" {
  count = "${var.count}"
  zone_id = "${var.root_zone_id}"
  name    = "ns${var.count}.${var.name}.${var.root_domain}"
  type    = "A"
  ttl     = "300"
  records = ["${aws_eip.nameserver_eip.public_ip}"]
}
