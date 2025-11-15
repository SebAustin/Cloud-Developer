#!/bin/bash

# Cleanup Script for AWS Static Website Deployment
# This script removes all AWS resources created by deploy.sh

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
print_message "$BLUE" "  AWS Static Website Cleanup Script"
print_message "$BLUE" "=========================================="
echo ""

# Check if deployment-info.txt exists
if [ ! -f "deployment-info.txt" ]; then
    print_message "$RED" "Error: deployment-info.txt not found."
    print_message "$YELLOW" "This file is created by deploy.sh and contains deployment information."
    echo ""
    print_message "$YELLOW" "If you want to clean up manually, you need to provide:"
    echo "  1. S3 Bucket Name"
    echo "  2. CloudFront Distribution ID"
    echo ""
    read -p "Do you want to enter these values manually? (y/n): " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        read -p "Enter S3 Bucket Name: " BUCKET_NAME
        read -p "Enter CloudFront Distribution ID: " DISTRIBUTION_ID
    else
        exit 1
    fi
else
    # Parse deployment information
    print_message "$GREEN" "Reading deployment information..."
    BUCKET_NAME=$(grep "S3 Bucket Name:" deployment-info.txt | cut -d' ' -f4)
    DISTRIBUTION_ID=$(grep "CloudFront Distribution ID:" deployment-info.txt | cut -d' ' -f4)
fi

# Validate AWS CLI is installed
if ! command -v aws &> /dev/null; then
    print_message "$RED" "Error: AWS CLI is not installed."
    exit 1
fi

# Validate AWS credentials are configured
if ! aws sts get-caller-identity &> /dev/null; then
    print_message "$RED" "Error: AWS credentials are not configured."
    print_message "$YELLOW" "Please run: aws configure"
    exit 1
fi

# Display what will be deleted
print_message "$YELLOW" "The following resources will be deleted:"
echo "  S3 Bucket: $BUCKET_NAME"
echo "  CloudFront Distribution: $DISTRIBUTION_ID"
echo ""
print_message "$RED" "WARNING: This action cannot be undone!"
echo ""
read -p "Are you sure you want to continue? (yes/no): " -r
echo ""
if [[ ! $REPLY = "yes" ]]; then
    print_message "$YELLOW" "Cleanup cancelled."
    exit 0
fi

# Step 1: Disable CloudFront distribution
print_message "$BLUE" "Step 1: Disabling CloudFront distribution..."

# Get current distribution config
ETAG=$(aws cloudfront get-distribution-config --id "$DISTRIBUTION_ID" --query 'ETag' --output text)
aws cloudfront get-distribution-config --id "$DISTRIBUTION_ID" --query 'DistributionConfig' > /tmp/cf-config.json

# Modify the config to disable the distribution
jq '.Enabled = false' /tmp/cf-config.json > /tmp/cf-config-disabled.json

# Update the distribution
aws cloudfront update-distribution \
    --id "$DISTRIBUTION_ID" \
    --distribution-config file:///tmp/cf-config-disabled.json \
    --if-match "$ETAG" > /dev/null

rm /tmp/cf-config.json /tmp/cf-config-disabled.json

print_message "$GREEN" "✓ CloudFront distribution disabled"
print_message "$YELLOW" "Waiting for distribution to be fully disabled (this may take several minutes)..."

# Wait for distribution to be deployed (disabled state)
aws cloudfront wait distribution-deployed --id "$DISTRIBUTION_ID"

print_message "$GREEN" "✓ CloudFront distribution is now disabled"
echo ""

# Step 2: Delete CloudFront distribution
print_message "$BLUE" "Step 2: Deleting CloudFront distribution..."

# Get new ETag after the distribution is disabled
ETAG=$(aws cloudfront get-distribution --id "$DISTRIBUTION_ID" --query 'ETag' --output text)

# Delete the distribution
aws cloudfront delete-distribution \
    --id "$DISTRIBUTION_ID" \
    --if-match "$ETAG"

print_message "$GREEN" "✓ CloudFront distribution deleted"
echo ""

# Step 3: Empty S3 bucket
print_message "$BLUE" "Step 3: Emptying S3 bucket..."

# Delete all objects and versions
aws s3 rm "s3://$BUCKET_NAME" --recursive

print_message "$GREEN" "✓ S3 bucket emptied"
echo ""

# Step 4: Delete S3 bucket
print_message "$BLUE" "Step 4: Deleting S3 bucket..."

aws s3api delete-bucket \
    --bucket "$BUCKET_NAME"

print_message "$GREEN" "✓ S3 bucket deleted"
echo ""

# Step 5: Archive deployment information
print_message "$BLUE" "Step 5: Archiving deployment information..."

if [ -f "deployment-info.txt" ]; then
    ARCHIVE_NAME="deployment-info-archived-$(date +%Y%m%d-%H%M%S).txt"
    mv deployment-info.txt "$ARCHIVE_NAME"
    print_message "$GREEN" "✓ Deployment info archived as: $ARCHIVE_NAME"
fi

echo ""
print_message "$GREEN" "=========================================="
print_message "$GREEN" "  CLEANUP COMPLETED SUCCESSFULLY!"
print_message "$GREEN" "=========================================="
echo ""
print_message "$GREEN" "All AWS resources have been deleted:"
echo "  ✓ CloudFront distribution removed"
echo "  ✓ S3 bucket and all contents deleted"
echo ""
print_message "$BLUE" "You will no longer be charged for these resources."
echo ""
print_message "$YELLOW" "Note: If you need to redeploy, run ./deploy.sh again."

