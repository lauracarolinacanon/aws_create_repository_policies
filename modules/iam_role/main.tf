
resource "aws_iam_role" "role-env" {
  name = "role-laura-${var.env}"
  assume_role_policy = data.aws_iam_policy_document.trust_glue.json

  }


resource "aws_iam_role_policy" "s3_rw" {
 role = aws_iam_role.role-env.id
 name = "s3-rw-${var.env}"
 policy = data.aws_iam_policy_document.glue_s3_rw.json
}


#trust policy to assume a role one resource 
data "aws_iam_policy_document" "trust_glue" {
    statement {
        effect = "Allow"
        actions = ["sts:AssumeRole"]

        principals {
        type        = "Service"
        identifiers = ["glue.amazonaws.com"]
    }

}
}


data "aws_iam_policy_document" "glue_s3_rw" {
 statement {
 sid = "ListBucket"
 effect = "Allow"
 actions = ["s3:ListBucket"]
 resources = ["arn:aws:s3:::${local.bucket_name}"]
 }
 statement {
 sid = "RWObjects"
 effect = "Allow"
 actions = ["s3:GetObject","s3:PutObject","s3:DeleteObject"]
 resources = ["arn:aws:s3:::${local.bucket_name}/*"]
 }
}

