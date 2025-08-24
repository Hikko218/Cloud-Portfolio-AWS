```markdown
# Step-by-Step Guide: Cloud Storage & Monitoring on AWS

This document provides a step-by-step guide to build a secure cloud storage solution with Amazon S3, CloudFront CDN, and monitoring using CloudWatch, GuardDuty, and Security Hub.

---

## **1. Preparation**
- AWS Account (Free Tier enabled)
- Region: e.g., `eu-central-1` (Frankfurt)

---

## **2. Create S3 Bucket**
1. Go to **S3 Console** → “Create bucket”.
2. Name: `portfolio-storage-bucket` (must be globally unique).
3. Block all public access (enabled by default).
4. Enable **Versioning**.
5. Add **Lifecycle Rule**: Move objects to Glacier after 30 days.

📸 Screenshot: *S3 Bucket Properties (Versioning + Lifecycle)*

---

## **3. CloudFront Distribution (CDN)**
1. Go to **CloudFront Console** → “Create Distribution”.
2. Origin: select the S3 Bucket.
3. Restrict Bucket Access: enable OAI (Origin Access Identity).
4. Viewer Protocol Policy: Redirect HTTP → HTTPS.
5. Default Root Object: `index.html` (if static site).
6. Deploy.

📸 Screenshot: *CloudFront Distribution Settings (OAI + HTTPS)*

---

## **4. Security Settings**
- **S3 Bucket Policy**: Allow access only via CloudFront OAI.
- **Encryption**: Enable server-side encryption (SSE-S3).
- **Block Public Access**: Must remain enabled.

📸 Screenshot: *S3 Bucket Policy JSON + Encryption Enabled*

---

## **5. Monitoring with CloudWatch**
1. Go to **CloudWatch → Dashboards** → Create new.
2. Add widgets for:
   - S3 GET Requests
   - S3 PUT Requests
   - 4xx/5xx Error Rates (via CloudFront)
3. Create **Alarm**:
   - Metric: >1000 PUT requests/min.
   - Action: Send SNS notification.

📸 Screenshot: *CloudWatch Dashboard with S3 metrics*

---

## **6. Threat Detection (GuardDuty + Security Hub)**
1. Go to **GuardDuty Console** → Enable.
   - GuardDuty will analyze S3 Data Events, VPC Flow Logs, CloudTrail.
2. Go to **Security Hub Console** → Enable.
   - Security Hub aggregates GuardDuty + Config findings.

📸 Screenshot: *GuardDuty Findings Dashboard*

---

## **7. Cost Estimation & Cleanup**
- S3: <$1/month (Free Tier 5GB).
- CloudFront: ~$1–2/month (depends on traffic).
- CloudWatch: minimal (logs/alarms a few cents).
- GuardDuty + Security Hub: Free trial (30 days).
- Cleanup: delete S3 bucket, disable CloudFront, remove alarms.

📸 Screenshot: *AWS Billing Console (S3 + CloudFront usage)*

---

✅ With this setup, you demonstrate **secure cloud storage**, integration with **CDN**, and **monitoring & threat detection** using AWS-native services.
```

