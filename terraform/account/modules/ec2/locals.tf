locals {
  web_data_script = <<-EOF
    #!/bin/bash
    echo "Hello, world from WEB - $(hostname -f)" > index.html
    nohup busybox httpd -f -p ${var.server_port} &
    EOF
}
