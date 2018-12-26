output "rest_api_id" {
  value = "${aws_api_gateway_rest_api.rest_api.id}"
}

output "rest_api_resource_id" {
  value = "${aws_api_gateway_rest_api.rest_api.root_resource_id}"
}

output "iam_role_arn" {
  value = "${aws_iam_role.rest_api_iam_role.arn}"
}
