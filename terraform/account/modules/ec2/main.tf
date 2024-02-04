resource "aws_launch_configuration" "sandbox" {
  image_id                    = "ami-0905a3c97561e0b69"
  instance_type               = "t2.micro"
  security_groups             = [aws_security_group.inbound.id]
  name_prefix                 = var.web_cluster_name
  associate_public_ip_address = false
  root_block_device {
    encrypted = true
  }

  metadata_options {
    http_tokens = "required"
  }

  lifecycle {
    create_before_destroy = true
  }

  user_data = <<-EOF
    #!/bin/bash
    echo "Hello, world from $(hostname -f)" > index.html
    nohup busybox httpd -f -p ${var.server_port} &
    EOF
}

resource "aws_autoscaling_group" "sandbox" {
  launch_configuration = aws_launch_configuration.sandbox.name
  vpc_zone_identifier  = var.default_aws_subnets

  target_group_arns = var.target_group_arns
  health_check_type = "ELB"

  min_size = 2
  max_size = 4
}

resource "aws_security_group" "inbound" {
  name        = "sandbox-sg"
  description = "Allow inbound HTTP traffic"
}

resource "aws_security_group_rule" "inbound" {
  type                     = "ingress"
  security_group_id        = aws_security_group.inbound.id
  from_port                = var.server_port
  to_port                  = var.server_port
  protocol                 = "tcp"
  source_security_group_id = var.alb_security_group
}
