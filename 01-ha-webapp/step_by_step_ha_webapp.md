```markdown
# Step-by-Step Guide: High Availability Web App Deployment on AWS

This document provides a practical step-by-step guide to deploy a highly available and secure web application architecture on AWS using **ECS Fargate, RDS, ALB, and Route 53**.

---

## **1. Preparation**
- AWS Account (Free Tier enabled)
- Domain (optional – otherwise use ALB DNS)
- Region: e.g., `eu-central-1` (Frankfurt)

---

## **2. VPC Setup**
1. Go to **VPC Console** → “Create VPC”.
2. Name: `ha-webapp-vpc`.
3. IPv4 CIDR: `10.0.0.0/16`.
4. Create **2 Public Subnets** (for ALB, e.g., `10.0.1.0/24` and `10.0.2.0/24`).
5. Create **2 Private Subnets** (for ECS + RDS, e.g., `10.0.3.0/24` and `10.0.4.0/24`).
6. Attach Internet Gateway to VPC.
7. Create a NAT Gateway in one Public Subnet (so ECS in Private Subnets has outbound Internet access).

📸 Screenshot: *VPC Topology in AWS Console*

---

## **3. RDS (Database)**
1. Go to **RDS Console** → “Create Database”.
2. Engine: **PostgreSQL** (or MySQL).
3. Template: Free Tier (or Dev/Test if Free Tier unavailable).
4. Instance Identifier: `ha-db`.
5. Public Access: **No** (Private Subnet only).
6. VPC: `ha-webapp-vpc`.
7. Subnet Group: Private Subnets.
8. Security Group: Only allow access from ECS Tasks.

📸 Screenshot: *RDS Instance Overview (Private Subnet)*

---

## **4. ECS Fargate (Compute Layer)**
1. Go to **ECS Console** → “Create Cluster”.
   - Name: `ha-webapp-cluster`.
   - Networking: VPC `ha-webapp-vpc`, select Private Subnets.

2. Create **Task Definition**:
   - Launch Type: Fargate.
   - Container: `nginx:latest`.
   - Memory: 512MB, CPU: 0.25 vCPU.
   - Logs: Enable CloudWatch Logs.

3. Create **Service**:
   - Cluster: `ha-webapp-cluster`.
   - Service Name: `ha-nginx-service`.
   - Desired Tasks: 2 (spread across AZs).
   - Placement: Spread across AZs.

📸 Screenshot: *ECS Service with 2 Running Tasks*

---

## **5. Application Load Balancer (ALB)**
1. Go to **EC2 Console** → Load Balancers → Create.
2. Type: **Application Load Balancer**.
3. Name: `ha-webapp-alb`.
4. Scheme: Internet-facing.
5. Listener: HTTPS (443).
   - ACM Certificate (request via AWS Certificate Manager).
   - If no domain: start with HTTP (80).
6. VPC: `ha-webapp-vpc`.
7. Subnets: Public Subnets.
8. Target Group: ECS Service (IP-based Target Group).

📸 Screenshot: *ALB Listener + Target Group Health Checks*

---

## **6. Route 53 (Optional, Custom Domain)**
1. Register a domain or use an existing one.
2. Create a Hosted Zone in **Route 53**.
3. Add `A` Record → Alias → ALB.
4. Access app via `https://yourdomain.com`.

📸 Screenshot: *Browser showing app via HTTPS + Route 53 domain*

---

## **7. Security Settings**
- **ALB Security Group**: Allow 80/443 from `0.0.0.0/0`.
- **ECS Security Group**: Allow inbound only from ALB SG.
- **RDS Security Group**: Allow inbound only from ECS SG.

📸 Screenshot: *Security Groups Overview (ALB, ECS, RDS)*

---

## **8. Monitoring**
1. Go to **CloudWatch → Logs** → ECS Log Group → check NGINX Access Logs.
2. Create **CloudWatch Alarm**:
   - Metric: `ALB → 5XXError`.
   - Threshold: >10 in 5 minutes.
   - Action: Send SNS notification (e.g., email).

📸 Screenshot: *CloudWatch Alarm Dashboard (ALB Error Rate)*

---

## **9. Cost Estimation & Cleanup**
- ECS (2 Tasks, Fargate): ~$15–20/month.
- RDS (Free Tier or ~$15/month).
- ALB: ~$16/month.
- Route 53 Domain: ~$12/year.
- **Cleanup after demo**: Delete ECS Cluster, RDS, ALB, NAT Gateway.

📸 Screenshot: *AWS Billing Console (Cost Breakdown)*

---

✅ With this setup, you have a **production-style HA deployment** that you can fully document with screenshots and architecture diagrams for your portfolio.
```

