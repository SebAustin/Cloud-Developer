#!/bin/bash

# Udagram Local Test Script
# This script sets up temporary environment variables for local testing WITHOUT real AWS resources
# Note: The backend will still fail to fully function without a real database

echo "=================================="
echo "Udagram Local Test Environment"
echo "=================================="
echo ""
echo "⚠️  WARNING: This is for TESTING ONLY"
echo "The backend services will fail to connect to the database."
echo "You need real AWS resources for full functionality."
echo ""
echo "To set up real AWS resources, see SETUP_GUIDE.md"
echo ""
echo "=================================="
echo ""

# Set temporary environment variables for testing
export POSTGRES_USERNAME=testuser
export POSTGRES_PASSWORD=testpassword
export POSTGRES_HOST=test-db.example.com
export POSTGRES_DB=testdb
export AWS_BUCKET=test-bucket
export AWS_REGION=us-east-1
export AWS_PROFILE=default
export JWT_SECRET=test-jwt-secret-key-12345
export URL=http://localhost:8100

echo "✅ Environment variables set (temporary test values)"
echo ""
echo "Building Docker images..."
echo ""

# Rebuild images with the fixed code
docker-compose -f docker-compose-build.yaml build

if [ $? -ne 0 ]; then
    echo ""
    echo "❌ Docker build failed!"
    echo "Please check the error messages above."
    exit 1
fi

echo ""
echo "✅ Docker images built successfully!"
echo ""
echo "Starting containers..."
echo ""
echo "You can access:"
echo "  - Frontend: http://localhost:8100"
echo "  - API: http://localhost:8080/api/v0"
echo ""
echo "Note: Backend services will show database errors (expected without real AWS RDS)"
echo ""
echo "Press Ctrl+C to stop all services"
echo ""

# Start docker-compose
docker-compose up

# Cleanup on exit
echo ""
echo "Stopping containers..."
docker-compose down

