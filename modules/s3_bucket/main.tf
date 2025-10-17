# Exactly ONE bucket per module call (no for_each here)
resource "aws_s3_bucket" "data_lake" {
  bucket = local.bucket_name
  tags = {
    Name         = local.bucket_name
    Environment  = var.env
    Architecture = "Medallion"
  }
}

# Create folders for the three layers


resource "aws_s3_object" "layers" {
  for_each = local.prefix_layers
  bucket   = aws_s3_bucket.data_lake.id
  key      = each.value
  content  = ""
}
