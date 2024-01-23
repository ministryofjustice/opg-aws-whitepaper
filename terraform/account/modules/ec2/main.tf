resource "aws_instance" "example" {
  ami           = "ami-0c45689cf7ad8a412"
  instance_type = "t2.micro"

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
