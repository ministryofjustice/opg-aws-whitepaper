module "network" {
  source = "./modules/network"
  providers = {
    aws = aws.sandbox
  }
}

module "public-loadbalancer" {
  source             = "./modules/alb"
  vpc_id             = module.network.vpc.id
  public             = true
  subnet_ids         = module.network.public_subnet_ids
  availability_zones = data.aws_availability_zones.default.names
  server_port        = local.web_server_port
  security_group     = module.ec2-web.public_security_group_id
  cluster_name       = "public-${local.web_cluster_name}"

  providers = {
    aws = aws.sandbox
  }
}

module "private-loadbalancer" {
  source             = "./modules/alb"
  vpc_id             = module.network.vpc.id
  public             = false
  subnet_ids         = module.network.private_subnet_ids
  availability_zones = data.aws_availability_zones.default.names
  server_port        = local.app_server_port
  security_group     = module.ec2-app.private_security_group_id
  cluster_name       = "private-${local.web_cluster_name}"

  providers = {
    aws = aws.sandbox
  }
}


module "ec2-web" {
  source             = "./modules/ec2"
  alb_security_group = module.public-loadbalancer.alb_security_group_id
  vpc_id             = module.network.vpc.id
  target_group_arns  = module.public-loadbalancer.target_group_arns
  subnet_ids         = module.network.public_subnet_ids
  server_port        = local.web_server_port
  cluster_name       = local.web_cluster_name
  public             = true
  app_server_port    = local.app_server_port
  app_alb_fqdn       = module.private-loadbalancer.alb_fqdn
  providers = {
    aws = aws.sandbox
  }
}

module "ec2-app" {
  source             = "./modules/ec2"
  alb_security_group = module.private-loadbalancer.alb_security_group_id
  vpc_id             = module.network.vpc.id
  target_group_arns  = module.private-loadbalancer.target_group_arns
  subnet_ids         = module.network.private_subnet_ids
  server_port        = local.app_server_port
  cluster_name       = local.app_cluster_name
  public             = false
  app_server_port    = local.app_server_port
  app_alb_fqdn       = module.private-loadbalancer.alb_fqdn
  providers = {
    aws = aws.sandbox
  }
}
