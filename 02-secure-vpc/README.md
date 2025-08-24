# Secure VPC Architecture

## 🎯 Goal
Build a secure AWS Virtual Private Cloud (VPC) with:
- Public and private subnets
- AWS Systems Manager Session Manager for secure access
- Comparison of Security Groups vs. NACLs

---

## 🏗️ Architecture
![Architecture](architecture.png)

---

## ⚙️ Services Used
- VPC (CIDR: 10.0.0.0/16)
- 2 Public Subnets (ALB, NAT Gateway)
- 2 Private Subnets (DB, ECS)
- Internet Gateway + NAT Gateway
- AWS Systems Manager (SSM) Session Manager

---

## 🔒 Security
- Security Groups (stateful) → fine-grained instance control
- Network ACLs (stateless) → subnet-level rules
- Session Manager as the only secure entry point into private subnets

---

## 📊 Monitoring
- VPC Flow Logs → CloudWatch Logs
- SNS Alarm for unusual traffic spikes

---

## 💰 Cost Estimation
- NAT Gateway: ~$32/month (can be disabled in demo)
- Flow Logs: a few cents

---

✅ With this setup, you demonstrate **secure network design**, proper use of **public vs. private subnets**, and **modern secure access** with AWS Systems Manager Session Manager.

