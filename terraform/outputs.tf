output "public_ip" {
  value = aws_instance.bank-app-ec2.public_ip
}

output "public_dns" {
  value = aws_instance.bank-app-ec2.public_dns
}

output "tag_name" {
  value = aws_instance.bank-app-ec2.tags.Name
}