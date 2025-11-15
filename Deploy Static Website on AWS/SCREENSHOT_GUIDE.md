# Screenshot Guide for Project Submission

This guide provides detailed instructions for taking all required screenshots for your Udacity "Deploy Static Website on AWS" project submission.

## Table of Contents

1. [Overview](#overview)
2. [Required Screenshots](#required-screenshots)
3. [Screenshot Guidelines](#screenshot-guidelines)
4. [Detailed Instructions for Each Screenshot](#detailed-instructions-for-each-screenshot)
5. [Organizing Your Submission](#organizing-your-submission)
6. [Screenshot Checklist](#screenshot-checklist)

## Overview

According to the project rubric, you need to submit screenshots demonstrating:
- ✅ S3 bucket creation
- ✅ Website files uploaded to S3
- ✅ S3 bucket static website hosting configuration
- ✅ S3 bucket IAM policy for public access
- ✅ CloudFront distribution configuration
- ✅ Website accessible in browser

This guide will walk you through capturing each required screenshot.

## Required Screenshots

You need to capture **6 screenshots** total:

1. **Screenshot 1:** S3 bucket in AWS Management Console
2. **Screenshot 2:** All website files uploaded to S3 bucket
3. **Screenshot 3:** S3 bucket static website hosting configuration
4. **Screenshot 4:** S3 bucket IAM policy showing public access
5. **Screenshot 5:** CloudFront distribution configuration
6. **Screenshot 6:** Website accessible in web browser (both URLs)

## Screenshot Guidelines

### General Best Practices

- **Use full-screen or windowed mode** - Make sure the entire browser window is visible
- **Include AWS Console navigation** - Show the AWS service name and navigation breadcrumbs
- **Ensure text is readable** - Don't make the window too small
- **Show your AWS account ID** - This proves you deployed the resources
- **Include URLs in browser screenshots** - Make sure the address bar is visible
- **Use PNG or JPG format** - Both are acceptable
- **Clear naming** - Name files descriptively (e.g., `1-s3-bucket-created.png`)

### What to Avoid

- ❌ Don't crop out important information (account ID, region, resource names)
- ❌ Don't include sensitive information (AWS access keys, passwords)
- ❌ Don't use low-resolution or blurry images
- ❌ Don't submit screenshots from practice/tutorial accounts

### Taking Screenshots

**macOS:**
- Full screen: `Command (⌘) + Shift + 3`
- Selected area: `Command (⌘) + Shift + 4`
- Window: `Command (⌘) + Shift + 4`, then press `Space`

**Windows:**
- Full screen: `Windows + PrtScn`
- Selected area: `Windows + Shift + S`
- Window: `Alt + PrtScn`

**Linux:**
- Use Screenshot tool or `gnome-screenshot`

## Detailed Instructions for Each Screenshot

### Screenshot 1: S3 Bucket Created

**What to show:** The S3 bucket visible in AWS Management Console

**Steps:**

1. Log into AWS Management Console: https://console.aws.amazon.com/
2. Navigate to S3 service:
   - Click "Services" in top navigation
   - Select "S3" under "Storage"
   - Or go directly to: https://s3.console.aws.amazon.com/
3. In the S3 buckets list, locate your bucket (name from `deployment-info.txt`)
4. **Take screenshot showing:**
   - The S3 service page title
   - Your bucket name in the list
   - Creation date
   - AWS region
   - Optionally: Your AWS account info in top-right corner

**Example view:**
```
S3 > Buckets
[Your bucket: udacity-static-website-20241113-120000]
Region: US East (N. Virginia) us-east-1
```

**Save as:** `1-s3-bucket-created.png`

---

### Screenshot 2: Website Files Uploaded

**What to show:** All website files in the S3 bucket

**Steps:**

1. In S3 console, click on your bucket name
2. You should see all the uploaded files and folders:
   - `index.html`
   - `css/` folder
   - `img/` folder
   - `vendor/` folder
3. **Take screenshot showing:**
   - Bucket name in breadcrumb navigation
   - All top-level files and folders
   - File sizes and upload dates
   - The "Objects" tab selected

**Optional:** Take additional screenshots showing contents of subdirectories:
- Click into `css/` folder and screenshot
- Click into `img/` folder and screenshot
- Click into `vendor/` folder and screenshot

**Save as:** `2-s3-files-uploaded.png`

**Additional screenshots (optional):**
- `2a-s3-css-folder.png`
- `2b-s3-img-folder.png`
- `2c-s3-vendor-folder.png`

---

### Screenshot 3: Static Website Hosting Configuration

**What to show:** S3 bucket configured for static website hosting

**Steps:**

1. In your S3 bucket, click the "Properties" tab
2. Scroll down to "Static website hosting" section
3. You should see:
   - Status: **Enabled** (with blue badge)
   - Hosting type: Static website hosting
   - Index document: `index.html`
   - Bucket website endpoint: `http://[bucket-name].s3-website-[region].amazonaws.com`
4. **Take screenshot showing:**
   - "Properties" tab selected
   - "Static website hosting" section expanded
   - Enabled status
   - Index document configuration
   - Bucket website endpoint URL

**Save as:** `3-s3-static-hosting-config.png`

---

### Screenshot 4: Bucket Policy - Public Access

**What to show:** IAM bucket policy that makes contents publicly accessible

**Steps:**

1. In your S3 bucket, click the "Permissions" tab
2. Scroll to "Bucket policy" section
3. You should see the JSON policy allowing public read access:

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::your-bucket-name/*"
        }
    ]
}
```

4. **Take screenshot showing:**
   - "Permissions" tab selected
   - "Bucket policy" section
   - The complete JSON policy (all lines visible)
   - Your actual bucket name in the Resource ARN

**Alternative/Additional:** Also screenshot the "Block public access" settings showing they are disabled:
- All four settings should show "Off"

**Save as:** `4-s3-bucket-policy.png`

**Optional additional:** `4a-s3-public-access-settings.png`

---

### Screenshot 5: CloudFront Distribution

**What to show:** CloudFront distribution created and configured

**Steps:**

1. Navigate to CloudFront service:
   - Click "Services"
   - Select "CloudFront" under "Networking & Content Delivery"
   - Or go to: https://console.aws.amazon.com/cloudfront/
2. You should see your distribution in the list
3. Click on the Distribution ID to view details
4. **Take screenshot showing:**
   - Distribution list page with your distribution
   - Distribution ID
   - Domain name (e.g., `d1234567890abc.cloudfront.net`)
   - Status: "Deployed"
   - Origin (your S3 bucket endpoint)
   - State: "Enabled"

**Additional screenshot (recommended):**
- Click on your distribution
- Go to "Origins" tab
- Screenshot showing S3 website endpoint as the origin

**Save as:** `5-cloudfront-distribution.png`

**Optional additional:** `5a-cloudfront-origin-config.png`

---

### Screenshot 6: Website in Browser

**What to show:** The website accessible via both S3 and CloudFront endpoints

**You need TWO screenshots here:**

#### Screenshot 6A: S3 Website Endpoint

**Steps:**

1. Open your web browser (Chrome, Firefox, Safari, etc.)
2. Navigate to your S3 website endpoint URL (from `deployment-info.txt`):
   - Format: `http://[bucket-name].s3-website-[region].amazonaws.com`
3. Wait for the page to fully load
4. **Take screenshot showing:**
   - Full browser window
   - Address bar with complete S3 website endpoint URL visible
   - Website content fully loaded (the Travel Blog homepage)
   - No error messages

**Save as:** `6a-website-s3-endpoint.png`

#### Screenshot 6B: CloudFront Domain

**Steps:**

1. In the same browser, navigate to your CloudFront domain URL:
   - Format: `https://[distribution-id].cloudfront.net`
2. Wait for the page to fully load
3. **Take screenshot showing:**
   - Full browser window
   - Address bar with complete CloudFront URL visible
   - HTTPS padlock icon in address bar (showing secure connection)
   - Website content fully loaded (same Travel Blog homepage)
   - No error messages

**Save as:** `6b-website-cloudfront-domain.png`

**Tips:**
- Make sure both URLs show the exact same website content
- The CloudFront URL should show HTTPS (secure)
- The S3 endpoint URL will show HTTP (not secure) - this is expected

---

## Organizing Your Submission

### Create a Submission Folder

1. Create a new folder named `submission/` or `project-submission/`
2. Place all screenshots in this folder
3. Add your `README.txt` file to this folder
4. Zip the entire folder

### Recommended Folder Structure

```
project-submission/
├── 1-s3-bucket-created.png
├── 2-s3-files-uploaded.png
├── 3-s3-static-hosting-config.png
├── 4-s3-bucket-policy.png
├── 5-cloudfront-distribution.png
├── 6a-website-s3-endpoint.png
├── 6b-website-cloudfront-domain.png
└── README.txt
```

### Creating the Zip File

**macOS/Linux:**
```bash
zip -r project-submission.zip project-submission/
```

**Windows:**
- Right-click the folder
- Select "Send to" > "Compressed (zipped) folder"

## Screenshot Checklist

Before submitting, verify you have:

### Required Screenshots (6 minimum)

- [ ] **Screenshot 1:** S3 bucket in AWS Console
  - [ ] Bucket name visible
  - [ ] Creation date visible
  - [ ] AWS region shown

- [ ] **Screenshot 2:** All website files uploaded
  - [ ] `index.html` visible
  - [ ] `css/` folder visible
  - [ ] `img/` folder visible
  - [ ] `vendor/` folder visible

- [ ] **Screenshot 3:** Static website hosting configuration
  - [ ] "Enabled" status visible
  - [ ] Index document: `index.html`
  - [ ] Bucket website endpoint URL visible

- [ ] **Screenshot 4:** Bucket policy for public access
  - [ ] Complete JSON policy visible
  - [ ] Shows "Principal": "*"
  - [ ] Shows "Action": "s3:GetObject"
  - [ ] Your bucket name in Resource ARN

- [ ] **Screenshot 5:** CloudFront distribution
  - [ ] Distribution ID visible
  - [ ] CloudFront domain name visible
  - [ ] Status: "Deployed"
  - [ ] Origin shows S3 bucket

- [ ] **Screenshot 6A:** Website via S3 endpoint
  - [ ] Full URL in address bar
  - [ ] Website fully loaded
  - [ ] No error messages

- [ ] **Screenshot 6B:** Website via CloudFront
  - [ ] Full CloudFront URL in address bar
  - [ ] HTTPS padlock visible
  - [ ] Website fully loaded
  - [ ] No error messages

### Quality Checks

- [ ] All images are clear and readable
- [ ] No sensitive information exposed (access keys, passwords)
- [ ] File names are descriptive and organized
- [ ] All screenshots are recent (match your current deployment)
- [ ] README.txt includes both URLs
- [ ] All files are in a single folder ready to zip

## Common Screenshot Mistakes to Avoid

1. **Missing URL in browser screenshots**
   - Always show the full address bar

2. **CloudFront not fully deployed**
   - Wait for status to show "Deployed" before taking screenshots

3. **Partial bucket policy**
   - Make sure the entire JSON policy is visible

4. **Wrong bucket shown**
   - Verify you're screenshotting YOUR bucket, not an example

5. **Inconsistent bucket names**
   - Make sure all screenshots show the same bucket name

6. **Website not loading**
   - Test both URLs before taking screenshots
   - If not working, troubleshoot before screenshotting

7. **Too much cropping**
   - Include AWS navigation and context

## Additional Tips

### Custom Branding (Stand Out Suggestions)

If you customized your website per the "Stand Out" suggestions:

1. Take an additional screenshot showing your customizations:
   - Changed title (e.g., "John's Travel Blog")
   - Your custom background image

2. Add a note in README.txt explaining your customizations

### Timing Your Screenshots

**Best practice workflow:**

1. Run `./deploy.sh`
2. While CloudFront is deploying (15-20 minutes):
   - Take screenshots 1-4 (S3 related)
3. Check CloudFront status:
   ```bash
   aws cloudfront get-distribution --id <DISTRIBUTION_ID> --query 'Distribution.Status'
   ```
4. Once status is "Deployed":
   - Take screenshot 5 (CloudFront distribution)
   - Test both URLs in browser
   - Take screenshots 6A and 6B

### Re-taking Screenshots

If you need to retake a screenshot:
- The resources are still deployed, so you can go back anytime
- Just navigate back to the relevant AWS console page
- Make sure nothing has changed (bucket is still there, CloudFront still enabled)

## Need Help?

If you're having trouble with screenshots:

1. Check that your deployment completed successfully
2. Verify resources exist in AWS Console
3. Review the DEPLOYMENT_GUIDE.md for troubleshooting
4. Make sure you're logged into the correct AWS account

## Summary

Taking good screenshots is crucial for your project submission. Follow this guide carefully to ensure you capture all required evidence of your AWS deployment. Good luck with your project!

**Remember:** After your project is reviewed and you receive a passing grade, run `./cleanup.sh` to delete all AWS resources and avoid charges!

