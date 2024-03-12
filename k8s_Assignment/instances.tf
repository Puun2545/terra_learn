resource "aws_instance" "kubernetes_controllers" {
    count                = 3
    ami                  = "ami-04505e74c0741db8d"
    instance_type        = "t2.micro"
    subnet_id            = aws_subnet.kubernetes_subnet.id
    key_name             = "kubernetes"
    associate_public_ip_address  = true
    security_groups      = [aws_security_group.kubernetes_sg.id]
    private_ip           = "10.0.1.1${count.index}"
    user_data            = "name=controller-${count.index}"
    disable_api_termination = false

    tags = {
        Name = "controller-${count.index}"
    }
}


resource "aws_instance" "kubernetes_workers" {
    count                = 3
    ami                  = "ami-04505e74c0741db8d"
    instance_type        = "t2.micro"
    subnet_id            = aws_subnet.kubernetes_subnet.id
    associate_public_ip_address  = true
    key_name             = "kubernetes"
    security_groups      = [aws_security_group.kubernetes_sg.id]
    private_ip           = "10.0.1.2${count.index}"
    user_data            = "name=worker-${count.index}|pod-cidr=10.200.${count.index}.0/24"
    disable_api_termination = false

    tags = {
        Name = "worker-${count.index}"
    }
}