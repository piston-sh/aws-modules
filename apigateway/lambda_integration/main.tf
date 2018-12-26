resource "aws_api_gateway_integration" "http_resource_integration" {
  rest_api_id = "${var.rest_api_id}"
  resource_id = "${var.resource_id}"
  http_method = "${var.http_method}"
  type        = "AWS"

  uri                     = "arn:aws:apigateway:${data.aws_region.current.name}:lambda:path/2015-03-31/functions/${var.lambda_arn}/invocations"
  integration_http_method = "POST"
}

resource "aws_api_gateway_integration_response" "http_resource_integration_response" {
  depends_on = [
    "aws_api_gateway_integration.http_resource_integration",
  ]

  rest_api_id = "${var.rest_api_id}"
  resource_id = "${var.resource_id}"
  http_method = "${var.http_method}"
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "http_resource_error_integration_response" {
  depends_on = [
    "aws_api_gateway_integration.http_resource_integration",
  ]

  rest_api_id       = "${var.rest_api_id}"
  resource_id       = "${var.resource_id}"
  http_method       = "${var.http_method}"
  status_code       = "500"
  selection_pattern = ".*[ERROR].*"
}

resource "aws_api_gateway_integration_response" "http_resource_forbidden_integration_response" {
  depends_on = [
    "aws_api_gateway_integration.http_resource_integration",
  ]

  rest_api_id       = "${var.rest_api_id}"
  resource_id       = "${var.resource_id}"
  http_method       = "${var.http_method}"
  status_code       = "403"
  selection_pattern = ".*[FORBIDDEN].*"
}

data "aws_region" "current" {}
