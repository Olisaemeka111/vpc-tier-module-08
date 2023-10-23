# configure aws provider
provider "aws" {
  region  = var.region
  profile = var.profile
}

# create vpc for the appleSCH-website project
# reference the vpc module already created under the interview project folder
# double period takes one up two dirs
# list all variables for the vpc
module "vpc" {
  source                      = "../modules/vpc"
  region                      = var.region
  profile                     = var.profile
  project_name                = var.project_name
  vpc_cidr                    = var.vpc_cidr
  public_subnet_az1_cidr      = var.public_subnet_az1_cidr
  public_subnet_az2_cidr      = var.public_subnet_az2_cidr
  private_app_subnet_az1_cidr = var.private_app_subnet_az1_cidr
  private_app_subnet_az2_cidr = var.private_app_subnet_az2_cidr
  private_db_subnet_az1_cidr  = var.private_db_subnet_az1_cidr
  private_db_subnet_az2_cidr  = var.private_db_subnet_az2_cidr
}

# create nat-gateway
module "appleSCH_nat_gateway" {
  source                    = "../modules/NAT-GATEWAY"
  public_subnet_az1_id      = module.vpc.public_subnet_az1_id
  aws_internet_gateway      = module.vpc.aws_internet_gateway
  vpc_id                    = module.vpc.vpc_id
  public_subnet_az2_id      = module.vpc.public_subnet_az2_id
  private_app_subnet_az1_id = module.vpc.private_app_subnet_az1_id
  private_db_subnet_az1_id  = module.vpc.private_db_subnet_az1_id
  private_app_subnet_az2_id = module.vpc.private_app_subnet_az2_id
  private_db_subnet_az2_id  = module.vpc.private_db_subnet_az2_id
}

module "security_group" {
  source = "../modules/security-group"
  vpc_id = module.vpc.vpc_id
}

module "ECS-task-execution-role" {
  source       = "../modules/ECS-task-execution-role"
  project_name = module.vpc.project_name
}

module "aws-certificate-manager" {
  source           = "../modules/aws-certificate-manager"
  domain_name      = var.domain_name
  alternative_name = var.alternative_name
}

module "application_load_balancer" {
  source                = "../modules/ALB"
  project_name          = module.vpc.project_name
  alb_security_group_id = module.security_group.alb_security_group_id
  public_subnet_az1_id  = module.vpc.private_db_subnet_az1_id
  public_subnet_az2_id  = module.vpc.public_subnet_az2_id
  vpc_id                = module.vpc.vpc_id
  certificate_arn       = module.aws-certificate-manager.certificate_arn
}
