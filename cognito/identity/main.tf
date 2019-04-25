resource "aws_cognito_user_pool" "user_pool" {
  name = "${var.name}"

  alias_attributes = [
    "email",
  ]

  admin_create_user_config {
    allow_admin_create_user_only = "${var.allow_admin_create_user_only}"
  }

  password_policy {
    minimum_length    = "${var.password_min_length}"
    require_uppercase = "${var.password_require_uppercase}"
    require_lowercase = "${var.password_require_lowercase}"
    require_numbers   = "${var.password_require_numbers}"
    require_symbols   = "${var.password_require_symbols}"
  }

  schema {
    name                = "email"
    attribute_data_type = "String"
    mutable             = false
    required            = true
  }

  lambda_config {
    pre_sign_up = "${aws_lambda_function.register_function.arn}"
  }

  lifecycle {
    ignore_changes = ["schema"]
  }
}

resource "aws_cognito_user_pool_client" "user_pool_client" {
  name = "${var.name}"

  user_pool_id    = "${aws_cognito_user_pool.user_pool.id}"
  generate_secret = false

  explicit_auth_flows = [
    "ADMIN_NO_SRP_AUTH",
    "USER_PASSWORD_AUTH",
  ]
}

resource "aws_cognito_identity_pool" "identity_pool" {
  identity_pool_name      = "${var.identity_pool_name}"
  developer_provider_name = "${var.identity_pool_provider}"

  allow_unauthenticated_identities = false

  cognito_identity_providers {
    client_id               = "${aws_cognito_user_pool_client.user_pool_client.id}"
    server_side_token_check = true
    provider_name           = "cognito-idp.${data.aws_region.current.name}.amazonaws.com/${aws_cognito_user_pool.user_pool.id}"
  }
}

resource "aws_cognito_identity_pool_roles_attachment" "identity_pool_role_attachment" {
  identity_pool_id = "${aws_cognito_identity_pool.identity_pool.id}"

  roles = {
    authenticated = "${aws_iam_role.cognito.arn}"
  }
}

data "aws_region" "current" {}
