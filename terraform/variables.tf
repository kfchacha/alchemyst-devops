variable "aws_region" {
  default = "eu-west-1"
}

variable "ami_id" {
  # Ubuntu 22.04 LTS in eu-west-1 (Ireland)
  default = "ami-017d3e24afcd69bab"
}

variable "my_ip" {
  description = "Your public IP for SSH access (format: x.x.x.x/32)"
}

variable "ssh_public_key_path" {
  default = "~/.ssh/alchemyst-key.pub"
}
