#!/bin/bash

# Setup Script - Prepares the project for deployment
# Run this once before deploying

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}=========================================="
echo -e "  AWS Static Website - Setup Script"
echo -e "==========================================${NC}"
echo ""

# Step 1: Make scripts executable
echo -e "${BLUE}Step 1: Making scripts executable...${NC}"
chmod +x deploy.sh cleanup.sh
echo -e "${GREEN}✓ Scripts are now executable${NC}"
echo ""

# Step 2: Check AWS CLI
echo -e "${BLUE}Step 2: Checking AWS CLI installation...${NC}"
if command -v aws &> /dev/null; then
    AWS_VERSION=$(aws --version)
    echo -e "${GREEN}✓ AWS CLI is installed: $AWS_VERSION${NC}"
else
    echo -e "${YELLOW}⚠ AWS CLI is not installed${NC}"
    echo "Please install AWS CLI from: https://aws.amazon.com/cli/"
    echo ""
    echo "macOS: brew install awscli"
    echo "Linux: Download from AWS website"
    echo "Windows: Download installer from AWS website"
    exit 1
fi
echo ""

# Step 3: Check AWS credentials
echo -e "${BLUE}Step 3: Checking AWS credentials...${NC}"
if aws sts get-caller-identity &> /dev/null; then
    ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
    USER_ARN=$(aws sts get-caller-identity --query Arn --output text)
    echo -e "${GREEN}✓ AWS credentials are configured${NC}"
    echo "  Account ID: $ACCOUNT_ID"
    echo "  User: $USER_ARN"
else
    echo -e "${YELLOW}⚠ AWS credentials are not configured${NC}"
    echo ""
    echo "Please run: aws configure"
    echo ""
    echo "You will need:"
    echo "  - AWS Access Key ID"
    echo "  - AWS Secret Access Key"
    echo "  - Default region (e.g., us-east-1)"
    echo "  - Default output format (json)"
    exit 1
fi
echo ""

# Step 4: Verify website files
echo -e "${BLUE}Step 4: Checking website files...${NC}"
if [ -d "udacity-starter-website" ]; then
    if [ -f "udacity-starter-website/index.html" ]; then
        echo -e "${GREEN}✓ Website files found${NC}"
        FILE_COUNT=$(find udacity-starter-website -type f | wc -l | tr -d ' ')
        echo "  Files to upload: $FILE_COUNT"
    else
        echo -e "${YELLOW}⚠ index.html not found in udacity-starter-website/${NC}"
        exit 1
    fi
else
    echo -e "${YELLOW}⚠ udacity-starter-website directory not found${NC}"
    exit 1
fi
echo ""

# Step 5: Check for configuration file
echo -e "${BLUE}Step 5: Checking configuration...${NC}"
if [ -f ".env" ]; then
    echo -e "${GREEN}✓ Configuration file (.env) found${NC}"
    echo "  Using custom configuration"
else
    echo -e "${YELLOW}ℹ No custom configuration found${NC}"
    echo "  Using default settings (us-east-1 region)"
    echo ""
    echo "  To customize, run: cp env.example .env"
    echo "  Then edit .env with your preferences"
fi
echo ""

# Step 6: Summary
echo -e "${GREEN}=========================================="
echo -e "  SETUP COMPLETE!"
echo -e "==========================================${NC}"
echo ""
echo -e "${BLUE}Next Steps:${NC}"
echo "1. (Optional) Customize configuration:"
echo "   cp env.example .env"
echo "   nano .env"
echo ""
echo "2. Deploy your website:"
echo "   ./deploy.sh"
echo ""
echo "3. Wait 15-20 minutes for CloudFront deployment"
echo ""
echo "4. Take screenshots (see SCREENSHOT_GUIDE.md)"
echo ""
echo "5. Update README.txt with your URLs"
echo ""
echo "6. After project review, cleanup:"
echo "   ./cleanup.sh"
echo ""
echo -e "${YELLOW}For detailed instructions, see DEPLOYMENT_GUIDE.md${NC}"
echo ""

