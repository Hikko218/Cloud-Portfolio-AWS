# High Availability Web App Deployment on AWS

## 🎯 Goal
Deploy a highly available and secure web application architecture using:
- ECS Fargate (compute layer)
- RDS (database in private subnet)
- Application Load Balancer (HTTPS via ACM)
- Route 53 (custom DNS)

---

## 🏗️ Architecture
<div style="display: flex; justify-content: center;">
  <img src="./docs/architecture.png" alt="Cluster" width="32%">
</div>

➡️ For the full step-by-step build process with screenshots, see the [Build Guide](./docs/BUILD.md).

---

## ⚙️ Services Used
- ECS Fargate (2 tasks across 2 AZs)
- Application Load Balancer (HTTPS termination)
- Amazon RDS (Postgres, Multi-AZ optional)
- Route 53 for domain management
- VPC with public and private subnets

---

## 🔒 Security
- RDS only accessible from ECS tasks (private subnet)
- Security Groups with least privilege
- IAM Role for ECS Task Execution

---

## 📊 Monitoring
- CloudWatch Logs (ECS and RDS)
- CloudWatch Alarm for ALB 5XX error rate

---

## 💰 Cost Estimation
- ECS Fargate: ~$15–20/month
- ALB: ~$16/month
- RDS: ~$15/month (Free Tier possible)
- Route 53: $0.50/month + domain