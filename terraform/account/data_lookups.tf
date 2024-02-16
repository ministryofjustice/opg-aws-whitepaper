data "aws_vpc" "default" {
  default  = true
  provider = aws.sandbox
}


data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
  provider = aws.sandbox
}

data "aws_availability_zones" "default" {
  state    = "available"
  provider = aws.sandbox
}
