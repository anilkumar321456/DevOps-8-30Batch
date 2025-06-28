// main.tf
// This file defines the core AWS infrastructure: VPC, Subnet, Internet Gateway,
// Route Tables, Security Group, EC2 Key Pair, and an EC2 instance with NGINX.

// Configure the AWS provider
//provider "aws" {
 // region = var.aws_region // Use a variable for the region
//}
// Create the VPC Block
resource "aws_vpc" "my_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "my-vpc"
  }
}

// Create the Public Subnet
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = true # Automatically assign a public IP address

  tags = {
    Name = "my-pub-sub"
  }
}

// Create an Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "my-internet-gateway"
  }
}

// Create Public Route Table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"           // All traffic
    gateway_id = aws_internet_gateway.igw.id // Route through the Internet Gateway
  }

  tags = {
    Name = "public-rt"
  }
}

// Associate Public Subnet with the Public Route Table
resource "aws_route_table_association" "public_rt_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

// Create Security Groups
resource "aws_security_group" "my_security_group" { // Renamed for consistency with resource block
  vpc_id      = aws_vpc.my_vpc.id // Ensure the security group is created in the same VPC
  name        = "my-security-group" // Changed name to be more standard
  description = "Security group for web access (HTTP, HTTPS, SSH)"

  ingress {
    description = "Allow HTTP access from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow traffic from anywhere
  }

  ingress {
    description = "Allow HTTPS access from anywhere"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow SSH access from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # -1 indicates all protocols
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "my-security-group" // Tag name matches the resource name
  }
}

// Generate a new private key
resource "tls_private_key" "terraform_kp" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

// Create AWS Key Pair using the public key generated above
resource "aws_key_pair" "my_terraform_kp" { // Renamed for consistency
  key_name   = "terraform-kp" // New Key Pair Name
  public_key = tls_private_key.terraform_kp.public_key_openssh
}

// To create a file or folder to save your Private Key
resource "local_file" "terraform_kp_pem" { // Changed resource name for clarity
  content         = tls_private_key.terraform_kp.private_key_pem
  filename        = "terraform-kp.pem" // Save as a .pem file
  file_permission = "0400" // Set appropriate file permissions for private key
}

// Create EC2 Instance with NGINX installation via user_data
resource "aws_instance" "project_server" {
  // Explicit dependencies ensure resources are created in the correct order.
  // While Terraform often infers dependencies, explicit ones can prevent
  // transient errors during initial deployment.
  depends_on = [
    aws_security_group.my_security_group, // Ensure SG is created
    aws_subnet.public_subnet,           // Ensure subnet is ready
    aws_internet_gateway.igw            // Ensure IGW is attached to VPC for public IP
  ]

  ami                         = var.ami_id // Using variable for AMI ID
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public_subnet.id
  associate_public_ip_address = true
  key_name                    = aws_key_pair.my_terraform_kp.key_name // Referencing the created key pair
  vpc_security_group_ids      = [aws_security_group.my_security_group.id]

  // User data script to install NGINX and create a simple index page
  user_data = <<-EOF
              #!/bin/bash
              sudo apt update -y
              sudo apt install -y nginx
              sudo systemctl start nginx
              sudo systemctl enable nginx
              echo "<h1>Welcome to my EC2 instance!</h1>" | sudo tee /var/www/html/index.nginx-debian.html
              EOF

  tags = {
    Name = "ProjectServer"
  }
}
