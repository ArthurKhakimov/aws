resource "aws_s3_bucket" "versioning_bucket" {
  bucket = "my-versioning-bucket-26092021"
  acl    = "private"
  versioning {
    enabled = true
  }
  lifecycle_rule {
    id      = "my-rule"
    enabled = true
    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }
    expiration {
      days = 90
    }
  }
}

resource "aws_s3_bucket_object" "upload_file" {
  bucket = aws_s3_bucket.versioning_bucket.id
  acl    = "private"
  key    = "testfile"
  source = "testfile.txt"
  etag   = filemd5("testfile.txt")
}

resource "null_resource" "change_file" {
  provisioner "local-exec" {
    command = "echo 'Changed by terraform' >> testfile.txt"
  }
}

resource "aws_s3_bucket_object" "upload_file_after_change" {
  bucket     = aws_s3_bucket.versioning_bucket.id
  acl        = "private"
  key        = "testfile"
  source     = "testfile.txt"
  depends_on = [null_resource.change_file]
}
