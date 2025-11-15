# Deploy Static Website on AWS - Automated Deployment

This repository contains automated AWS CLI scripts to deploy a static website to Amazon S3 with CloudFront CDN for the Udacity Cloud Developer Nanodegree project.

## 🎯 Project Overview

This project demonstrates how to:
- Deploy a static website to AWS S3
- Configure S3 for static website hosting
- Apply IAM policies for public access
- Set up CloudFront CDN for global content delivery
- Automate the entire deployment process using AWS CLI

## 📋 Prerequisites

Before you begin, ensure you have:

1. **AWS Account** - Active AWS account with appropriate permissions
2. **AWS CLI** - Installed and configured with credentials
3. **Bash Shell** - macOS/Linux terminal or Git Bash on Windows
4. **Website Files** - The `udacity-starter-website` directory with all files

## 🚀 Quick Start

```bash
# 1. Make scripts executable
chmod +x deploy.sh cleanup.sh

# 2. Deploy to AWS
./deploy.sh

# 3. Wait 15-20 minutes for CloudFront deployment

# 4. Access your website at the provided URLs

# 5. After project review, cleanup
./cleanup.sh
```

## 📁 Project Structure

```
.
├── deploy.sh                    # Main deployment script
├── cleanup.sh                   # Resource cleanup script
├── DEPLOYMENT_GUIDE.md          # Comprehensive deployment instructions
├── SCREENSHOT_GUIDE.md          # Screenshot requirements for submission
├── README.txt                   # Project submission README template
├── env.example                  # Configuration file template
├── PROJECT_README.md            # This file
└── udacity-starter-website/     # Website files to deploy
    ├── index.html
    ├── css/
    ├── img/
    └── vendor/
```

## 🛠️ What the Scripts Do

### deploy.sh

The deployment script automates the entire AWS setup:

1. ✅ **Creates S3 Bucket** - Generates unique bucket name with timestamp
2. ✅ **Configures Static Hosting** - Enables static website hosting on S3
3. ✅ **Applies IAM Policy** - Makes bucket contents publicly accessible
4. ✅ **Uploads Files** - Syncs all website files to S3
5. ✅ **Creates CloudFront Distribution** - Sets up CDN for global delivery
6. ✅ **Outputs URLs** - Provides S3 and CloudFront access URLs

**Generated file:** `deployment-info.txt` - Contains all deployment details

### cleanup.sh

The cleanup script removes all AWS resources:

1. 🗑️ **Disables CloudFront** - Safely disables the distribution
2. 🗑️ **Deletes CloudFront** - Removes the distribution
3. 🗑️ **Empties S3 Bucket** - Deletes all objects
4. 🗑️ **Deletes S3 Bucket** - Removes the bucket
5. 📦 **Archives Info** - Saves deployment info for reference

## 📖 Documentation Files

| File | Purpose |
|------|---------|
| **DEPLOYMENT_GUIDE.md** | Complete step-by-step deployment instructions, troubleshooting, and best practices |
| **SCREENSHOT_GUIDE.md** | Detailed instructions for taking all required screenshots for project submission |
| **README.txt** | Template for your project submission README (fill in your URLs) |
| **env.example** | Configuration template for customizing AWS region and bucket prefix |

## ⚙️ Configuration

To customize your deployment:

1. Copy the example configuration file:
   ```bash
   cp env.example .env
   ```

2. Edit `.env` with your preferences:
   ```bash
   # AWS Region
   AWS_REGION=us-east-1
   
   # S3 Bucket Name Prefix
   BUCKET_PREFIX=my-website
   ```

3. Run the deployment script:
   ```bash
   ./deploy.sh
   ```

## 🌐 Accessing Your Website

After deployment, you'll have two URLs:

### 1. S3 Website Endpoint (HTTP)
- Format: `http://[bucket-name].s3-website-[region].amazonaws.com`
- Available: Immediately after deployment
- Use for: Quick testing

### 2. CloudFront Domain (HTTPS)
- Format: `https://[distribution-id].cloudfront.net`
- Available: 15-20 minutes after deployment
- Use for: Production, project submission

Both URLs are saved in `deployment-info.txt`.

## 📸 Project Submission

### Required Screenshots

You need 6+ screenshots for Udacity project submission:

