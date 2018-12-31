resource "aws_lambda_function" "function" {
  s3_bucket     = "${var.s3_bucket_id}"
  s3_key        = "${var.s3_bucket_key}"
  function_name = "${var.identity_name}-${var.name}"
  role          = "${aws_iam_role.lambda.arn}"
  handler       = "${var.handler}"
  timeout       = "${var.function_timeout}"
  runtime       = "${var.runtime}"
}

resource "aws_lambda_permission" "function_permission" {
  action        = "lambda:InvokeFunction"
  statement_id  = "${var.identity_name}_${var.name}_allow_execution_from_cognito"
  function_name = "${aws_lambda_function.function.arn}"
  principal     = "cognito-idp.amazonaws.com"
  source_arn    = "${var.user_pool_arn}"
}
