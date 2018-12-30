output "lambda_arns" {
  value = "${zipmap(keys(var.method_function_map), aws_lambda_function.rest_function.*.arn)}"
}
