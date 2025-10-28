resource "aws_kms_key" "s3_cmk" {
  description         = "this is the aws_kms_key for the bucket ${local.bucket_name}"
  key_usage           = "ENCRYPT_DECRYPT"
  enable_key_rotation = true
  multi_region        = false
}

resource "aws_kms_alias" "s3_cmk_alias" {
  name          = "alias/s3-${local.bucket_name}"
  target_key_id = aws_kms_key.s3_cmk.id
}

##############################################
data "aws_iam_policy_document" "kms_policy" {
  # Admin a root (recomendado)
  statement {
    sid    = "RootAdmin"
    effect = "Allow"
    principals { 
    type = "AWS" 
    identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
     }
    actions   = ["kms:*"]
    resources = ["*"]
  }

  # Rol de Glue puede usar la CMK solo via S3
  statement {
    sid    = "AllowGlueRoleUseViaS3"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = [aws_iam_role.role_env.arn]
    }
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey"
    ]
    resources = ["*"]

   
  }
}

resource "aws_kms_key_policy" "policy_kms" {
  key_id = aws_kms_key.s3_cmk.id
  policy = data.aws_iam_policy_document.kms_policy.json
}