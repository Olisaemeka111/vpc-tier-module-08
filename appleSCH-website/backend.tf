# store the terraform state file for the appleSCH-website in s3
terraform {
  backend "s3" {
    bucket  = "applesch-website"
    key     = "applesch-website.tfstate"
    region  = "eu-west-2"
    profile = "otillia-aws"
  }
}