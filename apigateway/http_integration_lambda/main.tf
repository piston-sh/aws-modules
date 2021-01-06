resource "aws_api_gateway_integration" "http_resource_integration" {
  count       = "${var.enabled ? 1 : 0}"
  rest_api_id = var.rest_api_id
  resource_id = var.resource_id
  http_method = var.http_method
  type        = "AWS_PROXY"

  # Lambdas must always be invoked with a POST request
  uri                     = "arn:aws:apigateway:${data.aws_region.current.name}:lambda:path/2015-03-31/functions/${var.lambda_arn}/invocations"
  integration_http_method = "POST"

  request_parameters = "${merge(
    zipmap(
      split(",", var.auth_enabled ? "integration.request.header.Authorization" : "integration.request.header.Host"), 
      split(",", var.auth_enabled ? "method.request.header.Authorization" : "method.request.header.Host")
    ), 
    var.custom_request_parameters
  )}"

  request_templates = {
    "application/json" = var.json_request_template
  }
}

data "aws_region" "current" {}
