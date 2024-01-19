resource "aws_instance" "example" {
  ami           = "ami-0500f74cc2b89fb6b"
  instance_type = "t2.micro"

  root_block_device {
    encrypted = true
  }
  metadata_options {
    http_tokens = "required"
  } 
}