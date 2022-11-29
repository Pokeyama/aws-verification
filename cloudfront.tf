# CloudFront
resource "aws_cloudfront_distribution" "hriayama-cf" {
  # S3にアクセスするための諸々
  origin {
    domain_name = aws_s3_bucket.hirayama_bucket.bucket_regional_domain_name
    origin_id   = aws_s3_bucket.hirayama_bucket.id
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.hirayama-cf-identity.cloudfront_access_identity_path
    }
  }

  # ALBに向ける
  origin {
    domain_name = aws_lb.hirayama_alb.dns_name
    origin_id   = aws_lb.hirayama_alb.id
    custom_origin_config {
      http_port                = 80
      https_port               = 443
      origin_keepalive_timeout = 5
      # cfとalb間の通信
      origin_protocol_policy   = "http-only"
      origin_read_timeout      = 60
      origin_ssl_protocols     = ["TLSv1", "TLSv1.1", "TLSv1.2"]
    }
  }

  # アクセス許可
  enabled = true

  # enableで許可された人に最初に返すオブジェクト
  #  default_root_object = "index.html"

  # ALBのキャッシュ
  default_cache_behavior {
    allowed_methods  = ["HEAD", "DELETE", "POST", "GET", "OPTIONS", "PUT", "PATCH"]
    cached_methods   = ["HEAD", "GET", "OPTIONS"]
    target_origin_id = aws_lb.hirayama_alb.id

    forwarded_values {
      query_string = true
      cookies {
        forward = "all"
      }
      headers = ["*"]
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 10
    max_ttl                = 60
  }

  # S3のキャッシュ
  ordered_cache_behavior {
    # S3にリダイレクトするhttpメソッド
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = aws_s3_bucket.hirayama_bucket.id

    # クエリの数とかクッキーを使うかどうか
    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    # リクエストの圧縮許可
    compress               = true
    # httpsにリダイレクトさせる
    viewer_protocol_policy = "redirect-to-https"
    # CFに保存してるキャッシュを確認する最小時間
    min_ttl                = 0
    # デフォルトの時間 最小時間いる？
    default_ttl            = 3600
    # 最大時間
    max_ttl                = 86400
    path_pattern           = "/resources/*"
  }

  # 配信地域
  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["JP"]
    }
  }
  # SSL証明 httpsなら必須
  viewer_certificate {
    cloudfront_default_certificate = true
  }
}

resource "aws_cloudfront_origin_access_identity" "hirayama-cf-identity" {}