locals {
  http  = 80
  https = 443
  ssh   = 22

  vpc_id = var.vpc_id != "" ? var.vpc_id : data.aws_vpc.default.id
}
