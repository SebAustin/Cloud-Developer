# AWS Deployment Scripts - Usage Guide

## 🚀 Quick Start

```bash
# Deploy everything to AWS
./deploy-to-aws.sh

# Clean up after project (delete all resources)
./cleanup-aws.sh
```

---

## 📋 Overview

This directory contains two automated scripts:

1. **`deploy-to-aws.sh`** - Deploys Udagram to AWS
2. **`cleanup-aws.sh`** - Deletes all AWS resources

---

## 🎯 deploy-to-aws.sh

### What It Does

This script automates the entire AWS deployment process:

✅ **Creates AWS Resources:**
- RDS PostgreSQL database (for user data and posts)
- S3 bucket (for image storage)
- EKS Kubernetes cluster (optional)
- All necessary security groups and configurations

✅ **Configures Everything:**
- Updates `set_env.sh` with credentials
- Updates Kubernetes config files
- Deploys to Kubernetes (if EKS created)
- Sets up autoscaling

### Prerequisites

Before running the script, ensure you have:

1. **AWS CLI installed and configured:**
   ```bash
   aws configure
   # Enter your Access Key ID
   # Enter your Secret Access Key
   # Region: us-east-1
   # Output format: json
   ```

2. **Docker installed:**
   ```bash
   docker --version
   ```

3. **kubectl installed:**
   ```bash
   kubectl version --client
   ```

