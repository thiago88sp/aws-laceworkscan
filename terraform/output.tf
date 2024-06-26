# outputs.tf
output "instance_id" {
  description = "The ID of the EC2 instance"
  value       = aws_instance.web.id
}

output "public_ip" {
  description = "The public IP address of the EC2 instance"
  value       = aws_instance.web.public_ip
}

output "subnet_id" {
  description = "The subnet ID where the EC2 instance is deployed"
  value       = aws_instance.web.subnet_id
}
