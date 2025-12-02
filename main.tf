module "iam_role" {
  source = "./modules/iam_role"
  org    = var.org
  domain = var.domain
  env    = var.env
  region = var.region

}