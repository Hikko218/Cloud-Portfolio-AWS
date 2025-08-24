```markdown
# Step-by-Step Guide: Secure VPC Architecture on AWS

This document provides a step-by-step guide to design and implement a secure Virtual Private Cloud (VPC) on AWS with **public and private subnets, a bastion host, NAT gateway, and monitoring**.

---

## **1. Preparation**
- AWS Account (Free Tier enabled)
- Region: e.g., `eu-central-1` (Frankfurt)

---

## **2. VPC Setup**
1. Go to **VPC Console** → “Create VPC”.
2. Name: `secure-vpc`.
3. IPv4 CIDR: `10.0.0.0/16`.
4. Create **2 Public Subnets** (e.g., `10.0.1.0/24`, `10.0.2.0/24`).
5. Create **2 Private Subnets** (e.g., `10.0.3.0/24`, `10.0.4.0/24`).
6. Attach Internet Gateway.
7. Create **NAT Gateway** in one Public Subnet for outbound internet access of private resources.

📸 Screenshot: *VPC Topology Diagram in AWS Console*

---

## **3. Bastion Host (Jump Box)**
1. Go to **EC2 Console** → Launch Instance.
2. Name: `bastion-host`.
3. Instance Type: `t2.micro` (Free Tier).
4. Network: `secure-vpc`, select Public Subnet.
5. Security Group: allow **SSH (22) only from your IP**.
6. Assign Elastic IP for stable access.

📸 Screenshot: *EC2 Bastion Host Details*

---

## **4. Private Resources (Example: RDS & ECS)**
1. Launch RDS instance in **Private Subnet** (set Public Access = No).
2. ECS tasks or EC2 instances run inside **Private Subnet**.
3. Access them via **Bastion Host**.

📸 Screenshot: *RDS showing Private Subnet + No Public Access*

---

## **5. Security Groups vs. NACLs**
- **Security Groups (SGs)**: instance-level, stateful.
  - Example: RDS SG allows access only from ECS SG.
- **Network ACLs (NACLs)**: subnet-level, stateless.
  - Example: Block all traffic except required ports (80, 443, 22).

📸 Screenshot: *Security Group Rules vs. NACL Rules Table*

---

## **6. Monitoring**
1. Enable **VPC Flow Logs**.
   - Destination: CloudWatch Logs.
   - Log Group: `secure-vpc-logs`.
2. Create **CloudWatch Alarm**:
   - Metric: unusual inbound SSH attempts.
   - Action: Send SNS notification.

📸 Screenshot: *CloudWatch Flow Logs with IP traffic details*

---

## **7. Cost Estimation & Cleanup**
- NAT Gateway: ~$32/month (disable when not needed).
- Bastion Host (EC2 t2.micro): ~$8/month.
- Flow Logs: a few cents.
- Cleanup: terminate Bastion, delete NAT Gateway, VPC resources.

📸 Screenshot: *AWS Billing Console (showing NAT Gateway + EC2 costs)*

---

✅ With this setup, you demonstrate **secure network design**, proper use of **public vs. private subnets**, and **security best practices** with AWS.
```

