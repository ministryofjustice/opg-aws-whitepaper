resource "aws_launch_configuration" "sandbox" {
  image_id                    = "ami-0905a3c97561e0b69"
  instance_type               = "t2.micro"
  security_groups             = [aws_security_group.public-inbound.id, aws_security_group.ec2-ssh.id, aws_security_group.public-outbound.id]
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

  user_data = local.web_data_script
}

resource "aws_autoscaling_group" "sandbox" {
  launch_configuration = aws_launch_configuration.sandbox.name
  vpc_zone_identifier  = var.subnet_ids

  target_group_arns = var.target_group_arns
  health_check_type = "ELB"

  min_size = 2
  max_size = 2
}

resource "aws_security_group" "public-inbound" {
  vpc_id      = var.vpc_id
  name        = "${var.cluster_name}-inbound-sg"
  description = "Allow public inbound HTTP traffic"
}

resource "aws_security_group_rule" "public-inbound" {
  description              = "Allow ingress from public ALB"
  type                     = "ingress"
  security_group_id        = aws_security_group.public-inbound.id
  from_port                = var.server_port
  to_port                  = var.server_port
  protocol                 = "tcp"
  source_security_group_id = var.public_loadbalancer_sg
}

resource "aws_security_group" "public-outbound" {
  description = "Allow outbound to clone git repo etc"
  vpc_id      = var.vpc_id
  name        = "${var.cluster_name}-outbound"
}

resource "aws_security_group_rule" "public-outbound" {
  description       = "Allow outbound"
  type              = "egress"
  security_group_id = aws_security_group.public-outbound.id
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

resource "aws_security_group" "outbound-to-loadbalancer" {
  description = "Allow outbound traffic to the internal loadbalancer"
  vpc_id      = var.vpc_id
  name        = "${var.cluster_name}-to-loadbalancer"
}

resource "aws_security_group_rule" "outbound-to-loadbalancer" {
  description              = "Outbound to loadbalancer"
  type                     = "egress"
  security_group_id        = aws_security_group.outbound-to-loadbalancer.id
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = var.internal_loadbalancer_sg
}
