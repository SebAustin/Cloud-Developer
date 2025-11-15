#!/bin/bash

# Deploy Static Website on AWS - Automated Deployment Script
# This script creates an S3 bucket, uploads website files, and sets up CloudFront distribution

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored messages
print_message() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
}

print_message "$BLUE" "=========================================="
print_message "$BLUE" "  AWS Static Website Deployment Script"
print_message "$BLUE" "=========================================="
echo ""

# Load configuration from .env file if it exists
if [ -f .env ]; then
    print_message "$GREEN" "Loading configuration from .env file..."
    export $(cat .env | grep -v '^#' | xargs)
fi

# Configuration with defaults
AWS_REGION=${AWS_REGION:-us-east-1}
BUCKET_PREFIX=${BUCKET_PREFIX:-udacity-static-website}
WEBSITE_DIR="udacity-starter-website"

# Generate unique bucket name with timestamp
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
BUCKET_NAME="${BUCKET_PREFIX}-${TIMESTAMP}"

# Validate AWS CLI is installed
if ! command -v aws &> /dev/null; then
    print_message "$RED" "Error: AWS CLI is not installed."
    print_message "$YELLOW" "Please install AWS CLI: https://aws.amazon.com/cli/"
    exit 1
fi

# Validate AWS credentials are configured
if ! aws sts get-caller-identity &> /dev/null; then
    print_message "$RED" "Error: AWS credentials are not configured."
    print_message "$YELLOW" "Please run: aws configure"
    exit 1
fi

# Validate website directory exists
if [ ! -d "$WEBSITE_DIR" ]; then
    print_message "$RED" "Error: Website directory '$WEBSITE_DIR' not found."
    exit 1
fi

print_message "$GREEN" "Configuration:"
echo "  AWS Region: $AWS_REGION"
echo "  Bucket Name: $BUCKET_NAME"
echo "  Website Directory: $WEBSITE_DIR"
echo ""

# Step 1: Create S3 Bucket
print_message "$BLUE" "Step 1: Creating S3 bucket..."
if [ "$AWS_REGION" = "us-east-1" ]; then
    aws s3api create-bucket \
        --bucket "$BUCKET_NAME" \
        --region "$AWS_REGION"
else
    aws s3api create-bucket \
        --bucket "$BUCKET_NAME" \
        --region "$AWS_REGION" \
        --create-bucket-configuration LocationConstraint="$AWS_REGION"
fi
print_message "$GREEN" "✓ S3 bucket created: $BUCKET_NAME"
echo ""

# Step 2: Configure bucket for static website hosting
print_message "$BLUE" "Step 2: Configuring bucket for static website hosting..."
aws s3 website "s3://$BUCKET_NAME" \
    --index-document index.html \
    --error-document index.html
print_message "$GREEN" "✓ Static website hosting enabled"
echo ""

# Step 3: Create and apply bucket policy for public access
print_message "$BLUE" "Step 3: Applying IAM bucket policy for public access..."

# First, disable block public access settings
aws s3api put-public-access-block \
    --bucket "$BUCKET_NAME" \
    --public-access-block-configuration \
    "BlockPublicAcls=false,IgnorePublicAcls=false,BlockPublicPolicy=false,RestrictPublicBuckets=false"

