variable "region" {} 
variable "project_name" {
    description = "this is the project name"
    type = string
    default = "interview-project"
} 
variable "vpc_cidr" {}
variable "public_subnet_az1_cidr" {}
variable "public_subnet_az2_cidr" {}
variable "private_app_subnet_az1_cidr" {}
variable "private_app_subnet_az2_cidr" {}
variable "private_db_subnet_az1_cidr" {}
variable "private_db_subnet_az2_cidr" {}
