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
