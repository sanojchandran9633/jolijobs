terraform {
  backend "s3" {
    bucket       = "jolijobs-terraform-bknd-dev"
    key          = "dev/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}