output "inbound_security_group" {
  value = try(aws_security_group.internet-outbound.id, "")
}
