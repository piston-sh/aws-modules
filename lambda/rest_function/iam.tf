resource "aws_iam_role" "lambda_role" {
  count        = "${length(keys(var.function_key_map))}"
  name_prefix  = "${element(keys(var.function_key_map), count.index)}_lambda_role-"

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
