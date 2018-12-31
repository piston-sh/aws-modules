resource "aws_s3_bucket" "site_bucket" {
  bucket = "${var.bucket_name}"
  acl    = "public-read"

  website {
    index_document = "index.html"
    error_document = "index.html"
  }

  versioning {
    enabled = true
  }

  tags {
    name      = "${var.bucket_name}"
    terraform = "true"
  }
}
