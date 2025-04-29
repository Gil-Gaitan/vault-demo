# Create a VPC
resource "aws_vpc" "vault_vpc" {
  cidr_block = var.vpc_cidr
}

# Create an Internet Gateway
resource "aws_internet_gateway" "vault_igw" {
  vpc_id = aws_vpc.vault_vpc.id
}

# Create a Route Table
resource "aws_route_table" "vault_route_table" {
  vpc_id = aws_vpc.vault_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vault_igw.id
  }
}

# Create a Subnet
resource "aws_subnet" "vault_subnet" {
  vpc_id                  = aws_vpc.vault_vpc.id
  cidr_block              = var.subnet_cidr
  map_public_ip_on_launch = true
  availability_zone       = var.availability_zone
}

# Associate the Route Table with the Subnet
resource "aws_route_table_association" "vault_route_table_assoc" {
  subnet_id      = aws_subnet.vault_subnet.id
  route_table_id = aws_route_table.vault_route_table.id
}

# Create a Security Group to allow SSH
resource "aws_security_group" "vault_sg" {
  vpc_id = aws_vpc.vault_vpc.id

  ingress {
    description = "Allow SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Launch an EC2 Instance
resource "aws_instance" "vault_server" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.vault_subnet.id
  vpc_security_group_ids      = [aws_security_group.vault_sg.id]
  associate_public_ip_address = true
  key_name                    = var.key_name
  availability_zone           = var.availability_zone

  user_data = <<-EOF
              #!/bin/bash
              set -e

              apt-get update -y
              apt-get install -y unzip curl

              sleep 5

              cd /tmp
              curl -O https://releases.hashicorp.com/vault/1.15.4/vault_1.15.4_linux_amd64.zip

              unzip vault_1.15.4_linux_amd64.zip
              mv vault /usr/local/bin/vault

              vault --version

              rm -f vault_1.15.4_linux_amd64.zip
              EOF


  tags = {
    Name = "VaultServer"
  }
}

