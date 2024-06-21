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


