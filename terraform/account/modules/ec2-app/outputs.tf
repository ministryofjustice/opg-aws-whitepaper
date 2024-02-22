output "inbound_security_group_id" {
  value = try(aws_security_group.inbound.id, "")
}
