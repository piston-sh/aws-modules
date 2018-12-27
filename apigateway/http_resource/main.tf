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

resource "aws_api_gateway_method" "http_resource_method" {
  rest_api_id   = "${var.rest_api_id}"
  resource_id   = "${aws_api_gateway_resource.http_resource.id}"
  http_method   = "${var.http_method}"
  authorization = "NONE"
}

resource "aws_api_gateway_method_response" "response_200" {
  rest_api_id = "${var.rest_api_id}"
  resource_id = "${aws_api_gateway_resource.http_resource.id}"
  http_method = "${aws_api_gateway_method.http_resource_method.http_method}"
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
}

resource "aws_api_gateway_method_response" "response_500" {
  rest_api_id = "${var.rest_api_id}"
  resource_id = "${aws_api_gateway_resource.http_resource.id}"
  http_method = "${aws_api_gateway_method.http_resource_method.http_method}"
  status_code = "500"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
}

resource "aws_api_gateway_method_response" "response_403" {
  rest_api_id = "${var.rest_api_id}"
  resource_id = "${aws_api_gateway_resource.http_resource.id}"
  http_method = "${aws_api_gateway_method.http_resource_method.http_method}"
  status_code = "403"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
}

resource "aws_api_gateway_integration" "http_resource_integration" {
  rest_api_id = "${var.rest_api_id}"
  resource_id = "${aws_api_gateway_resource.http_resource.id}"
  http_method = "${aws_api_gateway_method.http_resource_method.http_method}"
  type        = "AWS"

  uri                     = "arn:aws:apigateway:${data.aws_region.current.name}:lambda:path/2015-03-31/functions/${var.lambda_arn}/invocations"
  integration_http_method = "POST"
}

resource "aws_api_gateway_integration_response" "http_resource_integration_response" {
  depends_on = [
    "aws_api_gateway_integration.http_resource_integration",
  ]

  rest_api_id = "${var.rest_api_id}"
  resource_id = "${aws_api_gateway_resource.http_resource.id}"
  http_method = "${aws_api_gateway_method.http_resource_method.http_method}"
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "http_resource_error_integration_response" {
  depends_on = [
    "aws_api_gateway_integration.http_resource_integration",
  ]

  rest_api_id       = "${var.rest_api_id}"
  resource_id       = "${aws_api_gateway_resource.http_resource.id}"
  http_method       = "${aws_api_gateway_method.http_resource_method.http_method}"
  status_code       = "500"
  selection_pattern = ".*[ERROR].*"
}

resource "aws_api_gateway_integration_response" "http_resource_forbidden_integration_response" {
  depends_on = [
    "aws_api_gateway_integration.http_resource_integration",
  ]

  rest_api_id       = "${var.rest_api_id}"
  resource_id       = "${aws_api_gateway_resource.http_resource.id}"
  http_method       = "${aws_api_gateway_method.http_resource_method.http_method}"
  status_code       = "403"
  selection_pattern = ".*[FORBIDDEN].*"
}

data "aws_region" "current" {}
