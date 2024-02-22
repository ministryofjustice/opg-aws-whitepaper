locals {
  app_data_script = <<-EOF
    #!/bin/bash

    sudo apt-get update
    sudo apt-get install -y python3 python3-pip

    git clone https://github.com/ministryofjustice/opg-aws-whitepaper.git
    cd opg-aws-whitepaper/python/app

    pip3 install -r requirements.txt

    python3 api.py
  EOF
}
