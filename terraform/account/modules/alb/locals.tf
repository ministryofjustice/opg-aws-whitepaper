locals {
  http  = 80
  https = 443
  ssh   = 22

  private_subnets = {
    subnet1 = { cidr = var.public ? null : cidrsubnet(data.aws_vpc.default.cidr_block, 8, 0) },
    subnet2 = { cidr = var.public ? null : cidrsubnet(data.aws_vpc.default.cidr_block, 8, 1) },
    subnet3 = { cidr = var.public ? null : cidrsubnet(data.aws_vpc.default.cidr_block, 8, 2) }
  }

  subnet_cidrs = var.public ? [] : cidrsubnets(aws_default_vpc.default.cidr_block, 8, 8, 8)

  az_list = tolist(var.availability_zones)
}
