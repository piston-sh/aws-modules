resource "aws_api_gateway_deployment" "serverless_application_deployment" {
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

resource "aws_api_gateway_method" "http_resource_post_method" {
  rest_api_id   = "${var.rest_api_id}"
  resource_id   = "${aws_api_gateway_resource.http_resource.id}"
  http_method   = "${var.http_method}"
  authorization = "NONE"
}

resource "aws_api_gateway_method_response" "processor_200" {
  rest_api_id = "${var.rest_api_id}"
  resource_id = "${aws_api_gateway_resource.http_resource.id}"
  http_method = "${aws_api_gateway_method.http_resource_post_method.http_method}"
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
}

resource "aws_api_gateway_method_response" "processor_500" {
  rest_api_id = "${var.rest_api_id}"
  resource_id = "${aws_api_gateway_resource.http_resource.id}"
  http_method = "${aws_api_gateway_method.http_resource_post_method.http_method}"
  status_code = "500"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
}

resource "aws_api_gateway_method_response" "processor_403" {
  rest_api_id = "${var.rest_api_id}"
  resource_id = "${aws_api_gateway_resource.http_resource.id}"
  http_method = "${aws_api_gateway_method.http_resource_post_method.http_method}"
  status_code = "403"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
}

resource "aws_api_gateway_integration" "http_resource_post_integration" {
  rest_api_id = "${var.rest_api_id}"
  resource_id = "${aws_api_gateway_resource.http_resource.id}"
  http_method = "${aws_api_gateway_method.http_resource_post_method.http_method}"
  type        = "AWS"

  uri                     = "arn:aws:apigateway:${data.aws_region.current.name}:lambda:path/2015-03-31/functions/${var.lambda_arn}/invocations"
  integration_http_method = "${aws_api_gateway_method.http_resource_post_method.http_method}"
}

resource "aws_api_gateway_integration_response" "http_resource_post_integration_response" {
  depends_on = [
    "aws_api_gateway_integration.http_resource_post_integration",
  ]

  rest_api_id = "${var.rest_api_id}"
  resource_id = "${aws_api_gateway_resource.http_resource.id}"
  http_method = "${aws_api_gateway_method.http_resource_post_method.http_method}"
  status_code = "${aws_api_gateway_method_response.processor_200.status_code}"
}

resource "aws_api_gateway_integration_response" "http_resource_post_error_integration_response" {
  depends_on = [
    "aws_api_gateway_integration.http_resource_post_integration",
  ]

  rest_api_id       = "${var.rest_api_id}"
  resource_id       = "${aws_api_gateway_resource.http_resource.id}"
  http_method       = "${aws_api_gateway_method.http_resource_post_method.http_method}"
  status_code       = "${aws_api_gateway_method_response.processor_500.status_code}"
  selection_pattern = ".*[ERROR].*"
}

resource "aws_api_gateway_integration_response" "http_resource_post_forbidden_integration_response" {
  depends_on = [
    "aws_api_gateway_integration.http_resource_post_integration",
  ]

  rest_api_id       = "${var.rest_api_id}"
  resource_id       = "${aws_api_gateway_resource.http_resource.id}"
  http_method       = "${aws_api_gateway_method.http_resource_post_method.http_method}"
  status_code       = "${aws_api_gateway_method_response.processor_403.status_code}"
  selection_pattern = ".*[FORBIDDEN].*"
}

data "aws_region" "current" {}
