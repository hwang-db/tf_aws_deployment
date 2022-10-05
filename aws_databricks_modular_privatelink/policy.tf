resource "aws_iam_policy" "added_policy" {
  name        = "test-policy"
  description = "A test policy"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "grantS3Access",
            "Effect": "Allow",
            "Action": [
                "s3:GetObject",
                "s3:GetObjectVersion",
                "s3:PutObject",
                "s3:DeleteObject",
                "s3:ListBucket",
                "s3:GetBucketLocation"
            ],
            "Resource": [
                "arn:aws:s3:::data-bucket-for-test/*",
                "arn:aws:s3:::data-bucket-for-test"
            ]
        }
    ]
}
EOF
}

/*
resource "aws_iam_role_policy_attachment" "test-attach" {
  role       = aws_iam_role.cross_account_role.name
  policy_arn = aws_iam_policy.added_policy.arn
}
*/
