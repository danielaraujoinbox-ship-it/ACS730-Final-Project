terraform {
  backend "s3" {
    bucket  = "acs730-dev-daniel009"
    key     = "terraform-state/dev/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}
