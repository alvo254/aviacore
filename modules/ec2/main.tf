#-----------------------------------------------------------------------Front end------------------------------------------------------------------------ 
resource "aws_instance" "sap_flori_sim" {
  ami           = "ami-053b0d53c279acc90"
  instance_type = "t2.micro"
  subnet_id = var.pub_subnet
  key_name = aws_key_pair.deployer.key_name

  #for my testing purposes and troubleshooting 
  user_data = <<-EOF
            #!/bin/bash
            echo "${tls_private_key.RSA.public_key_openssh}" >> /home/ec2-user/.ssh/authorized_keys
            EOF
  vpc_security_group_ids = [var.security_group]

  tags = {
    Name = "SAP flori-sim"
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
    Name = "customer-fascing-react"
  }
}


resource "aws_instance" "flori_sim" {
  ami           = "ami-053b0d53c279acc90"
  instance_type = "t2.micro"

  subnet_id = var.pub_subnet2
  key_name = aws_key_pair.deployer.key_name

  #   user_data = data.template_file.data_2.rendered

  vpc_security_group_ids = [var.security_group]

  tags = {
    Name = "redundant_flori-sim"
  }
}
# -------------------------------------------------------------end of frontend------------------------------------------------------------------


#---------------------------------------------------------backend--------------------------------------------------------------------------
resource "aws_instance" "hana" {
  ami           = "ami-053b0d53c279acc90"
  instance_type = "t2.micro"
  subnet_id = var.private_subnet
  vpc_security_group_ids = [var.security_group]

  tags = {
    Name = "4HANA-sim"
  }
}


resource "aws_instance" "redundant-hana" {
  ami           = "ami-053b0d53c279acc90"
  instance_type = "t2.micro"
  subnet_id = var.private_subnet2
  vpc_security_group_ids = [var.security_group]

  tags = {
    Name = "redundant-4HANA-sim"
  }
}
#---------------------------------------------------------------end of backend-------------------------------------------------------------



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
#   template = file("${path.module}/do_stuff.sh")
# }

