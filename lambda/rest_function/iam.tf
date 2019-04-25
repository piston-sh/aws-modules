resource "aws_iam_role" "lambda_role" {
  count       = var.enabled ? length(keys(var.method_function_map)) : 0
  name_prefix = "${var.group_name}_${element(keys(var.method_function_map), count.index)}-"

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
  count       = var.enabled ? 1 : 0
  name_prefix = "${var.group_name}-"
  policy      = data.aws_iam_policy_document.lambda_policy.json
}

resource "aws_iam_policy_attachment" "lambda_attachment" {
  count      = var.enabled ? 1 : 0
  name       = "rest_function_policy_attachment"
  policy_arn = aws_iam_policy.lambda.arn[0]
  roles      = aws_iam_role.lambda_role.*.name
}

resource "aws_iam_policy_attachment" "lambda_custom_attachment" {
  count      = var.enabled && length(var.custom_policy_arn) > 0 ? 1 : 0
  name       = "custom_rest_function_policy_attachment"
  policy_arn = var.custom_policy_arn
  roles      = aws_iam_role.lambda_role.*.name
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
