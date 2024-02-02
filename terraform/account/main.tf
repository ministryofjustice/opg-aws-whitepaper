module "loadbalancer" {
  source             = "./modules/alb"
  vpc_id             = data.aws_vpc.default.id
  subnet_ids         = data.aws_subnets.default.ids
  availability_zones = data.aws_availability_zones.default.names
  providers = {
    aws = aws.sandbox
  }
}
