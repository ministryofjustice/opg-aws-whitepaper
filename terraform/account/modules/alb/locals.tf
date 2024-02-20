locals {
  http  = 80
  https = 443
  app   = 8080
  ssh   = 22

  private_subnets = {
    subnet1 = { cidr = var.public ? null : cidrsubnet(data.aws_vpc.default.cidr_block, 8, 0) },
    subnet2 = { cidr = var.public ? null : cidrsubnet(data.aws_vpc.default.cidr_block, 8, 1) },
    subnet3 = { cidr = var.public ? null : cidrsubnet(data.aws_vpc.default.cidr_block, 8, 2) }
  }

  az_list = tolist(var.availability_zones)
}
