# S3
resource "aws_s3_bucket" "hirayama_bucket" {
  bucket_prefix = "hirayama-bucket"

  # terraformからバケットの中身を削除できないようにする
  #   force_destroy = false

  # 非推奨
  #   website {
  #     index_document = "index.html"
  #     error_document = "error.html"
  #   }
}

# S3とポリシーをつなぐ
resource "aws_s3_bucket_policy" "hirayama_bucket_policy" {
  bucket = aws_s3_bucket.hirayama_bucket.id
  policy = data.aws_iam_policy_document.hirayama_s3_policy.json
}

# S3で使うポリシー
data "aws_iam_policy_document" "hirayama_s3_policy" {
  statement {
    sid    = "Allow CloudFront"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.hirayama-cf-identity.iam_arn]
    }
    actions = [
      "s3:GetObject"
    ]

    resources = [
      "${aws_s3_bucket.hirayama_bucket.arn}/*"
    ]
  }
}

resource "aws_s3_bucket_website_configuration" "example" {
  bucket = aws_s3_bucket.hirayama_bucket.bucket

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }

  routing_rule {
    condition {
      key_prefix_equals = "docs/"
    }
    redirect {
      replace_key_prefix_with = "documents/"
    }
  }
}

# S3にアップロードするオブジェクト
resource "aws_s3_object" "index_page" {
  bucket       = aws_s3_bucket.hirayama_bucket.id
  key          = "index.html"
  source       = "resources/index.html"
  content_type = "text/html"
}

resource "aws_s3_object" "error_page" {
  bucket       = aws_s3_bucket.hirayama_bucket.id
  key          = "error.html"
  source       = "resources/error.html"
  content_type = "text/html"
}