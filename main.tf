locals {
  workspace  = terraform.workspace
  prefix     = "rbt-${local.workspace}"
  project_id = "ASCENDRA"
}

resource "aws_vpc" "main" {
  cidr_block = "10.10.0.0/16"
  tags = {
    Name = "${local.prefix}-vpc"
    Project = "${local.project_id}"
  }
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${local.prefix}-igw"
    Project = "${local.project_id}"
  }
}

resource "aws_route_table" "this" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = {
    Name = "${local.prefix}-prt"
    Project = "${local.project_id}"
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.10.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"

  tags = {
    Name = "${local.prefix}-subnet-pub"
    Project = "${local.project_id}"
  }
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.this.id
}

resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.10.2.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "${local.prefix}-subnet-pri"
    Project = "${local.project_id}"
  }
}

resource "tls_private_key" "bastion_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "aws_key_pair" "bastion_key" {
  key_name   = "${local.prefix}-key"
  public_key = tls_private_key.bastion_key.public_key_openssh
}

resource "local_file" "private_key" {
  content  = tls_private_key.bastion_key.private_key_pem
  filename = "./keys/${local.prefix}-bastion-key.pem"
}

resource "aws_instance" "bastion" {
  ami             = "ami-05b10e08d247fb927"
  instance_type   = "t2.micro"
  subnet_id       = aws_subnet.public.id
  associate_public_ip_address = true
  key_name        = aws_key_pair.bastion_key.key_name
  tags = {
    Name = "${local.prefix}-bastion"
    Project = "${local.project_id}"
  }
}

