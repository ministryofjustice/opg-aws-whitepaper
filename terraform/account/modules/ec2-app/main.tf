resource "aws_launch_configuration" "sandbox" {
  image_id                    = "ami-0905a3c97561e0b69"
  instance_type               = "t2.micro"
  security_groups             = [aws_security_group.inbound.id, aws_security_group.ec2-ssh.id, aws_security_group.internet-outbound.id]
  name_prefix                 = var.cluster_name
  associate_public_ip_address = true
  key_name                    = "sandbox"

  root_block_device {
    encrypted = true
  }

  metadata_options {
    http_tokens = "required"
  }

  lifecycle {
    create_before_destroy = true
  }

  user_data = local.app_data_script
}

resource "aws_autoscaling_group" "sandbox" {
  launch_configuration = aws_launch_configuration.sandbox.name
  vpc_zone_identifier  = var.subnet_ids

  target_group_arns = var.target_group_arns
  health_check_type = "ELB"

  min_size = 2
  max_size = 2
}

resource "aws_security_group" "inbound" {
  vpc_id      = var.vpc_id
  name        = "${var.cluster_name}-inbound-sg"
  description = "Allow inbound HTTP traffic"
}

resource "aws_security_group_rule" "inbound" {
  description              = "Allow ingress from internal ALB"
  type                     = "ingress"
  security_group_id        = aws_security_group.inbound.id
  from_port                = var.server_port
  to_port                  = var.server_port
  protocol                 = "tcp"
  source_security_group_id = var.internal_loadbalancer_sg
}

resource "aws_security_group" "internet-outbound" {
  description = "Allow outbound to clone git repo etc"
  vpc_id      = var.vpc_id
  name        = "${var.cluster_name}-outbound"
}

resource "aws_security_group_rule" "internet-outbound" {
  description       = "Allow outbound"
  type              = "egress"
  security_group_id = aws_security_group.internet-outbound.id
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group" "ec2-ssh" {
  description = "Allow SSH for debug"
  vpc_id      = var.vpc_id
  name        = "${var.cluster_name}-ssh-sg"
}

resource "aws_security_group_rule" "ec2-ssh" {
  description       = "Allow SSH"
  type              = "ingress"
  security_group_id = aws_security_group.ec2-ssh.id
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}