# Create bucket policy
BUCKET_POLICY=$(cat <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::${BUCKET_NAME}/*"
        }
    ]
}
EOF
)

# Apply bucket policy
echo "$BUCKET_POLICY" > /tmp/bucket-policy.json
aws s3api put-bucket-policy \
    --bucket "$BUCKET_NAME" \
    --policy file:///tmp/bucket-policy.json
rm /tmp/bucket-policy.json

print_message "$GREEN" "✓ Bucket policy applied (public read access)"
echo ""

# Step 4: Upload website files
print_message "$BLUE" "Step 4: Uploading website files to S3..."
aws s3 sync "$WEBSITE_DIR/" "s3://$BUCKET_NAME/" \
    --exclude ".DS_Store" \
    --exclude "*.md" \
    --delete

print_message "$GREEN" "✓ Website files uploaded"
echo ""

# Step 5: Create CloudFront distribution
print_message "$BLUE" "Step 5: Creating CloudFront distribution..."

# Get the S3 website endpoint
S3_WEBSITE_ENDPOINT="${BUCKET_NAME}.s3-website-${AWS_REGION}.amazonaws.com"

# Create CloudFront distribution configuration
CLOUDFRONT_CONFIG=$(cat <<EOF
{
    "CallerReference": "${BUCKET_NAME}-$(date +%s)",
    "Comment": "CloudFront distribution for ${BUCKET_NAME}",
    "Enabled": true,
    "DefaultRootObject": "index.html",
    "Origins": {
        "Quantity": 1,
        "Items": [
            {
                "Id": "${BUCKET_NAME}-origin",
                "DomainName": "${S3_WEBSITE_ENDPOINT}",
                "CustomOriginConfig": {
                    "HTTPPort": 80,
                    "HTTPSPort": 443,
                    "OriginProtocolPolicy": "http-only"
                }
            }
        ]
    },
    "DefaultCacheBehavior": {
        "TargetOriginId": "${BUCKET_NAME}-origin",
        "ViewerProtocolPolicy": "redirect-to-https",
        "AllowedMethods": {
            "Quantity": 2,
            "Items": ["GET", "HEAD"],
            "CachedMethods": {
                "Quantity": 2,
                "Items": ["GET", "HEAD"]
            }
        },
        "ForwardedValues": {
            "QueryString": false,
            "Cookies": {
                "Forward": "none"
            }
        },
        "MinTTL": 0,
        "DefaultTTL": 86400,
        "MaxTTL": 31536000,
        "Compress": true
    }
}
EOF
)

# Create the distribution
echo "$CLOUDFRONT_CONFIG" > /tmp/cloudfront-config.json
DISTRIBUTION_OUTPUT=$(aws cloudfront create-distribution \
    --distribution-config file:///tmp/cloudfront-config.json \
    --output json)
rm /tmp/cloudfront-config.json

DISTRIBUTION_ID=$(echo "$DISTRIBUTION_OUTPUT" | grep -o '"Id": "[^"]*"' | head -1 | sed 's/"Id": "\(.*\)"/\1/')
CLOUDFRONT_DOMAIN=$(echo "$DISTRIBUTION_OUTPUT" | grep -o '"DomainName": "[^"]*"' | head -1 | sed 's/"DomainName": "\(.*\)"/\1/')

print_message "$GREEN" "✓ CloudFront distribution created"
echo "  Distribution ID: $DISTRIBUTION_ID"
echo "  CloudFront Domain: $CLOUDFRONT_DOMAIN"
echo ""

# Save deployment information
print_message "$BLUE" "Saving deployment information..."
cat > deployment-info.txt <<EOF
AWS Static Website Deployment Information
==========================================
Date: $(date)
AWS Region: $AWS_REGION
S3 Bucket Name: $BUCKET_NAME
S3 Website Endpoint: http://${S3_WEBSITE_ENDPOINT}
CloudFront Distribution ID: $DISTRIBUTION_ID
CloudFront Domain: https://${CLOUDFRONT_DOMAIN}

IMPORTANT URLS FOR PROJECT SUBMISSION:
--------------------------------------
S3 Website URL: http://${S3_WEBSITE_ENDPOINT}
CloudFront URL: https://${CLOUDFRONT_DOMAIN}

Note: CloudFront distribution deployment takes 15-20 minutes.
The website will be accessible at the CloudFront URL once deployment is complete.
EOF

print_message "$GREEN" "✓ Deployment information saved to deployment-info.txt"
echo ""

# Display final results
print_message "$GREEN" "=========================================="
print_message "$GREEN" "  DEPLOYMENT COMPLETED SUCCESSFULLY!"
print_message "$GREEN" "=========================================="
echo ""
print_message "$YELLOW" "Your website has been deployed!"
echo ""
echo "S3 Bucket: $BUCKET_NAME"
echo "S3 Website Endpoint: http://${S3_WEBSITE_ENDPOINT}"
echo ""
echo "CloudFront Distribution ID: $DISTRIBUTION_ID"
echo "CloudFront Domain: https://${CLOUDFRONT_DOMAIN}"
echo ""
print_message "$YELLOW" "IMPORTANT:"
echo "1. The S3 website endpoint should be accessible immediately."
echo "2. CloudFront distribution is being deployed (this takes 15-20 minutes)."
echo "3. Check CloudFront status with: aws cloudfront get-distribution --id $DISTRIBUTION_ID"
echo "4. Once CloudFront status is 'Deployed', visit: https://${CLOUDFRONT_DOMAIN}"
echo ""
print_message "$BLUE" "Next Steps:"
echo "1. Review SCREENSHOT_GUIDE.md for required screenshots"
echo "2. Update README.txt with your CloudFront URL"
echo "3. After project review, run ./cleanup.sh to delete resources"
echo ""
print_message "$GREEN" "Deployment details saved in: deployment-info.txt"

