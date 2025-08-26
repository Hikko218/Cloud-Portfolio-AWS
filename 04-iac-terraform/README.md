# Infrastructure as Code with Terraform

## 🎯 Goal
Deploy a complete AWS architecture with Terraform:
- VPC (public + private subnets)
- ECS Fargate (with ALB)
- RDS (database in private subnet)
- S3 (storage with versioning)
- Monitoring (CloudWatch)
- Secure access to private resources via **AWS Systems Manager (SSM) Session Manager** 

---

## 🏗️ Architecture

```mermaid
flowchart TB
    User([User])
    Route53[Route 53]
    ALB[Application Load Balancer\n(HTTPS via ACM)]
    ECS[ECS Fargate]
    RDS[(Amazon RDS)]
    NAT[NAT Gateway]
    S3[(S3 Bucket)]
    CDN[CloudFront CDN\nLogs -> S3]
    Session[Session Manager\n(no Bastion Host)]
    Terraform[Terraform\n(IaC)]

    %% Connections
    User --> Route53 --> ALB
    ALB --> ECS
    ALB --> RDS
    ECS --> NAT
    Session --> ECS
    Session --> RDS
    CDN --> S3
    Terraform --> VPC[VPC\n(10.0.0.0/16)]

    %% Subnet grouping
    subgraph PrivateSubnet [Private Subnet]
        ECS
        RDS
        NAT
    end

    subgraph Management [Management & IaC]
        Session
        Terraform
    end
```

---

## ⚙️ Terraform Setup
1. Install Terraform: https://developer.hashicorp.com/terraform/downloads
2. Configure AWS CLI: `aws configure`
3. Clone this repo and navigate to `04-iac-terraform/`
4. Run:
   ```bash
   terraform init
   terraform plan
   terraform apply

5. Outputs:
	•	ALB DNS → App URL
	•	RDS Endpoint
	•	S3 Bucket Name

⸻

📂 Files
	•	main.tf → core infrastructure
	•	variables.tf → configurable values (region, instance type)
	•	outputs.tf → important outputs (ALB DNS, RDS Endpoint)
	•	providers.tf → AWS provider config

⸻

🔒 Security
	•	ECS tasks run in Private Subnet
	•	RDS only accessible from ECS SG
	•	S3 with Public Access Block + encryption
	•	IAM roles with least privilege
	•	AWS Systems Manager Session Manager provides secure, auditable access to private resources (instead of a Bastion Host)

⸻

📊 Monitoring
	•	CloudWatch Alarms on ALB 5XX errors
	•	ECS Task Logs → CloudWatch Logs
	•	GuardDuty & Security Hub enabled

⸻

💰 Cost Estimation
	•	ECS + RDS + ALB: ~$40–50/month (can be scaled down)
	•	S3: <$1/month
	•	CloudWatch: few cents
	•	Cleanup with: terraform destroy

⸻

✅ This project demonstrates Infrastructure as Code (IaC) with Terraform, integrating all components from Projects 1–3 into one automated deployment, while using modern access management (SSM Session Manager).


