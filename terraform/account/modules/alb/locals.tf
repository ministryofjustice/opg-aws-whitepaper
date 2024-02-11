locals {
  http  = 80
  https = 443
  ssh   = 22

  private_subnets = {
    "a" = { cidr_block = "10.0.1.0/16" },
    "b" = { cidr_block = "10.0.2.0/16" },
    "c" = { cidr_block = "10.0.3.0/16" }
  }

  # If the loadbalancer is public, we don't want to create unnecessary subnets
  subnets = var.public ? {} : local.private_subnets
}
