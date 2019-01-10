resource "aws_iam_instance_profile" "nat_profile" {
  count       = "${var.nat_gateway_enabled && var.use_nat_instance ? 1 : 0}"
  name_prefix = "${var.name}-nat-profile-"
  role        = "${aws_iam_role.role.name}"
}

resource "aws_iam_role" "role" {
  count       = "${var.nat_gateway_enabled && var.use_nat_instance ? 1 : 0}"
  name_prefix = "${var.name}-nat-role-"
  path        = "/"

  assume_role_policy = <<EOF
{
    "Version": "2008-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {"AWS": "*"},
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "modify_routes" {
  count       = "${var.nat_gateway_enabled && var.use_nat_instance ? 1 : 0}"
  name_prefix = "${var.name}-nat-modify-routes-"
  role        = "${aws_iam_role.role.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
        {
            "Action": [
                "ec2:ReplaceRoute",
                "ec2:CreateRoute",
                "ec2:DeleteRoute",
                "ec2:DescribeRouteTables",
                "ec2:DescribeNetworkInterfaces",
                "ec2:DescribeInstanceAttribute"
            ],
            "Effect": "Allow",
            "Resource": "*"
        }
    ]
}
EOF
}
