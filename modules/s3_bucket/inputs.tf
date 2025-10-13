#variables globally of the modeule 

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


variable "org"    {
     description = "name of the organization"
     type = string
     }  

variable "domain" { 
    description = "name of the organization"
    type = string
     }    






   