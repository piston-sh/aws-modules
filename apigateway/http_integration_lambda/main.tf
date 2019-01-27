resource "aws_api_gateway_integration" "http_resource_integration" {
  count       = "${var.enabled ? 1 : 0}"
  rest_api_id = "${var.rest_api_id}"
  resource_id = "${var.resource_id}"
  http_method = "${var.http_method}"
  type        = "AWS_PROXY"

  # Lambdas must always be invoked with a POST request
  uri                     = "arn:aws:apigateway:${data.aws_region.current.name}:lambda:path/2015-03-31/functions/${var.lambda_arn}/invocations"
  integration_http_method = "POST"

  request_parameters = "${zipmap(split(",", var.auth_enabled ? "integration.request.header.Authorization" : "integration.request.header.Host"), split(",", var.auth_enabled ? "method.request.header.Authorization" : "method.request.header.Host"))}"
}

resource "aws_api_gateway_integration_response" "http_resource_integration_response" {
  count       = "${var.enabled ? 1 : 0}"
  rest_api_id = "${var.rest_api_id}"
  resource_id = "${var.resource_id}"
  http_method = "${var.http_method}"
  status_code = "200"

  depends_on = [
    "aws_api_gateway_integration.http_resource_integration",
  ]
}

resource "aws_api_gateway_integration_response" "http_resource_error_integration_response" {
  count             = "${var.enabled ? 1 : 0}"
  rest_api_id       = "${var.rest_api_id}"
  resource_id       = "${var.resource_id}"
  http_method       = "${var.http_method}"
  status_code       = "500"
  selection_pattern = ".*[ERROR].*"

  depends_on = [
    "aws_api_gateway_integration.http_resource_integration",
  ]
}

resource "aws_api_gateway_integration_response" "http_resource_forbidden_integration_response" {
  count             = "${var.enabled ? 1 : 0}"
  rest_api_id       = "${var.rest_api_id}"
  resource_id       = "${var.resource_id}"
  http_method       = "${var.http_method}"
  status_code       = "403"
  selection_pattern = ".*[FORBIDDEN].*"

  depends_on = [
    "aws_api_gateway_integration.http_resource_integration",
  ]
}

data "aws_region" "current" {}
