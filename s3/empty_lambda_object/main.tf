resource "aws_s3_bucket_object" "object" {
  bucket = "${var.s3_bucket_name}"
  key    = "${var.s3_bucket_key}"
  source = "${data.archive_file.archive.output_path}"
  etag   = "${md5(file("${data.archive_file.archive.output_path}"))}"
}

data "archive_file" "archive" {
  type        = "zip"
  source_dir  = "${path.module}/files/empty_function"
  output_path = "${path.module}/files/${var.filename}"
}
