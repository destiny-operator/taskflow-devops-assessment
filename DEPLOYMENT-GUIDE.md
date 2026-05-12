# TaskFlow Deployment Guide
## Complete Step-by-Step Instructions for DevOps Assessment

---

## 📋 Table of Contents
1. [Prerequisites](#prerequisites)
2. [Setup GitHub Repository](#setup-github-repository)
3. [Configure Secrets](#configure-secrets)
4. [Deploy Infrastructure](#deploy-infrastructure)
5. [Verify Deployment](#verify-deployment)
6. [Demonstration Checklist](#demonstration-checklist)

---

## Prerequisites

### Required Accounts
- ✅ GitHub account
- ✅ Docker Hub account (free tier)
- ✅ AWS account (AWS Learner Lab or personal)

### Required Software (for local testing)
- Git
- Docker Desktop
- Terraform CLI (optional for local testing)
- Text editor (VS Code recommended)

---

## Setup GitHub Repository

### Step 1: Create Repository
```bash
# Create new repository on GitHub (via web interface)
# Name: taskflow-devops-demo
# Description: DevOps CI/CD Pipeline Demo - L5 Assessment
# Public or Private: Your choice

# Clone to your local machine
git clone https://github.com/YOUR-USERNAME/taskflow-devops-demo.git
cd taskflow-devops-demo

# Copy all TaskFlow files into this directory
# (index.html, app.js, styles.css, Dockerfile, etc.)

# Create directory structure
mkdir -p .github/workflows
mkdir -p terraform

# Copy files to correct locations
# - .github/workflows/ci-cd.yml
# - terraform/*.tf files
```

### Step 2: Initial Commit
```bash
git add .
git commit -m "Initial commit: TaskFlow application with CI/CD pipeline"
git push origin main
```

---

## Configure Secrets

### GitHub Secrets Setup
Go to: `Repository Settings → Secrets and variables → Actions → New repository secret`

Add the following secrets:

#### Docker Hub Secrets
```
DOCKER_USERNAME: your-dockerhub-username
DOCKER_PASSWORD: your-dockerhub-password (or access token)
```

#### AWS Secrets (if using AWS deployment)
```
AWS_ACCESS_KEY_ID: your-aws-access-key
AWS_SECRET_ACCESS_KEY: your-aws-secret-key
EC2_HOST: your-ec2-public-ip
EC2_USER: ec2-user
SSH_PRIVATE_KEY: your-private-key-content
```

#### Optional Secrets
```
SLACK_WEBHOOK: your-slack-webhook-url (for notifications)
```

### How to Get These Values:

**Docker Hub Token:**
1. Login to Docker Hub
2. Go to Account Settings → Security → New Access Token
3. Copy the token (use this as DOCKER_PASSWORD)

**AWS Credentials (Learner Lab):**
1. Start AWS Learner Lab session
2. Click "AWS Details" → "Show"
3. Copy AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY
4. Note: These expire when session ends

**SSH Key:**
1. Generate key pair: `ssh-keygen -t rsa -b 4096 -f taskflow-key`
2. Copy content of `taskflow-key` (private key) to SSH_PRIVATE_KEY secret
3. Add `taskflow-key.pub` (public key) to EC2 instance

---

## Deploy Infrastructure

### Option 1: AWS Learner Lab (Recommended for Students)

#### Step 1: Modify Terraform for Learner Lab
The provided Terraform config is ready, but you may need to:
- Remove S3 backend (Learner Lab may not allow)
- Use provided VPC instead of creating new one

#### Step 2: Manual Setup (Simplified)
Since Learner Lab has limitations, do this manually:

1. **Launch EC2 Instance:**
   - AMI: Amazon Linux 2
   - Instance Type: t2.micro
   - Network: Default VPC
   - Security Group: Allow HTTP (80), HTTPS (443), SSH (22)
   - Storage: 20GB GP3

2. **SSH into Instance:**
   ```bash
   ssh -i taskflow-key.pem ec2-user@YOUR-EC2-IP
   ```

3. **Install Docker:**
   ```bash
   sudo yum update -y
   sudo yum install docker -y
   sudo systemctl start docker
   sudo systemctl enable docker
   sudo usermod -a -G docker ec2-user
   ```

4. **Add EC2 IP to GitHub Secrets:**
   - Secret name: `EC2_HOST`
   - Value: Your EC2 public IP

### Option 2: Full Terraform Deployment (Personal AWS)

```bash
cd terraform

# Initialize Terraform
terraform init

# Review the plan
terraform plan

# Apply infrastructure
terraform apply

# Save the outputs
terraform output > ../deployment-outputs.txt
```

---

## Verify Deployment

### Test 1: Local Docker Build
```bash
# Build image locally
docker build -t taskflow-app:test .

# Run container
docker run -d -p 8080:80 taskflow-app:test

# Test in browser
open http://localhost:8080

# Stop container
docker stop $(docker ps -q --filter ancestor=taskflow-app:test)
```

### Test 2: GitHub Actions Pipeline
```bash
# Make a small change
echo "# Test change" >> README.md
git add README.md
git commit -m "Test: Trigger CI/CD pipeline"
git push origin main

# Watch the pipeline run in GitHub Actions tab
# URL: https://github.com/YOUR-USERNAME/taskflow-devops-demo/actions
```

### Test 3: Application Health Check
```bash
# Once deployed to EC2
curl http://YOUR-EC2-IP

# Or visit in browser
open http://YOUR-EC2-IP
```

### Test 4: Advanced Features Verification

**✅ Automated Testing:**
- Check GitHub Actions logs for test results
- Look for "Automated Testing" job

**✅ Health Checks:**
- Docker health check: `docker inspect taskflow | grep Health`
- ALB health check: Check target group in AWS Console

**✅ Secret Management:**
- Verify secrets aren't exposed in logs
- Check GitHub Actions masked values

**✅ Monitoring:**
- CloudWatch logs: AWS Console → CloudWatch → Log Groups
- Metrics: Check CPU/Memory in EC2 dashboard

---

## Demonstration Checklist

### Pre-Recording Setup
- [ ] Application running on AWS
- [ ] GitHub repository accessible
- [ ] Architecture diagram ready
- [ ] Reference citations prepared
- [ ] Screen recording software tested

### Recording Structure (20 minutes)

#### Minute 0-2: Introduction
- [ ] Show architecture diagram
- [ ] Explain what you built
- [ ] Overview of pipeline stages

#### Minute 2-8: Live Demonstration
- [ ] Open GitHub repository
- [ ] Make a code change (e.g., change app title)
- [ ] Commit and push
- [ ] Show GitHub Actions pipeline triggering
- [ ] Show test stage running
- [ ] Show Docker build stage
- [ ] Show deployment stage
- [ ] Access live application
- [ ] Show the change is deployed

#### Minute 8-13: Explain Tools & Architecture
- [ ] Walk through Dockerfile (containerization)
- [ ] Explain GitHub Actions workflow (CI/CD)
- [ ] Show Terraform files (IaC)
- [ ] Explain AWS infrastructure (VPC, EC2, ALB)
- [ ] **Cite sources** for each choice

#### Minute 13-16: Effectiveness Assessment
- [ ] Show pipeline execution time
- [ ] Demonstrate health checks working
- [ ] Show automated rollback capability (explain)
- [ ] Discuss what worked well
- [ ] Discuss challenges faced

#### Minute 16-19: Reflection & Industry Context
- [ ] Your experience creating this
- [ ] How this applies to your organization
- [ ] Industry trends (cite DevOps reports)
- [ ] Benefits vs challenges

#### Minute 19-20: Conclusion
- [ ] Summary of key learnings
- [ ] Future improvements
- [ ] Thank you

### What to Show On Screen
1. **GitHub repository** - file structure
2. **GitHub Actions** - pipeline running
3. **AWS Console** - EC2 instance, Load Balancer
4. **Live application** - working in browser
5. **Architecture diagram** - reference throughout
6. **Code snippets** - Dockerfile, workflow, Terraform

---

## Common Issues & Solutions

### Issue 1: Pipeline Fails at Build Stage
**Solution:** Check Docker Hub credentials in secrets

### Issue 2: Terraform Apply Fails
**Solution:** Check AWS credentials, verify IAM permissions

### Issue 3: Application Not Accessible
**Solution:** 
- Check security group allows port 80
- Verify EC2 instance is running
- Check Docker container is healthy: `docker ps`

### Issue 4: Tests Failing
**Solution:** Run locally first: `npm install && npm test`

### Issue 5: Terraform State Lock
**Solution:** If using S3 backend, delete lock in DynamoDB

---

## Advanced Features Explained

### 1. Automated Testing
- Jest framework runs unit tests
- Tests run on every push
- Pipeline fails if tests fail
- Coverage report generated

### 2. Health Checks
- Docker native health check
- ALB target group health check
- CloudWatch monitoring
- Automatic instance replacement if unhealthy

### 3. Secret Management
- GitHub Secrets for sensitive data
- Never hardcoded in code
- Masked in logs
- Environment-specific

### 4. Multi-Environment
- Can add staging/production branches
- Different workflows per environment
- Environment variables per stage

### 5. Auto Rollback
- Pipeline monitors deployment
- Health check failure triggers rollback
- Previous container kept until new one healthy

---

## Cost Estimation

### AWS Costs (per month)
- EC2 t2.micro: ~$8.50
- ALB: ~$16.50
- Data transfer: ~$1.00
- **Total: ~$26/month**

### AWS Learner Lab
- Free credits provided
- Resets when credits expire

### Docker Hub
- Free tier: Unlimited public repos

---

## Next Steps After Deployment

1. **Add monitoring dashboard** (CloudWatch/Grafana)
2. **Implement blue-green deployment**
3. **Add database** (RDS)
4. **Set up alerting** (SNS)
5. **Add HTTPS** (ACM certificate)
6. **Implement caching** (CloudFront)

---

## Support & Resources

### Documentation
- AWS: https://docs.aws.amazon.com
- Terraform: https://developer.hashicorp.com/terraform/docs
- GitHub Actions: https://docs.github.com/actions
- Docker: https://docs.docker.com

### Troubleshooting
- Check GitHub Actions logs
- Check EC2 system logs
- Check Docker container logs: `docker logs taskflow`
- Check CloudWatch logs

---

## Assessment Submission Checklist

- [ ] Video recorded (max 20 minutes)
- [ ] GitHub repository link in submission
- [ ] Architecture diagram included
- [ ] Reference list created
- [ ] Cover sheet completed
- [ ] AI prompts documented in appendix
- [ ] All citations included verbally in video

---

**Good luck with your assessment!** 🚀
