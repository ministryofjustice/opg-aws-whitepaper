output "public_security_group_id" {
  value = aws_security_group.public-inbound[0].id
}

output "private_security_group_id" {
  value = aws_security_group.private-inbound[0].id
}
