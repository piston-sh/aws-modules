output "http_methods" {
  value = "${aws_api_gateway_method.http_resource_method.*.http_method}"
}
