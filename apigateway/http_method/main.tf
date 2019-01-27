resource "aws_api_gateway_method" "http_resource_method" {
  count         = "${var.enabled ? 1 : 0}"
  rest_api_id   = "${var.rest_api_id}"
  resource_id   = "${var.resource_id}"
  http_method   = "${var.http_method}"
  authorization = "NONE"
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
    "method.response.header.x-amzn-requestid"             = false
    "method.response.header.x-amz-apigw-id"               = false
    "method.response.header.x-amzn-trace-id"              = false
    "method.response.header.x-amz-cf-id"                  = false
    "method.response.header.x-cache"                      = false
    "method.response.header.via"                          = false
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
    "method.response.header.x-amzn-requestid"             = false
    "method.response.header.x-amz-apigw-id"               = false
    "method.response.header.x-amzn-trace-id"              = false
    "method.response.header.x-amz-cf-id"                  = false
    "method.response.header.x-cache"                      = false
    "method.response.header.via"                          = false
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
    "method.response.header.x-amzn-requestid"             = false
    "method.response.header.x-amz-apigw-id"               = false
    "method.response.header.x-amzn-trace-id"              = false
    "method.response.header.x-amz-cf-id"                  = false
    "method.response.header.x-cache"                      = false
    "method.response.header.via"                          = false
  }

  depends_on = [
    "aws_api_gateway_method.http_resource_method",
  ]
}
