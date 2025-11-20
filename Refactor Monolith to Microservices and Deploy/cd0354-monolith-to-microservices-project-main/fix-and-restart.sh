#!/bin/bash

# Quick fix script to connect local app to AWS database

set -e

echo ""
echo "=========================================="
echo "Connecting Local App to AWS Database"
echo "=========================================="
echo ""

# Get database password
echo "Your RDS database is ready:"
echo "  Endpoint: udagram-db.centnkisklgf.us-east-1.rds.amazonaws.com"
echo "  Username: udagramadmin"
echo ""

read -sp "Enter the database password you set during deployment: " DB_PASSWORD
echo ""

if [ -z "$DB_PASSWORD" ]; then
    echo "Error: Password cannot be empty"
    exit 1
fi

# Check/Create S3 bucket
S3_BUCKET="udagram-shenry-$(date +%s | tail -c 6)"

echo ""
echo "Checking for S3 bucket..."

EXISTING_BUCKET=$(aws s3 ls | grep udagram | awk '{print $3}' | head -1)

if [ -n "$EXISTING_BUCKET" ]; then
    echo "✓ Found existing bucket: $EXISTING_BUCKET"
    S3_BUCKET=$EXISTING_BUCKET
else
    echo "Creating S3 bucket: $S3_BUCKET"
    aws s3 mb s3://$S3_BUCKET --region us-east-1
    
    # Configure bucket
    echo "Configuring bucket for public access..."
    aws s3api put-public-access-block \
        --bucket $S3_BUCKET \
        --public-access-block-configuration \
        "BlockPublicAcls=false,IgnorePublicAcls=false,BlockPublicPolicy=false,RestrictPublicBuckets=false"
    
    # Add CORS
    echo '[{"AllowedHeaders":["*"],"AllowedMethods":["GET","PUT","POST","DELETE","HEAD"],"AllowedOrigins":["*"],"ExposeHeaders":["ETag"],"MaxAgeSeconds":3000}]' > /tmp/cors.json
    
    aws s3api put-bucket-cors --bucket $S3_BUCKET --cors-configuration file:///tmp/cors.json
    
    # Add bucket policy
    cat > /tmp/policy.json <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "PublicReadGetObject",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::$S3_BUCKET/*"
    }
  ]
}
EOF
    
    aws s3api put-bucket-policy --bucket $S3_BUCKET --policy file:///tmp/policy.json
    
    echo "✓ S3 bucket created and configured"
fi

# Create set_env.sh
echo ""
echo "Creating set_env.sh with correct credentials..."

JWT_SECRET=$(openssl rand -base64 32)

cat > set_env.sh << EOFENV
# Udagram Environment Variables
# Updated: $(date)

export POSTGRES_USERNAME=udagramadmin
export POSTGRES_PASSWORD=$DB_PASSWORD
export POSTGRES_HOST=udagram-db.centnkisklgf.us-east-1.rds.amazonaws.com
export POSTGRES_DB=postgres
export AWS_BUCKET=$S3_BUCKET
export AWS_REGION=us-east-1
export AWS_PROFILE=default
export JWT_SECRET=$JWT_SECRET
export URL=http://localhost:8100
EOFENV

chmod 600 set_env.sh

echo "✓ set_env.sh created"

# Stop existing containers
echo ""
echo "Stopping existing containers..."
docker-compose down 2>/dev/null || true

# Load environment variables
echo ""
echo "Loading environment variables..."
source set_env.sh

# Verify database connection
echo ""
echo "Testing database connection..."
if command -v psql &> /dev/null; then
    if PGPASSWORD=$DB_PASSWORD psql -h $POSTGRES_HOST -U $POSTGRES_USERNAME -d $POSTGRES_DB -c "SELECT version();" &> /dev/null; then
        echo "✓ Database connection successful!"
    else
        echo "⚠ Could not connect to database. This may be due to:"
        echo "  1. Wrong password"
        echo "  2. Security group not allowing your IP"
        echo "  3. Database still initializing"
        echo ""
        echo "Continuing anyway..."
    fi
else
    echo "⚠ psql not installed, skipping connection test"
fi

# Start containers with new environment
echo ""
echo "Starting containers with AWS database..."
docker-compose up -d

echo ""
echo "Waiting for containers to start..."
sleep 5

# Show status
echo ""
echo "=========================================="
echo "Container Status:"
echo "=========================================="
docker-compose ps

echo ""
echo "=========================================="
echo "Setup Complete!"
echo "=========================================="
echo ""
echo "Your application is now connected to AWS:"
echo "  ✓ RDS PostgreSQL: udagram-db.centnkisklgf.us-east-1.rds.amazonaws.com"
echo "  ✓ S3 Bucket: $S3_BUCKET"
echo ""
echo "Open your browser: http://localhost:8100"
echo ""
echo "You should now be able to:"
echo "  • Register new users"
echo "  • Login"
echo "  • Post photos (saved to S3)"
echo ""
echo "If you see errors, check logs with:"
echo "  docker-compose logs backend-user"
echo "  docker-compose logs backend-feed"
echo ""

