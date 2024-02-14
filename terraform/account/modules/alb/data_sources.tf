data "aws_vpc" "default" {
  default  = true
  provider = aws.sandbox
}
