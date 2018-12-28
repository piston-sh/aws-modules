output "resource_id" {
  value = "${aws_api_gateway_resource.http_resource.id}"
}

output "deployment_stage_name" {
  value = "${aws_api_gateway_deployment.http_resource_deployment.stage_name}"
}
