output "target_group_arns" {
  value = toset([aws_lb_target_group.sandbox_asg.arn])
}

output "alb_security_group_id" {
  value = var.public ? aws_security_group.sandbox_lb_sg_public[0].id : aws_security_group.sandbox_lb_sg_internal[0].id
}

output "alb_fqdn" {
  value = aws_lb.sandbox_lb.dns_name
}
