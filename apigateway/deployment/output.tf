output "deployment_stage_name" {
  value = "${aws_api_gateway_deployment.http_resource_deployment.stage_name}"
}
