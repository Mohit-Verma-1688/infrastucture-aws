# Generated by Terragrunt. Sig: nIlQXj57tbuaRZEa
terraform {
  backend "s3" {
    bucket         = "mvlab-terraform-state"
    dynamodb_table = "terraform-lock-table"
    encrypt        = true
    key            = "./terraform.tfstate"
    region         = "us-east-1"
    role_arn       = "arn:aws:iam::833192599359:role/terraform"
  }
}
