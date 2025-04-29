resource "aws_vpc" "vault_vpc" {
  cidr_block = var.vpc_cidr
}

resource "aws_subnet" "vault_subnet" {
  vpc_id     = aws_vpc.vault_vpc.id
  cidr_block = var.subnet_cidr
}

resource "aws_security_group" "vault_sg" {
  vpc_id = aws_vpc.vault_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "vault_server" {
  ami                         = var.ami_id # Get Ubuntu AMI ID for your region
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.vault_subnet.id
  security_groups             = [aws_security_group.vault_sg.name]
  associate_public_ip_address = true
  key_name                    = var.key_name

  tags = {
    Name = "VaultServer"
  }
}