4. **DockerHub account** (you'll need your username)

### Usage

```bash
./deploy-to-aws.sh
```

### Interactive Prompts

The script will ask you for:

1. **Database master username** (default: `udagramadmin`)
2. **Database master password** (min 8 characters)
3. **S3 bucket name** (default: `udagram-<user>-<random>`)
4. **Create EKS cluster?** (y/n)
5. **EKS cluster name** (if yes, default: `udagram-cluster`)
6. **DockerHub username**

### Example Run

```bash
$ ./deploy-to-aws.sh

╔════════════════════════════════════════════════════════════╗
║                                                            ║
║        Udagram Microservices - AWS Deployment             ║
║                                                            ║
╚════════════════════════════════════════════════════════════╝

========================================
Checking Prerequisites
========================================

✓ aws is installed
✓ docker is installed
✓ kubectl is installed
✓ AWS credentials configured
ℹ AWS Account: 123456789012
✓ All prerequisites met!

========================================
Configuration
========================================

Enter database master username [udagramadmin]: 
Enter database master password (min 8 chars): ********
Enter S3 bucket name [udagram-shenry-123456]: 
Create EKS cluster? (y/n) [y]: y
Enter EKS cluster name [udagram-cluster]: 
Enter DockerHub username: yourusername

Summary:
  Database: udagramadmin@udagram-db
  S3 Bucket: udagram-shenry-123456
  Region: us-east-1
  EKS Cluster: udagram-cluster

Continue with deployment? (y/n): y
```

### What Happens

**Phase 1: RDS Database (10-15 minutes)**
- Creates PostgreSQL database
- Configures security group for port 5432
- Waits for database to become available
- Gets endpoint URL

**Phase 2: S3 Bucket (1 minute)**
- Creates S3 bucket
- Enables public access
- Configures CORS
- Adds bucket policy

**Phase 3: Environment Configuration (instant)**
- Creates/updates `set_env.sh`
- Saves all credentials securely

**Phase 4: EKS Cluster (15-20 minutes)** - Optional
- Creates EKS cluster
- Creates node group (2-3 nodes)
- Configures kubectl

**Phase 5: Kubernetes Deployment (5 minutes)** - If EKS created
- Updates K8s config files
- Deploys all services
- Creates LoadBalancers
- Sets up autoscaling

### After Deployment

The script outputs a complete summary:

```
========================================
Deployment Summary
========================================

AWS Resources Created:
  ✓ RDS PostgreSQL: udagram-db
    Endpoint: udagram-db.xxxxx.us-east-1.rds.amazonaws.com
    Username: udagramadmin
    Database: postgres

  ✓ S3 Bucket: udagram-shenry-123456
    URL: https://udagram-shenry-123456.s3.amazonaws.com

  ✓ EKS Cluster: udagram-cluster
    Region: us-east-1

Environment Configuration:
  File: set_env.sh
  Load with: source set_env.sh

Local Testing:
  1. source set_env.sh
  2. docker-compose up
  3. Open http://localhost:8100

Kubernetes Commands:
  kubectl get pods          # Check pod status
  kubectl get services      # Get service endpoints
  kubectl get hpa           # Check autoscaling
  kubectl logs <pod-name>   # View logs

Cost Estimate (Monthly):
  RDS t3.micro: ~$15-20 (750 hours free tier)
  S3: ~$0.50
  EKS: ~$72 (cluster)
  EC2: ~$30-60 (nodes)
  Total: ~$120-150/month

⚠ Remember to delete resources after project submission to avoid charges!

Next Steps:
  1. Wait for LoadBalancer External IPs (5-10 min)
  2. Update frontend with reverseproxy IP
  3. Rebuild and redeploy frontend
  4. Take required screenshots
  5. Submit project
```

### Files Created/Modified

- ✅ `set_env.sh` - Environment variables with credentials
- ✅ `udagram-deployment/*.yaml` - Updated with your values
- ✅ Kubernetes resources in AWS EKS

### Troubleshooting

**Issue: "AWS credentials not configured"**
```bash
aws configure
# Enter your credentials
```

**Issue: "Bucket already exists"**
- Choose a different bucket name (must be globally unique)

**Issue: "Insufficient permissions"**
- Ensure your IAM user has:
  - RDS full access
  - S3 full access
  - EKS full access
  - EC2 full access

**Issue: "eksctl not found"**
```bash
# macOS
brew install weaveworks/tap/eksctl

# Linux
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin
```

---

## 🧹 cleanup-aws.sh

### What It Does

Deletes ALL AWS resources created by the deployment script:

- ❌ EKS Kubernetes cluster and nodes
- ❌ RDS PostgreSQL database
- ❌ S3 bucket and all contents
- ❌ Load Balancers
- ❌ Security groups

### ⚠️ WARNING

**THIS DELETES EVERYTHING!** There is NO undo!

Only run this after:
- ✅ Your project is graded and approved
- ✅ You've downloaded all screenshots
- ✅ You've backed up any data you need

### Usage

```bash
./cleanup-aws.sh
```

### Interactive Prompts

```bash
╔════════════════════════════════════════════════════════════╗
║                                                            ║
║        ⚠️  AWS RESOURCE CLEANUP WARNING  ⚠️                ║
║                                                            ║
╚════════════════════════════════════════════════════════════╝

⚠ This script will DELETE all Udagram AWS resources:
  • EKS Kubernetes cluster
  • RDS PostgreSQL database
  • S3 bucket and all contents
  • Associated security groups and networking

✗ THIS ACTION CANNOT BE UNDONE!

Are you ABSOLUTELY sure you want to continue? (type 'YES' to confirm): YES

Enter EKS cluster name [udagram-cluster]: 
Enter RDS instance identifier [udagram-db]: 
Enter S3 bucket name: udagram-shenry-123456

Will delete:
  • EKS Cluster: udagram-cluster
  • RDS Database: udagram-db
  • S3 Bucket: udagram-shenry-123456

Proceed? (y/n): y
```

### What Happens

**Phase 1: Kubernetes Resources (2-5 minutes)**
- Deletes all services (removes LoadBalancers)
- Deletes all deployments
- Deletes autoscaling configurations
- Deletes secrets and configmaps

**Phase 2: EKS Cluster (10-15 minutes)**
- Deletes node groups
- Deletes cluster
- Removes all associated resources

**Phase 3: RDS Database (5-10 minutes)**
- Deletes database instance
- Waits for confirmation

**Phase 4: S3 Bucket (1 minute)**
- Empties bucket (deletes all files)
- Deletes bucket

**Phase 5: Local Cleanup**
- Optionally deletes `set_env.sh`

### After Cleanup

```
========================================
Cleanup Complete
========================================

✓ All AWS resources have been deleted!

Resources deleted:
  ✓ EKS Cluster: udagram-cluster
  ✓ RDS Database: udagram-db
  ✓ S3 Bucket: udagram-shenry-123456

⚠ Please verify in AWS Console that all resources are gone:
  1. EKS → Clusters (should be empty)
  2. RDS → Databases (should be empty)
  3. S3 → Buckets (bucket should be gone)
  4. EC2 → Load Balancers (should be empty)
  5. EC2 → Security Groups (check for orphaned groups)

✓ You should no longer incur AWS charges for this project!
```

### Manual Verification

Always verify in AWS Console that everything is deleted:

1. **EKS Console** → No clusters
2. **RDS Console** → No databases
3. **S3 Console** → Bucket gone
4. **EC2 Console** → Load Balancers → None
5. **Billing Dashboard** → Check for $0 charges

---

## 📊 Cost Management

### Monthly Costs (Estimated)

| Resource | Free Tier | Cost After Free Tier |
|----------|-----------|----------------------|
| RDS t3.micro | 750 hours/month | ~$15-20/month |
| S3 Storage | 5 GB | ~$0.50/month |
| EKS Cluster | None | ~$72/month |
| EC2 Nodes (t3.medium x2) | 750 hours/month* | ~$30-60/month |
| **Total** | - | **~$120-150/month** |

*Some EC2 instance types have free tier

### Cost Optimization Tips

1. **Delete after approval** - Run cleanup script ASAP
2. **Use free tier** - Choose t2.micro/t3.micro instances
3. **Skip EKS initially** - Deploy EKS only when ready to submit
4. **Monitor billing** - Check AWS Billing Dashboard daily

### Minimum Setup (Cheapest)

Deploy without EKS initially:
```bash
# When prompted "Create EKS cluster?", answer: n
./deploy-to-aws.sh
```

This creates:
- RDS database (~$15-20/month, possibly free)
- S3 bucket (~$0.50/month)
- **Total: ~$15-20/month or $0 with free tier**

Test locally, then create EKS when ready to submit.

---

## 🎯 Recommended Workflow

### 1. Initial Setup (Day 1)
```bash
./deploy-to-aws.sh
# Answer "n" to EKS cluster
# This creates: RDS + S3 only
```

### 2. Local Development (Days 2-5)
```bash
source set_env.sh
docker-compose up
# Test everything locally
```

### 3. Build Images & CI/CD (Day 6)
```bash
# Set up Travis CI
# Push to DockerHub
# Verify automated builds
```

### 4. Deploy to Kubernetes (Day 7)
```bash
# Create EKS cluster
eksctl create cluster --name udagram-cluster --region us-east-1

# Or run deployment script again, answer "y" to EKS
./deploy-to-aws.sh  # Will skip RDS/S3 (already exist)

# Deploy application
cd udagram-deployment
kubectl apply -f .
```

### 5. Take Screenshots & Submit (Day 7)
```bash
kubectl get pods
kubectl describe services
kubectl describe hpa
kubectl logs <pod-name>
# Take all screenshots
# Submit project
```

### 6. Cleanup (After Approval)
```bash
./cleanup-aws.sh
# DELETE EVERYTHING!
```

---

## 🆘 Support

### Script Issues

If the deployment script fails:

1. **Check AWS credentials:**
   ```bash
   aws sts get-caller-identity
   ```

2. **Check logs:**
   - Script shows detailed error messages
   - Check AWS Console for resource status

3. **Run cleanup and retry:**
   ```bash
   ./cleanup-aws.sh
   ./deploy-to-aws.sh
   ```

### Application Issues

If application doesn't work after deployment:

1. **Check pods:**
   ```bash
   kubectl get pods
   kubectl logs <pod-name>
   ```

2. **Check services:**
   ```bash
   kubectl get services
   kubectl describe service <service-name>
   ```

3. **Check environment variables:**
   ```bash
   kubectl get configmap env-config -o yaml
   ```

### Getting Help

- 📖 Read `TROUBLESHOOTING.md`
- 📖 Read `DEPLOYMENT_GUIDE.md`
- 🔍 Check AWS Console for resource status
- 📧 Check CloudWatch logs

---

## ✅ Checklist

### Before Running deploy-to-aws.sh
- [ ] AWS CLI installed and configured
- [ ] Docker installed
- [ ] kubectl installed
- [ ] DockerHub account created
- [ ] Have credit card on AWS account
- [ ] Understand monthly costs

### After Running deploy-to-aws.sh
- [ ] `set_env.sh` file created
- [ ] RDS database endpoint received
- [ ] S3 bucket created
- [ ] Can run locally: `source set_env.sh && docker-compose up`
- [ ] Application works at http://localhost:8100

### Before Running cleanup-aws.sh
- [ ] Project is graded and approved
- [ ] All screenshots downloaded
- [ ] No more testing needed
- [ ] Understand THIS DELETES EVERYTHING
- [ ] Have verified in AWS Console all resources exist

### After Running cleanup-aws.sh
- [ ] Checked AWS Console - no resources
- [ ] Checked Billing Dashboard - $0 charges
- [ ] Deleted local `set_env.sh` (if desired)

---

**Happy Deploying! 🚀**

