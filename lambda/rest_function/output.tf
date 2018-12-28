output "lambda_arns" {
  value = "${aws_lambda_function.rest_function.*.arn}"
}
