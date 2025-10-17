locals {
  bucket_name = lower(replace(
    "${var.org}-${var.domain}-${var.env}-data-${var.region}",
    "_", "-"
  ))

  prefix_layers = {
    silver = "silver/"
    golden = "golden/"
    bronze = "bronze/"
  }
}
