resource "aws_instance" "example" {
  ami           = "ami-0c45689cf7ad8a412"
  instance_type = "t2.micro"

  root_block_device {
    encrypted = true
  }
  metadata_options {
    http_tokens = "required"
  }

  provider = aws
}