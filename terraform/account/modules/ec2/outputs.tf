output "outbound_security_group" {
  value = try(aws_security_group.outbound-to-loadbalancer[0].id, "")
}

output "inbound_security_group" {
  value = try(aws_security_group.public-inbound[0].id, "")
}

output "inbound_from_loadbalancer_security_group" {
  value = try(aws_security_group.inbound-from-loadbalancer[0].id, "")
}
