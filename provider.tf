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

resource "aws_instance" "example" {
   ami           = "ami-0a13d44dccf1f5cf6"
   instance_type = "t2.micro"
   provisioner "local-exec" {
   command = "sleep 120; ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u ubuntu -i '${aws_instance.example.public_dns},' main.yml"
 }
}
