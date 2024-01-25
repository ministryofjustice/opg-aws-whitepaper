resource "aws_launch_configuration" "sandbox" {
  image_id        = "ami-0905a3c97561e0b69"
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.sandbox_sg]
  root_block_device {
    encrypted = true
  }
  metadata_options {
    http_tokens = "required"
  }

  user_data = <<-EOF
    #!/bin/bash
    echo "Hello, World!" > index.html
    nohup busybox httpd -f -p ${var.server_port} &
    EOF

  lifecycle {
    create_before_destroy = true
  }

  provider = aws
}

resource "aws_autoscaling_group" "sanbox" {
  launch_configuration = aws_launch_configuration.sandbox.name
  vpc_zone_identifier  = data.aws_subnets.default.ids

  min_size = 2
  max_size = 5

  tag {
    key                 = "Name"
    value               = "sandbox-asg"
    propagate_at_launch = true
  }
}

resource "aws_lb" "sandbox" {
  name               = "sandbox-asg-lb"
  load_balancer_type = "application"
  subnets            = data.aws_subnets.default.ids
}


resource "aws_security_group" "sandbox_sg" {
  name = "sandbox-sg"

  ingress {
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_security_group" "sandbox_alb" {
  name = "sandbox_alb"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.sandbox.arn
  port              = 80
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

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}
