module "public-loadbalancer" {
  source             = "./modules/alb"
  vpc_id             = data.aws_vpc.default.id
  private            = false
  subnet_ids         = data.aws_subnets.default.ids
  availability_zones = data.aws_availability_zones.default.names
  server_port        = local.server_port
  security_group     = module.ec2-web.security_group_id
  cluster_name       = "public-${local.web_cluster_name}"

  providers = {
    aws = aws.sandbox
  }
}

module "internal-loadbalancer" {
  source             = "./modules/alb"
  vpc_id             = data.aws_vpc.default.id
  private            = true
  availability_zones = data.aws_availability_zones.default.names
  cluster_name       = "private-${local.web_cluster_name}"
  server_port        = local.server_port
  security_group     = module.ec2-app.security_group_id
  providers = {
    aws = aws.sandbox
  }
}


module "ec2-web" {
  source              = "./modules/ec2"
  alb_security_group  = module.loadbalancer.alb_security_group_id
  target_group_arns   = module.loadbalancer.target_group_arns
  default_aws_subnets = data.aws_subnets.default.ids
  server_port         = local.server_port
  web_cluster_name    = local.web_cluster_name
  web_server          = true
  providers = {
    aws = aws.sandbox
  }
}

module "ec2-app" {
  source              = "./modules/ec2"
  alb_security_group  = module.loadbalancer.alb_security_group_id
  target_group_arns   = module.loadbalancer.target_group_arns
  default_aws_subnets = data.aws_subnets.default.ids
  server_port         = local.server_port
  web_cluster_name    = local.web_cluster_name
  web_server          = false
  providers = {
    aws = aws.sandbox
  }
}
