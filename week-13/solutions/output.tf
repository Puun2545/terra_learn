##################################################################################
# OUTPUT
##################################################################################

output "aws_lb_public_dns" {
  value = aws_lb.webLB.dns_name
}