1. S3 bucket in AWS Console
2. All website files uploaded to S3
3. S3 static website hosting configuration
4. S3 bucket IAM policy (public access)
5. CloudFront distribution configuration
6. Website in browser (both S3 and CloudFront URLs)

See **SCREENSHOT_GUIDE.md** for detailed instructions.

### Submission Checklist

- [ ] Run `./deploy.sh` and verify successful deployment
- [ ] Wait for CloudFront status to show "Deployed"
- [ ] Test both S3 and CloudFront URLs in browser
- [ ] Take all required screenshots
- [ ] Fill in URLs in `README.txt`
- [ ] Create submission folder with screenshots and README.txt
- [ ] Zip the submission folder
- [ ] Submit to Udacity
- [ ] After receiving passing grade, run `./cleanup.sh`

## 🔧 Troubleshooting

### Common Issues

**Problem: "AWS CLI is not installed"**
```bash
# macOS
brew install awscli

# Or download from: https://aws.amazon.com/cli/
```

**Problem: "AWS credentials are not configured"**
```bash
aws configure
# Enter your Access Key ID, Secret Key, region, and output format
```

**Problem: "Access Denied" errors**
- Verify your AWS user has required permissions
- Check IAM policies for S3 and CloudFront access

**Problem: Website shows 403 Forbidden**
- Verify bucket policy is applied correctly
- Check public access settings are disabled
- Ensure files were uploaded successfully

**Problem: CloudFront URL not working**
- Wait 15-20 minutes for deployment to complete
- Check distribution status: `aws cloudfront get-distribution --id <ID>`
- Status should show "Deployed"

For more troubleshooting, see **DEPLOYMENT_GUIDE.md**.

## 💰 Cost Considerations

This project uses AWS Free Tier eligible services:

- **S3:** First 5GB storage free, 20,000 GET requests
- **CloudFront:** 50GB data transfer out, 2,000,000 HTTP requests

**Important:** Run `./cleanup.sh` after project review to avoid any charges!

## 🔒 Security Notes

- S3 bucket is publicly accessible (required for static hosting)
- CloudFront uses HTTPS for secure delivery
- No sensitive data should be stored in the website files
- AWS credentials are never stored in the scripts

## 📚 Resources

- [AWS S3 Static Website Hosting](https://docs.aws.amazon.com/AmazonS3/latest/dev/WebsiteHosting.html)
- [AWS CloudFront Documentation](https://docs.aws.amazon.com/cloudfront/)
- [AWS CLI Command Reference](https://docs.aws.amazon.com/cli/latest/reference/)
- [Udacity Cloud Developer Nanodegree](https://www.udacity.com/course/cloud-developer-nanodegree--nd9990)

## 🎓 Learning Objectives

By completing this project, you will learn:

- ✅ How to deploy static websites to S3
- ✅ How to configure S3 for web hosting
- ✅ How to apply IAM policies for resource access
- ✅ How to set up CloudFront CDN
- ✅ How to automate AWS deployments with CLI
- ✅ How to manage cloud infrastructure
- ✅ Best practices for static website hosting

## ⚠️ Important Reminders

1. **Test Both URLs** - Verify S3 and CloudFront endpoints work
2. **Wait for CloudFront** - Distribution takes 15-20 minutes to deploy
3. **Take Screenshots** - Follow SCREENSHOT_GUIDE.md carefully
4. **Update README.txt** - Fill in your actual URLs before submission
5. **Cleanup After Review** - Run `./cleanup.sh` to avoid charges

## 🤝 Support

If you encounter issues:

1. Check **DEPLOYMENT_GUIDE.md** for detailed troubleshooting
2. Review AWS CloudWatch logs
3. Verify AWS credentials and permissions
4. Post in Udacity student forums
5. Check AWS service health dashboard

## ✅ Success Criteria

Your deployment is successful when:

- ✅ S3 bucket created and configured
- ✅ All files uploaded to S3
- ✅ S3 website endpoint accessible
- ✅ CloudFront distribution created
- ✅ CloudFront status shows "Deployed"
- ✅ CloudFront URL accessible via HTTPS
- ✅ Both URLs display the complete website

## 📝 License

This project is part of the Udacity Cloud Developer Nanodegree program.

## 🎉 Good Luck!

You're now ready to deploy your static website to AWS! Follow the guides carefully, take good screenshots, and don't forget to cleanup after your project is reviewed.

**Happy Deploying! 🚀**

