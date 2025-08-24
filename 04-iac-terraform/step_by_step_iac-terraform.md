# Step-by-Step Guide: Infrastructure as Code with Terraform

This guide explains how to deploy a **complete AWS infrastructure** using **Terraform**, integrating components from Projects 1–3 into one **end-to-end automated architecture** with **modern access via AWS Systems Manager Session Manager (no Bastion Host)**.

---

## **1. Preparation**
- Install Terraform: [Terraform Downloads](https://developer.hashicorp.com/terraform/downloads)
- Install AWS CLI: [AWS CLI Installation](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
- Configure AWS CLI:
  ```bash
  aws configure

(provide Access Key, Secret Key, Region, Output format)

⸻

2. Repository Structure

Example structure for this project:

04-iac-terraform/
│
├── main.tf        # core infrastructure (VPC, ECS, RDS, S3, ALB, CloudWatch)
├── variables.tf   # input variables (region, names, instance sizes)
├── outputs.tf     # outputs (ALB DNS, RDS endpoint, S3 bucket)
├── providers.tf   # provider configuration (AWS)
└── README.md      # project documentation


⸻

3. Terraform Configuration

providers.tf

provider "aws" {
  region = var.aws_region
}

variables.tf

variable "aws_region" {
  default = "eu-central-1"
}

variable "project_name" {
  default = "cloud-portfolio"
}

main.tf (simplified example)

# VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = { Name = "${var.project_name}-vpc" }
}

# S3 bucket
resource "aws_s3_bucket" "storage" {
  bucket = "${var.project_name}-bucket"
  force_destroy = true

  versioning { enabled = true }

  tags = { Project = var.project_name }
}

# ECS Cluster
resource "aws_ecs_cluster" "main" {
  name = "${var.project_name}-cluster"
}

# Example IAM role for Session Manager access
resource "aws_iam_role" "ssm_role" {
  name = "${var.project_name}-ssm-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = { Service = "ec2.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ssm_attach" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

outputs.tf

output "s3_bucket_name" {
  value = aws_s3_bucket.storage.bucket
}

output "ecs_cluster_name" {
  value = aws_ecs_cluster.main.name
}


⸻

4. Deployment Steps
	1.	Initialize Terraform:

terraform init


	2.	Preview resources to be created:

terraform plan


	3.	Deploy the infrastructure:

terraform apply

Confirm with yes.

	4.	Check outputs:
	•	ALB DNS → URL of the deployed app
	•	RDS Endpoint
	•	S3 Bucket Name

📸 Screenshot: Terraform plan + apply results

⸻

5. Secure Access with SSM Session Manager

Instead of a Bastion Host:
	•	Private resources (ECS, EC2, RDS access) can be reached through Session Manager.
	•	Ensure the AmazonSSMManagedInstanceCore policy is attached to instances.
	•	Start a session:

aws ssm start-session --target <instance-id>


	•	Sessions can be logged in CloudWatch Logs or S3 for auditing.

📸 Screenshot: Session Manager Console with active session

⸻

6. Monitoring
	•	CloudWatch Logs: ECS tasks, ALB access logs
	•	CloudWatch Alarms: ALB 5XX error rate
	•	GuardDuty + Security Hub: enabled for threat detection

📸 Screenshot: CloudWatch Dashboard with metrics

⸻

7. Cost Estimation & Cleanup
	•	ECS + RDS + ALB: ~$40–50/month (scale down for demo)
	•	S3: <$1/month
	•	CloudWatch: minimal
	•	GuardDuty/Security Hub: free trial (30 days)

Cleanup:

terraform destroy

📸 Screenshot: Terraform destroy output

⸻

✅ With this setup, you demonstrate:
	•	IaC with Terraform
	•	End-to-End AWS Infrastructure (VPC, ECS, RDS, S3, ALB, Monitoring)
	•	Modern secure access (Session Manager, no Bastion Host)
	•	Automation and reproducibility for production-like environments


