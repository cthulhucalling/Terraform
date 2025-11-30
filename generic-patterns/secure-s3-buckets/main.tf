resource "aws_s3_bucket" "s3buckets" {
        bucket = var.bucketname
        tags = var.tags
}

resource "aws_s3_bucket_public_access_block" "public_access_block" {
      bucket = aws_s3_bucket.s3buckets.id

      block_public_acls       = true
      block_public_policy     = true
      ignore_public_acls      = true
      restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "bucket_encryption" {
        bucket = aws_s3_bucket.s3buckets.id

        rule {
                apply_server_side_encryption_by_default {
                        sse_algorithm = "AES256"
                }
        }
}

resource "aws_s3_bucket_versioning" "my_bucket_versioning" {
        bucket = aws_s3_bucket.s3buckets.id
        versioning_configuration {
                status = "Enabled"
        }
}

resource "aws_s3_bucket_versioning" "bucket_versioning" {
        bucket = aws_s3_bucket.s3buckets.id

        versioning_configuration {
                status = "Enabled"
        }
}
