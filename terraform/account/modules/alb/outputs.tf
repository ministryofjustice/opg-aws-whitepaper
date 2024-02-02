output "target_group_arns" {
  value = aws_lb_target_group.sandbox_asg.arn
}
