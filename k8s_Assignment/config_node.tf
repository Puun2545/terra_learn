# Create EC2 instance for configure node
resource "aws_instance" "configure_node_instance" {
  ami           = "ami-0440d3b780d96b29d"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.kubernetes_subnet.id
  key_name      = "vockey"
  associate_public_ip_address = true
  private_ip     = "10.0.1.99"
  security_groups = [aws_security_group.configure_node_sg.id]
# Remove the security_group_ids attribute
# security_group_ids = [aws_security_group.configure_node_sg.id]

  tags = {
    Name = "configure-node"
  }
}