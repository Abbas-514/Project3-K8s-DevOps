terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# VPC
resource "aws_vpc" "project3_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "project3-vpc"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "project3_igw" {
  vpc_id = aws_vpc.project3_vpc.id

  tags = {
    Name = "project3-igw"
  }
}

# Subnet
resource "aws_subnet" "project3_subnet" {
  vpc_id                  = aws_vpc.project3_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "project3-subnet"
  }
}

# Route Table
resource "aws_route_table" "project3_rt" {
  vpc_id = aws_vpc.project3_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.project3_igw.id
  }

  tags = {
    Name = "project3-rt"
  }
}

# Route Table Association
resource "aws_route_table_association" "project3_rta" {
  subnet_id      = aws_subnet.project3_subnet.id
  route_table_id = aws_route_table.project3_rt.id
}

# Security Group
resource "aws_security_group" "project3_sg" {
  name        = "project3-sg"
  description = "Security group for Project 3 EC2 instance"
  vpc_id      = aws_vpc.project3_vpc.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    description = "Frontend NodePort"
    from_port   = 30080
    to_port     = 30080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Backend NodePort"
    from_port   = 30000
    to_port     = 30000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "ArgoCD NodePort"
    from_port   = 30088
    to_port     = 30088
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "project3-sg"
  }
}

# Data source to get latest Ubuntu 22.04 AMI
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

# EC2 Instance
resource "aws_instance" "k8s_node" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.medium"
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.project3_sg.id]
  subnet_id              = aws_subnet.project3_subnet.id

  root_block_device {
    volume_size = 30
    volume_type = "gp3"
  }

  tags = {
    Name = "project3-k8s-node"
  }
}
