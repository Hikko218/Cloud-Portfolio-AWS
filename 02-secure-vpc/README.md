# Secure VPC Architecture

## 🎯 Goal
Build a secure AWS Virtual Private Cloud (VPC) with:
- Public and private subnets
- AWS Systems Manager Session Manager for secure access
- S3 Gateway Endpoint for secure/cost-optimized S3 access
- Comparison of Security Groups vs. NACLs

---

## 🏗️ Architecture
```text
                    +----------------------+
                    |      Internet        |
                    +----------+-----------+
                               |
                               v
                     +-------------------+
                     |   Internet GW     |
                     +---------+---------+
                               |
                   Public Subnet (10.0.1.0/24)
                               |
                   +-----------+-----------+
                   |       NAT Gateway     |
                   +-----------+-----------+
                               |
             -------------------------------------------------------------
             |                                                           |
 Private Subnet (10.0.2.0/24, 1a)                                        |
             |                                                           |
   +---------+--------+                          +-------------------+   |
   |     EC2 Instance |                          |   RDS Instance    |   |
   |  (no public IP)  |----SG allow 3306-------> |  (no public IP)   |   |
   +------------------+                          +-------------------+   |
             |                                                           |
             | Session Manager (SSM Agent + IAM Role)                    |
             v                                                           |
   Secure access via AWS Console / CLI                                   |
                                                                         |
 Private Subnet (10.0.3.0/24, 1b)                                        |
   [used in DB Subnet Group for RDS requirement]                         |
                                                                         |
                    +-------------------+                                |
                    |   S3 Gateway      |                                |
                    |   VPC Endpoint    | ------------------------------> Amazon S3
                    +-------------------+
```   

➡️ For the full step-by-step build process with screenshots, see the [Build Guide](./docs/BUILD.md).

---

## ⚙️ Services Used
- VPC (CIDR: 10.0.0.0/16)
- 2 Public Subnets (ALB, NAT Gateway)
- 2 Private Subnets (DB, ECS)
- Internet Gateway + NAT Gateway
- S3 Gateway VPC Endpoint (direct/private access to S3 without NAT)
- AWS Systems Manager (SSM) Session Manager

---

## 🔒 Security
- Security Groups (stateful) → fine-grained instance control
- Network ACLs (stateless) → subnet-level rules
- Session Manager as the only secure entry point into private subnets
- S3 Gateway Endpoint ensures traffic to S3 stays within AWS network (no Internet path)

---

## 📊 Monitoring
- VPC Flow Logs → CloudWatch Logs
- SNS Alarm for unusual traffic spikes

---

## 💰 Cost Estimation
- NAT Gateway: ~$32/month (can be disabled in demo)
- Flow Logs: a few cents
- S3 Gateway Endpoint: free (saves NAT data processing costs for S3 traffic)

---


