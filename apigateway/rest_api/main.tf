resource "aws_api_gateway_rest_api" "rest_api" {
  name        = "${var.cluster_name}-rest-api"
  description = "API for ${var.cluster_name}"
}

resource "aws_api_gateway_account" "rest_api_account" {
  cloudwatch_role_arn = "${aws_iam_role.rest_api_iam_role.arn}"
}
