resource "aws_api_gateway_deployment" "http_resource_deployment" {
  depends_on = [
    "aws_api_gateway_resource.http_resource",
  ]

  rest_api_id = "${var.rest_api_id}"
  stage_name  = "prod"
}

resource "aws_api_gateway_resource" "http_resource" {
  rest_api_id = "${var.rest_api_id}"
  parent_id   = "${var.root_resource_id}"
  path_part   = "${var.path_part}"
}
