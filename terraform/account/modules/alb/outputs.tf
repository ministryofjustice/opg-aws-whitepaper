output "target_group_arns" {
  value = toset([aws_lb_target_group.sandbox_asg.arn])
}

output "alb_security_group_id" {
  value = aws_security_group.sandbox_lb_sg.id
}

output "subnet_ids" {
  value       = [for subnet in aws_subnet.private-subnet : subnet.id]
  description = "The IDs of the subnets created for the ALB"
}

output "alb_fqdn" {
  value = aws_lb.sandbox_lb.dns_name
}
