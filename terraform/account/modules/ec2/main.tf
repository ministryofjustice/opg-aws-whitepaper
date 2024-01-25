resource "aws_launch_configuration" "sandbox" {
  image_id        = "ami-0905a3c97561e0b69"
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.example_sg.id]

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

  provider = aws
}

resource "aws_security_group" "example_sg" {
  name = "example-sg"

  ingress {
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

}
