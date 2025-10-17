module "iam" {
  source = "./modules/iam_role"
  org    = var.ctx.org
  domain = var.ctx.domain
  env    = var.ctx.env
  region = var.ctx.region
  # pass the single object
}



module "s3_bucket" {
  source = "./modules/s3_bucket"
  org    = var.ctx.org
  domain = var.ctx.domain
  env    = var.ctx.env
  region = var.ctx.region
  # pass the single object
}






# so we re gonna create everything in the apply and the destroy everything at the same time 
#and the just like create depends of the branch and thats it  but yeah today basically for create more things and objects 
#tomorrow with versioning and the firt thihg kms policies 