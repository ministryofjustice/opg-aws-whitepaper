resource "aws_launch_configuration" "sandbox" {
  image_id                    = "ami-0905a3c97561e0b69"
  instance_type               = "t2.micro"
  security_groups             = var.public ? [aws_security_group.public-inbound.id] : [aws_security_group.private-inbound.id]
  name_prefix                 = var.cluster_name
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

  # If the EC2 instance allows ingress from the public facing
  # ALB, then we know it's the web server and needs that
  # user data script
  user_data = var.public ? local.web_data_script : local.app_data_script

}

resource "aws_autoscaling_group" "sandbox" {
  launch_configuration = aws_launch_configuration.sandbox.name
  vpc_zone_identifier  = var.default_aws_subnets

  target_group_arns = var.target_group_arns
  health_check_type = "ELB"

  min_size = 2
  max_size = 4
}

resource "aws_security_group" "public-inbound" {
  count       = var.public ? 1 : 0
  name        = "${var.cluster_name}-public-inbound-sg"
  description = "Allow public inbound HTTP traffic"
}

resource "aws_security_group_rule" "public-inbound" {
  count                    = var.public ? 1 : 0
  description              = "Allow ingress from public ALB"
  type                     = "ingress"
  security_group_id        = aws_security_group.public-inbound.id
  from_port                = var.server_port
  to_port                  = var.server_port
  protocol                 = "tcp"
  source_security_group_id = var.alb_security_group
}

resource "aws_security_group" "private-inbound" {
  count       = var.public ? 0 : 1
  name        = "${var.cluster_name}-private-inbound-sg"
  description = "Allow internal inbound HTTP traffic"
}

resource "aws_security_group_rule" "private-inbound" {
  count                    = var.public ? 0 : 1
  description              = "Allow ingress from private ALB"
  type                     = "ingress"
  security_group_id        = aws_security_group.private-inbound.id
  from_port                = var.server_port
  to_port                  = var.server_port
  protocol                 = "tcp"
  source_security_group_id = var.alb_security_group
}

resource "aws_security_group" "private-outbound" {
  count       = var.public ? 0 : 1
  description = "Allow egress to the private ALB"
  name        = "${var.cluster_name}-private-outbound-sg"
}

resource "aws_security_group_rule" "private-outbound" {
  count                    = var.public ? 0 : 1
  description              = "Allow ingress to private ALB"
  type                     = "egress"
  security_group_id        = aws_security_group.private-outbound.id
  from_port                = var.app_server_port
  to_port                  = var.app_server_port
  protocol                 = "tcp"
  source_security_group_id = var.alb_security_group
}
