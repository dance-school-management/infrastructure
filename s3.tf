# to create s3_bucket
resource "aws_s3_bucket" "users-media" {
  bucket = "users-media-bucket-dev-123456"
  region = "eu-north-1"


  tags = {
    Name        = "users-media-bucket"
    Environment = "Development"
  }
}

resource "aws_s3_bucket_public_access_block" "users-media" {
  bucket              = aws_s3_bucket.users-media.id
  block_public_policy = false

  block_public_acls       = true
  ignore_public_acls      = true
  restrict_public_buckets = false
}
# to create the backend application as IAM user
resource "aws_iam_user" "backend-apps" {
  name = "backend-apps-user"
}

# to allow the backend application execute certain operations
data "aws_iam_policy_document" "s3-bucket-access-document" {
  statement {
    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:DeleteObject"
    ]
    resources = ["${aws_s3_bucket.users-media.arn}/*"]
  }
}

# to allow public read access to the "public" folder in the bucket
data "aws_iam_policy_document" "public-access-read" {
  statement {
    actions = [
      "s3:GetObject"
    ]
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    resources = ["${aws_s3_bucket.users-media.arn}/public/*"]
  }
}

# connect bucket with policy
resource "aws_s3_bucket_policy" "public-access-read" {
  bucket     = aws_s3_bucket.users-media.id
  policy     = data.aws_iam_policy_document.public-access-read.json
  depends_on = [aws_s3_bucket_public_access_block.users-media]
}

# connect user with policy
resource "aws_iam_user_policy" "backend-apps-s3-access" {
  name   = "backend-apps-s3-access-policy"
  user   = aws_iam_user.backend-apps.name
  policy = data.aws_iam_policy_document.s3-bucket-access-document.json
}

# to create access keys for the backend application
resource "aws_iam_access_key" "backend-apps" {
  user = aws_iam_user.backend-apps.name
}

output "s3_bucket_name" {
  value = aws_s3_bucket.users-media.bucket
}
output "s3_bucket_region" {
  value = aws_s3_bucket.users-media.region
}

output "aws_access_key_id" {
  value     = aws_iam_access_key.backend-apps.id
  sensitive = true
}

output "aws_secret_access_key" {
  value     = aws_iam_access_key.backend-apps.secret
  sensitive = true
}
