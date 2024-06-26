provider "aws" {
  region = var.aws_region
}

provider "azurerm" {
  features {}
}

terraform {
  backend "azurerm" {
    storage_account_name = "tspontes7xg2dfzesta001"
    container_name       = "terraform"
    key                  = "aws.tfstate"
  }
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "main" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "${var.aws_region}a"
}

resource "aws_security_group" "main" {
  vpc_id = aws_vpc.main.id

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

resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  
  subnet_id     = aws_subnet.main.id

  // Public IP
  associate_public_ip_address = true

  tags = {
    Name     = "EC2 Instance"
    Username = "tpontes"
    Source   = "Terraform"
    Purpose  = "Lacework Test"
  }
}
