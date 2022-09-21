provider "aws" {
  region = "ap-southeast-1"
}

terraform {
  /*
  backend "s3" {
    # Replace this with your bucket name!
    bucket = "terraform-up-and-running-state-unique"
    key    = "global/s3/terraform.tfstate"
    region = "ap-southeast-1"
    # Replace this with your DynamoDB table name!
    dynamodb_table = "terraform-up-and-running-locks-hwang"
    encrypt        = true
  }
*/
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "terraform-up-and-running-state-unique"
  # Enable versioning so we can see the full revision history of our
  # state files
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
  name         = "terraform-up-and-running-locks-hwang"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}
