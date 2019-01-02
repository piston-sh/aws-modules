resource "aws_iam_role" "lambda_role" {
  count       = "${var.enabled ? length(keys(var.method_function_map)) : 0}"
  name_prefix = "${element(keys(var.method_function_map), count.index)}_lambda_role-"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
        "Action": "sts:AssumeRole",
        "Principal": {
            "Service": "lambda.amazonaws.com"
        },
        "Effect": "Allow",
        "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy" "lambda" {
  count       = "${var.enabled ? 1 : 0}"
  name_prefix = "rest_function_policy-"
  policy      = "${data.aws_iam_policy_document.lambda_policy.json}"
}

resource "aws_iam_policy_attachment" "lambda_attachment" {
  count      = "${var.enabled ? 1 : 0}"
  name       = "rest_function_policy_attachment"
  policy_arn = "${aws_iam_policy.lambda.arn}"
  roles      = ["${aws_iam_role.lambda_role.*.name}"]
}

resource "aws_iam_policy_attachment" "lambda_custom_attachment" {
  count      = "${var.enabled ? 1 : 0}"
  name       = "custom_rest_function_policy_attachment"
  policy_arn = "${var.custom_policy_arn}"
  roles      = ["${aws_iam_role.lambda_role.*.name}"]
}

data "aws_iam_policy_document" "lambda_policy" {
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = ["arn:aws:logs:*:*:*"]
  }
}
