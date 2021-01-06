resource "aws_api_gateway_method" "http_resource_method" {
  count         = var.enabled ? 1 : 0
  rest_api_id   = var.rest_api_id
  resource_id   = var.resource_id
  http_method   = var.http_method
  authorization = length(var.cognito_authorizer_id) > 0 ? "COGNITO_USER_POOLS" : "NONE"
  authorizer_id = length(var.cognito_authorizer_id) > 0 ? var.cognito_authorizer_id : ""

  request_parameters = merge(
    zipmap(
      split(",", length(var.cognito_authorizer_id) > 0 ? "method.request.header.Authorization" : "method.request.header.Host"), 
      list("true")
    ), 
    var.method_request_parameters
  )
}

resource "aws_api_gateway_method_response" "response" {
  count       = var.enabled ? length(var.response_codes) : 0
  rest_api_id = var.rest_api_id
  resource_id = var.resource_id
  http_method = aws_api_gateway_method.http_resource_method[0].http_method
  status_code = element(var.response_codes, count.index)

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin"  = true
  }

  depends_on = [
    "aws_api_gateway_method.http_resource_method",
  ]
}

resource "aws_api_gateway_integration" "http_resource_integration" {
  count       = var.enabled ? 1 : 0
  rest_api_id = var.rest_api_id
  resource_id = var.resource_id
  http_method = var.http_method
  type        = "AWS_PROXY"

  # Lambdas must always be invoked with a POST request
  uri                     = "arn:aws:apigateway:${data.aws_region.current.name}:lambda:path/2015-03-31/functions/${var.lambda_arn}/invocations"
  integration_http_method = "POST"

  request_parameters = merge(
    zipmap(
      split(",", length(var.cognito_authorizer_id) > 0 ? "integration.request.header.Authorization" : "integration.request.header.Host"), 
      split(",", length(var.cognito_authorizer_id) > 0 ? "method.request.header.Authorization" : "method.request.header.Host")
    ), 
    var.integration_request_parameters
  )

  request_templates = {
    "application/json" = var.json_request_template
  }

  depends_on = [
    "aws_api_gateway_method.http_resource_method",
  ]
}

data "aws_region" "current" {}
