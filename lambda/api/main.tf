module "lambda_functions" {
  source = "github.com/piston-sh/tf-aws-modules/lambda/rest_function"

  enabled                = "${length(keys(var.method_function_map)) > 0}"
  cluster_name           = "${var.cluster_name}"
  group_name             = "${var.group_name}"
  rest_api_execution_arn = "${var.rest_api_execution_arn}"
  s3_bucket_id           = "${var.s3_bucket_id}"
  s3_bucket_arn          = "${var.s3_bucket_arn}"
  custom_policy_arn      = "${var.custom_policy_arn}"

  method_function_map = "${var.method_function_map}"
  method_env_map      = "${var.method_env_map}"
}

module "resource" {
  source = "github.com/piston-sh/tf-aws-modules/apigateway/http_resource"

  rest_api_id      = "${var.rest_api_id}"
  path_part        = "${var.path_part}"
  root_resource_id = "${length(var.root_resource_id) > 0 ? "${var.root_resource_id}" : "${var.rest_api_resource_id}"}"
}

module "get_method" {
  source = "github.com/piston-sh/tf-aws-modules/apigateway/http_method"

  enabled               = "${contains(keys(var.method_function_map), "GET")}"
  rest_api_id           = "${var.rest_api_id}"
  resource_id           = "${module.resource.resource_id}"
  http_method           = "GET"
  cognito_authorizer_id = "${var.cognito_authorizer_id}"

  custom_request_parameters = "${zipmap(
    formatlist("method.%s", var.get_request_params),
    compact(split(",", replace(join(",", var.get_request_params), "/.+/", "true"))),
  )}"
}

module "get_integration" {
  source = "github.com/piston-sh/tf-aws-modules/apigateway/http_integration_lambda"

  enabled      = "${contains(keys(var.method_function_map), "GET")}"
  rest_api_id  = "${var.rest_api_id}"
  resource_id  = "${module.resource.resource_id}"
  http_method  = "GET"
  lambda_arn   = "${lookup(module.lambda_functions.lambda_arns, "GET", "")}"
  auth_enabled = "${length(var.cognito_authorizer_id) > 0}"

  custom_request_parameters = "${zipmap(
    formatlist("integration.%s", var.get_request_params),
    formatlist("method.%s", var.get_request_params),
  )}"

  json_request_template = "${var.get_request_template}"
}

module "post_method" {
  source = "github.com/piston-sh/tf-aws-modules/apigateway/http_method"

  enabled               = "${contains(keys(var.method_function_map), "POST")}"
  rest_api_id           = "${var.rest_api_id}"
  resource_id           = "${module.resource.resource_id}"
  http_method           = "POST"
  cognito_authorizer_id = "${var.cognito_authorizer_id}"

  custom_request_parameters = "${zipmap(
    formatlist("method.%s", var.post_request_params),
    compact(split(",", replace(join(",", var.post_request_params), "/.+/", "true"))),
  )}"
}

module "post_integration" {
  source = "github.com/piston-sh/tf-aws-modules/apigateway/http_integration_lambda"

  enabled      = "${contains(keys(var.method_function_map), "POST")}"
  rest_api_id  = "${var.rest_api_id}"
  resource_id  = "${module.resource.resource_id}"
  http_method  = "POST"
  lambda_arn   = "${lookup(module.lambda_functions.lambda_arns, "POST", "")}"
  auth_enabled = "${length(var.cognito_authorizer_id) > 0}"

  custom_request_parameters = "${zipmap(
    formatlist("integration.%s", var.post_request_params),
    formatlist("method.%s", var.post_request_params),
  )}"

  json_request_template = "${var.post_request_template}"
}

module "put_method" {
  source = "github.com/piston-sh/tf-aws-modules/apigateway/http_method"

  enabled               = "${contains(keys(var.method_function_map), "PUT")}"
  rest_api_id           = "${var.rest_api_id}"
  resource_id           = "${module.resource.resource_id}"
  http_method           = "PUT"
  cognito_authorizer_id = "${var.cognito_authorizer_id}"

  custom_request_parameters = "${zipmap(
    formatlist("method.%s", var.put_request_params),
    compact(split(",", replace(join(",", var.put_request_params), "/.+/", "true"))),
  )}"
}

module "put_integration" {
  source = "github.com/piston-sh/tf-aws-modules/apigateway/http_integration_lambda"

  enabled      = "${contains(keys(var.method_function_map), "PUT")}"
  rest_api_id  = "${var.rest_api_id}"
  resource_id  = "${module.resource.resource_id}"
  http_method  = "PUT"
  lambda_arn   = "${lookup(module.lambda_functions.lambda_arns, "PUT", "")}"
  auth_enabled = "${length(var.cognito_authorizer_id) > 0}"

  custom_request_parameters = "${zipmap(
    formatlist("integration.%s", var.put_request_params),
    formatlist("method.%s", var.put_request_params),
  )}"

  json_request_template = "${var.put_request_template}"
}

module "delete_method" {
  source = "github.com/piston-sh/tf-aws-modules/apigateway/http_method"

  enabled               = "${contains(keys(var.method_function_map), "DELETE")}"
  rest_api_id           = "${var.rest_api_id}"
  resource_id           = "${module.resource.resource_id}"
  http_method           = "DELETE"
  cognito_authorizer_id = "${var.cognito_authorizer_id}"

  custom_request_parameters = "${zipmap(
    formatlist("method.%s", var.delete_request_params),
    compact(split(",", replace(join(",", var.delete_request_params), "/.+/", "true"))),
  )}"
}

module "delete_integration" {
  source = "github.com/piston-sh/tf-aws-modules/apigateway/http_integration_lambda"

  enabled      = "${contains(keys(var.method_function_map), "DELETE")}"
  rest_api_id  = "${var.rest_api_id}"
  resource_id  = "${module.resource.resource_id}"
  http_method  = "DELETE"
  lambda_arn   = "${lookup(module.lambda_functions.lambda_arns, "DELETE", "")}"
  auth_enabled = "${length(var.cognito_authorizer_id) > 0}"

  custom_request_parameters = "${zipmap(
    formatlist("integration.%s", var.delete_request_params),
    formatlist("method.%s", var.delete_request_params),
  )}"

  json_request_template = "${var.delete_request_template}"
}
