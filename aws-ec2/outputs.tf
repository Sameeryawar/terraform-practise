output "ec2_IP" {
  value = aws_instance.myserver.public_ip
}