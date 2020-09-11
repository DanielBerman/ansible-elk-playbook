variable "public_key_path" {
  description = "Path to the public SSH key you want to bake into the instance."
  default     = "home/ubuntu/.ssh/authorized_keys"
}

variable "private_key_path" {
  description = "Path to the private SSH key, used to access the instance."
  default     = "jenkinskey"
}

#variable "project_name" {
#  description = "Name of your AWS project.  Example: ansible-terraform-V1"
#  default     = "ansible-terraform-V1"
#}
#variable "ssh_private_key_file" {
#  default = "files/jenkinskey.pem"
#  }

variable "ssh_user" {
  description = "SSH user name to connect to your instance."
  default     = "ubuntu"
}
