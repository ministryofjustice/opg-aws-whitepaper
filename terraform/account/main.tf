module "loadbalancer" {
  source = "./modules/alb"

  providers = {
    aws = aws.sandbox
  }
}
