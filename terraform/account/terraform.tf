terraform {

  backend "s3" {
    bucket         = "opg.terraform.state"
    key            = "aws-whitepaper/account/terraform.tfstate"
    encrypt        = true
    region         = "eu-west-1"
    role_arn       = "arn:aws:iam::311462405659:role/sandbox-whitepaper-ci"
    dynamodb_table = "remote_lock"
  }

}

provider "github" {
  token = var.github_token
  owner = "ministryofjustice"
}

locals {
  sandbox = "995199299616"
}

provider "aws" {
  alias = "sandbox"

  assume_role {
    role_arn     = "arn:aws:iam::${local.sandbox}:role/${var.DEFAULT_ROLE}"
    session_name = "terraform-session"
  }
}

variable "DEFAULT_ROLE" {
  default = "sandbox-whitepaper-ci"
}

data "aws_caller_identity" "current" {
  provider = aws.sandbox
}