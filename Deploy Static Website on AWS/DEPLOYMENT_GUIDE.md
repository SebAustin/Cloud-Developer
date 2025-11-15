# AWS Static Website Deployment Guide

This guide walks you through deploying your static website to AWS using the automated deployment scripts provided in this project.

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Quick Start](#quick-start)
3. [Detailed Deployment Steps](#detailed-deployment-steps)
4. [Configuration Options](#configuration-options)
5. [Verifying Your Deployment](#verifying-your-deployment)
6. [Accessing Your Website](#accessing-your-website)
7. [Taking Screenshots for Submission](#taking-screenshots-for-submission)
8. [Cleanup Instructions](#cleanup-instructions)
9. [Troubleshooting](#troubleshooting)

## Prerequisites

Before you begin, ensure you have the following:

### 1. AWS Account
- Active AWS account with appropriate permissions
- Access to create S3 buckets, configure IAM policies, and create CloudFront distributions

### 2. AWS CLI Installed and Configured

**Check if AWS CLI is installed:**
```bash
aws --version
```

**If not installed, install it:**

- **macOS:** 
  ```bash
  brew install awscli
  ```
  Or download from: https://aws.amazon.com/cli/

- **Linux:**
  ```bash
  curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
  unzip awscliv2.zip
  sudo ./aws/install
  ```

- **Windows:**
  Download the installer from: https://aws.amazon.com/cli/

**Configure AWS CLI:**
```bash
aws configure
```

You'll need to provide:
- AWS Access Key ID
- AWS Secret Access Key
- Default region (e.g., `us-east-1`)
- Default output format (use `json`)

**Verify configuration:**
```bash
aws sts get-caller-identity
```

### 3. Required Permissions

Your AWS user/role needs the following permissions:
- `s3:CreateBucket`
- `s3:PutObject`
- `s3:PutBucketWebsite`
- `s3:PutBucketPolicy`
- `s3:PutPublicAccessBlock`
- `cloudfront:CreateDistribution`
- `cloudfront:GetDistribution`

### 4. Website Files

Ensure the `udacity-starter-website` directory exists in the project root with all website files.

## Quick Start

For experienced users who have all prerequisites met:

```bash
# 1. Make scripts executable
chmod +x deploy.sh cleanup.sh

# 2. Run deployment
./deploy.sh

# 3. Wait 15-20 minutes for CloudFront deployment
# 4. Access your website at the provided URLs
# 5. Take required screenshots (see SCREENSHOT_GUIDE.md)
# 6. After project review, cleanup
./cleanup.sh
```

## Detailed Deployment Steps

### Step 1: Prepare the Project

1. Open your terminal/command prompt
2. Navigate to the project directory:
   ```bash
   cd "/Users/shenry/Documents/Personal/Training/Project/Udacity/Cloud Developper/Deploy Static Website on AWS"
   ```

3. Verify the website files are present:
   ```bash
   ls udacity-starter-website/
   ```
   You should see: `index.html`, `css/`, `img/`, `vendor/`

### Step 2: Make Scripts Executable

```bash
chmod +x deploy.sh cleanup.sh
```

### Step 3: (Optional) Configure Deployment Settings

If you want to customize the deployment, create a `.env` file:

```bash
cp .env.example .env
nano .env  # or use your preferred text editor
```

Edit the following settings:
- `AWS_REGION` - AWS region for your resources (default: us-east-1)
- `BUCKET_PREFIX` - Prefix for your S3 bucket name (default: udacity-static-website)

### Step 4: Run the Deployment Script

```bash
./deploy.sh
```

**What the script does:**

1. ✅ Creates a uniquely-named S3 bucket
2. ✅ Configures the bucket for static website hosting
3. ✅ Applies IAM policy for public access
4. ✅ Uploads all website files to S3
5. ✅ Creates CloudFront distribution
6. ✅ Saves deployment information to `deployment-info.txt`

**Expected output:**
```
==========================================
  AWS Static Website Deployment Script
==========================================

Configuration:
  AWS Region: us-east-1
  Bucket Name: udacity-static-website-20241113-120000
  Website Directory: udacity-starter-website

Step 1: Creating S3 bucket...
✓ S3 bucket created: udacity-static-website-20241113-120000

Step 2: Configuring bucket for static website hosting...
✓ Static website hosting enabled

Step 3: Applying IAM bucket policy for public access...
✓ Bucket policy applied (public read access)

Step 4: Uploading website files to S3...
✓ Website files uploaded

Step 5: Creating CloudFront distribution...
✓ CloudFront distribution created
  Distribution ID: E1234567890ABC
  CloudFront Domain: d1234567890abc.cloudfront.net

==========================================
  DEPLOYMENT COMPLETED SUCCESSFULLY!
==========================================

Your website has been deployed!

S3 Website Endpoint: http://udacity-static-website-20241113-120000.s3-website-us-east-1.amazonaws.com
CloudFront Domain: https://d1234567890abc.cloudfront.net
```

### Step 5: Wait for CloudFront Deployment

CloudFront distribution deployment takes **15-20 minutes**. During this time:

1. The S3 website endpoint is immediately accessible
2. CloudFront is propagating your content to edge locations worldwide

**Check CloudFront status:**
```bash
aws cloudfront get-distribution --id <DISTRIBUTION_ID> --query 'Distribution.Status'
```

When the status shows `"Deployed"`, your CloudFront distribution is ready.

## Configuration Options

### Environment Variables

Create a `.env` file to customize your deployment:

```bash
# AWS Region (default: us-east-1)
AWS_REGION=us-east-1

# S3 Bucket Name Prefix (default: udacity-static-website)
# A timestamp will be appended for uniqueness
BUCKET_PREFIX=my-static-website
```

### Why Different Regions?

- **us-east-1** (N. Virginia) - Most services, lowest cost, default for many AWS services
- **us-west-2** (Oregon) - West coast users
- **eu-west-1** (Ireland) - European users

Choose a region close to your primary audience for better performance.

## Verifying Your Deployment

### 1. Check S3 Bucket

**AWS Console:**
1. Go to https://s3.console.aws.amazon.com/
2. Find your bucket (name from `deployment-info.txt`)
3. Verify all files are uploaded

**AWS CLI:**
```bash
aws s3 ls s3://<YOUR-BUCKET-NAME>/ --recursive
```

### 2. Test S3 Website Endpoint

Open the S3 website endpoint URL in your browser (from `deployment-info.txt`):
```
http://<bucket-name>.s3-website-<region>.amazonaws.com
```

You should see your website immediately.

### 3. Check CloudFront Distribution

**AWS Console:**
1. Go to https://console.aws.amazon.com/cloudfront/
2. Find your distribution
3. Check status (should be "Deployed" after 15-20 minutes)

**AWS CLI:**
```bash
aws cloudfront get-distribution --id <DISTRIBUTION_ID>
```

### 4. Test CloudFront URL

After CloudFront status is "Deployed", open the CloudFront URL:
```
https://<cloudfront-domain>.cloudfront.net
```

## Accessing Your Website

You have **two URLs** to access your website:

### 1. S3 Website Endpoint (HTTP)
- Format: `http://<bucket-name>.s3-website-<region>.amazonaws.com`
- Available: Immediately after deployment
- Protocol: HTTP only
- Use for: Quick testing, verification

### 2. CloudFront Domain (HTTPS)
- Format: `https://<distribution-id>.cloudfront.net`
- Available: 15-20 minutes after deployment
- Protocol: HTTPS (secure)
- Use for: Production access, project submission

**Both URLs must be included in your project submission.**

## Taking Screenshots for Submission

See `SCREENSHOT_GUIDE.md` for detailed instructions on taking the required screenshots for your Udacity project submission.

Key screenshots needed:
1. S3 bucket in AWS Console
2. All uploaded files in S3
3. S3 bucket static website hosting configuration
4. S3 bucket policy showing public access
5. CloudFront distribution configuration
6. Website in browser (both endpoints)

## Cleanup Instructions

**IMPORTANT:** After receiving your project review and passing, delete all AWS resources to avoid charges.

### Run the Cleanup Script

```bash
./cleanup.sh
```

**What the cleanup script does:**

1. Reads deployment information from `deployment-info.txt`
2. Disables CloudFront distribution
3. Waits for distribution to be disabled
4. Deletes CloudFront distribution
5. Empties S3 bucket
6. Deletes S3 bucket
7. Archives deployment information

**The script will ask for confirmation:**
```
The following resources will be deleted:
  S3 Bucket: udacity-static-website-20241113-120000
  CloudFront Distribution: E1234567890ABC

WARNING: This action cannot be undone!

Are you sure you want to continue? (yes/no):
```

Type `yes` to proceed.

### Manual Cleanup (if needed)

If the script fails or you need to clean up manually:

1. **Delete CloudFront Distribution:**
   ```bash
   # Disable distribution
   aws cloudfront get-distribution-config --id <DISTRIBUTION_ID> > config.json
   # Edit config.json, set "Enabled": false
   aws cloudfront update-distribution --id <DISTRIBUTION_ID> --distribution-config file://config.json --if-match <ETAG>
   # Wait for deployment
   aws cloudfront wait distribution-deployed --id <DISTRIBUTION_ID>
   # Delete distribution
   aws cloudfront delete-distribution --id <DISTRIBUTION_ID> --if-match <NEW_ETAG>
   ```

2. **Delete S3 Bucket:**
   ```bash
   aws s3 rm s3://<BUCKET_NAME> --recursive
   aws s3api delete-bucket --bucket <BUCKET_NAME>
   ```

## Troubleshooting

### Problem: "AWS CLI is not installed"

**Solution:**
```bash
# macOS
brew install awscli

# Linux
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
```

### Problem: "AWS credentials are not configured"

**Solution:**
```bash
aws configure
```
Provide your AWS Access Key ID, Secret Access Key, region, and output format.

### Problem: "Bucket name already exists"

**Cause:** S3 bucket names must be globally unique across all AWS accounts.

**Solution:** The script automatically generates unique names using timestamps. If you encounter this error, wait a moment and run the script again.

### Problem: "Access Denied" errors

**Cause:** Your AWS user lacks necessary permissions.

**Solution:**
1. Log into AWS Console as an administrator
2. Go to IAM → Users → Your User
3. Attach policy: `PowerUserAccess` or create custom policy with required permissions
4. Alternatively, use a different AWS account with full access

### Problem: CloudFront distribution stuck in "In Progress"

**Cause:** CloudFront deployments take 15-20 minutes.

**Solution:** Be patient. Check status:
```bash
aws cloudfront get-distribution --id <DISTRIBUTION_ID> --query 'Distribution.Status'
```

### Problem: Website shows 403 Forbidden

**Causes:**
1. Bucket policy not applied correctly
2. Public access block still enabled
3. File permissions incorrect

**Solutions:**

1. **Verify bucket policy:**
   ```bash
   aws s3api get-bucket-policy --bucket <BUCKET_NAME>
   ```

2. **Verify public access settings:**
   ```bash
   aws s3api get-public-access-block --bucket <BUCKET_NAME>
   ```

3. **Reapply policy manually:**
   ```bash
   aws s3api put-bucket-policy --bucket <BUCKET_NAME> --policy file://policy.json
   ```

### Problem: CSS/Images not loading

**Cause:** Files not uploaded or incorrect paths.

**Solution:**
1. Check files in S3:
   ```bash
   aws s3 ls s3://<BUCKET_NAME>/ --recursive
   ```

2. Re-upload if needed:
   ```bash
   aws s3 sync udacity-starter-website/ s3://<BUCKET_NAME>/
   ```

### Problem: Cleanup script can't find deployment-info.txt

**Solution:** Manually provide bucket name and distribution ID when prompted, or clean up resources via AWS Console.

## Additional Resources

- [AWS S3 Static Website Hosting Documentation](https://docs.aws.amazon.com/AmazonS3/latest/dev/WebsiteHosting.html)
- [AWS CloudFront Documentation](https://docs.aws.amazon.com/cloudfront/)
- [AWS CLI Command Reference](https://docs.aws.amazon.com/cli/latest/reference/)
- [Udacity Project Rubric](https://review.udacity.com/)

## Getting Help

If you encounter issues not covered in this guide:

1. Check AWS CloudWatch logs
2. Review AWS service health dashboard
3. Post in Udacity student forums
4. Contact AWS Support (if you have a support plan)

## Summary

This deployment process gives you hands-on experience with:
- ✅ S3 bucket creation and configuration
- ✅ IAM policies for public access
- ✅ Static website hosting
- ✅ CloudFront CDN distribution
- ✅ AWS CLI automation
- ✅ Cloud infrastructure management

**Remember to delete all resources after your project is reviewed to avoid charges!**

