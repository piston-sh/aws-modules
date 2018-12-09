output "security_group_ids" {
  value = {
    rpc      = "${aws_security_group.security_group_rpc.id}"
    serf     = "${aws_security_group.security_group_serf.id}"
    dns      = "${aws_security_group.security_group_dns.id}"
    http_api = "${aws_security_group.security_group_http_api.id}"
  }
}

output "security_group_id_list" {
  value = [
    "${aws_security_group.security_group_rpc.id}",
    "${aws_security_group.security_group_serf.id}",
    "${aws_security_group.security_group_dns.id}",
    "${aws_security_group.security_group_http_api.id}",
  ]
}
