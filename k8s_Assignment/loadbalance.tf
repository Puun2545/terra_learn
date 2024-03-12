# Create Network Load Balancer
resource "aws_lb" "kubernetes_lb" {
  name               = "kubernetes"
  internal           = false
  load_balancer_type = "network"
  subnets            = [aws_subnet.kubernetes_subnet.id]
}

# Create Target Group
resource "aws_lb_target_group" "kubernetes_target_group" {
  name     = "kubernetes"
  port     = 6443
  protocol = "TCP"
  vpc_id   = aws_vpc.kubernetes_vpc.id
}

# Register Targets
resource "aws_lb_target_group_attachment" "kubernetes_targets" {
  count            = 3
  target_group_arn = aws_lb_target_group.kubernetes_target_group.arn
  target_id        = "10.0.1.1${count.index}"
}

# Create Listener
resource "aws_lb_listener" "kubernetes_listener" {
  load_balancer_arn = aws_lb.kubernetes_lb.arn
  port              = 443
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.kubernetes_target_group.arn
  }
}

# Create SSH Key Pair
resource "tls_private_key" "kubernetes_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "local_sensitive_file" "kubernetes_key_file" {
  filename = "kubernetes.id_rsa"
  content  = tls_private_key.kubernetes_key.private_key_pem
}


