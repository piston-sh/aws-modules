resource "aws_lambda_function" "rest_function" {
  count         = var.enabled ? length(keys(var.method_function_map)) : 0
  s3_bucket     = var.s3_bucket_id
  s3_key        = element(values(var.method_function_map), count.index)
  function_name = "${var.cluster_name}_${var.group_name}_${lower(element(keys(var.method_function_map), count.index))}"
  role          = element(aws_iam_role.lambda_role.*.arn, count.index)
  handler       = var.runtime == "go1.x" ? "${var.group_name}_${lower(element(keys(var.method_function_map), count.index))}" : var.handler
  timeout       = var.function_timeout
  runtime       = var.runtime

  environment {
    variables = var.method_env_map[element(keys(var.method_function_map), count.index)]
  }
}

resource "aws_lambda_permission" "rest_function_api_gateway_permission" {
  count         = var.enabled ? length(keys(var.method_function_map)) : 0
  statement_id  = "${var.cluster_name}_${lower(element(keys(var.method_function_map), count.index))}_allow_execution_from_gateway"
  action        = "lambda:InvokeFunction"
  function_name = element(aws_lambda_function.rest_function.*.function_name, count.index)
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${var.rest_api_execution_arn}/*/*/*"
}

resource "aws_lambda_permission" "rest_function_release_bucket_permission" {
  count         = var.enabled ? length(keys(var.method_function_map)): 0
  statement_id  = "${var.cluster_name}_${lower(element(keys(var.method_function_map), count.index))}_release_bucket_permission"
  action        = "lambda:InvokeFunction"
  function_name = element(aws_lambda_function.rest_function.*.arn, count.index)
  principal     = "s3.amazonaws.com"
  source_arn    = var.s3_bucket_arn
}
