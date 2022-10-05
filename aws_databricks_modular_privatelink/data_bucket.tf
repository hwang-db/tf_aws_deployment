data "aws_iam_policy_document" "assume_role_for_ec2" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      identifiers = ["ec2.amazonaws.com"]
      type        = "Service"
    }
  }
}

resource "aws_iam_role" "role_for_s3_access" {
  name               = "${local.prefix}-ec2-role-for-s3"
  description        = "iam role for ec2 to access s3"
  assume_role_policy = data.aws_iam_policy_document.assume_role_for_ec2.json
  tags               = var.tags
}

data "aws_iam_policy_document" "pass_role_for_s3_access" {
  statement {
    effect    = "Allow"
    actions   = ["iam:PassRole"]
    resources = [aws_iam_role.role_for_s3_access.arn]
  }
}

resource "aws_iam_policy" "pass_role_for_s3_access" {
  name   = "${local.prefix}-pass-role-for-s3-access"
  path   = "/"
  policy = data.aws_iam_policy_document.pass_role_for_s3_access.json
}

resource "aws_iam_role_policy_attachment" "cross_account" {
  policy_arn = aws_iam_policy.pass_role_for_s3_access.arn
  role       = aws_iam_role.cross_account_role.name
}


// add grant s3 access policy to role
resource "aws_iam_role_policy_attachment" "test-attach-2" {
  policy_arn = aws_iam_policy.added_policy.arn
  role       = aws_iam_role.role_for_s3_access.name
}


resource "aws_iam_instance_profile" "instance_profile" {
  name = "${local.prefix}-instance-profile"
  role = aws_iam_role.role_for_s3_access.name
}

resource "databricks_instance_profile" "instance_profile" {
  instance_profile_arn = aws_iam_instance_profile.instance_profile.arn
  skip_validation      = true
}



output "role_for_s3_access_id" {
  value = aws_iam_role.role_for_s3_access.id
}

output "role_for_s3_access_name" {
  value = aws_iam_role.role_for_s3_access.name
}

output "instance_profile_arn" {
  value = aws_iam_instance_profile.instance_profile.arn
}

output "databricks_instance_profile_id" {
  value = databricks_instance_profile.instance_profile.id
}


// second way of creating roles and attach inline policies

/*
resource "aws_iam_role" "new_s3_data_access_role" {
  name               = "s3_data_access_iam_role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_for_ec2.json # (not shown)

  inline_policy {
    name = "policy-12345"

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action   = ["ec2:Describe*"]
          Effect   = "Allow"
          Resource = "*"
        },
      ]
    })
  }

  inline_policy {
    name   = "policy-54321"
    policy = data.aws_iam_policy_document.inline_policy.json
  }
}

data "aws_iam_policy_document" "inline_policy" {
  statement {
    actions   = ["ec2:DescribeAccountAttributes"]
    resources = ["*"]
  }
}


*/


// create a data s3 bucket
resource "aws_s3_bucket" "data_bucket" {
  bucket        = "data-bucket-for-test"
  acl           = "private"
  force_destroy = true
}


/*
data "databricks_aws_bucket_policy" "stuff" {
  bucket = aws_s3_bucket.data_bucket.bucket
}

resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.data_bucket.id
  policy = data.databricks_aws_bucket_policy.stuff.json
}

resource "aws_s3_bucket" "ds" {
  bucket = "${local.prefix}-ds"
  acl    = "private"
  versioning {
    enabled = false
  }
  force_destroy = true
  tags = merge(var.tags, {
    Name = "${local.prefix}-ds"
  })
}

//Bucket policy with full access
data "aws_iam_policy_document" "assume_role_for_ec2" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      identifiers = ["ec2.amazonaws.com"]
      type        = "Service"
    }
  }
}


// added policy to the role
resource "aws_iam_role_policy" "additional_policy" {
  name   = "${local.prefix}-policy-2"
  role   = aws_iam_role.cross_account_role.id
  policy = data.databricks_aws_bucket_policy.stuff.json
}


resource "aws_iam_role" "data_role" {
  name               = "${local.prefix}-first-ec2s3"
  description        = "(${local.prefix}) EC2 Assume Role role for S3 access"
  assume_role_policy = data.aws_iam_policy_document.assume_role_for_ec2.json
  tags               = var.tags
}

data "databricks_aws_bucket_policy" "ds" {
  provider         = databricks.mws
  full_access_role = aws_iam_role.data_role.arn
  bucket           = aws_s3_bucket.ds.bucket
}

// allow databricks to access this bucket
resource "aws_s3_bucket_policy" "ds" {
  bucket = aws_s3_bucket.ds.id
  policy = data.databricks_aws_bucket_policy.ds.json
}
*/
