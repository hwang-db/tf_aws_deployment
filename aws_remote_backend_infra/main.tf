provider "aws" {
  region = var.region
}

terraform {
  backend "s3" {
    bucket         = "tf-backend-bucket-hwang" # Replace this with your bucket name!
    key            = "global/s3/terraform.tfstate"
    region         = "ap-southeast-1"
    dynamodb_table = "tf-backend-dynamodb-hwang" # Replace this with your DynamoDB table name!
    encrypt        = true
  }
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = var.bucket_name
  # Enable versioning so we can see the full revision history of state files
  versioning {
    enabled = true
  }
  force_destroy = true
  # Enable server-side encryption by default
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_dynamodb_table" "terraform_locks" {
  name         = var.dynamodb_table
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}
