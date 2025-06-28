output "vpc_id" {
  description = "The ID of the created VPC."
  value       = aws_vpc.my_vpc.id
}

output "public_subnet_id" {
  description = "The ID of the created public subnet."
  value       = aws_subnet.public_subnet.id
}

output "instance_public_ip" {
  description = "The public IP address of the EC2 instance."
  value       = aws_instance.project_server.public_ip
}

output "ssh_command" {
  description = "SSH command to connect to the EC2 instance."
  value       = "ssh -i \"terraform-kp.pem\" ubuntu@${aws_instance.project_server.public_ip}"
}

output "private_key_file" {
  description = "The name of the generated private key file."
  value       = local_file.terraform_kp_pem.filename
}
