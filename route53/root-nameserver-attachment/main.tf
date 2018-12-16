resource "aws_route53_record" "nameservers" {
  zone_id = "${var.root_zone_id}"
  name    = "${var.name}.${var.root_domain}"
  type    = "NS"
  ttl     = "300"
  records = ["${var.nameservers}"]
}
