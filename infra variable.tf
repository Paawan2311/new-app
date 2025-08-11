variable "environment" {
  description = "Environment name: dev or prod"
  type        = string
  default     = "dev"
}

variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR block for the private subnet"
  type        = string
  default     = "10.0.2.0/24"
}

variable "ec2_instance_type_dev" {
  description = "EC2 instance type for dev environment"
  type        = string
  default     = "t3.micro"
}

variable "ec2_instance_type_prod" {
  description = "EC2 instance type for prod environment"
  type        = string
  default     = "t3.medium"
}

variable "rds_instance_class_dev" {
  description = "RDS instance class for dev environment"
  type        = string
  default     = "db.t3.micro"
}

variable "rds_instance_class_prod" {
  description = "RDS instance class for prod environment"
  type        = string
  default     = "db.t3.medium"
}

variable "db_name" {
  description = "PostgreSQL database name"
  type        = string
  default     = "myappdb"
}

variable "db_username" {
  description = "PostgreSQL username"
  type        = string
  default     = "myappuser"
}

variable "db_password" {
  description = "PostgreSQL password"
  type        = string
  sensitive   = true
}

