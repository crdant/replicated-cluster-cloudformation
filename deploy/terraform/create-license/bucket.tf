resource "random_pet" "bucket_suffix" {
  length = 2
}

resource "aws_s3_bucket" "licenses" {
  bucket = "slackernews-license-${random_pet.bucket_suffix.id}"
}

resource "aws_s3_bucket_ownership_controls" "licenses" {
  bucket = aws_s3_bucket.licenses.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "licenses" {
  depends_on = [ aws_s3_bucket_ownership_controls.licenses ]

  bucket = aws_s3_bucket.licenses.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "licenses" {
  bucket = aws_s3_bucket.licenses.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "licenses" {
  bucket = aws_s3_bucket.licenses.id

  rule {
    id     = "expire_objects"
    status = "Enabled"

    expiration {
      days = 1
    }
  }
}

resource "aws_iam_policy" "lambda_license_bucket" {
  name   = "lambda_license_bucket"
  policy = data.aws_iam_policy_document.lambda_license_bucket.json
}

data "aws_iam_policy_document" "lambda_license_bucket" {
  statement {
    actions   = [
      "s3:ListBucket",
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:PutObject",
      "s3:DeleteObject",
      "s3:PutObject",
    ]
    resources = [ "${aws_s3_bucket.licenses.arn}/*" ]
  }
}

resource "aws_iam_role_policy_attachment" "lambda_license_bucket" {
  role       = aws_iam_role.license_lambda_exec_role.id
  policy_arn = aws_iam_policy.lambda_license_bucket.arn
}
