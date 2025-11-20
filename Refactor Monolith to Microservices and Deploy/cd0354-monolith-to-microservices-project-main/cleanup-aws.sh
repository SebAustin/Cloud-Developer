#!/bin/bash

################################################################################
# Udagram Microservices - AWS Cleanup Script
# This script deletes all AWS resources to avoid charges
################################################################################

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

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

################################################################################
# Warning
################################################################################

clear
echo ""
echo "╔════════════════════════════════════════════════════════════╗"
echo "║                                                            ║"
echo "║        ⚠️  AWS RESOURCE CLEANUP WARNING  ⚠️                ║"
echo "║                                                            ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""
print_warning "This script will DELETE all Udagram AWS resources:"
echo "  • EKS Kubernetes cluster"
echo "  • RDS PostgreSQL database"
echo "  • S3 bucket and all contents"
echo "  • Associated security groups and networking"
echo ""
print_error "THIS ACTION CANNOT BE UNDONE!"
echo ""
read -p "Are you ABSOLUTELY sure you want to continue? (type 'YES' to confirm): " CONFIRM

if [ "$CONFIRM" != "YES" ]; then
    print_info "Cleanup cancelled. No resources were deleted."
    exit 0
fi

AWS_REGION="us-east-1"

################################################################################
# Get Resource Names
################################################################################

print_header "Gathering Resource Information"

read -p "Enter EKS cluster name [udagram-cluster]: " EKS_CLUSTER_NAME
EKS_CLUSTER_NAME=${EKS_CLUSTER_NAME:-udagram-cluster}

read -p "Enter RDS instance identifier [udagram-db]: " DB_INSTANCE_ID
DB_INSTANCE_ID=${DB_INSTANCE_ID:-udagram-db}

read -p "Enter S3 bucket name: " S3_BUCKET_NAME

if [ -z "$S3_BUCKET_NAME" ]; then
    print_error "S3 bucket name is required"
    exit 1
fi

echo ""
print_warning "Will delete:"
echo "  • EKS Cluster: $EKS_CLUSTER_NAME"
echo "  • RDS Database: $DB_INSTANCE_ID"
echo "  • S3 Bucket: $S3_BUCKET_NAME"
echo ""
read -p "Proceed? (y/n): " PROCEED

if [[ ! "$PROCEED" =~ ^[Yy]$ ]]; then
    print_info "Cleanup cancelled"
    exit 0
fi

################################################################################
# Delete Kubernetes Resources
################################################################################

print_header "Deleting Kubernetes Resources"

if command -v kubectl &> /dev/null && kubectl config current-context &> /dev/null; then
    print_info "Deleting Kubernetes deployments and services..."
    
    # Delete services first (to remove load balancers)
    kubectl delete service frontend --ignore-not-found=true
    kubectl delete service reverseproxy --ignore-not-found=true
    kubectl delete service backend-feed --ignore-not-found=true
    kubectl delete service backend-user --ignore-not-found=true
    
    print_info "Waiting for LoadBalancers to be deleted (this may take a few minutes)..."
    sleep 30
    
    # Delete deployments
    kubectl delete deployment frontend --ignore-not-found=true
    kubectl delete deployment reverseproxy --ignore-not-found=true
    kubectl delete deployment backend-feed --ignore-not-found=true
    kubectl delete deployment backend-user --ignore-not-found=true
    
    # Delete HPA
    kubectl delete hpa backend-user --ignore-not-found=true
    
    # Delete configmaps and secrets
    kubectl delete configmap env-config --ignore-not-found=true
    kubectl delete secret env-secret --ignore-not-found=true
    kubectl delete secret aws-secret --ignore-not-found=true
    
    print_success "Kubernetes resources deleted"
else
    print_warning "kubectl not configured, skipping Kubernetes cleanup"
fi

################################################################################
# Delete EKS Cluster
################################################################################

print_header "Deleting EKS Cluster"

if command -v eksctl &> /dev/null; then
    if eksctl get cluster --name $EKS_CLUSTER_NAME --region $AWS_REGION &> /dev/null; then
        print_info "Deleting EKS cluster $EKS_CLUSTER_NAME (this takes 10-15 minutes)..."
        eksctl delete cluster --name $EKS_CLUSTER_NAME --region $AWS_REGION --wait
        print_success "EKS cluster deleted"
    else
        print_warning "EKS cluster $EKS_CLUSTER_NAME not found"
    fi
else
    print_warning "eksctl not installed, skipping EKS deletion"
    print_info "Delete manually via AWS Console: EKS → Clusters → Delete"
fi

################################################################################
# Delete RDS Database
################################################################################

print_header "Deleting RDS Database"

if aws rds describe-db-instances --db-instance-identifier $DB_INSTANCE_ID --region $AWS_REGION &> /dev/null; then
    print_info "Deleting RDS instance $DB_INSTANCE_ID..."
    
    aws rds delete-db-instance \
        --db-instance-identifier $DB_INSTANCE_ID \
        --skip-final-snapshot \
        --region $AWS_REGION
    
    print_info "Waiting for database deletion..."
    aws rds wait db-instance-deleted \
        --db-instance-identifier $DB_INSTANCE_ID \
        --region $AWS_REGION
    
    print_success "RDS database deleted"
else
    print_warning "RDS instance $DB_INSTANCE_ID not found"
fi

################################################################################
# Delete S3 Bucket
################################################################################

print_header "Deleting S3 Bucket"

if aws s3 ls s3://$S3_BUCKET_NAME 2>/dev/null; then
    print_info "Emptying S3 bucket..."
    aws s3 rm s3://$S3_BUCKET_NAME --recursive
    
    print_info "Deleting S3 bucket..."
    aws s3api delete-bucket --bucket $S3_BUCKET_NAME --region $AWS_REGION
    
    print_success "S3 bucket deleted"
else
    print_warning "S3 bucket $S3_BUCKET_NAME not found"
fi

################################################################################
# Cleanup Local Files
################################################################################

print_header "Cleaning Up Local Files"

if [ -f "set_env.sh" ]; then
    read -p "Delete set_env.sh (contains credentials)? (y/n): " DELETE_ENV
    if [[ "$DELETE_ENV" =~ ^[Yy]$ ]]; then
        rm -f set_env.sh
        print_success "set_env.sh deleted"
    fi
fi

################################################################################
# Summary
################################################################################

print_header "Cleanup Complete"

print_success "All AWS resources have been deleted!"
echo ""
print_info "Resources deleted:"
echo "  ✓ EKS Cluster: $EKS_CLUSTER_NAME"
echo "  ✓ RDS Database: $DB_INSTANCE_ID"
echo "  ✓ S3 Bucket: $S3_BUCKET_NAME"
echo ""
print_warning "Please verify in AWS Console that all resources are gone:"
echo "  1. EKS → Clusters (should be empty)"
echo "  2. RDS → Databases (should be empty)"
echo "  3. S3 → Buckets (bucket should be gone)"
echo "  4. EC2 → Load Balancers (should be empty)"
echo "  5. EC2 → Security Groups (check for orphaned groups)"
echo ""
print_success "You should no longer incur AWS charges for this project!"

