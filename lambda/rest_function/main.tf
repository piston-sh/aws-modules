resource "aws_lambda_function" "rest_function" {
  s3_bucket = "${var.s3_bucket_id}"
  s3_key    = "${var.s3_bucket_key}"

  function_name = "${var.cluster_name}_${var.function_name}"
  role          = "${var.iam_role_arn}"
  handler       = "${var.handler}"
  timeout       = "${var.function_timeout}"

  runtime = "${var.runtime}"
}

resource "aws_lambda_permission" "rest_function_api_gateway_permission" {
  statement_id = "${var.cluster_name}_${var.function_name}_allow_execution_from_gateway"

  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.rest_function.function_name}"

  principal = "apigateway.amazonaws.com"

  source_arn = "arn:aws:execute-api:${data.aws_region.current.name}::${var.rest_api_id}/*/${var.integration_http_method}${var.resource_path}"
}

resource "aws_lambda_permission" "rest_function_release_bucket_permission" {
  statement_id = "${var.cluster_name}_${var.function_name}_release_bucket_permission"

  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.rest_function.arn}"

  principal  = "s3.amazonaws.com"
  source_arn = "${var.s3_bucket_arn}"
}

data "aws_region" "current" {}
