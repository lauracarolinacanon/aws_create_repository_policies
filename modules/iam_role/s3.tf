resource "aws_s3_bucket" "data_lake" {
  bucket = local.bucket_name
  tags = {
    Name         = local.bucket_name
    Environment  = var.env
    Architecture = "Medallion"
  }
}

# Carpetas vacías (opcionales)
resource "aws_s3_object" "layers" {
  for_each = local.prefix_layers
  bucket   = aws_s3_bucket.data_lake.id
  key      = each.value
  content  = ""
}
##########################################

resource "aws_s3_bucket_server_side_encryption_configuration" "encryptions3" {
  bucket = aws_s3_bucket.data_lake.id

  #  depends_on = [
  #   aws_kms_key_policy.s3_cmk  # aseguras que la policy de la CMK esté antes
  # ]

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = aws_kms_key.s3_cmk.id
    }
    bucket_key_enabled = true
  }
}