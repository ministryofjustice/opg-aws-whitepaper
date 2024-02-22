module "network" {
  source = "./modules/network"
  providers = {
    aws = aws.sandbox
  }
}


module "web-loadbalancer" {
  source             = "./modules/alb"
  vpc_id             = module.network.vpc.id
  public             = true
  subnet_ids         = module.network.public_subnet_ids
  availability_zones = data.aws_availability_zones.default.names
  server_port        = local.web_server_port
  ec2_security_group = module.ec2-web.inbound_security_group_id
  cluster_name       = "public-web-${local.web_cluster_name}"
  providers = {
    aws = aws.sandbox
  }
}

module "app-loadbalancer" {
  source             = "./modules/alb"
  vpc_id             = module.network.vpc.id
  public             = false
  subnet_ids         = module.network.private_subnet_ids
  availability_zones = data.aws_availability_zones.default.names
  server_port        = local.app_server_port
  ec2_security_group = module.ec2-app.inbound_security_group_id
  cluster_name       = "private-app-${local.app_cluster_name}"
  providers = {
    aws = aws.sandbox
  }
}

module "ec2-web" {
  source                   = "./modules/ec2-web"
  alb_security_group       = module.web-loadbalancer.alb_security_group_id
  vpc_id                   = module.network.vpc.id
  target_group_arns        = module.web-loadbalancer.target_group_arns
  subnet_ids               = module.network.public_subnet_ids
  server_port              = local.web_server_port
  cluster_name             = local.web_cluster_name
  public                   = true
  internal_loadbalancer_sg = module.app-loadbalancer.alb_security_group_id
  providers = {
    aws = aws.sandbox
  }
}

module "ec2-app" {
  source             = "./modules/ec2-app"
  alb_security_group = module.web-loadbalancer.alb_security_group_id
  vpc_id             = module.network.vpc.id
  target_group_arns  = module.app-loadbalancer.target_group_arns
  subnet_ids         = module.network.private_subnet_ids
  server_port        = local.app_server_port
  cluster_name       = local.app_cluster_name
  app_server_port    = local.app_server_port
  providers = {
    aws = aws.sandbox
  }
}
