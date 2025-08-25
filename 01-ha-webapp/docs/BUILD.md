# High Availability Web App – Build Guide

## Step 1 – Create VPC

![VPC](./screenshots/01_VPC.png)

---

## Step 2 – Security Settings

### Security Groups

![Security Groups](./screenshots/02_Security_Group.png)

| Security Group       | Inbound Rules             | Source                 | Outbound Rules  | Description                          |
|----------------------|---------------------------|------------------------|-----------------|--------------------------------------|
| ha-webapp-sg-alb     | 80, 443                   | 0.0.0.0/0              | All traffic     | Allow public HTTP/HTTPS inbound      |
| ha-webapp-sg-ecs     | 80                        | ha-webapp-sg-alb       | All traffic     | Allow traffic from ALB only          |
| ha-webapp-sg-rds-c   | 5432 (Postgres)           | ha-webapp-sg-ecs       | All traffic     | Allow Postgres from ECS only         |

### DB Subnet Group
- Name: ha-webapp-db-subnet-group
- Subnets: private subnets across 2 AZs

![Subnets](./screenshots/02_Subnets.png)

---

## Step 3 – Create RDS Database

![Subnets](./screenshots/03_RDS.png)

### RDS Setup
- **Engine:** PostgreSQL
- **Instance class:** db.t4g.micro (Free Tier eligible)
- **Subnet Group:** ha-webapp-db-subnet-group (private subnets only)
- **Public Access:** Disabled
- **Security Group:** ha-webapp-sg-rds-c (allows inbound Postgres 5432 only from ECS SG)
- **High Availability:** Single-AZ (cost optimization for demo). In production, this would be Multi-AZ for high availability.

---

## Step 4 – ECS Fargate (Compute Layer)

ECS Cluster with Fargate Tasks running `nginx:latest` across **2 Availability Zones**.

### ECS Setup
- **Cluster:** `ha-webapp-cluster`
- **Task Definition:** `ha-webapp-task` (Fargate, 0.25 vCPU, 512 MB Memory)
- **Service:** `ha-nginx-service` (2 tasks, spread across AZs)
- **Logging:** CloudWatch enabled
- **Security Group:** `ha-webapp-sg-ecs` (inbound from ALB only)

---

### Screenshots

<div style="display: flex; justify-content: space-between;">
  <img src="./screenshots/04_Cluster.png" alt="Cluster" width="32%">
  <img src="./screenshots/04_Service.png" alt="Service" width="32%">
  <img src="./screenshots/04_Task.png" alt="Task" width="32%">
</div>

---


