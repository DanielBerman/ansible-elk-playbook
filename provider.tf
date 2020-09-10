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

#variable "key_name" {default="my-key11"}
#resource "tls_private_key" "example" {
 # algorithm = "RSA"
#  rsa_bits  = 4096
#}
#resource "aws_key_pair" "generated_key" {
#  key_name   = var.key_name
#  public_key = tls_private_key.example.public_key_openssh
#}

resource "aws_key_pair" "ubuntu" {
  key_name   = "ubuntu"
 # public_key = file(var.public_key_path)
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQClVV5FgX+HlcZVv/mDYn9bhPTVwS0YwqdZzcscqZNpcqUOtEJg0a27w/+ijr5VVYKiZB+67dGC1XvmUHRR1R1thBKjfFRBgxDuW63ra2vtRAItOG7lHfhcJluxU2K7jIym1S+J60bB2xUXEeibqL+1uZGpPdafUgSyPWidVBFcBaK7nXGPZe5YIGFGK33Mrwjs/Zwvh1mdILcBIC0cIks25lK2br6ozc8mNB3rq0K3zutZnVq54C2XEbNTAh+bpXUXoZCwapv8xAprwW9Ydqkrg6ub7UflzjR1RdtPLQ8xLQ78V0xY/naOdwYb+3jk32+uEaQHrk2eBZScEYuaOt+V"
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
  # key_name         = aws_key_pair.terraform-ansible.key_name
   key_name         = "jenkinskey"
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
   # private_key = tls_private_key.example.private_key_pem
    private_key  = file(var.private_key_path)
    host        = self.public_ip
  }
 }
   provisioner "local-exec" {
  # command = "sleep 120; ansible-playbook host_key_checking=false -u ubuntu --private-key ${var.private_key_path} -i '${aws_instance.example.public_dns},' site.yml"
  # command = "ansible-playbook ANSIBLE_HOST_KEY_CHECKING=False -u ubuntu -i '${aws_instance.example.public_dns},' --private-key ${tls_private_key.example.private_key_pem} site.yml"
    command = "ansible-playbook ANSIBLE_HOST_KEY_CHECKING=False -u ubuntu -i '${aws_instance.example.public_dns},' --private-key ${var.private_key_path} site.yml"
     }
}
