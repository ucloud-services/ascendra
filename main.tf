locals {
  preffix="rbt"
  project_id = "ASCENDRA"
}

resource "aws_vpc" "main" {
  cidr_block = "10.10.0.0/16"
  tags = {
    Name = "${local.preffix}-vpc"
    Project = "${local.project_id}"
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.10.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"

  tags = {
    Name = "${local.preffix}-subnet-pub"
    Project = "${local.project_id}"
  }
}

resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.10.2.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "${local.preffix}-subnet-pri"
    Project = "${local.project_id}"
  }
}

resource "aws_instance" "bastion" {
  ami             = "ami-05b10e08d247fb927"
  instance_type   = "t2.micro"
  subnet_id       = aws_subnet.public.id
  # key_name        = "my-key"
  tags = {
    Name = "${local.preffix}-bastion"
    Project = "${local.project_id}"
  }
}