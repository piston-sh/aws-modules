output "lambda_arns" {
  value = "${zipmap(keys(var.method_function_map), aws_lambda_function.rest_function.*.arn)}"
}

output "lambda_iam_role_names" {
  value = "${zipmap(keys(var.method_function_map), aws_iam_role.lambda_role.*.name)}"
}
