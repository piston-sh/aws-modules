resource "aws_api_gateway_deployment" "http_resource_deployment" {
  rest_api_id = "${var.rest_api_id}"
  stage_name  = "${var.stage_name}"
}
