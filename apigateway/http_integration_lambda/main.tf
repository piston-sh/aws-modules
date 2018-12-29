resource "aws_api_gateway_integration" "http_resource_integration" {
  count       = "${length(var.http_methods)}"
  rest_api_id = "${var.rest_api_id}"
  resource_id = "${var.resource_id}"
  http_method = "${element(var.http_methods, count.index)}"
  type        = "AWS"

  # Lambdas must always be invoked with a POST request
  uri                     = "arn:aws:apigateway:${data.aws_region.current.name}:lambda:path/2015-03-31/functions/${element(var.lambda_arns, count.index)}/invocations"
  integration_http_method = "POST"
}

resource "aws_api_gateway_integration_response" "http_resource_integration_response" {
  count       = "${length(var.http_methods)}"
  rest_api_id = "${var.rest_api_id}"
  resource_id = "${var.resource_id}"
  http_method = "${element(var.http_methods, count.index)}"
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "http_resource_error_integration_response" {
  count             = "${length(var.http_methods)}"
  rest_api_id       = "${var.rest_api_id}"
  resource_id       = "${var.resource_id}"
  http_method       = "${element(var.http_methods, count.index)}"
  status_code       = "500"
  selection_pattern = ".*[ERROR].*"
}

resource "aws_api_gateway_integration_response" "http_resource_forbidden_integration_response" {
  count             = "${length(var.http_methods)}"
  rest_api_id       = "${var.rest_api_id}"
  resource_id       = "${var.resource_id}"
  http_method       = "${element(var.http_methods, count.index)}"
  status_code       = "403"
  selection_pattern = ".*[FORBIDDEN].*"
}

data "aws_region" "current" {}
