module "ec2" {
  source = "./modules/ec2"
  providers = {
    aws = aws.sandbox
  }
}
