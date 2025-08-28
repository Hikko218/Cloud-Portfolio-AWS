# Cloud Storage & Monitoring

## 🎯 Goal
Set up a secure and monitored cloud storage solution using S3:
- Object versioning and lifecycle policies
- Monitoring and alerts
- Optional CDN with CloudFront

---

## 🏗️ Architecture

```mermaid
flowchart TB
    User([User])
    WAF[WAF - Web Application Firewall]
    CF[CloudFront CDN]
    CW1[CloudWatch Logs]
    Alarm[CloudWatch Alarms]
    CW2[CloudWatch Metrics]
    CW3[CloudWatch Monitoring]
    Guard[GuardDuty + Security Hub]
    S3[(S3 Bucket)]

    User --> WAF --> CF --> CW1
    CF --> CW2
    CF --> CW3

    CW1 --> Alarm
    CW2 --> Guard --> S3
```

➡️ For the full step-by-step build process with screenshots, see the [Build Guide](./docs/BUILD.md).

---

## ⚙️ Services Used
- Amazon S3 (Versioning, Lifecycle → Glacier)
- CloudFront (CDN with HTTPS)
- CloudWatch Dashboard (S3 Access Logs)
- GuardDuty + Security Hub for threat detection

---

## 🔒 Security
- S3 Public Access Block enabled
- Bucket Policy restricted (only via CloudFront OAI)
- Encryption enabled (SSE-S3)

---

## 📊 Monitoring
- CloudWatch Dashboard: GET/PUT request metrics
- CloudWatch Alarm for abnormal request volume
- GuardDuty findings documented

---

## 💰 Cost Estimation
- S3: <$1/month
- CloudFront: ~$1–2/month (depends on traffic)
- CloudWatch: minimal
