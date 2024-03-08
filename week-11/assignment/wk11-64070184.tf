
# Create a new provider block
provider "aws" {
  access_key = "ASIA6GBMCP37YZBNX7JR"
  secret_key = "BtqbY/lVf9Q2AlQcKJL+B0DbRnX2ouWM/hNNxfRT"
  token      = "FwoGZXIvYXdzEJX//////////wEaDEzvVW3qicTAMBAfXSLFAUU15HivQwBChxRyxOf6X0K/KfPCKVrjKY+OCzdSDUZIpOXOjr8C3oDuK2BaxOkNGm8ykHOkE3pBTvO6thYr+d8MiatyU2HHKdaA28cTxOVMekNlIAFdvxyQastYAO0xR/OJRvH61zVzFMEkz15SlL9265x+UkqCvuErB8BW6GOyDDwJr7r8FbzI2l5ElPw1EToBeelTCxl/PWSdKd3R0Vpu7a8tfvBFP5Ld6YNxV1Hd/9AlgymbyxU3kPtQ5HsfbpdYw9OwKPSm4K4GMi3v/3TGGhw+wH1CvtkbhRafMC8yivLGfw1n+5wpWQLb6/AFqBydGheUWyAA/YI="
  region     = "us-east-1"
}

data "aws_ami" "aws-linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023*-x86_64*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_vpc" "testVPC" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "testVPC"
  }
}

resource "aws_subnet" "Public1" {
  vpc_id                  = aws_vpc.testVPC.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true
  tags = {
    Name = "Public1"
  }
}

# Create a security group -> name: AllowSSHandWeb
resource "aws_security_group" "AllowSSHandWeb" {
  name        = "AllowSSHandWeb"
  description = "Allow SSH and Web"
  vpc_id      = aws_vpc.testVPC.id

  # Inbound rule -> SSH
  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Inbound rule -> HTTP
  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound rule -> Defualt Security Group
  egress {
    description = "Allow all outbound traffic by default"
    from_port   = 0
    to_port     = 0
    protocol    = -1 # -1 is all protocols
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create an Internet Gateway
resource "aws_internet_gateway" "testIGW" {
  vpc_id = aws_vpc.testVPC.id
  tags = {
    Name = "testIGW"
  }
}

# Create a Route Table
resource "aws_route_table" "PublicRoute" {
  vpc_id = aws_vpc.testVPC.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.testIGW.id
    }
    tags = {
        Name = "PublicRouteTable"
    }
}

resource "aws_route_table_association" "public_subnet_association" {
  subnet_id      = aws_subnet.Public1.id
  route_table_id = aws_route_table.PublicRoute.id
}

# Create an EC2 instance -> name: tfTest
resource "aws_instance" "tfTest" {
  ami                    = data.aws_ami.aws-linux.id
  instance_type          = "t2.micro"
  key_name               = "vockey"
  vpc_security_group_ids = [aws_security_group.AllowSSHandWeb.id]
  subnet_id              = aws_subnet.Public1.id

  root_block_device {
    volume_size = 8
    volume_type = "gp2"
  }

  tags = {
    Name = "tfTest"
  }
}

# OUTPUT

output "public_ip" {
  value = aws_instance.tfTest.public_ip
}

