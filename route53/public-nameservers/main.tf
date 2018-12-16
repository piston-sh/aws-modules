resource "aws_eip" "instance_public_ip" {
  count = "${var.count}"
  vpc = true
}

resource "aws_route53_record" "eip" {
  count = "${var.count}"
  zone_id = "${var.root_zone_id}"
  name    = "ns${var.count}.${var.name}.${var.root_domain}"
  type    = "A"
  ttl     = "300"
  records = ["${aws_eip.instance_public_ip.public_ip}"]
}
