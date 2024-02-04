data "aws_lb_target_group" "alb" {
  target_group_arns = var.target_group_arns
}
