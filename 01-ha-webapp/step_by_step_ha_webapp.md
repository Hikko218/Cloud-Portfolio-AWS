```markdown
# Step-by-Step Guide: High Availability Web App Deployment on AWS

This document provides a practical step-by-step guide to deploy a highly available and secure web application architecture on AWS using **ECS Fargate, RDS, ALB, and Route 53**.

---

## **1. VPC Setup**
1. Create VPC  
   - Name: `ha-webapp-vpc`  
   - IPv4 CIDR: `10.0.0.0/16`  

2. Create Public Subnets (for ALB, NAT Gateways)  
   - `ha-webapp-public-subnet-1a` → `10.0.1.0/24` (AZ 1a)  
   - `ha-webapp-public-subnet-1b` → `10.0.2.0/24` (AZ 1b)  

3. Create Private Subnets (for ECS + RDS)  
   - `ha-webapp-private-subnet-ecs-1a` → `10.0.3.0/24` (AZ 1a)  
   - `ha-webapp-private-subnet-ecs-1b` → `10.0.4.0/24` (AZ 1b)  
   - *(Optional)* `ha-webapp-private-subnet-rds` → `10.0.5.0/24` (dedicated DB subnet without Internet access)  

4. Internet Gateway (IGW) 
   - Name: `ha-webapp-igw`  
   - Create and attach to `ha-webapp-vpc`  

5. NAT Gateway  
   - Name: `ha-webapp-nat-1a`  
   - Place in `ha-webapp-public-subnet-1a`  
   - Allocate and associate an Elastic IP  
   - *Production:* one NAT Gateway per AZ for High Availability  
   - *Demo:* one NAT Gateway is enough to save costs  

6. Route Tables 
   - **Public Route Table** (`ha-webapp-rtb-public`)  
     - Routes:  
       - `10.0.0.0/16 → local` (default)  
       - `0.0.0.0/0 → Internet Gateway`  
     - Subnet Associations: Public Subnets (1a + 1b)  

   - **Private Route Table** (`ha-webapp-rtb-private`)  
     - Routes:  
       - `10.0.0.0/16 → local`  
       - `0.0.0.0/0 → NAT Gateway (in 1a)`  
     - Subnet Associations: Private ECS Subnets (1a + 1b)  

   - *(Optional)* **DB Route Table** (`ha-webapp-rtb-db`)  
     - Routes: only `10.0.0.0/16 → local`  
     - Subnet Associations: Private RDS Subnet (no Internet access)

📸 Screenshot: *VPC Topology in AWS Console*

---

## **2. Security Settings**
- **ALB Security Group**: Allow 80/443 from `0.0.0.0/0`.
- **ECS Security Group**: Allow inbound only from ALB SG.
- **RDS Security Group**: Allow inbound only from ECS SG.

📸 Screenshot: *Security Groups Overview (ALB, ECS, RDS)*

### DB Subnet Group
- Name: `ha-webapp-db-subnet-group`
- VPC: `ha-webapp-vpc`
- Subnets: Private Subnets across 2 AZs (e.g., `10.0.3.0/24` and `10.0.4.0/24`)

📸 Screenshot: *DB Subnet Group Setup*

---

## **3. RDS (Database)**
1. Go to **RDS Console** → “Create Database”.
2. Engine: **PostgreSQL** (or MySQL).
3. Template: Free Tier (or Dev/Test if Free Tier unavailable).
4. Instance Identifier: `ha-db`.
5. Public Access: **No** (Private Subnet only).
6. VPC: `ha-webapp-vpc`.
7. Subnet Group: `ha-webapp-db-subnet-group` (created in Step 2).
8. Security Group: `ha-webapp-sg-rds` (only allow access from ECS SG).

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

## **7. Monitoring**
1. Go to **CloudWatch → Logs** → ECS Log Group → check NGINX Access Logs.
2. Create **CloudWatch Alarm**:
   - Metric: `ALB → 5XXError`.
   - Threshold: >10 in 5 minutes.
   - Action: Send SNS notification (e.g., email).

📸 Screenshot: *CloudWatch Alarm Dashboard (ALB Error Rate)*

---

## **8. Cost Estimation & Cleanup**
- ECS (2 Tasks, Fargate): ~$15–20/month.
- RDS (Free Tier or ~$15/month).
- ALB: ~$16/month.
- Route 53 Domain: ~$12/year.
- **Cleanup after demo**: Delete ECS Cluster, RDS, ALB, NAT Gateway.

📸 Screenshot: *AWS Billing Console (Cost Breakdown)*

---

✅ With this setup, you have a **production-style HA deployment** that you can fully document with screenshots and architecture diagrams for your portfolio.
```

