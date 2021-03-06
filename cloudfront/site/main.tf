resource "aws_route53_record" "www" {
  count   = "${var.enable_route53 ? 1 : 0}"
  zone_id = data.aws_route53_zone.hosted_zone.zone_id
  name    = "${length(var.subdomain) > 0 ? "${var.subdomain}.${var.root_domain}" : "${var.root_domain}" }"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.distribution.domain_name
    zone_id                = "Z2FDTNDATAQYW2"
    evaluate_target_health = false
  }
}

resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = "Restrict s3 buckets to cloudfront distribution only"
}

resource "aws_cloudfront_distribution" "distribution" {
  comment = var.comment

  origin {
    domain_name = aws_s3_bucket.site_bucket.website_endpoint
    origin_id   = "SiteBucket"

    custom_origin_config {
        http_port              = "80"
        https_port             = "443"
        origin_protocol_policy = "http-only"
        origin_ssl_protocols   = ["TLSv1.1", "TLSv1.2"]
    }
  }

  enabled             = true
  default_root_object = "index.html"

  price_class = "PriceClass_100"
  aliases     = ["${length(var.subdomain) > 0 ? "${var.subdomain}.${var.root_domain}" : "${var.root_domain}" }"]

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "SiteBucket"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    lambda_function_association {
      event_type = "origin-request"
      lambda_arn = "${aws_lambda_function.lambda_at_edge.arn}:${aws_lambda_function.lambda_at_edge.version}"
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  viewer_certificate {
    acm_certificate_arn      = var.acm_certificate_arn
    minimum_protocol_version = "TLSv1"
    ssl_support_method       = "sni-only"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = {
    provisioner = "terraform"
  }

  depends_on = [
    aws_s3_bucket.site_bucket,
  ]
}

data "aws_route53_zone" "hosted_zone" {
  name = "${var.root_domain}."
}
