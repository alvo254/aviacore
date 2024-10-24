resource "aws_instance" "jump_host" {
  ami           = "ami-053b0d53c279acc90"
  instance_type = "t2.micro"

  subnet_id = var.pub_subnet
  key_name = aws_key_pair.deployer.key_name
  user_data = <<-EOF
            #!/bin/bash
            echo "${tls_private_key.RSA.public_key_openssh}" >> /home/ec2-user/.ssh/authorized_keys
            EOF

  #   user_data = data.template_file.data_2.rendered

  vpc_security_group_ids = [var.security_group]

  tags = {
    Name = "jump_host"
  }
}

resource "aws_instance" "react_app" {
  ami           = "ami-053b0d53c279acc90"
  instance_type = "t2.micro"

  subnet_id = var.pub_subnet2
  key_name = aws_key_pair.deployer.key_name

  #   user_data = data.template_file.data_2.rendered

  vpc_security_group_ids = [var.security_group]

  tags = {
    Name = "frontend_app"
  }
}

resource "aws_instance" "backend_app" {
  ami           = "ami-053b0d53c279acc90"
  instance_type = "t2.micro"

  subnet_id = var.pub_subnet2
  key_name = aws_key_pair.deployer.key_name

  #   user_data = data.template_file.data_2.rendered

  vpc_security_group_ids = [var.security_group]

  tags = {
    Name = "backend_app"
  }
}



resource "aws_instance" "testing_app" {
  ami           = "ami-053b0d53c279acc90"
  instance_type = "t2.micro"

  subnet_id = var.testing_subnet
  key_name = aws_key_pair.deployer.key_name

  #   user_data = data.template_file.data_2.rendered

  vpc_security_group_ids = [var.security_group]

  tags = {
    Name = "testing_app"
  }
}


resource "aws_instance" "secret_app" {
  ami           = "ami-053b0d53c279acc90"
  instance_type = "t2.micro"

  subnet_id = var.private_subnet

  #   user_data = data.template_file.data_2.rendered

  vpc_security_group_ids = [var.security_group]

  tags = {
    Name = "secret_app"
  }
}


resource "aws_key_pair" "deployer" {
  key_name = "alvo-ssh-keys"
  //storing ssh key on the server
  public_key = tls_private_key.RSA.public_key_openssh
}


resource "tls_private_key" "RSA" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "alvo-ssh-keys" {
  # content = tls_private_key.RSA.private_key_pem
  content  = tls_private_key.RSA.private_key_pem
  filename = "alvo-ssh-keys.pem"
}


# data "template_file" "user_data" {
#   template = file("${path.module}/install_nginx.sh")
# }

