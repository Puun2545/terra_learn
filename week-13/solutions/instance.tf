##################################################################################
# DATA
##################################################################################

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

##################################################################################
# RESOURCES
##################################################################################

resource "aws_instance" "Server1" {
  ami                    = data.aws_ami.aws-linux.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.allow_ssh_web.id]
  subnet_id = aws_subnet.Public1.id

  tags = merge(local.common_tags, { Name = "${var.cName}-Server1"})
}

resource "aws_instance" "Server2" {
  ami                    = data.aws_ami.aws-linux.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.allow_ssh_web.id]
  subnet_id = aws_subnet.Public2.id

  tags = merge(local.common_tags, { Name = "${var.cName}-Server2"})

}
