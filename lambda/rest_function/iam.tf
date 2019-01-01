resource "aws_iam_role" "lambda_role" {
  count       = "${length(keys(var.method_function_map))}"
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
  name_prefix = "rest_function_policy-"
  policy      = "${data.template_file.lambda_policy.rendered}"
}

resource "aws_iam_policy_attachment" "lambda_attachment" {
  name  = "rest_function_policy_attachment-"

  policy_arn = "${aws_iam_policy.lambda.arn}"
  roles      = ["${aws_iam_role.lambda_role.*.name}"]
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
    }
  ]
}
EOF
}
