# Step-by-Step Guide: Secure VPC Architecture on AWS (with Session Manager)

This document provides a step-by-step guide to design and implement a secure Virtual Private Cloud (VPC) on AWS with **public and private subnets, NAT gateway, and secure access via AWS Systems Manager Session Manager**.

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

## **3. Secure Access with Session Manager**

1. Ensure **SSM Agent** is installed (pre-installed on Amazon Linux 2, ECS instances, most AMIs).
2. Attach an **IAM Role** to private resources (e.g., ECS/EC2 instances):
   - Policy: `AmazonSSMManagedInstanceCore`
3. Go to **Systems Manager Console** → Session Manager.
4. Start a session directly from the AWS Console or via CLI:
   ```bash
   aws ssm start-session --target <instance-id>

	5.	Configure Session Logging → CloudWatch Logs or S3.

📸 Screenshot: Session Manager starting a session without public IP

⸻

## **4. Private Resources (Example: RDS & ECS)
	1.	Launch RDS instance in Private Subnet (set Public Access = No).
	2.	ECS tasks run inside Private Subnet.
	3.	Use SSM Session Manager to securely connect to private resources for troubleshooting.

📸 Screenshot: RDS showing Private Subnet + No Public Access

⸻

## **5. Security Groups vs. NACLs
	•	Security Groups (SGs): instance-level, stateful.
	•	Example: RDS SG allows access only from ECS SG.
	•	Network ACLs (NACLs): subnet-level, stateless.
	•	Example: Block all traffic except required ports (80, 443).

📸 Screenshot: Security Group Rules vs. NACL Rules Table

⸻

## **6. Monitoring
	1.	Enable VPC Flow Logs.
	•	Destination: CloudWatch Logs.
	•	Log Group: secure-vpc-logs.
	2.	Create CloudWatch Alarm:
	•	Metric: unusual inbound attempts.
	•	Action: Send SNS notification.

📸 Screenshot: CloudWatch Flow Logs with IP traffic details

⸻

## **7. Cost Estimation & Cleanup
	•	NAT Gateway: ~$32/month (disable when not needed).
	•	Flow Logs: a few cents.
	•	Cleanup: delete NAT Gateway, VPC resources.

📸 Screenshot: AWS Billing Console (showing NAT Gateway costs)

⸻

✅ With this setup, you demonstrate secure network design, proper use of public vs. private subnets, and modern secure access with AWS Systems Manager Session Manager.

