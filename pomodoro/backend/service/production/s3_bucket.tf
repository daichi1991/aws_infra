resource "aws_s3_bucket" "prod_pomodoro_backend_pipeline_artifact" {
  bucket = "prod-pomodoro-backend-codepipeline"
}

resource "aws_s3_bucket_public_access_block" "prod_pomodoro_backend_pipeline_artifact" {
  bucket                  = aws_s3_bucket.prod_pomodoro_backend_pipeline_artifact.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# ---------------------------
# S3 bucket to store WAF logs
# ---------------------------
# resource "aws_s3_bucket" "wafcharm_reporting" {
#   bucket              = local.wafcharm_waf_logs_bucket_name
#   force_destroy       = false
#   object_lock_enabled = false
# }

# resource "aws_s3_bucket_acl" "wafcharm_reporting" {
#   bucket = aws_s3_bucket.wafcharm_reporting.bucket

#   access_control_policy {
#     grant {
#       permission = "FULL_CONTROL"

#       grantee {
#         id   = data.aws_canonical_user_id.current.id
#         type = "CanonicalUser"
#       }
#     }

#     owner {
#       //display_name = "prod"
#       id = data.aws_canonical_user_id.current.id
#     }
#   }
# }

# resource "aws_s3_bucket_policy" "wafcharm_reporting" {
#   bucket = aws_s3_bucket.wafcharm_reporting.bucket
#   policy = jsonencode(
#     {
#       Statement = [
#         {
#           Action = "s3:PutObject"
#           Condition = {
#             ArnLike = {
#               "aws:SourceArn" = "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:*"
#             }
#             StringEquals = {
#               "aws:SourceAccount" = data.aws_caller_identity.current.account_id
#               "s3:x-amz-acl"      = "bucket-owner-full-control"
#             }
#           }
#           Effect = "Allow"
#           Principal = {
#             Service = "delivery.logs.amazonaws.com"
#           }
#           Resource = "${aws_s3_bucket.wafcharm_reporting.arn}/AWSLogs/${data.aws_caller_identity.current.account_id}/*"
#           Sid      = "AWSLogDeliveryWrite"
#         },
#         {
#           Action = "s3:GetBucketAcl"
#           Condition = {
#             ArnLike = {
#               "aws:SourceArn" = "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:*"
#             }
#             StringEquals = {
#               "aws:SourceAccount" = data.aws_caller_identity.current.account_id
#             }
#           }
#           Effect = "Allow"
#           Principal = {
#             Service = "delivery.logs.amazonaws.com"
#           }
#           Resource = aws_s3_bucket.wafcharm_reporting.arn
#           Sid      = "AWSLogDeliveryAclCheck"
#         },
#       ]
#       Version = "2012-10-17"
#     }
#   )
# }

# resource "aws_s3_bucket_public_access_block" "wafcharm_reporting" {
#   bucket                  = aws_s3_bucket.wafcharm_reporting.bucket
#   block_public_acls       = true
#   block_public_policy     = true
#   ignore_public_acls      = true
#   restrict_public_buckets = true
# }

# resource "aws_s3_bucket_versioning" "wafcharm_reporting" {
#   bucket = aws_s3_bucket.wafcharm_reporting.bucket

#   versioning_configuration {
#     status = "Disabled"
#   }
# }

# resource "aws_s3_bucket_notification" "wafcharm_reporting" {
#   bucket      = aws_s3_bucket.wafcharm_reporting.bucket
#   eventbridge = false

#   lambda_function {
#     events              = ["s3:ObjectCreated:*"]
#     filter_prefix       = "AWSLogs/${data.aws_caller_identity.current.account_id}/WAFLogs/${data.aws_region.current.name}/${aws_wafv2_web_acl.wafcharm.name}/"
#     lambda_function_arn = aws_lambda_function.wafcharm_reporting.arn
#   }
# }

# resource "aws_s3_bucket_lifecycle_configuration" "wafcharm_reporting" {
#   bucket = aws_s3_bucket.wafcharm_reporting.bucket

#   rule {
#     id     = "delete-old-objects"
#     status = "Enabled"

#     expiration {
#       days                         = 60
#       expired_object_delete_marker = false
#     }
#   }
# }


# ---------------------------
# S3 bucket to RDS snapshot to ap-northeast-3
# ---------------------------
resource "aws_s3_bucket" "rds_snapshot_copy" {
  bucket = "rds-snapshot-copy-functions-bucket"
}

resource "aws_s3_bucket_object" "rds_snapshot_copy" {
  bucket = aws_s3_bucket.rds_snapshot_copy.id
  key    = "rds_snapshot_copy/rds_snapshot_copy.zip"
  source = "rds_snapshot_copy.zip"
}

resource "aws_s3_bucket_acl" "rds_snapshot_copy" {
  bucket = aws_s3_bucket.rds_snapshot_copy.bucket

  access_control_policy {
    grant {
      permission = "FULL_CONTROL"

      grantee {
        id   = data.aws_canonical_user_id.current.id
        type = "CanonicalUser"
      }
    }

    owner {
      display_name = "dev"
      id           = data.aws_canonical_user_id.current.id
    }
  }
}
/*
resource "aws_s3_bucket_policy" "rds_snapshot_copy" {
  bucket = aws_s3_bucket.rds_snapshot_copy.bucket
  policy = jsonencode(
    {
      Statement = [
        {
          Action = "s3:PutObject"
          Condition = {
            ArnLike = {
              "aws:SourceArn" = "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:*"
            }
            StringEquals = {
              "aws:SourceAccount" = data.aws_caller_identity.current.account_id
              "s3:x-amz-acl"      = "bucket-owner-full-control"
            }
          }
          Effect = "Allow"
          Principal = {
            Service = "delivery.logs.amazonaws.com"
          }
          Resource = "${aws_s3_bucket.rds_snapshot_copy.arn}/AWSLogs/${data.aws_caller_identity.current.account_id}/*"
          Sid      = "AWSLogDeliveryWrite"
        },
        {
          Action = "s3:GetBucketAcl"
          Condition = {
            ArnLike = {
              "aws:SourceArn" = "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:*"
            }
            StringEquals = {
              "aws:SourceAccount" = data.aws_caller_identity.current.account_id
            }
          }
          Effect = "Allow"
          Principal = {
            Service = "delivery.logs.amazonaws.com"
          }
          Resource = aws_s3_bucket.wafcharm_reporting.arn
          Sid      = "AWSLogDeliveryAclCheck"
        },
      ]
      Version = "2012-10-17"
    }
  )
}*/
