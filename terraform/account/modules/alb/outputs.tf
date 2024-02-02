output "target_group_arns" {
  value = aws_lb_target_group.sandbox_asg.arn
}

output "alb_security_group_id" {
  value = aws_security_group.sandbox_lb_sg.id
}
