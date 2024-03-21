##################################################################################
# PROVIDERS
##################################################################################

provider "aws" {
  access_key = "ASIA6GBMCP37YS6H6YLU"
  secret_key = "qFjVvlGFQJd/1NwCDHkGyPUCFFsHmoewU/kFGeHa"
  token      = "FwoGZXIvYXdzECIaDMyKkrJIv353sgizLCLFAToa2U8a4qoHzZ8mD25o3xUkAQIpJpmj4qv9JZPPim8rVfH5Tj75G5UBQSN6kmA65cI0RbkSMIi88l9BSMQgXg5ytrSUUAbvdei/6j7HGnNkFGvFTN3+HH03dNqzb07L6H4dFTURAi2SAItKXyjys8G43aPNn6ZjY+MehTOIKJ96E2EvWyYzky401KRJCapNhlD+nKVl8+JQWGJS38w+RV0xSpe4gJ8DITLIVmuji0lsaSlfRSL0T+zniV3bj1duhk48K5HJKJrk768GMi2Yr48bs5tMa7n0LUlMxvAJ+ooQ2JTROxsSBH8Wpoc8Et9uoybH1KlfC56kPIQ="
  region     = "us-east-1"
}

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

#This uses the default VPC.  It WILL NOT delete it on destroy.
resource "aws_default_vpc" "default" {}

resource "aws_security_group" "sg1" {
  name        = "npaWk11_demo"
  description = "Allow all"
  vpc_id      = aws_default_vpc.default.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "testweb" {
  ami                    = data.aws_ami.aws-linux.id
  instance_type          = "t2.micro"
  key_name               = "vockey"
  vpc_security_group_ids = [aws_security_group.sg1.id]
}

# Define EBS volume
resource "aws_ebs_volume" "testweb_volume" {
  availability_zone = aws_instance.testweb.availability_zone
  size              = 8
  type              = "gp2"
}

# Attach EBS volume to EC2 instance
resource "aws_volume_attachment" "testweb_attachment" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.testweb_volume.id
  instance_id = aws_instance.testweb.id
}

##################################################################################
# OUTPUT
##################################################################################

output "aws_instance_public_dns" {
  value = aws_instance.testweb.public_dns
}
