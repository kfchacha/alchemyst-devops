# SSH key pair
resource "aws_key_pair" "main" {
  key_name   = "alchemyst-key"
  public_key = file(var.ssh_public_key_path)
}

# Gateway VM (public subnet)
resource "aws_instance" "gateway" {
  ami                    = var.ami_id
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.gateway.id]
  key_name               = aws_key_pair.main.key_name

  tags = { Name = "alchemyst-gateway" }
}

# Caller VM (private subnet)
resource "aws_instance" "caller" {
  ami                    = var.ami_id
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.private.id
  vpc_security_group_ids = [aws_security_group.workers.id]
  key_name               = aws_key_pair.main.key_name

  tags = { Name = "alchemyst-caller" }
}

# Inference VM (private subnet)
resource "aws_instance" "inference" {
  ami                    = var.ami_id
  instance_type          = "t3.small"
  subnet_id              = aws_subnet.private.id
  vpc_security_group_ids = [aws_security_group.workers.id]
  key_name               = aws_key_pair.main.key_name

  root_block_device {
    volume_size = 20
  }

  tags = { Name = "alchemyst-inference" }
}
