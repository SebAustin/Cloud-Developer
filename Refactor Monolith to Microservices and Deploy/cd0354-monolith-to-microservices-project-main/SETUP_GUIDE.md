# Setup Guide for Udagram Microservices Project

## Prerequisites Installation (If Not Already Done)

### PostgreSQL Client
```bash
brew install postgresql@15
psql --version  # Verify installation
```

### Ionic CLI
```bash
npm install -g ionic
ionic --version  # Verify installation
```

## AWS Resources Setup

### 1. Create IAM User

1. Go to AWS Console → IAM → Users → Add User
2. User name: `udagram-admin`
3. Access type: Programmatic access
4. Attach existing policies directly: `AdministratorAccess`
5. Download the credentials (Access Key ID and Secret Access Key)
6. Configure AWS CLI:
```bash
aws configure
# Enter your Access Key ID
# Enter your Secret Access Key
# Default region: us-east-1
# Default output format: json
```

7. Verify configuration:
```bash
aws iam list-users
```

### 2. Create RDS PostgreSQL Database

1. Go to AWS Console → RDS → Create database
2. Choose: PostgreSQL
3. Version: 12.x to 15.x (recommended: 15.x)
4. Templates: Free tier (or Dev/Test)
5. Settings:
   - DB instance identifier: `udagram-db`
   - Master username: `udagramadmin`
   - Master password: (create a strong password)
6. Instance configuration: db.t3.micro (or db.t2.micro for free tier)
7. Storage: 20 GB, disable autoscaling
8. Connectivity:
   - Public access: **Yes** (important!)
   - VPC security group: Create new → `udagram-db-sg`
9. Database options:
   - Initial database name: `udagram`
   - Port: 5432
10. Create database (wait ~10 minutes)
11. After creation, note the **Endpoint** (e.g., `udagram-db.xxxxx.us-east-1.rds.amazonaws.com`)
12. Edit security group inbound rules:
    - Type: PostgreSQL
    - Port: 5432
    - Source: 0.0.0.0/0 (or your IP for security)

### 3. Create S3 Bucket

1. Go to AWS Console → S3 → Create bucket
2. Bucket name: `udagram-<your-name>-<random-number>` (must be globally unique)
   - Example: `udagram-shenry-987654`
3. Region: us-east-1
4. Uncheck "Block all public access"
5. Acknowledge the warning
6. Create bucket
7. Configure CORS:
   - Click on bucket → Permissions → CORS
   - Add this configuration:
```json
[
    {
        "AllowedHeaders": ["*"],
        "AllowedMethods": ["GET", "PUT", "POST", "DELETE", "HEAD"],
        "AllowedOrigins": ["*"],
        "ExposeHeaders": ["ETag", "x-amz-server-side-encryption", "x-amz-request-id", "x-amz-id-2"],
        "MaxAgeSeconds": 3000
    }
]
```

8. Configure Bucket Policy:
   - Click on bucket → Permissions → Bucket policy
   - Add this policy (replace `YOUR-BUCKET-NAME`):
```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::YOUR-BUCKET-NAME/*"
        }
    ]
}
```

## External Accounts Setup

### 1. DockerHub Account

1. Go to https://hub.docker.com/signup
2. Create a free account
3. Verify your email
4. Log in and note your username

### 2. Travis CI Account

1. Go to https://travis-ci.com/
2. Sign up with GitHub
3. Authorize Travis CI to access your GitHub repositories
4. You'll configure the specific repository later

## Update Environment Variables

After creating all AWS resources, update the `set_env.sh` file with your actual values:

```bash
export POSTGRES_USERNAME=udagramadmin
export POSTGRES_PASSWORD=<your-rds-password>
export POSTGRES_HOST=<your-rds-endpoint>  # e.g., udagram-db.xxxxx.us-east-1.rds.amazonaws.com
export POSTGRES_DB=udagram
export AWS_BUCKET=<your-bucket-name>  # e.g., udagram-shenry-987654
export AWS_REGION=us-east-1
export AWS_PROFILE=default
export JWT_SECRET=<generate-random-string>  # e.g., mySecretJWT2025!@#
export URL=http://localhost:8100
```

To generate a secure JWT secret:
```bash
openssl rand -base64 32
```

## Configure Git to Ignore Credentials

```bash
cd "/Users/shenry/Documents/Personal/Training/Project/Udacity/Cloud Developper/Monolith to Microservices and Deploy/cd0354-monolith-to-microservices-project-main"
git rm --cached set_env.sh
echo "set_env.sh" >> .gitignore
```

## Next Steps

After completing these setup steps, the code implementation will:
1. Refactor the monolith into microservices
2. Create Dockerfiles for each service
3. Set up Docker Compose for local testing
4. Create Travis CI pipeline
5. Deploy to Kubernetes on EKS

**Important:** Keep your credentials secure and never commit them to Git!
