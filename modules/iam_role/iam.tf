resource "aws_iam_role" "role_env" {
  name               = "role-laura-${var.env}"
  assume_role_policy = data.aws_iam_policy_document.trust_glue.json
}

#trust policy to assume a role one resource 

data "aws_iam_policy_document" "trust_glue" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["glue.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "glue_s3_rw" {
  statement {
    sid     = "ListBucket"
    effect  = "Allow"
    actions = ["s3:ListBucket", "s3:GetBucketLocation"]
    resources = ["arn:aws:s3:::${local.bucket_name}"]
  }

  statement {
    sid     = "RWObjects"
    effect  = "Allow"
    actions = [
      "s3:GetObject","s3:PutObject","s3:DeleteObject","s3:AbortMultipartUpload"
    ]
    resources = ["arn:aws:s3:::${local.bucket_name}/*"]
  }

 statement {
    sid     = "AllowS3AndKMS"
    effect  = "Allow"
    actions = [
      "kms:Encrypt","kms:Decrypt","kms:ReEncrypt*",
      "kms:GenerateDataKey*","kms:DescribeKey"
    ]
    resources = [aws_kms_key.s3_cmk.arn]

   
  }
}

resource "aws_iam_role_policy" "s3_rw" {
  role   = aws_iam_role.role_env.name
  name   = "s3-rw-${var.env}"
  policy = data.aws_iam_policy_document.glue_s3_rw.json
}


