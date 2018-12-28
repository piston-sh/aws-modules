output "http_methods" {
  type = "list"
  value = "${aws_api_gateway_method.http_resource_method.*.http_method}"
}
