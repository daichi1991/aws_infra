resource "aws_s3_bucket" "pomodoro_backend" {
  for_each = local.s3
  bucket   = each.key
}

resource "aws_s3_bucket_public_access_block" "pomodoro_backend" {
  for_each                = local.s3
  bucket                  = aws_s3_bucket.pomodoro_backend[each.key].id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "pomodoro_backend" {
  bucket = aws_s3_bucket.pomodoro_backend["pomodoro-backend"].id

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : [
          "s3:PutObject"
        ],
        "Effect" : "Allow",
        "Resource" : "arn:aws:s3:::pomodoro-backend/*/AWSLogs/${data.aws_caller_identity.current.account_id}/*",
        "Principal" : {
          "AWS" : [
            "arn:aws:iam::582318560864:root"
          ]
        }
      }
    ]
  })
}
