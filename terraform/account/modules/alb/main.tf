resource "aws_lb" "sandbox_lb" {
  name                       = "${var.web_cluster_name}-lb"
  load_balancer_type         = "application"
  subnets                    = var.subnet_ids
  security_groups            = [aws_security_group.sandbox_lb_sg.id]
  drop_invalid_header_fields = true
}

resource "aws_lb_listener" "http" {
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
  listener_arn = aws_lb_listener.http.arn
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
  name     = "${var.web_cluster_name}-asg"
  port     = var.server_port
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 15
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_security_group" "sandbox_lb_sg" {
  name        = "${var.web_cluster_name}-lb-sg"
  description = "Allow access from the internet"
}

resource "aws_security_group_rule" "sandbox_lb_sg_rule" {
  type              = "ingress"
  security_group_id = aws_security_group.sandbox_lb_sg.id
  from_port         = 0
  to_port           = 0
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

# Create up to 3 availability zones, depending on input
/*
resource "aws_subnet" "public_subnet" {
  for_each          = var.availability_zones
  vpc_id            = var.vpc_id
  cidr_block        = "10.0.${count.index + 1}.0/24"
  availability_zone = element(data.aws_availability_zones.default.names, count.index)
}
*/
