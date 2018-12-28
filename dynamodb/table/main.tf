resource "aws_dynamodb_table" "submissions_table" {
  name = "${var.table_name}"

  read_capacity  = "${var.read_capacity}"
  write_capacity = "${var.write_capacity}"

  hash_key = "${var.primary_key}"

  attribute {
    name = "${var.primary_key}"
    type = "${var.primary_key_type}"
  }

  stream_enabled   = true
  stream_view_type = "NEW_IMAGE"
}
