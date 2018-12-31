resource "aws_iam_role" "cognito" {
  name_prefix        = "${var.name}-identity-"
  assume_role_policy = "${data.template_file.cognito_policy.rendered}"
}

resource "aws_iam_role" "lambda" {
  name_prefix = "${var.name}-identity-register-"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": {
    "Effect": "Allow",
    "Principal": {
      "Service": "lambda.amazonaws.com"
    },
    "Action": "sts:AssumeRole"
  }
}
EOF
}

resource "aws_iam_policy" "lambda" {
  name_prefix = "${var.name}-identity-register-"
  policy      = "${data.template_file.lambda_policy.rendered}"
}

resource "aws_iam_policy_attachment" "lambda_attachment" {
  name = "${var.name}-identity-register"

  policy_arn = "${aws_iam_policy.lambda.arn}"
  roles      = ["${aws_iam_role.lambda.name}"]
}

data "template_file" "cognito_policy" {
  template = <<EOF
{
  "Version": "2012-10-17",
  "Statement": {
    "Effect": "Allow",
    "Principal": {
      "Federated": "cognito-identity.amazonaws.com"
    },
    "Action": "sts:AssumeRoleWithWebIdentity",
    "Condition": {
      "StringEquals": {
        "cognito-identity.amazonaws.com:aud": "$${identity_pool_id}"
      },
      "ForAnyValue:StringLike": {
        "cognito-identity.amazonaws.com:amr": "authenticated"
      }
    }
  }
}
EOF

  vars {
    identity_pool_id = "${aws_cognito_identity_pool.identity_pool.id}"
  }
}

data "template_file" "lambda_policy" {
  template = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "cognito-idp:ListUsers"
      ],
      "Resource": "$${user_pool_arn}"
    }
  ]
}
EOF

  vars {
    user_pool_arn = "${aws_cognito_user_pool.user_pool.arn}"
  }
}
