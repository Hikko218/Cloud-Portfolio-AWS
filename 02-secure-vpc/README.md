# Secure VPC Architecture

## 🎯 Goal
Build a secure AWS Virtual Private Cloud (VPC) with:
- Public and private subnets
- Bastion host for secure access
- Comparison of Security Groups vs. NACLs

---

## 🏗️ Architecture
![Architecture](architecture.png)

---

## ⚙️ Services Used
- VPC (CIDR: 10.0.0.0/16)
- 2 Public Subnets (ALB, Bastion Host)
- 2 Private Subnets (DB, ECS)
- Internet Gateway + NAT Gateway

---

## 🔒 Security
- Security Groups (stateful) → fine-grained instance control
- Network ACLs (stateless) → subnet-level rules
- Bastion Host as the only SSH entry point

---

## 📊 Monitoring
- VPC Flow Logs → CloudWatch Logs
- SNS Alarm for unusual traffic spikes

---

## 💰 Cost Estimation
- NAT Gateway: ~$32/month (can be disabled in demo)
- EC2 Bastion Host: ~$8/month (t2.micro)
- Flow Logs: a few cents