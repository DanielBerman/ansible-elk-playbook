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

resource "aws_key_pair" "ssh-key" {
  key_name   = "SSH-Key"
  public_key = file(".pub")
}

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
   key_name         = aws_key_pair.ssh-key.key_name
   ami              = "ami-0287acb18b6d8efff"
   instance_type    = "t2.micro"
   security_groups  = ["${aws_security_group.test_sg.name}"]
  
   connection {
     type         ="ssh"
     user         ="ubuntu"
     private_key  =file("")
     host         =self.public_ip
     }

    
  
   provisioner "local-exec" {
   command = "sleep 120; ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u ubuntu -i '${aws_instance.example.public_dns},' site.yml"
 }
}
