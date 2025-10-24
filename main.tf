module "iam_role" {
  source = "./modules/iam_role"
  org    = var.ctx.org
  domain = var.ctx.domain
  env    = var.ctx.env
  region = var.ctx.region

}