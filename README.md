# ☁️ Cloud Infrastructure Portfolio

This repository showcases my cloud engineering projects, focused on **AWS Infrastructure, Security, and Monitoring**.  
Each project demonstrates one of the core pillars of cloud infrastructure: **Compute, Networking, Storage, and Security**.  
I intentionally left out web development and CI/CD pipelines to highlight my focus on **cloud infrastructure engineering**.  

---

## 📚 Certifications
- AWS Cloud Practitioner (in progress)
- AWS Solutions Architect – Associate 🎯 (in progress)

---

## 📂 Projects

### 1. [High Availability Web App Deployment](./01-ha-webapp)
A production-ready deployment using:
- **ECS Fargate** (compute)  
- **RDS** (database in private subnet)  
- **Application Load Balancer** with HTTPS (ACM)  
- **Route 53** for custom DNS  

> Focus: Compute, Databases, High Availability, Security Groups, Monitoring.

---

### 2. [Secure VPC Architecture](./02-secure-vpc)
Design of a secure and scalable AWS VPC:  
- Public + Private Subnets  
- **Bastion Host** for controlled access  
- **Security Groups vs. NACLs** comparison  
- VPC Flow Logs to CloudWatch  

> Focus: Networking, Access Control, Security Best Practices.

---

### 3. [Cloud Storage & Monitoring](./03-s3-monitoring)
A secure storage and monitoring setup with AWS services:  
- **S3** with Versioning + Lifecycle → Glacier  
- **CloudFront** CDN with HTTPS (optional)  
- **CloudWatch Dashboard** for request metrics  
- **GuardDuty + Security Hub** for threat detection  

> Focus: Storage, Monitoring, Security, Cost Optimization.

### 4. [Infrastructure as Code with Terraform](./04-iac-terraform)
Focus: Infrastructure as Code (IaC), automation, reproducibility.
- Terraform scripts to deploy VPC, ECS Fargate, RDS, S3, ALB, CloudWatch.
- Demonstrates automation of the complete architecture from Projects 1–3.
- Commands: `terraform init`, `terraform plan`, `terraform apply`, `terraform destroy`.

---

## 🎯 Focus
My career goal is to work as a **Cloud Infrastructure Engineer**.  
I focus on **infrastructure, networking, security, monitoring, and IaC**, not on application development.  

Each project is designed to demonstrate **practical AWS knowledge** that directly translates into production-ready cloud infrastructure.  