resource "aws_iam_role" "iam_role" {
  name = "${length(var.subdomain) > 0 ? "${var.subdomain}" : "root" }-cloudfront-edge-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "lambda.amazonaws.com",
          "edgelambda.amazonaws.com"
        ]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "lambda_role_policy" {
  name = "${length(var.subdomain) > 0 ? "${var.subdomain}" : "root" }-cloudfront-edge-policy"
  role = "${aws_iam_role.iam_role.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
      {
         "Effect": "Allow",
         "Action": [
            "logs:*"
         ],
         "Resource": [
            "*"
         ]
      }
  ]
}
EOF
}
