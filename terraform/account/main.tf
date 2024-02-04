module "loadbalancer" {
  source             = "./modules/alb"
  vpc_id             = data.aws_vpc.default.id
  subnet_ids         = data.aws_subnets.default.ids
  availability_zones = data.aws_availability_zones.default.names
  server_port        = local.server_port
  ec2_security_group = module.ec2.ec2_security_group_id
  web_cluster_name   = local.web_cluster_name
  providers = {
    aws = aws.sandbox
  }
}

module "ec2" {
  source              = "./modules/ec2"
  alb_security_group  = module.loadbalancer.alb_security_group_id
  target_group_arns   = module.loadbalancer.target_group_arns
  default_aws_subnets = data.aws_subnets.default.ids
  server_port         = local.server_port
  web_cluster_name    = local.web_cluster_name
  providers = {
    aws = aws.sandbox
  }
}
