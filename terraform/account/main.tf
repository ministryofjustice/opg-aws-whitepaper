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
  cluster_name       = "public-web-${local.web_cluster_name}"
  web_security_group = module.ec2-web.inbound_security_group
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
  web_security_group = module.ec2-web.outbound_security_group
  app_security_group = module.ec2-app.inbound_security_group
  cluster_name       = "private-app-${local.app_cluster_name}"
  providers = {
    aws = aws.sandbox
  }
}

module "ec2-web" {
  source                   = "./modules/ec2"
  vpc_id                   = module.network.vpc.id
  target_group_arns        = module.web-loadbalancer.target_group_arns
  subnet_ids               = module.network.public_subnet_ids
  cluster_name             = local.web_cluster_name
  web_server_port          = local.web_server_port
  public                   = true
  public_loadbalancer_sg   = module.web-loadbalancer.alb_security_group_id
  internal_loadbalancer_sg = module.app-loadbalancer.alb_security_group_id
  app_alb_fqdn             = module.app-loadbalancer.alb_fqdn
  providers = {
    aws = aws.sandbox
  }
}

module "ec2-app" {
  source                   = "./modules/ec2"
  vpc_id                   = module.network.vpc.id
  target_group_arns        = module.app-loadbalancer.target_group_arns
  subnet_ids               = module.network.private_subnet_ids
  web_server_port          = local.app_server_port
  cluster_name             = local.app_cluster_name
  app_server_port          = local.app_server_port
  internal_loadbalancer_sg = module.app-loadbalancer.alb_security_group_id
  providers = {
    aws = aws.sandbox
  }
}
