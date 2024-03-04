resource "aws_launch_configuration" "sandbox" {
  image_id                    = "ami-0905a3c97561e0b69"
  instance_type               = "t2.micro"
  security_groups             = var.public ? [aws_security_group.outbound-to-loadbalancer[0].id, aws_security_group.public-inbound[0].id, aws_security_group.internet-outbound.id, aws_security_group.ec2-ssh.id] : [aws_security_group.inbound-from-loadbalancer[0].id, aws_security_group.ec2-ssh.id, aws_security_group.internet-outbound.id]
  associate_public_ip_address = true
  name_prefix                 = var.cluster_name
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

  user_data = var.public ? local.web_data_script : local.app_data_script
}

resource "aws_autoscaling_group" "sandbox" {
  name                 = var.public ? "web-autoscaling-group" : "app-autoscaling-group"
  launch_configuration = aws_launch_configuration.sandbox.name
  vpc_zone_identifier  = var.subnet_ids

  target_group_arns = var.target_group_arns
  health_check_type = "ELB"

  min_size = 2
  max_size = 2
}

# -------------------- Public Security Groups -------------------------------

resource "aws_security_group" "public-inbound" {
  count       = var.public ? 1 : 0
  vpc_id      = var.vpc_id
  name        = "${var.cluster_name}-inbound-sg"
  description = "Allow public inbound HTTP traffic"

  tags = {
    Name = "${var.cluster_name}-public-inbound-sg"
  }
}

resource "aws_security_group_rule" "public-inbound" {
  count                    = var.public ? 1 : 0
  description              = "Allow ingress from public ALB"
  type                     = "ingress"
  security_group_id        = aws_security_group.public-inbound[0].id
  from_port                = var.web_server_port
  to_port                  = var.web_server_port
  protocol                 = "tcp"
  source_security_group_id = var.public_loadbalancer_sg
}

resource "aws_security_group" "outbound-to-loadbalancer" {
  count       = var.public ? 1 : 0
  description = "Allow outbound traffic to the internal loadbalancer"
  vpc_id      = var.vpc_id
  name        = "${var.cluster_name}-outbound-to-loadbalancer"
}

resource "aws_security_group_rule" "outbound-to-loadbalancer" {
  count                    = var.public ? 1 : 0
  description              = "Outbound to loadbalancer"
  type                     = "egress"
  security_group_id        = aws_security_group.outbound-to-loadbalancer[0].id
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = var.internal_loadbalancer_sg
}

# -------------------- Private Security Groups -------------------------------

resource "aws_security_group" "inbound-from-loadbalancer" {
  count       = var.public ? 0 : 1
  vpc_id      = var.vpc_id
  name        = "${var.cluster_name}-inbound-from-loadbalancer"
  description = "Allow inbound HTTP traffic"
}

resource "aws_security_group_rule" "inbound-from-loadbalancer" {
  count                    = var.public ? 0 : 1
  type                     = "ingress"
  security_group_id        = aws_security_group.inbound-from-loadbalancer[0].id
  from_port                = var.app_server_port
  to_port                  = var.app_server_port
  protocol                 = "tcp"
  source_security_group_id = var.internal_loadbalancer_sg
}

# -------------------- Generic Security Groups -------------------------------

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
