resource "aws_kms_key" "s3_cmk" {
    description = "this is the aws_kms_key for the bucket ${locals.bucket_name}"
    key_usage = "ENCRYPT_DECRYPT"
    enable_key_rotation = true
    multi_region = false

}

resource "aws_kms_alias" "s3_cmk_alias" {
    name = "alias/s3-${locals.bucket_name}"
    target_key_id = aws_kms_key.s3_cmk.id
}


resource "server_side_encryption_configuration" "encryptions3" {
    bucket = locals.bucket_name
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_alias.s3_cmk_alias.target_key_id
        sse_algorithm = "aws:kms"
      }
    }

    bucket_key_enable = true
  }

  resource "aws_kms_key_policy" "policy_kms" {
    key_id = aws_kms_alias.s3_cmk_alias.target_key_id
    policy = data.aws_iam_policy_document.kms_policy.json
    
  }


# Autoriza al rol en la KMS (y root admin)
data "aws_iam_policy_document" "kms_policy" {


  statement {
    sid = "AllowGlueRoleUseViaS3"
    effect = "Allow"
    principals { 
        type = "AWS" 
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

    # Recomendado: limitar uso de la CMK a llamadas hechas por S3 en TU región
    condition {
      test     = "StringEquals"
      variable = "kms:ViaService"
      values   = ["s3.${data.aws_region.current.name}.amazonaws.com"]
    }
  }
}


