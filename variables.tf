variable "aws_region" {
  description = "The AWS region where resources will be deployed."
  type        = string
  default     = "us-east-1" # Example: Mumbai region, change as needed
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "The CIDR block for the public subnet."
  type        = string
  default     = "10.0.1.0/24"
}

variable "availability_zone" {
  description = "The availability zone for the public subnet."
  type        = string
  default     = "us-east-1a" # Example: Mumbai AZ, change as needed. Must be in selected region.
}

variable "ami_id" {
  description = "The AMI ID for the EC2 instance (e.g., Ubuntu 22.04 LTS HVM for ap-south-1)."
  type        = string
  default     = "ami-0e86e20dae9224db8" // This is an example AMI ID for Ubuntu 22.04 LTS in ap-south-1 (Mumbai).
                                        // **IMPORTANT**: Verify this AMI ID is still valid and correct for your chosen `aws_region`.
                                        // You can find current AMI IDs in the AWS EC2 console under AMIs or via AWS CLI.
}
