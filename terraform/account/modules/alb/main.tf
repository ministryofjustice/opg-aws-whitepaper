resource "aws_lb" "sandbox_lb" {
  name                       = "${var.cluster_name}-lb"
  load_balancer_type         = "application"
  subnets                    = var.subnet_ids
  security_groups            = var.public ? [aws_security_group.sandbox_lb_sg_public[0].id] : [aws_security_group.sandbox_lb_sg_internal[0].id]
  drop_invalid_header_fields = true
  internal                   = var.public ? false : true
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.sandbox_lb.arn
  port              = local.http
  protocol          = "HTTP"

  # By default, return a 404 page
  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "404: page not found"
      status_code  = 404
    }
  }
}

resource "aws_lb_listener_rule" "sandbox_asg" {
  listener_arn = aws_lb_listener.listener.arn
  priority     = 100

  condition {
    path_pattern {
      values = ["*"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.sandbox_asg.arn
  }
}

resource "aws_lb_target_group" "sandbox_asg" {
  name     = "${var.cluster_name}-asg"
  port     = var.server_port
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/health"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 20
    timeout             = 3
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
}

resource "aws_security_group" "sandbox_lb_sg_public" {
  count       = var.public ? 1 : 0
  vpc_id      = var.vpc_id
  name        = "${var.cluster_name}-lb-sg"
  description = "Loadbalancer public security group"
}

resource "aws_security_group_rule" "sandbox_lb_sg_public_ingress" {
  count             = var.public ? 1 : 0
  description       = "Allow access from internet"
  type              = "ingress"
  security_group_id = aws_security_group.sandbox_lb_sg_public[0].id
  from_port         = local.http
  to_port           = local.http
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "sandbox_lb_sg_public_egress" {
  count                    = var.public ? 1 : 0
  description              = "Allow egress from loadbalancer to the web servers"
  type                     = "egress"
  security_group_id        = aws_security_group.sandbox_lb_sg_public[0].id
  from_port                = var.server_port
  to_port                  = var.server_port
  protocol                 = "tcp"
  source_security_group_id = var.web_security_group
}

resource "aws_security_group" "sandbox_lb_sg_internal" {
  count       = var.public ? 0 : 1
  vpc_id      = var.vpc_id
  name        = "${var.cluster_name}-lb-sg"
  description = "Loadbalancer private security group"
}

resource "aws_security_group_rule" "sandbox_lb_sg_internal_ingress" {
  count                    = var.public ? 0 : 1
  description              = "Allow access from web servers"
  type                     = "ingress"
  security_group_id        = aws_security_group.sandbox_lb_sg_internal[0].id
  from_port                = local.http
  to_port                  = local.http
  protocol                 = "tcp"
  source_security_group_id = var.web_security_group
}

resource "aws_security_group_rule" "sandbox_lb_sg_internal_egress" {
  count                    = var.public ? 0 : 1
  description              = "Allow egress to the app servers"
  type                     = "egress"
  security_group_id        = aws_security_group.sandbox_lb_sg_internal[0].id
  from_port                = var.server_port
  to_port                  = var.server_port
  protocol                 = "tcp"
  source_security_group_id = var.app_security_group
}
