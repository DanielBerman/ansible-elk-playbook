variable "public_key_path" {
  description = "Path to the public SSH key you want to bake into the instance."
  default     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCxsPxL81YchLmn1e93GDiyPOZeUUROhmcJYwDBlrjOKDMbFmUy7QCuRlQ8lILEqYtj9u6f3Z+DsXsGIPV38BmG6oCEjSlPMTTITAcAmZgIfMFFbEDdMy7y9nA3zNqigS5quWBQ+Pm+jscWnetM8oR6f8p7FcCM+0BMyBet2G9qHE9XolyZ4qkCte9lEMEy71+Eld6GxERL5KTzO7WMGFIKo7I73u8+YQqM19lNg6ehCwGSmm17W51+67GGUUVoz1M959DDv2pu+DmH5aMrNtO27y3N0nlUhZLfJljVpVbnttBblJx5ZAt4Wq+rKVp5dgurrwXG7K927AvcyPdd8G8h shaziyamukada83@gmail.com"
}

variable "private_key_path" {
  description = "Path to the private SSH key, used to access the instance."
  default     = "/var/lib/jenkins/terraform"
}

variable "project_name" {
  description = "Name of your AWS project.  Example: ansible-terraform-V1"
  default     = "ansible-terraform-V1"
}

variable "ssh_user" {
  description = "SSH user name to connect to your instance."
  default     = "ubuntu"
}
