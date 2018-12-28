output "lambda_arns" {
  type = "list"
  value = "${aws_lambda_function.rest_function.*.arn}"
}
