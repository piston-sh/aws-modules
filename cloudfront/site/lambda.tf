resource "aws_lambda_function" "lambda_at_edge" {
  filename         = "${data.archive_file.lambda.output_path}"
  function_name    = "${length(var.subdomain) > 0 ? "${var.subdomain}" : "root" }-cloudfront-lambda-at-edge"
  role             = "${aws_iam_role.iam_role.arn}"
  handler          = "index.handler"
  runtime          = "nodejs6.10"
  source_code_hash = "${base64sha256(file("${data.archive_file.lambda.output_path}"))}"
  publish          = "true"
}

data "archive_file" "lambda" {
  type        = "zip"
  source_dir  = "${path.module}/files/lambda_at_edge"
  output_path = "${path.module}/files/lambda_at_edge.zip"
}
