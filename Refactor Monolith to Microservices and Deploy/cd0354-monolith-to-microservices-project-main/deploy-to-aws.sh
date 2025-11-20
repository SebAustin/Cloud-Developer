#!/bin/bash

################################################################################
# Udagram Microservices - AWS Deployment Script
# This script automates the deployment of Udagram to AWS
################################################################################

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
PROJECT_NAME="udagram"
AWS_REGION="us-east-1"
DB_INSTANCE_CLASS="db.t3.micro"
DB_ALLOCATED_STORAGE=20
DB_ENGINE_VERSION="15.10"
EKS_NODE_TYPE="t3.medium"
EKS_MIN_NODES=2
EKS_MAX_NODES=3

################################################################################
# Helper Functions
################################################################################

print_header() {
    echo ""
    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}========================================${NC}"
    echo ""
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ $1${NC}"
}

check_command() {
    if ! command -v $1 &> /dev/null; then
        print_error "$1 is not installed"
        return 1
    fi
    print_success "$1 is installed"
    return 0
}

################################################################################
# Step 0: Prerequisites Check
################################################################################

check_prerequisites() {
    print_header "Checking Prerequisites"
    
    local all_good=true
    
    check_command "aws" || all_good=false
    check_command "docker" || all_good=false
    check_command "kubectl" || all_good=false
    
    # Check AWS credentials
    if aws sts get-caller-identity &> /dev/null; then
        print_success "AWS credentials configured"
        print_info "AWS Account: $(aws sts get-caller-identity --query Account --output text)"
    else
        print_error "AWS credentials not configured"
        print_warning "Run: aws configure"
        all_good=false
    fi
    
    if [ "$all_good" = false ]; then
        print_error "Prerequisites check failed. Please install missing tools."
        exit 1
    fi
    
    print_success "All prerequisites met!"
}

################################################################################
# Step 1: Get User Input
################################################################################

