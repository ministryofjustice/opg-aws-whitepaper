output "ec2_security_group_id" {
  value = aws_security_group.inbound.id
}
