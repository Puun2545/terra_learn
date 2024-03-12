# Define variables

# Create VPC
resource "aws_vpc" "kubernetes_vpc" {
  cidr_block = var.vpc_cidr_block
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "kubernetes-the-hard-way"
  }
}

# Create Subnet
resource "aws_subnet" "kubernetes_subnet" {
  vpc_id     = aws_vpc.kubernetes_vpc.id
  cidr_block = var.subnet_cidr_block

  tags = {
    Name = "kubernetes"
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "kubernetes_igw" {
  vpc_id = aws_vpc.kubernetes_vpc.id

  tags = {
    Name = "k8s-IGW"
  }
}

# Create Public Route Table
resource "aws_route_table" "kubernetes_route_table" {
  vpc_id = aws_vpc.kubernetes_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.kubernetes_igw.id
  }

  tags = {
    Name = "kubernetes"
  }
}

# Associate Subnet with Route Table
resource "aws_route_table_association" "kubernetes_subnet_association" {
  subnet_id      = aws_subnet.kubernetes_subnet.id
  route_table_id = aws_route_table.kubernetes_route_table.id
}

# Create Security Group for K8S cluster
resource "aws_security_group" "kubernetes_sg" {
  name        = "kubernetes"
  description = "Kubernetes security group"
  vpc_id      = aws_vpc.kubernetes_vpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.0.0.0/16", "10.200.0.0/16"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "kubernetes"
  }
}

# Create Security Group for configure node
resource "aws_security_group" "configure_node_sg" {
  name        = "configureNodeRule"
  description = "only allow SSH"
  vpc_id      = aws_vpc.kubernetes_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "configureNodeRule"
  }
}

