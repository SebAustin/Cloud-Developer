===============================================
UDACITY CLOUD DEVELOPER NANODEGREE
Project: Deploy Static Website on AWS
===============================================

Student Name: [YOUR NAME HERE]
Submission Date: November 14, 2025

===============================================
PROJECT URLS
===============================================

S3 Website Endpoint:
http://udacity-static-website-sh-20251114-113344.s3-website-us-west-2.amazonaws.com

CloudFront Domain Name:
https://d1bh82ajnlmq2r.cloudfront.net

Note: Both URLs display the same static website. The CloudFront URL provides HTTPS and global content delivery.

===============================================
PROJECT OVERVIEW
===============================================

This project demonstrates the deployment of a static website to AWS using:

1. Amazon S3 - For storage and static website hosting
2. Amazon CloudFront - For content delivery network (CDN) distribution
3. IAM Policies - For public access configuration

===============================================
DEPLOYMENT DETAILS
===============================================

AWS Services Used:
- Amazon S3 (Simple Storage Service)
- Amazon CloudFront
- IAM (Identity and Access Management)

S3 Bucket Configuration:
- Static website hosting: Enabled
- Index document: index.html
- Public access: Enabled via bucket policy
- Bucket policy: Applied to allow public read access to all objects

CloudFront Configuration:
- Origin: S3 static website endpoint
- Viewer protocol policy: Redirect to HTTPS
- Caching: Enabled with default TTL settings
- Compression: Enabled

===============================================
DEPLOYMENT PROCESS
===============================================

The deployment was automated using AWS CLI scripts:

1. Created S3 bucket with unique name
2. Configured bucket for static website hosting
3. Applied IAM bucket policy for public access
4. Uploaded all website files (HTML, CSS, JS, images)
5. Created CloudFront distribution
6. Verified website accessibility via both endpoints

===============================================
INCLUDED FILES
===============================================

This submission includes the following screenshots:

1. S3 bucket created in AWS Management Console
2. All website files uploaded to S3 bucket
3. S3 bucket static website hosting configuration
4. S3 bucket IAM policy showing public access
5. CloudFront distribution configuration
6. Website accessible in browser:
   - Via S3 website endpoint
   - Via CloudFront domain

===============================================
VERIFICATION
===============================================

To verify the deployment:

1. Visit the S3 Website Endpoint URL (above)
   - Should load the Travel Blog website via HTTP
   
2. Visit the CloudFront Domain URL (above)
   - Should load the same website via HTTPS
   - May take 15-20 minutes after deployment for full propagation

Both URLs should display the same static website content.

===============================================
CUSTOMIZATIONS (OPTIONAL)
===============================================

[IF YOU CUSTOMIZED THE WEBSITE, DESCRIBE YOUR CHANGES HERE]

Stand out suggestions implemented:
- [ ] Customized website text (e.g., changed "Travel Blog" to personal name)
- [ ] Changed background image to personal photo
- [ ] Other customizations: [DESCRIBE HERE]

[IF YOU DID NOT CUSTOMIZE, YOU CAN DELETE THIS SECTION]

===============================================
ADDITIONAL NOTES
===============================================

Technical Details:
- AWS Region: us-west-2
- Deployment Date: November 14, 2025
- Deployment Method: Automated via AWS CLI scripts

Security Considerations:
- S3 bucket is publicly accessible (required for static website hosting)
- CloudFront uses HTTPS for secure content delivery
- No server-side processing or sensitive data

Cost Considerations:
- Resources were deployed for project demonstration
- All resources will be deleted after project review to avoid ongoing charges

===============================================
PROJECT REQUIREMENTS CHECKLIST
===============================================

✓ Created a public S3 bucket
✓ Uploaded all website files to S3
✓ Configured bucket for static website hosting
✓ Applied IAM bucket policy for public access
✓ Created CloudFront distribution
✓ Website accessible via S3 endpoint
✓ Website accessible via CloudFront domain
✓ Included all required screenshots
✓ Provided both URLs in this README

===============================================
REVIEWER NOTES
===============================================

Dear Reviewer,

Thank you for reviewing my project submission. 

Please note:
- Both URLs should be fully functional and display the complete website
- CloudFront URL uses HTTPS (secure connection)
- S3 endpoint URL uses HTTP
- All required screenshots are included in this submission
- Screenshots show my actual AWS account resources

If you encounter any issues accessing the URLs, please let me know and I will investigate.

===============================================
CONTACT INFORMATION
===============================================

If you have any questions about this submission, please reach out through the Udacity platform.

===============================================
REFERENCES
===============================================

AWS Documentation:
- S3 Static Website Hosting: https://docs.aws.amazon.com/AmazonS3/latest/dev/WebsiteHosting.html
- CloudFront Documentation: https://docs.aws.amazon.com/cloudfront/
- AWS CLI Reference: https://docs.aws.amazon.com/cli/

Project Resources:
- Udacity Course Materials
- AWS Free Tier: https://aws.amazon.com/free/

===============================================
END OF README
===============================================

