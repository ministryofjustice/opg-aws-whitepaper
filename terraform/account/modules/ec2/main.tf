resource "aws_instance" "example" {
  ami                    = "ami-0905a3c97561e0b69"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.example_sg.id]

  root_block_device {
    encrypted = true
  }
  metadata_options {
    http_tokens = "required"
  }

  user_data = <<-EOF
    #!/bin/bash
    echo "Hello, World!" > index.html
    nohup busybox httpd -f -p 8080 &
    EOF

  user_data_replace_on_change = true

  tags = {
    Name = "temp-webserver"
  }

  provider = aws
}

resource "aws_security_group" "example_sg" {
  name = "example-sg"

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/1"]
  }
}
