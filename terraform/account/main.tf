module "network" {
  source = "./modules/network"
}

module "public-loadbalancer" {
  source             = "./modules/alb"
  vpc_id             = module.network.vpc.id
  public             = true
  subnet_ids         = module.network.public_subnets
  availability_zones = data.aws_availability_zones.default.names
  server_port        = local.web_server_port
  security_group     = module.ec2-web.public_security_group_id
  cluster_name       = "public-${local.web_cluster_name}"

  providers = {
    aws = aws.sandbox
  }
}

module "ec2-web" {
  source             = "./modules/ec2"
  alb_security_group = module.public-loadbalancer.alb_security_group_id
  target_group_arns  = module.public-loadbalancer.target_group_arns
  subnet_ids         = data.aws_subnets.default.ids
  server_port        = local.web_server_port
  cluster_name       = local.web_cluster_name
  public             = true
  app_server_port    = local.app_server_port
  # app_alb_fqdn       = module.internal-loadbalancer.alb_fqdn
  providers = {
    aws = aws.sandbox
  }
}
