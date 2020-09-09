terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
  backend "s3" {
    bucket = "terraform-bucket-saziya"
    key    = "terraform.tfstate"
    region = "eu-west-2"
  }
}

provider "aws" {
  profile = "default"
  region  = "eu-west-2"
}

variable "key_name" {default="my-key6"}
resource "tls_private_key" "example" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
resource "aws_key_pair" "generated_key" {
  key_name   = var.key_name
  public_key = tls_private_key.example.public_key_openssh
}

#resource "aws_key_pair" "terraform-ansible" {
#  key_name   = "terr-ansib-key"
#  public_key = var.public_key_path
#  }

resource "aws_security_group" "test_sg" {
  name = "test_sg"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow outgoing traffic to anywhere.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "example" {
  # key_name         = aws_key_pair.terraform-ansible.key_name
   key_name         = aws_key_pair.generated_key.key_name
   ami              = "ami-0287acb18b6d8efff"
   instance_type    = "t2.micro"
   security_groups  = ["${aws_security_group.test_sg.name}"]
  
  provisioner "remote-exec" {
    inline = ["echo 'Hello World'"]
   
  #  connection {
   #   type        = "ssh"
   #   user        = var.ssh_user
   #   private_key = file(var.private_key_path)
    #  host        = self.public_ip
    #  }
   # }
  connection {
    type        = "ssh"
    user        = "ubuntu"
   # private_key = file("var.private_key_path")
    private_key =  tls_private_key.example.private_key_pem
    host        = self.public_ip
  }
 }
   provisioner "local-exec" {
  # command = "sleep 120; ansible-playbook host_key_checking=false -u ubuntu --private-key ${var.private_key_path} -i '${aws_instance.example.public_dns},' site.yml"
   command = "sleep 120; ansible-playbook -e host_key_checking=False -u ubuntu -i '${aws_instance.example.public_dns},' --private-key ${tls_private_key.example.private_key_pem} ./site.yml -b"
 }
}