get_user_input() {
    print_header "Configuration"
    
    echo "This script will create:"
    echo "  1. RDS PostgreSQL database"
    echo "  2. S3 bucket for images"
    echo "  3. EKS Kubernetes cluster (optional)"
    echo ""
    
    # Database credentials
    read -p "Enter database master username [udagramadmin]: " DB_USERNAME
    DB_USERNAME=${DB_USERNAME:-udagramadmin}
    
    read -sp "Enter database master password (min 8 chars): " DB_PASSWORD
    echo ""
    
    if [ ${#DB_PASSWORD} -lt 8 ]; then
        print_error "Password must be at least 8 characters"
        exit 1
    fi
    
    # S3 bucket name
    RANDOM_SUFFIX=$(date +%s | tail -c 6)
    read -p "Enter S3 bucket name [udagram-$USER-$RANDOM_SUFFIX]: " S3_BUCKET_NAME
    S3_BUCKET_NAME=${S3_BUCKET_NAME:-udagram-$USER-$RANDOM_SUFFIX}
    
    # EKS cluster
    read -p "Create EKS cluster? (y/n) [y]: " CREATE_EKS
    CREATE_EKS=${CREATE_EKS:-y}
    
    if [[ "$CREATE_EKS" =~ ^[Yy]$ ]]; then
        read -p "Enter EKS cluster name [udagram-cluster]: " EKS_CLUSTER_NAME
        EKS_CLUSTER_NAME=${EKS_CLUSTER_NAME:-udagram-cluster}
    fi
    
    # DockerHub credentials
    read -p "Enter DockerHub username: " DOCKERHUB_USERNAME
    
    # JWT Secret
    JWT_SECRET=$(openssl rand -base64 32)
    
    print_success "Configuration complete!"
    echo ""
    echo "Summary:"
    echo "  Database: $DB_USERNAME@${PROJECT_NAME}-db"
    echo "  S3 Bucket: $S3_BUCKET_NAME"
    echo "  Region: $AWS_REGION"
    if [[ "$CREATE_EKS" =~ ^[Yy]$ ]]; then
        echo "  EKS Cluster: $EKS_CLUSTER_NAME"
    fi
    echo ""
    
    read -p "Continue with deployment? (y/n): " CONFIRM
    if [[ ! "$CONFIRM" =~ ^[Yy]$ ]]; then
        print_warning "Deployment cancelled"
        exit 0
    fi
}

################################################################################
# Step 2: Create RDS PostgreSQL Database
################################################################################

create_rds_database() {
    print_header "Creating RDS PostgreSQL Database"
    
    # Check if database already exists
    if aws rds describe-db-instances --db-instance-identifier ${PROJECT_NAME}-db --region $AWS_REGION &> /dev/null; then
        print_warning "Database ${PROJECT_NAME}-db already exists"
        DB_ENDPOINT=$(aws rds describe-db-instances \
            --db-instance-identifier ${PROJECT_NAME}-db \
            --region $AWS_REGION \
            --query 'DBInstances[0].Endpoint.Address' \
            --output text)
        print_info "Database endpoint: $DB_ENDPOINT"
        return 0
    fi
    
    print_info "Creating RDS instance (this takes ~10-15 minutes)..."
    
    aws rds create-db-instance \
        --db-instance-identifier ${PROJECT_NAME}-db \
        --db-instance-class $DB_INSTANCE_CLASS \
        --engine postgres \
        --engine-version $DB_ENGINE_VERSION \
        --master-username $DB_USERNAME \
        --master-user-password "$DB_PASSWORD" \
        --allocated-storage $DB_ALLOCATED_STORAGE \
        --db-name postgres \
        --publicly-accessible \
        --region $AWS_REGION \
        --no-multi-az \
        --no-storage-encrypted \
        --backup-retention-period 0 \
        --tags Key=Project,Value=Udagram Key=Environment,Value=Development
    
    print_info "Waiting for database to become available..."
    aws rds wait db-instance-available \
        --db-instance-identifier ${PROJECT_NAME}-db \
        --region $AWS_REGION
    
    # Get database endpoint
    DB_ENDPOINT=$(aws rds describe-db-instances \
        --db-instance-identifier ${PROJECT_NAME}-db \
        --region $AWS_REGION \
        --query 'DBInstances[0].Endpoint.Address' \
        --output text)
    
    print_success "Database created successfully!"
    print_info "Database endpoint: $DB_ENDPOINT"
    
    # Configure security group
    print_info "Configuring security group..."
    
    DB_SECURITY_GROUP=$(aws rds describe-db-instances \
        --db-instance-identifier ${PROJECT_NAME}-db \
        --region $AWS_REGION \
        --query 'DBInstances[0].VpcSecurityGroups[0].VpcSecurityGroupId' \
        --output text)
    
    # Allow PostgreSQL access from anywhere (for development)
    aws ec2 authorize-security-group-ingress \
        --group-id $DB_SECURITY_GROUP \
        --protocol tcp \
        --port 5432 \
        --cidr 0.0.0.0/0 \
        --region $AWS_REGION 2>/dev/null || print_warning "Security group rule may already exist"
    
    print_success "Security group configured"
}

################################################################################
# Step 3: Create S3 Bucket
################################################################################

create_s3_bucket() {
    print_header "Creating S3 Bucket"
    
    # Check if bucket already exists
    if aws s3 ls s3://$S3_BUCKET_NAME 2>/dev/null; then
        print_warning "Bucket $S3_BUCKET_NAME already exists"
        return 0
    fi
    
    # Create bucket
    if [ "$AWS_REGION" = "us-east-1" ]; then
        aws s3api create-bucket \
            --bucket $S3_BUCKET_NAME \
            --region $AWS_REGION
    else
        aws s3api create-bucket \
            --bucket $S3_BUCKET_NAME \
            --region $AWS_REGION \
            --create-bucket-configuration LocationConstraint=$AWS_REGION
    fi
    
    print_success "S3 bucket created"
    
    # Disable block public access
    print_info "Configuring bucket for public access..."
    aws s3api put-public-access-block \
        --bucket $S3_BUCKET_NAME \
        --public-access-block-configuration \
        "BlockPublicAcls=false,IgnorePublicAcls=false,BlockPublicPolicy=false,RestrictPublicBuckets=false"
    
    # Add CORS configuration
    print_info "Adding CORS configuration..."
    cat > /tmp/cors.json << 'EOF'
[
    {
        "AllowedHeaders": ["*"],
        "AllowedMethods": ["GET", "PUT", "POST", "DELETE", "HEAD"],
        "AllowedOrigins": ["*"],
        "ExposeHeaders": ["ETag", "x-amz-server-side-encryption", "x-amz-request-id", "x-amz-id-2"],
        "MaxAgeSeconds": 3000
    }
]
EOF
    
    aws s3api put-bucket-cors \
        --bucket $S3_BUCKET_NAME \
        --cors-configuration file:///tmp/cors.json
    
    # Add bucket policy for public read
    print_info "Adding bucket policy..."
    cat > /tmp/bucket-policy.json << EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::$S3_BUCKET_NAME/*"
        }
    ]
}
EOF
    
    aws s3api put-bucket-policy \
        --bucket $S3_BUCKET_NAME \
        --policy file:///tmp/bucket-policy.json
    
    print_success "S3 bucket configured"
}

################################################################################
# Step 4: Update Environment Variables
################################################################################

update_environment_file() {
    print_header "Updating Environment Configuration"
    
    cat > set_env.sh << EOF
# Udagram Environment Variables
# Generated on $(date)

export POSTGRES_USERNAME=$DB_USERNAME
export POSTGRES_PASSWORD=$DB_PASSWORD
export POSTGRES_HOST=$DB_ENDPOINT
export POSTGRES_DB=postgres
export AWS_BUCKET=$S3_BUCKET_NAME
export AWS_REGION=$AWS_REGION
export AWS_PROFILE=default
export JWT_SECRET=$JWT_SECRET
export URL=http://localhost:8100
EOF
    
    chmod 600 set_env.sh
    
    print_success "Environment file updated: set_env.sh"
    print_warning "Keep this file secure! It contains sensitive credentials."
}

################################################################################
# Step 5: Create EKS Cluster (Optional)
################################################################################

create_eks_cluster() {
    if [[ ! "$CREATE_EKS" =~ ^[Yy]$ ]]; then
        print_info "Skipping EKS cluster creation"
        return 0
    fi
    
    print_header "Creating EKS Cluster"
    
    # Check if eksctl is installed
    if ! command -v eksctl &> /dev/null; then
        print_warning "eksctl not installed. Installing..."
        if [[ "$OSTYPE" == "darwin"* ]]; then
            brew tap weaveworks/tap
            brew install weaveworks/tap/eksctl
        else
            print_error "Please install eksctl manually: https://eksctl.io/"
            return 1
        fi
    fi
    
    # Check if cluster exists
    if eksctl get cluster --name $EKS_CLUSTER_NAME --region $AWS_REGION &> /dev/null; then
        print_warning "EKS cluster $EKS_CLUSTER_NAME already exists"
        return 0
    fi
    
    print_info "Creating EKS cluster (this takes ~15-20 minutes)..."
    print_warning "This will incur AWS charges (~\$72/month for cluster + nodes)"
    
    eksctl create cluster \
        --name $EKS_CLUSTER_NAME \
        --region $AWS_REGION \
        --nodegroup-name ${PROJECT_NAME}-nodes \
        --node-type $EKS_NODE_TYPE \
        --nodes $EKS_MIN_NODES \
        --nodes-min $EKS_MIN_NODES \
        --nodes-max $EKS_MAX_NODES \
        --managed
    
    print_success "EKS cluster created!"
    
    # Configure kubectl
    print_info "Configuring kubectl..."
    aws eks update-kubeconfig --region $AWS_REGION --name $EKS_CLUSTER_NAME
    
    kubectl get nodes
    
    print_success "kubectl configured"
}

################################################################################
# Step 6: Update Kubernetes Configuration Files
################################################################################

update_kubernetes_configs() {
    if [[ ! "$CREATE_EKS" =~ ^[Yy]$ ]]; then
        print_info "Skipping Kubernetes configuration"
        return 0
    fi
    
    print_header "Updating Kubernetes Configuration Files"
    
    cd udagram-deployment
    
    # Update env-configmap.yaml
    sed -i.bak "s/udagram-YOUR-BUCKET-NAME/$S3_BUCKET_NAME/g" env-configmap.yaml
    sed -i.bak "s/YOUR-RDS-ENDPOINT.rds.amazonaws.com/$DB_ENDPOINT/g" env-configmap.yaml
    
    # Update env-secret.yaml
    sed -i.bak "s/YOUR_POSTGRES_USERNAME/$DB_USERNAME/g" env-secret.yaml
    sed -i.bak "s/YOUR_POSTGRES_PASSWORD/$DB_PASSWORD/g" env-secret.yaml
    
    # Update aws-secret.yaml with base64 credentials
    if [ -f ~/.aws/credentials ]; then
        AWS_CREDS_BASE64=$(cat ~/.aws/credentials | tail -n 5 | head -n 2 | base64)
        sed -i.bak "s/___INSERT_AWS_CREDENTIALS_FILE__BASE64____/$AWS_CREDS_BASE64/g" aws-secret.yaml
    fi
    
    # Update deployment files with DockerHub username
    for file in *-deployment.yaml; do
        sed -i.bak "s/YOUR_DOCKERHUB_USERNAME/$DOCKERHUB_USERNAME/g" $file
    done
    
    # Clean up backup files
    rm -f *.bak
    
    cd ..
    
    print_success "Kubernetes configuration files updated"
}

################################################################################
# Step 7: Deploy to Kubernetes
################################################################################

deploy_to_kubernetes() {
    if [[ ! "$CREATE_EKS" =~ ^[Yy]$ ]]; then
        print_info "Skipping Kubernetes deployment"
        return 0
    fi
    
    print_header "Deploying to Kubernetes"
    
    cd udagram-deployment
    
    print_info "Applying ConfigMaps and Secrets..."
    kubectl apply -f env-configmap.yaml
    kubectl apply -f env-secret.yaml
    kubectl apply -f aws-secret.yaml
    
    print_info "Deploying applications..."
    kubectl apply -f backend-feed-deployment.yaml
    kubectl apply -f backend-user-deployment.yaml
    kubectl apply -f reverseproxy-deployment.yaml
    kubectl apply -f frontend-deployment.yaml
    
    print_info "Creating services..."
    kubectl apply -f backend-feed-service.yaml
    kubectl apply -f backend-user-service.yaml
    kubectl apply -f reverseproxy-service.yaml
    kubectl apply -f frontend-service.yaml
    
    cd ..
    
    print_success "Deployment complete!"
    
    print_info "Waiting for pods to be ready..."
    sleep 10
    kubectl get pods
    
    print_info "Getting service endpoints (LoadBalancers may take 5-10 minutes)..."
    kubectl get services
    
    print_success "Kubernetes deployment complete!"
}

################################################################################
# Step 8: Configure Autoscaling
################################################################################

configure_autoscaling() {
    if [[ ! "$CREATE_EKS" =~ ^[Yy]$ ]]; then
        return 0
    fi
    
    print_header "Configuring Autoscaling"
    
    kubectl autoscale deployment backend-user --cpu-percent=70 --min=3 --max=5
    
    print_success "Autoscaling configured"
    kubectl get hpa
}

################################################################################
# Step 9: Print Summary
################################################################################

print_deployment_summary() {
    print_header "Deployment Summary"
    
    echo -e "${GREEN}AWS Resources Created:${NC}"
    echo "  ✓ RDS PostgreSQL: ${PROJECT_NAME}-db"
    echo "    Endpoint: $DB_ENDPOINT"
    echo "    Username: $DB_USERNAME"
    echo "    Database: postgres"
    echo ""
    echo "  ✓ S3 Bucket: $S3_BUCKET_NAME"
    echo "    URL: https://$S3_BUCKET_NAME.s3.amazonaws.com"
    echo ""
    
    if [[ "$CREATE_EKS" =~ ^[Yy]$ ]]; then
        echo "  ✓ EKS Cluster: $EKS_CLUSTER_NAME"
        echo "    Region: $AWS_REGION"
        echo ""
        
        print_info "To get application URLs, run:"
        echo "  kubectl get services"
        echo ""
        print_info "Frontend will be available at the EXTERNAL-IP of the 'frontend' service"
    fi
    
    echo ""
    echo -e "${YELLOW}Environment Configuration:${NC}"
    echo "  File: set_env.sh"
    echo "  Load with: source set_env.sh"
    echo ""
    
    echo -e "${YELLOW}Local Testing:${NC}"
    echo "  1. source set_env.sh"
    echo "  2. docker-compose up"
    echo "  3. Open http://localhost:8100"
    echo ""
    
    if [[ "$CREATE_EKS" =~ ^[Yy]$ ]]; then
        echo -e "${YELLOW}Kubernetes Commands:${NC}"
        echo "  kubectl get pods          # Check pod status"
        echo "  kubectl get services      # Get service endpoints"
        echo "  kubectl get hpa           # Check autoscaling"
        echo "  kubectl logs <pod-name>   # View logs"
        echo ""
    fi
    
    echo -e "${YELLOW}Cost Estimate (Monthly):${NC}"
    echo "  RDS t3.micro: ~\$15-20 (750 hours free tier)"
    echo "  S3: ~\$0.50"
    if [[ "$CREATE_EKS" =~ ^[Yy]$ ]]; then
        echo "  EKS: ~\$72 (cluster)"
        echo "  EC2: ~\$30-60 (nodes)"
        echo "  Total: ~\$120-150/month"
    else
        echo "  Total: ~\$15-20/month"
    fi
    echo ""
    
    print_warning "Remember to delete resources after project submission to avoid charges!"
    echo ""
    
    echo -e "${BLUE}Next Steps:${NC}"
    if [[ "$CREATE_EKS" =~ ^[Yy]$ ]]; then
        echo "  1. Wait for LoadBalancer External IPs (5-10 min)"
        echo "  2. Update frontend with reverseproxy IP"
        echo "  3. Rebuild and redeploy frontend"
        echo "  4. Take required screenshots"
        echo "  5. Submit project"
    else
        echo "  1. Test locally: source set_env.sh && docker-compose up"
        echo "  2. Create EKS cluster when ready"
        echo "  3. Deploy to Kubernetes"
        echo "  4. Take required screenshots"
    fi
}

################################################################################
# Main Execution
################################################################################

main() {
    clear
    
    echo ""
    echo "╔════════════════════════════════════════════════════════════╗"
    echo "║                                                            ║"
    echo "║        Udagram Microservices - AWS Deployment             ║"
    echo "║                                                            ║"
    echo "╚════════════════════════════════════════════════════════════╝"
    echo ""
    
    check_prerequisites
    get_user_input
    create_rds_database
    create_s3_bucket
    update_environment_file
    create_eks_cluster
    update_kubernetes_configs
    deploy_to_kubernetes
    configure_autoscaling
    print_deployment_summary
    
    print_success "Deployment script completed successfully!"
}

# Run main function
main

