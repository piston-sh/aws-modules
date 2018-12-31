resource "aws_iam_role" "role" {
  name_prefix = "${var.cognito_name}-${var.name}-"

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

resource "aws_iam_policy" "policy" {
  name_prefix = "${var.cognito_name}-${var.name}-"
  policy      = "${data.template_file.policy.rendered}"
}

resource "aws_iam_policy_attachment" "lambda_attachment" {
  name = "${var.cognito_name}-${var.name}"

  policy_arn = "${aws_iam_policy.policy.arn}"
  roles      = ["${aws_iam_role.role.name}"]
}

data "template_file" "policy" {
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
      "Resource": "${user_pool_arn}"
    }
  ]
}
EOF

  vars {
    user_pool_arn = "${aws_cognito_user_pool.user_pool.arn}"
  }
}
