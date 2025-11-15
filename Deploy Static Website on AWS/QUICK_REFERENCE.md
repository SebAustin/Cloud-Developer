# Quick Reference Card

## 🚀 Essential Commands

```bash
# Setup (run once)
./setup.sh

# Deploy to AWS
./deploy.sh

# Check CloudFront status
aws cloudfront get-distribution --id <DISTRIBUTION_ID> --query 'Distribution.Status'

# Cleanup (after project review)
./cleanup.sh
```

## 📝 File Reference

| File | Purpose |
|------|---------|
| `deploy.sh` | Deploys website to AWS |
| `cleanup.sh` | Removes all AWS resources |
| `setup.sh` | Validates prerequisites |
| `DEPLOYMENT_GUIDE.md` | Complete deployment instructions |
| `SCREENSHOT_GUIDE.md` | Screenshot requirements |
| `README.txt` | Submission README (fill in your URLs) |
| `env.example` | Configuration template |

## 🔗 Your URLs

After running `deploy.sh`, find your URLs in `deployment-info.txt`:

```
S3 Website Endpoint: http://[bucket].s3-website-[region].amazonaws.com
CloudFront Domain: https://[distribution-id].cloudfront.net
```

## ⏱️ Deployment Timeline

- **0 min**: Run `./deploy.sh`
- **2-5 min**: S3 deployment complete, S3 URL accessible
- **15-20 min**: CloudFront deployed, CloudFront URL accessible

## 📸 Screenshot Checklist

- [ ] 1. S3 bucket in AWS Console
- [ ] 2. Files uploaded to S3
- [ ] 3. S3 static hosting config
- [ ] 4. S3 bucket policy
- [ ] 5. CloudFront distribution
- [ ] 6. Website in browser (S3 URL)
- [ ] 7. Website in browser (CloudFront URL)

## ⚠️ Common Issues

| Problem | Solution |
|---------|----------|
| "AWS CLI not found" | Install: `brew install awscli` |
| "Credentials not configured" | Run: `aws configure` |
| "403 Forbidden" | Check bucket policy applied |
| "CloudFront not ready" | Wait 15-20 minutes |

## 🔧 Useful AWS CLI Commands

```bash
# List S3 buckets
aws s3 ls

# List files in bucket
aws s3 ls s3://YOUR-BUCKET-NAME/

# Check CloudFront distributions
aws cloudfront list-distributions

# Get caller identity (verify credentials)
aws sts get-caller-identity

# Copy file to S3
aws s3 cp file.html s3://YOUR-BUCKET-NAME/
```

## 💰 Cost Reminder

**Always cleanup after project review:**
```bash
./cleanup.sh
```

## 📚 Documentation

- Detailed Instructions: `DEPLOYMENT_GUIDE.md`
- Screenshot Guide: `SCREENSHOT_GUIDE.md`
- Project Overview: `PROJECT_README.md`

## ✅ Submission Steps

1. Deploy: `./deploy.sh`
2. Wait for CloudFront (15-20 min)
3. Test both URLs in browser
4. Take all screenshots
5. Fill URLs in `README.txt`
6. Create submission folder
7. Zip and submit to Udacity
8. After passing: `./cleanup.sh`

## 🎯 Project Success Criteria

✅ S3 bucket created  
✅ Files uploaded  
✅ Static hosting enabled  
✅ Public access configured  
✅ CloudFront distribution created  
✅ Both URLs accessible  
✅ Screenshots taken  
✅ README.txt completed  

---

**Need help?** See `DEPLOYMENT_GUIDE.md` for detailed troubleshooting.

