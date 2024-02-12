locals {
  http  = 80
  https = 443
  ssh   = 22

  private_subnets = {
    "a" = { cidr_block = "10.0.1.0/16" },
    "b" = { cidr_block = "10.0.2.0/16" },
    "c" = { cidr_block = "10.0.3.0/16" }
  }

  subnet_cidrs = var.public ? [] : cidrsubnets("172.31.48.0", 8, 8, 8)

  az_list = tolist(var.availability_zones)
}
