variable "aws_region" {
  default = "eu-central-1"
}

variable "project_name" {
  default = "cloud-portfolio"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "public_subnets" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnets" {
  type    = list(string)
  default = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "db_username" {
  default = "admin"
}

variable "db_password" {
  description = "RDS password"
  sensitive   = true
}