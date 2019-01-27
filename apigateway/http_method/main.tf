resource "aws_api_gateway_method" "http_resource_method" {
  count              = "${var.enabled ? 1 : 0}"
  rest_api_id        = "${var.rest_api_id}"
  resource_id        = "${var.resource_id}"
  http_method        = "${var.http_method}"
  authorization      = "${length(var.cognito_authorizer_id) > 0 ? "COGNITO_USER_POOLS" : "NONE"}"
  authorizer_id      = "${length(var.cognito_authorizer_id) > 0 ? "${var.cognito_authorizer_id}" : ""}"
  request_parameters = "${zipmap(split(",", length(var.cognito_authorizer_id) > 0 ? "method.request.header.Authorization" : ""), split(",", length(var.cognito_authorizer_id) > 0 ? "true" : ""))}"
}

resource "aws_api_gateway_method_response" "response_200" {
  count       = "${var.enabled ? 1 : 0}"
  rest_api_id = "${var.rest_api_id}"
  resource_id = "${var.resource_id}"
  http_method = "${aws_api_gateway_method.http_resource_method.http_method}"
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin"  = true
  }

  depends_on = [
    "aws_api_gateway_method.http_resource_method",
  ]
}

resource "aws_api_gateway_method_response" "response_500" {
  count       = "${var.enabled ? 1 : 0}"
  rest_api_id = "${var.rest_api_id}"
  resource_id = "${var.resource_id}"
  http_method = "${aws_api_gateway_method.http_resource_method.http_method}"
  status_code = "500"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin"  = true
  }

  depends_on = [
    "aws_api_gateway_method.http_resource_method",
  ]
}

resource "aws_api_gateway_method_response" "response_403" {
  count       = "${var.enabled ? 1 : 0}"
  rest_api_id = "${var.rest_api_id}"
  resource_id = "${var.resource_id}"
  http_method = "${aws_api_gateway_method.http_resource_method.http_method}"
  status_code = "403"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin"  = true
  }

  depends_on = [
    "aws_api_gateway_method.http_resource_method",
  ]
}
