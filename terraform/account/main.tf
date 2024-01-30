module "ec2" {
  source       = "./modules/ec2"
  cluster_name = "sandbox-staging"
  providers = {
    aws = aws.sandbox
  }
}

module "ec2" {
  source       = "./modules/ec2"
  cluster_name = "sandbox-prp"
  providers = {
    aws = aws.sandbox
  }
}
