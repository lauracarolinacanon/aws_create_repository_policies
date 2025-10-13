#s3 variables

# One map keyed by env; each value holds org/domain/region
variable "definition_s3_buckets" {
  description = "Per-environment S3 definitions"
  type = map(object({
    org    : string
    domain : string
    region : string
  }))
}


variable "region" {
    type = string
    description = "the region where im gona create my resources"
    default = "us-east-1"
  
}

variable "env" {
    type = string
    description = "enviroment"
    validation {
    condition = contains(["dev","prod","qa"],var.env)
    error_message = "must be dev prod or qa"
    
    }
  
}