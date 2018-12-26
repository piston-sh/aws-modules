output "lambda_arn" {
  value = "${aws_lambda_function.rest_function.arn}"
}
